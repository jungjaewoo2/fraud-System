<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                
                <!-- 사용자 정보 박스 - 이미지와 동일하게 구현 -->
                <c:if test="${user != null}">
                    <div class="alert alert-info">
                        <i class="fas fa-user me-2"></i>
                        <strong>${user.name}</strong>님 환영합니다.
                        <br>
                        <small>핸드폰: ${user.phoneNumber}</small>
                        <br>
                        <small>생년월일: ${user.birthDate}</small>
                    </div>
                </c:if>

                <form method="post" action="/verify-code">
                    <div class="mb-4">
                        <label for="codeNumber" class="form-label">
                            <i class="fas fa-key me-2"></i>인증 코드
                        </label>
                        <input type="text" class="form-control text-center" id="codeNumber" name="codeNumber" 
                               placeholder="코드번호를 입력하세요" 
                               style="font-size: 1.2rem; font-weight: bold;"
                               required>
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>
                            관리자에게 받은 코드번호를 정확히 입력해주세요
                        </div>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="fas fa-check me-2"></i>
                            인증하기
                        </button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <a href="/logout" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        이전으로
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 코드 입력 필드에 포커스
    document.getElementById('codeNumber').focus();
    
    // 엔터키로 제출
    document.getElementById('codeNumber').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.form.submit();
        }
    });
</script>

<%@ include file="footer.jsp" %>