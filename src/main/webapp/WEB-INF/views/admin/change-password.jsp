<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 변경 - 상품권 부정방지 시스템</title>
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
        .form-control {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 12px 20px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
        }
        .password-strength {
            height: 4px;
            border-radius: 2px;
            transition: all 0.3s;
        }
        .strength-weak { background-color: #dc3545; }
        .strength-medium { background-color: #ffc107; }
        .strength-strong { background-color: #28a745; }
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
                            <a class="nav-link" href="/admin/gift-cards">
                                <i class="fas fa-gift me-2"></i>
                                상품권 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/admin/change-password">
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
                        <i class="fas fa-lock me-2"></i>
                        비밀번호 변경
                    </h1>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body p-4">
                                <div class="text-center mb-4">
                                    <i class="fas fa-key fa-4x text-primary mb-3"></i>
                                    <h4 class="card-title">비밀번호 변경</h4>
                                    <p class="text-muted">보안을 위해 정기적으로 비밀번호를 변경해주세요</p>
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

                                <form method="post" action="/admin/change-password" id="passwordForm">
                                    <div class="mb-4">
                                        <label for="currentPassword" class="form-label">
                                            <i class="fas fa-lock me-2"></i>현재 비밀번호
                                        </label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                                               placeholder="현재 비밀번호를 입력하세요" required>
                                    </div>

                                    <div class="mb-4">
                                        <label for="newPassword" class="form-label">
                                            <i class="fas fa-key me-2"></i>새 비밀번호
                                        </label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                               placeholder="새 비밀번호를 입력하세요" required>
                                        <div class="password-strength mt-2" id="passwordStrength"></div>
                                        <small class="form-text text-muted">
                                            <i class="fas fa-info-circle me-1"></i>
                                            비밀번호는 최소 8자 이상이어야 합니다.
                                        </small>
                                    </div>

                                    <div class="mb-4">
                                        <label for="confirmPassword" class="form-label">
                                            <i class="fas fa-check-circle me-2"></i>비밀번호 확인
                                        </label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               placeholder="새 비밀번호를 다시 입력하세요" required>
                                        <div class="invalid-feedback" id="passwordMismatch">
                                            비밀번호가 일치하지 않습니다.
                                        </div>
                                    </div>

                                    <div class="d-grid">
                                        <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                            <i class="fas fa-save me-2"></i>
                                            비밀번호 변경
                                        </button>
                                    </div>
                                </form>

                                <div class="mt-4">
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <h6 class="card-title">
                                                <i class="fas fa-shield-alt me-2"></i>
                                                비밀번호 보안 가이드
                                            </h6>
                                            <ul class="list-unstyled mb-0">
                                                <li class="mb-2">
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    최소 8자 이상의 길이
                                                </li>
                                                <li class="mb-2">
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    대소문자, 숫자, 특수문자 포함
                                                </li>
                                                <li class="mb-2">
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    개인정보나 예측하기 쉬운 단어 사용 금지
                                                </li>
                                                <li>
                                                    <i class="fas fa-check text-success me-2"></i>
                                                    정기적인 비밀번호 변경 (3개월마다 권장)
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 비밀번호 강도 체크
        function checkPasswordStrength(password) {
            const strengthBar = document.getElementById('passwordStrength');
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            strengthBar.className = 'password-strength mt-2';
            
            if (strength < 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength < 4) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        }
        
        // 비밀번호 일치 확인
        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('submitBtn');
            
            if (confirmPassword && newPassword !== confirmPassword) {
                document.getElementById('confirmPassword').classList.add('is-invalid');
                submitBtn.disabled = true;
            } else {
                document.getElementById('confirmPassword').classList.remove('is-invalid');
                submitBtn.disabled = false;
            }
        }
        
        // 이벤트 리스너
        document.getElementById('newPassword').addEventListener('input', function() {
            checkPasswordStrength(this.value);
            checkPasswordMatch();
        });
        
        document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
        
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
