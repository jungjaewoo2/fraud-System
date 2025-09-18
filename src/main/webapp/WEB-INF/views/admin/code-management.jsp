<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>코드 관리 - 상품권 부정방지 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 0;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.2);
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .table th {
            border-top: none;
            background-color: #f8f9fa;
        }
        .code-badge {
            font-family: 'Courier New', monospace;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 사이드바 -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <i class="fas fa-shield-alt fa-3x text-white mb-2"></i>
                        <h5 class="text-white">관리자 패널</h5>
                        <small class="text-white-50">관리자님</small>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                대시보드
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/admin/codes">
                                <i class="fas fa-key me-2"></i>
                                코드 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/gift-cards">
                                <i class="fas fa-gift me-2"></i>
                                상품권 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/admin/change-password">
                                <i class="fas fa-lock me-2"></i>
                                비밀번호 변경
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <a class="nav-link" href="/admin/logout">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                로그아웃
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 메인 콘텐츠 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-key me-2"></i>
                        코드 관리
                    </h1>
                </div>

                <c:if test="${success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 코드 추가 폼 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-plus me-2"></i>
                            새 코드 추가
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="/admin/codes">
                            <div class="row">
                                <div class="col-md-4">
                                    <label for="adminName" class="form-label">관리자 이름</label>
                                    <input type="text" class="form-control" id="adminName" name="adminName" 
                                           placeholder="관리자 이름" required>
                                </div>
                                <div class="col-md-4">
                                    <label for="codeNumber" class="form-label">코드 번호</label>
                                    <input type="text" class="form-control code-badge" id="codeNumber" name="codeNumber" 
                                           placeholder="CODE001" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-plus me-2"></i>
                                            코드 추가
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 코드 목록 -->
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list me-2"></i>
                                등록된 코드 목록
                            </h5>
                            <div class="d-flex align-items-center">
                                <label for="pageSize" class="form-label me-2 mb-0">표시 개수:</label>
                                <select id="pageSize" class="form-select form-select-sm" style="width: auto;" onchange="changePageSize()">
                                    <option value="5" ${size == 5 ? 'selected' : ''}>5개</option>
                                    <option value="10" ${size == 10 ? 'selected' : ''}>10개</option>
                                    <option value="20" ${size == 20 ? 'selected' : ''}>20개</option>
                                    <option value="50" ${size == 50 ? 'selected' : ''}>50개</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty adminCodes}">
                                <div class="text-center py-5">
                                    <i class="fas fa-key fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">등록된 코드가 없습니다</h5>
                                    <p class="text-muted">새 코드를 추가해보세요.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th style="width: 60px;">순번</th>
                                                <th>관리자 이름</th>
                                                <th>코드 번호</th>
                                                <th>
                                                    등록일 
                                                    <i class="fas fa-sort-down text-primary ms-1" title="최신순 정렬"></i>
                                                </th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="code" items="${adminCodes}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <span class="badge bg-secondary">
                                                            ${totalElements - (currentPage * size) - status.index}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-user me-2 text-primary"></i>
                                                        ${code.adminName}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info code-badge">
                                                            ${code.codeNumber}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        ${code.createdAt.toLocalDate()}
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <button type="button" class="btn btn-outline-primary" 
                                                                    onclick="editCode(${code.id}, '${code.adminName}', '${code.codeNumber}')">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-outline-danger" 
                                                                    onclick="deleteCode(${code.id}, '${code.adminName}')">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- 페이징 UI -->
                                <c:if test="${totalPages > 1}">
                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <div>
                                            <small class="text-muted">
                                                총 ${totalElements}개의 코드 중 ${currentPage * size + 1} - ${currentPage * size + adminCodes.size()}번째
                                            </small>
                                        </div>
                                        <nav aria-label="페이지 네비게이션">
                                            <ul class="pagination mb-0">
                                                <!-- 이전 페이지 -->
                                                <c:if test="${hasPrevious}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${currentPage - 1}&size=${size}">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                                <c:if test="${!hasPrevious}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </span>
                                                    </li>
                                                </c:if>
                                                
                                                <!-- 페이지 번호들 -->
                                                <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                                    <c:if test="${pageNum >= currentPage - 2 && pageNum <= currentPage + 2}">
                                                        <c:choose>
                                                            <c:when test="${pageNum == currentPage}">
                                                                <li class="page-item active">
                                                                    <span class="page-link">${pageNum + 1}</span>
                                                                </li>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <li class="page-item">
                                                                    <a class="page-link" href="?page=${pageNum}&size=${size}">${pageNum + 1}</a>
                                                                </li>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </c:forEach>
                                                
                                                <!-- 다음 페이지 -->
                                                <c:if test="${hasNext}">
                                                    <li class="page-item">
                                                        <a class="page-link" href="?page=${currentPage + 1}&size=${size}">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </c:if>
                                                <c:if test="${!hasNext}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link">
                                                            <i class="fas fa-chevron-right"></i>
                                                        </span>
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 수정 모달 -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>
                        코드 수정
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editForm" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editAdminName" class="form-label">관리자 이름</label>
                            <input type="text" class="form-control" id="editAdminName" name="adminName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editCodeNumber" class="form-label">코드 번호</label>
                            <input type="text" class="form-control code-badge" id="editCodeNumber" name="codeNumber" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>
                            수정
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        코드 삭제 확인
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 이 코드를 삭제하시겠습니까?</p>
                    <div class="alert alert-warning">
                        <strong id="deleteCodeInfo"></strong>
                        <br>
                        <small>삭제된 코드는 복구할 수 없습니다.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-2"></i>
                            삭제
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editCode(id, adminName, codeNumber) {
            document.getElementById('editForm').action = '/admin/codes/edit/' + id;
            document.getElementById('editAdminName').value = adminName;
            document.getElementById('editCodeNumber').value = codeNumber;
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }

        function deleteCode(id, adminName) {
            document.getElementById('deleteForm').action = '/admin/codes/delete/' + id;
            document.getElementById('deleteCodeInfo').textContent = adminName + '의 코드를 삭제하시겠습니까?';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function changePageSize() {
            const pageSize = document.getElementById('pageSize').value;
            const currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('page', '0'); // 페이지 크기 변경시 첫 페이지로
            currentUrl.searchParams.set('size', pageSize);
            window.location.href = currentUrl.toString();
        }

        // 자동으로 알림 메시지 숨기기
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
