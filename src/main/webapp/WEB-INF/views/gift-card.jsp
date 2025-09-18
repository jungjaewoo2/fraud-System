<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="상품권 지급" />

<div class="row justify-content-center">
    <div class="col-12">
        <div class="card">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <i class="fas fa-gift fa-4x text-warning mb-3"></i>
                    <h4 class="card-title">상품권 지급</h4>
                    <p class="text-muted">상품권 금액과 지급 담당자를 선택해주세요</p>
                </div>
                
                
                <c:if test="${isLimitExceeded}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>지급 가능한 상품권 금액이 모두 지급되었습니다.</strong>
                        <br>
                        <small>최대 지급 한도인 140,000원에 도달했습니다.</small>
                    </div>
                </c:if>
                
                <form method="post" action="/gift-card" ${isLimitExceeded ? 'style="opacity: 0.5; pointer-events: none;"' : ''}>
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-won-sign me-2"></i>상품권 금액
                        </label>
                        <div class="row">
                            <div class="col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="amount10000" value="10000" 
                                           required ${isLimitExceeded ? 'disabled' : ''}>
                                    <label class="form-check-label" for="amount10000" 
                                           ${isLimitExceeded ? 'style="color: #6c757d;"' : ''}>
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        10,000원
                                    </label>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="amount20000" value="20000" 
                                           required ${isLimitExceeded || (totalAmount + 20000 > 140000) ? 'disabled' : ''}>
                                    <label class="form-check-label" for="amount20000" 
                                           ${isLimitExceeded || (totalAmount + 20000 > 140000) ? 'style="color: #6c757d;"' : ''}>
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        20,000원
                                    </label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 20,000원 선택 불가 시 안내 메시지 -->
                        <c:if test="${!isLimitExceeded && (totalAmount + 20000 > 140000)}">
                            <div class="alert alert-warning mt-2">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>20,000원을 선택할 수 없습니다.</strong><br>
                                현재 지급된 총금액(${totalAmount}원)에 20,000원을 추가하면 140,000원을 초과합니다.<br>
                                <strong>10,000원을 선택해주세요.</strong>
                            </div>
                        </c:if>
                        <div class="form-text text-info">
                            <i class="fas fa-info-circle me-1"></i>
                            상품권 지급된 총금액: <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>원
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="issuedBy" class="form-label">
                            <i class="fas fa-user-tie me-2"></i>지급 담당자
                        </label>
                        <input type="text" class="form-control" id="issuedBy" name="issuedBy" 
                               value="${adminCode.adminName}" readonly
                               style="background-color: #f8f9fa;">
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>
                            인증된 관리자: ${adminCode.adminName} (코드: ${adminCode.codeNumber})
                        </div>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-warning btn-lg" ${isLimitExceeded ? 'disabled' : ''}>
                            <i class="fas fa-gift me-2"></i>
                            <c:choose>
                                <c:when test="${isLimitExceeded}">
                                    지급 한도 도달
                                </c:when>
                                <c:otherwise>
                                    상품권 지급하기
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <a href="/history" class="btn btn-outline-primary">
                        <i class="fas fa-history me-2"></i>
                        사용이력 보기
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 금액 선택 시 시각적 피드백
    document.querySelectorAll('input[name="amount"]').forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.querySelectorAll('input[name="amount"]').forEach(function(r) {
                r.parentElement.parentElement.classList.remove('bg-light', 'border', 'border-success', 'rounded');
            });
            if (this.checked) {
                this.parentElement.parentElement.classList.add('bg-light', 'border', 'border-success', 'rounded', 'p-2');
            }
        });
    });
</script>

<%@ include file="footer.jsp" %>
