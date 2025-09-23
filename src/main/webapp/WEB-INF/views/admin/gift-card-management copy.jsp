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
        .table tbody tr:hover {
            background-color: #f1f1f1;
            cursor: pointer;
        }
        .user-detail-btn {
            white-space: nowrap;
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

                <!-- 보기 모드 선택 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-users me-2"></i>
                            사용자 목록
                            <c:if test="${totalElements != null}">
                                <small class="text-muted">(${totalElements}명)</small>
                            </c:if>
                        </h5>
                              <div class="d-flex align-items-center">
                                  
                                  <!-- 버튼 그룹 -->
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-primary" id="cardViewBtn">
                                        <i class="fas fa-th-large me-1"></i> 카드 보기
                                    </button>
                                    <button type="button" class="btn btn-primary" id="tableViewBtn">
                                        <i class="fas fa-table me-1"></i> 테이블 보기
                                    </button>
                                    <button type="button" class="btn btn-success" id="exportBtn">
                                        <i class="fas fa-file-excel me-1"></i> 엑셀 다운로드
                                    </button>
                                    <button type="button" class="btn btn-warning" id="addUserBtn" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                        <i class="fas fa-user-plus me-1"></i> 신규 사용자 등록
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 사용자 목록 -->
                <div class="card mb-4">
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
                                <!-- 카드 보기 -->
                                <div id="cardView" style="display: none;">
                                    <div class="row">
                                        <c:forEach var="user" items="${users}" varStatus="loop">
                                            <div class="col-md-6 col-lg-4 mb-4">
                                                <div class="card user-card h-100" data-user-id="${user.id}">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                                            <h6 class="card-title mb-0">${user.name}</h6>
                                                            <c:choose>
                                                                <c:when test="${user.isBlacklisted}">
                                                                    <span class="badge bg-danger">블랙리스트</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success">정상</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <p class="card-text">
                                                            <small class="text-muted">
                                                                <i class="fas fa-phone me-1"></i> ${user.phoneNumber}
                                                            </small>
                                                        </p>
                                                        <div class="row text-center mb-3">
                                                            <div class="col-6">
                                                                <div class="border-end">
                                                                    <h6 class="text-primary mb-1">${user.giftCardCount}</h6>
                                                                    <small class="text-muted">지급 횟수</small>
                                                                </div>
                                                            </div>
                                                            <div class="col-6">
                                                                <h6 class="text-success mb-1">
                                                                    <fmt:formatNumber value="${user.totalGiftCardAmount}" type="number"/>원
                                                                </h6>
                                                                <small class="text-muted">총 지급액</small>
                                                            </div>
                                                        </div>
                                                        <p class="card-text">
                                                            <small class="text-muted">
                                                                <i class="fas fa-calendar me-1"></i>
                                                                가입일: ${user.createdAt.toLocalDate()} ${user.createdAt.toLocalTime()}
                                                            </small>
                                                        </p>
                                                    </div>
                                                    <div class="card-footer bg-transparent">
                                                        <div class="d-flex justify-content-between">
                                                            <a href="/admin/users/${user.id}" class="btn btn-sm btn-info">
                                                                <i class="fas fa-eye me-1"></i> 보기
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-danger" 
                                                                    onclick="deleteUser('${user.id}', '${user.name}');">
                                                                <i class="fas fa-trash me-1"></i> 삭제
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- 테이블 보기 -->
                                <div id="tableView">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">이름</th>
                                                    <th scope="col">전화번호</th>
                                                    <th scope="col">지급 횟수</th>
                                                    <th scope="col">총 지급액</th>
                                                    <th scope="col">가입일</th>
                                                    <th scope="col">블랙리스트</th>
                                                    <th scope="col">관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="user" items="${users}" varStatus="loop">
                                                    <tr class="user-table-row" data-user-id="${user.id}">
                                                        <th scope="row">${users.size() - loop.index}</th>
                                                        <td>${user.name}</td>
                                                        <td>${user.phoneNumber}</td>
                                                        <td>${user.giftCardCount}회</td>
                                                        <td><fmt:formatNumber value="${user.totalGiftCardAmount}" type="number"/>원</td>
                                                        <td>${user.createdAt.toLocalDate()} ${user.createdAt.toLocalTime()}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.isBlacklisted}">
                                                                    <span class="badge bg-danger">예</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success">아니오</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex">
                                                                <a href="/admin/users/${user.id}" class="btn btn-sm btn-info me-2">
                                                                    <i class="fas fa-eye"></i> 보기
                                                                </a>
                                                                <button type="button" class="btn btn-sm btn-danger" 
                                                                        onclick="deleteUser('${user.id}', '${user.name}');">
                                                                    <i class="fas fa-trash"></i> 삭제
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- 페이징 네비게이션 -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="사용자 목록 페이징">
                                <ul class="pagination justify-content-center">
                                    <!-- 이전 페이지 -->
                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${currentPage > 0}">
                                                <a class="page-link" href="/admin/gift-cards?page=${currentPage - 1}&size=${size}<c:if test='${search != null}'>&search=${search}</c:if>">
                                                    <i class="fas fa-chevron-left"></i> 이전
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="page-link"><i class="fas fa-chevron-left"></i> 이전</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                    
                                    <!-- 페이지 번호들 -->
                                    <c:forEach begin="0" end="${totalPages - 1}" var="pageNum">
                                        <c:if test="${pageNum == 0 || pageNum == totalPages - 1 || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <c:choose>
                                                    <c:when test="${pageNum == currentPage}">
                                                        <span class="page-link">${pageNum + 1}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="page-link" href="/admin/gift-cards?page=${pageNum}&size=${size}<c:if test='${search != null}'>&search=${search}</c:if>">${pageNum + 1}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:if>
                                        <c:if test="${pageNum == currentPage - 3 || pageNum == currentPage + 3}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    
                                    <!-- 다음 페이지 -->
                                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${currentPage < totalPages - 1}">
                                                <a class="page-link" href="/admin/gift-cards?page=${currentPage + 1}&size=${size}<c:if test='${search != null}'>&search=${search}</c:if>">
                                                    다음 <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="page-link">다음 <i class="fas fa-chevron-right"></i></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>
                            </nav>
                            
                            <!-- 페이징 정보 -->
                            <div class="text-center text-muted mt-3">
                                <small>
                                    총 ${totalElements}명의 사용자 중 
                                    ${currentPage * size + 1}-${endIndex}번째 표시 
                                    (${currentPage + 1}/${totalPages} 페이지)
                                </small>
                            </div>
                        </c:if>
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

    <!-- 신규 사용자 등록 모달 -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>
                        신규 사용자 등록
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="/admin/users/add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="userName" class="form-label">
                                <i class="fas fa-user me-1"></i>이름
                            </label>
                            <input type="text" class="form-control" id="userName" name="name" 
                                   placeholder="사용자 이름을 입력하세요" required>
                        </div>
                        <div class="mb-3">
                            <label for="userPhoneNumber" class="form-label">
                                <i class="fas fa-mobile-alt me-1"></i>핸드폰 번호
                            </label>
                            <input type="tel" class="form-control" id="userPhoneNumber" name="phoneNumber" 
                                   placeholder="010-1234-5678" 
                                   oninput="formatPhoneNumber(this)"
                                   maxlength="13" required>
                        </div>
                        <div class="mb-3">
                            <label for="userBirthDate" class="form-label">
                                <i class="fas fa-birthday-cake me-1"></i>생년월일
                            </label>
                            <input type="date" class="form-control" id="userBirthDate" name="birthDate" required>
                        </div>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>안내사항</strong><br>
                            <small>
                                • 신규 등록된 사용자는 자동으로 정상 상태로 설정됩니다.<br>
                                • 동일한 이름과 핸드폰 번호로는 중복 등록이 불가능합니다.<br>
                                • 등록 후 바로 상품권 지급이 가능합니다.
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-user-plus me-2"></i>
                            사용자 등록
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 페이지 로드 시 보기 모드 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing gift-card-management page');
            
            // 기본적으로 테이블 보기로 설정
            showTableView();
            
            // 버튼 요소들 확인
            const cardViewBtn = document.getElementById('cardViewBtn');
            const tableViewBtn = document.getElementById('tableViewBtn');
            const exportBtn = document.getElementById('exportBtn');
            
            console.log('Buttons found:', {
                cardViewBtn: !!cardViewBtn,
                tableViewBtn: !!tableViewBtn,
                exportBtn: !!exportBtn
            });
            
            // 카드 보기 버튼 이벤트
            if (cardViewBtn) {
                cardViewBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    console.log('Card view button clicked');
                    showCardView();
                });
            }
            
            // 테이블 보기 버튼 이벤트
            if (tableViewBtn) {
                tableViewBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    console.log('Table view button clicked');
                    showTableView();
                });
            }
            
            // 엑셀 다운로드 버튼 이벤트
            if (exportBtn) {
                exportBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    console.log('Export button clicked');
                    exportToExcel();
                });
            }
            
            // 카드 클릭 시 사용자 상세 페이지로 이동
            document.querySelectorAll('.user-card').forEach(card => {
                card.addEventListener('click', function(e) {
                    // 버튼 클릭이 아닌 경우에만 이동
                    if (!e.target.closest('button') && !e.target.closest('a')) {
                        const userId = this.dataset.userId;
                        if (userId) {
                            window.location.href = '/admin/users/' + userId;
                        }
                    }
                });
            });
            
            // 테이블 행 클릭 시 사용자 상세 페이지로 이동
            document.querySelectorAll('.user-table-row').forEach(row => {
                row.addEventListener('click', function(e) {
                    // 버튼 클릭이 아닌 경우에만 이동
                    if (!e.target.closest('button') && !e.target.closest('a')) {
                        const userId = this.dataset.userId;
                        if (userId) {
            window.location.href = '/admin/users/' + userId;
                        }
                    }
                });
            });
        });

        function showCardView() {
            console.log('showCardView function called');
            const cardView = document.getElementById('cardView');
            const tableView = document.getElementById('tableView');
            const cardViewBtn = document.getElementById('cardViewBtn');
            const tableViewBtn = document.getElementById('tableViewBtn');
            
            if (cardView && tableView && cardViewBtn && tableViewBtn) {
                cardView.style.display = 'block';
                tableView.style.display = 'none';
                cardViewBtn.classList.remove('btn-outline-primary');
                cardViewBtn.classList.add('btn-primary');
                tableViewBtn.classList.remove('btn-primary');
                tableViewBtn.classList.add('btn-outline-primary');
                console.log('Card view activated');
            } else {
                console.error('Required elements not found for card view');
            }
        }

        function showTableView() {
            console.log('showTableView function called');
            const cardView = document.getElementById('cardView');
            const tableView = document.getElementById('tableView');
            const cardViewBtn = document.getElementById('cardViewBtn');
            const tableViewBtn = document.getElementById('tableViewBtn');
            
            if (cardView && tableView && cardViewBtn && tableViewBtn) {
                cardView.style.display = 'none';
                tableView.style.display = 'block';
                cardViewBtn.classList.remove('btn-primary');
                cardViewBtn.classList.add('btn-outline-primary');
                tableViewBtn.classList.remove('btn-outline-primary');
                tableViewBtn.classList.add('btn-primary');
                console.log('Table view activated');
            } else {
                console.error('Required elements not found for table view');
            }
        }

        function exportToExcel() {
            console.log('exportToExcel function called');
            // 현재 검색어 가져오기
            const searchParam = new URLSearchParams(window.location.search).get('search') || '';
            
            // 엑셀 다운로드 URL 생성
            let exportUrl = '/admin/gift-cards/export';
            if (searchParam) {
                exportUrl += '?search=' + encodeURIComponent(searchParam);
            }
            
            console.log('Opening export URL:', exportUrl);
            // 새 창에서 다운로드 실행
            window.open(exportUrl, '_blank');
        }

        function deleteUser(id, name) {
            document.getElementById('deleteForm').action = '/admin/users/delete/' + id;
            document.getElementById('deleteUserInfo').textContent = name + ' 사용자를 삭제하시겠습니까?';
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        // 핸드폰 번호 포맷팅 함수
        function formatPhoneNumber(input) {
            let value = input.value.replace(/\D/g, ''); // 숫자만 추출
            if (value.length >= 11) {
                value = value.substring(0, 11);
            }
            if (value.length >= 7) {
                value = value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
            } else if (value.length >= 3) {
                value = value.replace(/(\d{3})(\d{0,4})/, '$1-$2');
            }
            input.value = value;
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
