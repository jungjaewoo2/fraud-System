<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="상품권 사용이력" />

<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="card-title mb-1">
                            <i class="fas fa-history me-2 text-primary"></i>
                            상품권 사용이력
                        </h4>
                        <p class="text-muted mb-0">
                            <i class="fas fa-user me-1"></i>
                            ${user.name}님의 상품권 지급 내역
                        </p>
                    </div>
                    <!--<div class="btn-group">
                        <a href="/gift-card" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>
                            새 상품권 지급
                        </a>
                    </div>--->
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
                
                <c:choose>
                    <c:when test="${empty giftCards}">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">상품권 지급 내역이 없습니다</h5>
                            <p class="text-muted">아직 지급받은 상품권이 없습니다.</p>
                            <a href="/gift-card" class="btn btn-primary">
                                <i class="fas fa-gift me-2"></i>
                                상품권 지급받기
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="giftCard" items="${giftCards}">
                                <div class="col-12 mb-3">
                                    <div class="card gift-card-item shadow-sm">
                                        <div class="card-body p-3">
                                            <div class="info-row">
                                                <div class="info-label">
                                                    <i class="fas fa-calendar me-1"></i>지급일
                                                </div>
                                                <div class="info-value">
                                                    ${giftCard.issuedAt.toString().substring(0, 16).replace('T', ' ')}
                                                </div>
                                            </div>
                                            
                                            <div class="info-row">
                                                <div class="info-label">
                                                    <i class="fas fa-won-sign me-1"></i>금액
                                                </div>
                                                <div class="info-value">
                                                    <span class="badge bg-success fs-6">
                                                        <fmt:formatNumber value="${giftCard.amount}" pattern="#,###"/>원
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <div class="info-row">
                                                <div class="info-label">
                                                    <i class="fas fa-user-tie me-1"></i>담당자
                                                </div>
                                                <div class="info-value">
                                                    ${giftCard.issuedBy}
                                                </div>
                                            </div>
                                            
                                            <div class="d-flex justify-content-end mt-3 pt-2 border-top">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="/history/edit/${giftCard.id}" class="btn btn-outline-primary">
                                                        <i class="fas fa-edit me-1"></i>수정
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="deleteGiftCard(${giftCard.id})">
                                                        <i class="fas fa-trash me-1"></i>삭제
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
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
    </div>
</div>

<!-- 삭제 확인 모달 -->
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
                정말로 이 상품권을 삭제하시겠습니까?
                <br>
                <small class="text-muted">삭제된 상품권은 복구할 수 없습니다.</small>
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

<script>
    function deleteGiftCard(id) {
        document.getElementById('deleteForm').action = '/history/delete/' + id;
        new bootstrap.Modal(document.getElementById('deleteModal')).show();
    }

    // 브라우저 뒤로가기 시 메인 페이지로 이동
    document.addEventListener('DOMContentLoaded', function() {
        // 히스토리에 현재 페이지를 메인 페이지로 교체
        history.replaceState({page: 'main'}, '', '/');
        
        // 뒤로가기 이벤트 처리
        window.addEventListener('popstate', function(event) {
            // 뒤로가기 시 메인 페이지로 이동
            window.location.href = '/';
        });
        
        // 모바일에서 뒤로가기 제스처 처리 (터치 이벤트)
        let startX = 0;
        let startY = 0;
        
        document.addEventListener('touchstart', function(e) {
            startX = e.touches[0].clientX;
            startY = e.touches[0].clientY;
        }, false);
        
        document.addEventListener('touchend', function(e) {
            if (!startX || !startY) {
                return;
            }
            
            let endX = e.changedTouches[0].clientX;
            let endY = e.changedTouches[0].clientY;
            
            let diffX = startX - endX;
            let diffY = startY - endY;
            
            // 오른쪽에서 왼쪽으로 스와이프 (뒤로가기 제스처)
            if (Math.abs(diffX) > Math.abs(diffY) && diffX > 50) {
                window.location.href = '/';
            }
            
            startX = 0;
            startY = 0;
        }, false);
    });
</script>

<%@ include file="footer.jsp" %>
