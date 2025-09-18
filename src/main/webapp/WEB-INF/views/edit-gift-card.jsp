<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="상품권 수정" />

<div class="row justify-content-center">
    <div class="col-12">
        <div class="card">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <i class="fas fa-edit fa-4x text-warning mb-3"></i>
                    <h4 class="card-title">상품권 정보 수정</h4>
                    <p class="text-muted">상품권 정보를 수정해주세요</p>
                </div>
                
                <c:if test="${error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <form method="post" action="/history/edit/${giftCard.id}">
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-won-sign me-2"></i>상품권 금액
                        </label>
                        <div class="row">
                            <div class="col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="amount10000" 
                                           value="10000" ${giftCard.amount == 10000 ? 'checked' : ''} required>
                                    <label class="form-check-label" for="amount10000">
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        10,000원
                                    </label>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="amount" id="amount20000" 
                                           value="20000" ${giftCard.amount == 20000 ? 'checked' : ''} required>
                                    <label class="form-check-label" for="amount20000">
                                        <i class="fas fa-coins me-1 text-success"></i>
                                        20,000원
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="issuedBy" class="form-label">
                            <i class="fas fa-user-tie me-2"></i>지급 담당자
                        </label>
                        <input type="text" class="form-control" id="issuedBy" name="issuedBy" 
                               value="${giftCard.issuedBy}" 
                               placeholder="지급 담당자 이름을 입력하세요" required>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-warning btn-lg">
                            <i class="fas fa-save me-2"></i>
                            수정하기
                        </button>
                        <a href="/history" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>
                            취소
                        </a>
                    </div>
                </form>
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
    
    // 페이지 로드 시 선택된 금액에 스타일 적용
    document.addEventListener('DOMContentLoaded', function() {
        const checkedRadio = document.querySelector('input[name="amount"]:checked');
        if (checkedRadio) {
            checkedRadio.parentElement.parentElement.classList.add('bg-light', 'border', 'border-success', 'rounded', 'p-2');
        }
    });
</script>

<%@ include file="footer.jsp" %>
