<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="로그인" />

<div class="row justify-content-center">
    <div class="col-12">
        <div class="card">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <i class="fas fa-user-circle fa-4x text-primary mb-3"></i>
                    <h4 class="card-title">상품권 시스템 로그인</h4>
                    <p class="text-muted">이름과 핸드폰 번호를 입력해주세요</p>
                </div>
                
                <c:if test="${error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <form method="post" action="/login">
                    <div class="mb-3">
                        <label for="name" class="form-label">
                            <i class="fas fa-user me-2"></i>이름
                        </label>
                        <input type="text" class="form-control" id="name" name="name" 
                               placeholder="이름을 입력하세요" required>
                    </div>
                    
                    <div class="mb-4">
                        <label for="phoneNumber" class="form-label">
                            <i class="fas fa-mobile-alt me-2"></i>핸드폰 번호
                        </label>
                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                               placeholder="010-1234-5678" 
                               oninput="formatPhoneNumber(this)"
                               maxlength="13" required>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-sign-in-alt me-2"></i>
                            로그인
                        </button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <small class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        관리자는 <a href="/admin/login">관리자 로그인</a>을 이용해주세요
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
