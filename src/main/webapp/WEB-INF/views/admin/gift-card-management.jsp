<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품권 관리 - 상품권 부정방지 시스템</title>
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
        .user-card {
            transition: transform 0.2s;
            cursor: pointer;
        }
        .user-card:hover {
            transform: translateY(-2px);
        }
        .search-box {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 12px 20px;
        }
        .search-box:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
                            <a class="nav-link" href="/admin/codes">
                                <i class="fas fa-key me-2"></i>
                                코드 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/admin/gift-cards">
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
                        <i class="fas fa-gift me-2"></i>
                        상품권 관리
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

                <!-- 검색 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="/admin/gift-cards">
                            <div class="row">
                                <div class="col-md-8">
                                    <input type="text" class="form-control search-box" name="search" 
                                           placeholder="이름 또는 핸드폰 번호로 검색..." 
                                           value="${search}">
                                </div>
                                <div class="col-md-4">
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-2"></i>
                                            검색
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 사용자 목록 -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>
                            사용자 목록
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty users}">
                                <div class="text-center py-5">
                                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">등록된 사용자가 없습니다</h5>
                                    <p class="text-muted">
                                        <c:if test="${search != null}">
                                            검색 결과가 없습니다. 다른 검색어를 시도해보세요.
                                        </c:if>
                                        <c:if test="${search == null}">
                                            아직 등록된 사용자가 없습니다.
                                        </c:if>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <c:forEach var="user" items="${users}">
                                        <div class="col-lg-6 col-xl-4 mb-4">
                                            <div class="card user-card h-100" onclick="viewUserDetail(${user.id})">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center mb-3">
                                                        <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" 
                                                             style="width: 50px; height: 50px;">
                                                            <i class="fas fa-user fa-lg"></i>
                                                        </div>
                                                        <div>
                                                            <h6 class="card-title mb-1">${user.name}</h6>
                                                            <small class="text-muted">
                                                                <i class="fas fa-mobile-alt me-1"></i>
                                                                ${user.phoneNumber}
                                                            </small>
                                                        </div>
                                                    </div>
                                                    
                                                    <c:if test="${user.birthDate != null}">
                                                        <div class="mb-2">
                                                            <small class="text-muted">
                                                                <i class="fas fa-birthday-cake me-1"></i>
                                                                생년월일: 
                                                                ${user.birthDate}
                                                            </small>
                                                        </div>
                                                    </c:if>
                                                    
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <small class="text-muted">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            가입일: 
                                                            ${user.createdAt}
                                                        </small>
                                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                onclick="deleteUser(${user.id}, '${user.name}'); event.stopPropagation();">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 사용자 삭제 확인 모달 -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        사용자 삭제 확인
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 이 사용자를 삭제하시겠습니까?</p>
                    <div class="alert alert-warning">
                        <strong id="deleteUserInfo"></strong>
                        <br>
                        <small>사용자 삭제 시 관련된 모든 상품권 내역도 함께 삭제됩니다.</small>
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
        function viewUserDetail(userId) {
            window.location.href = '/admin/users/' + userId;
        }

        function deleteUser(id, name) {
            document.getElementById('deleteForm').action = '/admin/users/delete/' + id;
            document.getElementById('deleteUserInfo').textContent = name + ' 사용자를 삭제하시겠습니까?';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
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
