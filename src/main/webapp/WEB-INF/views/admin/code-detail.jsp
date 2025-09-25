<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>코드 상세 내역 - 상품권 부정방지 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            padding-top: 30px;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.95);
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
        }
        .table th {
            border-top: none;
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .code-badge {
            font-family: 'Courier New', monospace;
            font-weight: bold;
        }
        .amount-success {
            color: #198754;
            font-weight: bold;
        }
        .amount-warning {
            color: #fd7e14;
            font-weight: bold;
        }
        .amount-danger {
            color: #dc3545;
            font-weight: bold;
        }
        .summary-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
        }
        .summary-negative {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
        }
        .btn-close-custom {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
        }
        .btn-close-custom:hover {
            background: rgba(255, 255, 255, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card">
                    <div class="card-header position-relative">
                        <h4 class="mb-0">
                            <i class="fas fa-receipt me-2"></i>
                            코드 상세 내역
                        </h4>
                        <button type="button" class="btn btn-close-custom" onclick="window.close()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- 코드 정보 -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <h6 class="text-muted">관리자</h6>
                                <p class="fs-5 fw-bold">
                                    <i class="fas fa-user me-2 text-primary"></i>
                                    ${adminCode.adminName}
                                </p>
                            </div>
                            <div class="col-md-4">
                                <h6 class="text-muted">코드 번호</h6>
                                <p class="fs-5">
                                    <span class="badge bg-info code-badge fs-6">${adminCode.codeNumber}</span>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <h6 class="text-muted">지급 금액</h6>
                                <p class="fs-5 amount-success">
                                    <i class="fas fa-won-sign me-1"></i>
                                    <fmt:formatNumber value="${adminCode.money}" type="number" pattern="#,##0"/>원
                                </p>
                            </div>
                        </div>

                        <hr>

                        <!-- 오늘 발행한 상품권 내역 -->
                        <h5 class="mb-3">
                            <i class="fas fa-gift me-2 text-primary"></i>
                            오늘 발행한 상품권 내역 
                            <small class="text-muted">(<fmt:formatDate value="${today}" pattern="yyyy-MM-dd"/>)</small>
                        </h5>

                        <c:choose>
                            <c:when test="${empty todayGiftCards}">
                                <div class="text-center py-5">
                                    <i class="fas fa-gift fa-3x text-muted mb-3"></i>
                                    <h6 class="text-muted">오늘 발행한 상품권이 없습니다</h6>
                                    <p class="text-muted">아직 이 코드로 발행된 상품권이 없습니다.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th style="width: 60px;">순번</th>
                                                <th>지급 시간</th>
                                                <th>상품권 발급 금액</th>
                                                <th>받은 사용자</th>
                                                <th>발급자</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="giftCard" items="${todayGiftCards}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <span class="badge bg-secondary">${status.index + 1}</span>
                                                    </td>
                                                    <td>
                                                        ${giftCard.issuedAt.toLocalTime()}
                                                    </td>
                                                    <td>
                                                        <span class="amount-success">
                                                            <i class="fas fa-won-sign me-1"></i>
                                                            <fmt:formatNumber value="${giftCard.amount}" type="number" pattern="#,##0"/>원
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-user me-2 text-muted"></i>
                                                        ${giftCard.user.name}
                                                        <small class="text-muted">(${giftCard.user.phoneNumber})</small>
                                                    </td>
                                                    <td>
                                                        <i class="fas fa-user-shield me-2 text-primary"></i>
                                                        ${giftCard.issuedBy}
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- 차액 정보 -->
                        <div class="summary-card ${difference < 0 ? 'summary-negative' : ''}">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h5 class="mb-2">
                                        <i class="fas fa-calculator me-2"></i>
                                        오늘 차액 정보
                                    </h5>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <small class="opacity-75">지급 금액</small>
                                            <p class="mb-1 fs-6">
                                                <fmt:formatNumber value="${adminCode.money}" type="number" pattern="#,##0"/>원
                                            </p>
                                        </div>
                                        <div class="col-sm-6">
                                            <small class="opacity-75">발행 총액</small>
                                            <p class="mb-1 fs-6">
                                                <fmt:formatNumber value="${todayTotalAmount}" type="number" pattern="#,##0"/>원
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 text-md-end">
                                    <small class="opacity-75">차액</small>
                                    <h3 class="mb-0">
                                        <c:choose>
                                            <c:when test="${difference >= 0}">
                                                <i class="fas fa-plus-circle me-2"></i>
                                                +<fmt:formatNumber value="${difference}" type="number" pattern="#,##0"/>원
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-minus-circle me-2"></i>
                                                <fmt:formatNumber value="${difference}" type="number" pattern="#,##0"/>원
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <small class="opacity-75">
                                        <c:choose>
                                            <c:when test="${difference > 0}">남은 금액</c:when>
                                            <c:when test="${difference == 0}">정확히 일치</c:when>
                                            <c:otherwise>초과 발행</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                            </div>
                        </div>

                        <!-- 발행 건수 정보 -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>발행 정보:</strong> 
                                    오늘 총 <strong>${todayGiftCards.size()}건</strong>의 상품권이 발행되었습니다.
                                    <c:if test="${todayGiftCards.size() > 0}">
                                        (평균 발급액: <fmt:formatNumber value="${todayTotalAmount / todayGiftCards.size()}" type="number" pattern="#,##0"/>원)
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ESC 키로 창 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                window.close();
            }
        });

        // 창이 열릴 때 포커스
        window.onload = function() {
            window.focus();
        };
    </script>
</body>
</html>
