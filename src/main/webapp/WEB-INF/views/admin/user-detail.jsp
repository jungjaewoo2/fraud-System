<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 상세 - 상품권 부정방지 시스템</title>
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
        .user-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .form-control {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 12px 20px;
        }
        .form-control:focus {
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
                        <i class="fas fa-user me-2"></i>
                        사용자 상세 정보
                    </h1>
                    <a href="/admin/gift-cards" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        목록으로
                    </a>
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

                <!-- 사용자 정보 -->
                <div class="card user-info-card mb-4">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h3 class="card-title mb-2">
                                    <i class="fas fa-user me-2"></i>
                                    ${user.name}
                                </h3>
                                <p class="mb-1">
                                    <i class="fas fa-mobile-alt me-2"></i>
                                    ${user.phoneNumber}
                                </p>
                                <c:if test="${user.birthDate != null}">
                                    <p class="mb-1">
                                        <i class="fas fa-birthday-cake me-2"></i>
                                        생년월일: ${user.birthDate}
                                    </p>
                                </c:if>
                                <p class="mb-0">
                                    <i class="fas fa-calendar me-2"></i>
                                    가입일: ${user.createdAt}
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="h2 mb-0">
                                    <i class="fas fa-gift me-2"></i>
                                    ${giftCards.size()}개
                                </div>
                                <small>총 상품권 개수</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상품권 추가 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-plus me-2"></i>
                            상품권 추가
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="post" action="/admin/users/${user.id}/gift-cards">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label">상품권 금액</label>
                                    <div class="d-grid gap-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="amount" id="amount10000" value="10000" required>
                                            <label class="form-check-label" for="amount10000">
                                                <i class="fas fa-coins me-1 text-success"></i>
                                                10,000원
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="amount" id="amount20000" value="20000" required>
                                            <label class="form-check-label" for="amount20000">
                                                <i class="fas fa-coins me-1 text-success"></i>
                                                20,000원
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label for="issuedBy" class="form-label">지급 담당자</label>
                                    <input type="text" class="form-control" id="issuedBy" name="issuedBy" 
                                           placeholder="담당자 이름" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">&nbsp;</label>
                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-plus me-2"></i>
                                            상품권 추가
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 상품권 목록 -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-list me-2"></i>
                            상품권 지급 내역
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty giftCards}">
                                <div class="text-center py-5">
                                    <i class="fas fa-gift fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">지급된 상품권이 없습니다</h5>
                                    <p class="text-muted">위의 폼을 사용하여 상품권을 추가해보세요.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>순번</th>
                                                <th>지급일</th>
                                                <th>금액</th>
                                                <th>담당자</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="giftCard" items="${giftCards}" varStatus="status">
                                                <tr>
                                                    <td>${giftCards.size() - status.index}</td>
                                                    <td>
                                                        ${giftCard.issuedAt}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-success fs-6">
                                                            <fmt:formatNumber value="${giftCard.amount}" pattern="#,###"/>원
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-user-tie me-1"></i>
                                                        ${giftCard.issuedBy}
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <button type="button" class="btn btn-outline-primary" 
                                                                    onclick="editGiftCard(${giftCard.id}, ${giftCard.amount}, '${giftCard.issuedBy}')">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-outline-danger" 
                                                                    onclick="deleteGiftCard(${giftCard.id}, ${giftCard.amount})">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- 통계 -->
                                <div class="mt-4">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card bg-light">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-gift me-2"></i>
                                                        총 지급 건수
                                                    </h6>
                                                    <h4 class="text-primary">${giftCards.size()}건</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card bg-light">
                                                <div class="card-body text-center">
                                                    <h6 class="card-title">
                                                        <i class="fas fa-won-sign me-2"></i>
                                                        총 지급 금액
                                                    </h6>
                                                    <h4 class="text-success">
                                                        <c:set var="totalAmount" value="0" />
                                                        <c:forEach var="giftCard" items="${giftCards}">
                                                            <c:set var="totalAmount" value="${totalAmount + giftCard.amount}" />
                                                        </c:forEach>
                                                        <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>원
                                                    </h4>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 상품권 수정 모달 -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>
                        상품권 수정
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editForm" method="post">
                    <input type="hidden" name="userId" value="${user.id}">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">상품권 금액</label>
                            <div class="d-grid gap-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="editAmount10000" value="10000" required>
                                    <label class="form-check-label" for="editAmount10000">
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        10,000원
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="editAmount20000" value="20000" required>
                                    <label class="form-check-label" for="editAmount20000">
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        20,000원
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editIssuedBy" class="form-label">지급 담당자</label>
                            <input type="text" class="form-control" id="editIssuedBy" name="issuedBy" required>
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

    <!-- 상품권 삭제 확인 모달 -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        상품권 삭제 확인
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>정말로 이 상품권을 삭제하시겠습니까?</p>
                    <div class="alert alert-warning">
                        <strong id="deleteGiftCardInfo"></strong>
                        <br>
                        <small>삭제된 상품권은 복구할 수 없습니다.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="userId" value="${user.id}">
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
        function editGiftCard(id, amount, issuedBy) {
            document.getElementById('editForm').action = '/admin/gift-cards/edit/' + id;
            document.getElementById('editIssuedBy').value = issuedBy;
            
            // 금액 라디오 버튼 선택
            document.getElementById('editAmount10000').checked = (amount == 10000);
            document.getElementById('editAmount20000').checked = (amount == 20000);
            
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }

        function deleteGiftCard(id, amount) {
            document.getElementById('deleteForm').action = '/admin/gift-cards/delete/' + id;
            document.getElementById('deleteGiftCardInfo').textContent = 
                amount.toLocaleString() + '원 상품권을 삭제하시겠습니까?';
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
