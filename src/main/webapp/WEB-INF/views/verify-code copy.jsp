<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="true" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="2차 인증" />

<div class="row justify-content-center">
    <div class="col-12">
        <div class="card">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <i class="fas fa-shield-alt fa-4x text-success mb-3"></i>
                    <h4 class="card-title">2차 인증</h4>
                    <p class="text-muted">관리자가 부여한 코드번호를 입력해주세요</p>
                </div>
                
                <c:if test="${error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- 사용자 정보 박스 - 1.png 형태 유지 (자동 숨기기 방지) -->
                <c:if test="${user != null}">
                    <div class="user-info-box mb-4" style="background-color: #e3f2fd; border: 1px solid #bbdefb; border-radius: 8px; padding: 16px;"
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-user me-2 text-primary"></i>
                            <strong class="text-primary">${user.name}</strong>님 환영합니다.
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <small class="text-muted">
                                    <i class="fas fa-mobile-alt me-1"></i>
                                    핸드폰: ${user.phoneNumber}
                                </small>
                            </div>
                            <div class="col-md-6">
                                <small class="text-muted">
                                    <i class="fas fa-birthday-cake me-1"></i>
                                    생년월일: ${user.birthDate}
                                </small>
                            </div>
                        </div>
                        <c:if test="${totalAmount != null}">
                            <div class="row mt-2">
                                <div class="col-md-6">
                                    <small class="text-success">
                                        <i class="fas fa-coins me-1"></i>
                                        현재 총 상품권 금액: <fmt:formatNumber value="${totalAmount}" type="number"/>원
                                    </small>
                                </div>
                                <div class="col-md-6">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        지급 가능 한도: <fmt:formatNumber value="${140000 - totalAmount}" type="number"/>원
                                    </small>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <form method="post" action="/verify-code">
                    <div class="mb-4">
                        <label for="codeNumber" class="form-label">
                            <i class="fas fa-key me-2"></i>인증 코드
                        </label>
                        <input type="text" class="form-control text-center" id="codeNumber" name="codeNumber" 
                               placeholder="코드번호를 입력하세요" 
                               style="font-size: 1.1rem; font-weight: 500; padding: 12px; border: 2px solid #007bff; border-radius: 8px;"
                               required>
                        <div class="form-text mt-2">
                            <i class="fas fa-info-circle me-1"></i>
                            관리자에게 받은 코드번호를 정확히 입력해주세요
                        </div>
                    </div>
                    
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-success btn-lg" 
                                style="padding: 12px 24px; font-size: 1.1rem; font-weight: 500; border-radius: 8px;">
                            <i class="fas fa-check me-2"></i>
                            인증하기
                        </button>
                    </div>
                </form>
                
                <div class="text-center">
                    <a href="/logout" class="btn btn-outline-secondary" 
                       style="padding: 8px 16px; font-size: 0.9rem; border-radius: 6px;">
                        <i class="fas fa-arrow-left me-2"></i>
                        이전으로
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 리다이렉트 방지 및 디버깅
    console.log('verify-code.jsp loaded at:', new Date().toISOString());
    console.log('Current URL:', window.location.href);
    
    // 페이지 로드 완료 확인
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, verify-code page is ready');
        
        // 코드 입력 필드에 포커스
        document.getElementById('codeNumber').focus();
        
        // 엔터키로 제출
        document.getElementById('codeNumber').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.form.submit();
            }
        });
    });
    
    // 리다이렉트 감지
    window.addEventListener('beforeunload', function(e) {
        console.log('Page is about to unload/redirect');
    });
    
    // 자동 알림 숨기기 방지 - verify-code 페이지에서 사용자 정보는 항상 표시
    document.addEventListener('DOMContentLoaded', function() {
        console.log('verify-code page loaded, user info will remain visible');
        
        // 5초 후 자동 숨기기 스크립트 오버라이드
        setTimeout(function() {
            console.log('Auto-hide timeout reached, keeping user info visible');
            
            // 사용자 정보 박스는 숨기지 않음 (alert 클래스가 없으므로 자동으로 제외됨)
            // 일반 알림만 숨기기 (오류 메시지 등)
            const regularAlerts = document.querySelectorAll('.alert:not(.user-info-box)');
            regularAlerts.forEach(function(alert) {
                // 사용자 정보 박스가 아닌 경우에만 숨기기
                if (!alert.classList.contains('user-info-box')) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            });
        }, 5000);
    });
</script>

<%@ include file="footer.jsp" %>