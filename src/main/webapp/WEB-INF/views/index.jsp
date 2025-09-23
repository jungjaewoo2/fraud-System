<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>

<c:set var="pageTitle" value="로그인" />
<%--깃클론테스트--%>
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
                
                <form method="post" action="/login" onsubmit="return validateForm()">
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
                    
                    <div class="mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="privacyAgree" name="privacyAgree">
                            <label class="form-check-label" for="privacyAgree">
                                <i class="fas fa-shield-alt me-2"></i>
                                <a href="#" id="privacyLink">개인정보 처리방침</a>에 동의합니다
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" id="loginBtn" class="btn btn-primary btn-lg">
                            <i class="fas fa-sign-in-alt me-2"></i>
                            로그인
                        </button>
                    </div>
                </form> 
                <div class="d-grid">
                    <button type="button" id="btn_submit" class="btn btn-primary btn-lg">
                        <i class="fas fa-sign-in-alt me-2"></i>
                        본인인증
                    </button>
                </div>
                
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

<div style="display: none;">
    <form name="form_chk" method="post" action="https://nice.checkplus.co.kr/cert/request" target="popupChk">
        <label for="m">m:
            <input type="text" id="m" name="m" value="service">
        </label><br>
        <label for="token_version_id">token_version_id :
            <input type="text"  id="token_version_id" name="token_version_id" value="${token_version_id}">
        </label><br>
        <label for="enc_data"> enc_data :
            <input type="text" id="enc_data" name="enc_data" value="${enc_data}">
        </label><br>
        <label for="integrity_value"> integrity_value :
            <input type="text" id="integrity_value" name="integrity_value" value="${integrity_value}">
        </label><br>
    </form>
</div>
<%@ include file="footer.jsp" %>

<script>
function formatPhoneNumber(input) {
    var value = input.value.replace(/[^\d]/g, '');
    if (value.length >= 11) {
        value = value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
    } else if (value.length >= 7) {
        value = value.replace(/(\d{3})(\d{3})(\d+)/, '$1-$2-$3');
    } else if (value.length >= 3) {
        value = value.replace(/(\d{3})(\d+)/, '$1-$2');
    }
    input.value = value;
}

function openPrivacyWindow() {
    var privacyWindow = window.open('', 'privacyWindow', 'width=800, height=600, scrollbars=yes, resizable=yes');
    privacyWindow.document.write('<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><title>개인정보 처리방침</title><style>body{font-family:\'Malgun Gothic\',Arial,sans-serif;line-height:1.6;margin:20px;background-color:#f8f9fa}.container{max-width:800px;margin:0 auto;background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}h1{color:#2c3e50;border-bottom:3px solid #3498db;padding-bottom:10px;margin-bottom:30px}h2{color:#34495e;margin-top:30px;margin-bottom:15px}h3{color:#7f8c8d;margin-top:20px;margin-bottom:10px}p{margin-bottom:15px;text-align:justify}.highlight{background-color:#e8f4fd;padding:15px;border-left:4px solid #3498db;margin:20px 0}.contact-info{background-color:#f8f9fa;padding:20px;border-radius:5px;margin-top:30px}.close-btn{background-color:#3498db;color:white;padding:10px 20px;border:none;border-radius:5px;cursor:pointer;font-size:14px;margin-top:20px}.close-btn:hover{background-color:#2980b9}</style></head><body><div class="container"><h1>개인정보 처리방침</h1><div class="highlight"><strong>상품권 시스템</strong>은 이용자의 개인정보를 보호하기 위해 최선을 다하고 있습니다. 본 개인정보 처리방침은 이용자의 개인정보 처리에 관한 사항을 안내합니다.</div><h2>1. 개인정보의 수집 및 이용목적</h2><h3>1.1 수집하는 개인정보 항목</h3><p>• <strong>필수항목:</strong> 이름, 핸드폰 번호</p><p>• <strong>자동수집항목:</strong> 접속 IP, 접속 로그, 서비스 이용 기록</p><h3>1.2 개인정보 수집 및 이용목적</h3><p>• 본인 확인 및 서비스 이용자 식별</p><p>• 상품권 조회 및 관리 서비스 제공</p><p>• 서비스 이용 통계 및 개선</p><p>• 부정 이용 방지 및 서비스 안정성 확보</p><h2>2. 개인정보의 보유 및 이용기간</h2><p>• <strong>보유기간:</strong> 서비스 이용 종료 시까지</p><p>• <strong>법령에 의한 보유:</strong> 관련 법령에 따라 필요한 경우 해당 기간까지 보유</p><h2>3. 개인정보의 제3자 제공</h2><p>회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 다음의 경우는 예외로 합니다:</p><p>• 이용자가 사전에 동의한 경우</p><p>• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</p><h2>4. 개인정보의 안전성 확보조치</h2><p>• 개인정보 암호화</p><p>• 해킹 등에 대비한 기술적 대책</p><p>• 개인정보처리시스템 등의 접근권한 관리</p><p>• 개인정보처리자 및 취급직원의 최소화 및 교육</p><h2>5. 이용자의 권리와 행사방법</h2><p>이용자는 언제든지 다음의 권리를 행사할 수 있습니다:</p><p>• 개인정보 처리현황 통지 요구</p><p>• 개인정보 열람, 정정·삭제, 처리정지 요구</p><p>• 개인정보 보호법 제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지)의 규정에 의한 권리 행사</p><h2>6. 개인정보 보호책임자</h2><div class="contact-info"><p><strong>개인정보 보호책임자:</strong> 시스템 관리자</p><p><strong>연락처:</strong> 1588-0000</p><p><strong>이메일:</strong> privacy@example.com</p><p>개인정보 처리에 관한 불만이나 문의사항이 있으시면 언제든지 연락주시기 바랍니다.</p></div><h2>7. 고지의 의무</h2><p>현 개인정보 처리방침은 2025년 1월 1일부터 시행됩니다. 내용의 추가, 삭제 및 수정이 있을 시에는 시행일의 7일 전부터 공지사항을 통하여 고지할 것입니다.</p><button class="close-btn" onclick="window.close()">창 닫기</button></div></body></html>');
    privacyWindow.document.close();
}

function validateForm() {
    var privacyAgree = document.getElementById('privacyAgree');
    
    if (!privacyAgree || !privacyAgree.checked) {
        alert('개인정보 처리방침에 동의해야 로그인할 수 있습니다.\n\n개인정보 처리방침을 확인하고 동의 체크박스를 선택해주세요.');
        if (privacyAgree) {
            privacyAgree.focus();
        }
        return false;
    }
    
    return true;
}

// DOM 로드 후 실행
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('btn_submit').addEventListener('click', function () {
        window.open('', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
        document.form_chk.submit();
    });
    
    document.getElementById('privacyLink').addEventListener('click', function(e) {
        e.preventDefault();
        openPrivacyWindow();
    });
});
</script>