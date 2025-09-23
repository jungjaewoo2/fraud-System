<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</div>
        
        <footer class="bg-white border-top mt-5 py-3">
            <div class="container-fluid text-center">
                <small class="text-muted">
                    <i class="fas fa-copyright me-1"></i>
                    2025 상품권 부정방지 시스템. All rights reserved.<br>
                    대구시 달서구월배로15길8 7층  <br>
                    TEL : 053 635 0595 EMAILddtt555@naver.com
                    
                </small>
            </div>
        </footer>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 자동으로 알림 메시지 숨기기 (verify-code 페이지 제외)
        setTimeout(function() {
            // verify-code 페이지에서는 자동 숨기기 비활성화
            if (window.location.pathname === '/verify-code') {
                console.log('verify-code page detected, skipping auto-hide');
                return;
            }
            
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                // 사용자 정보 박스는 제외
                if (!alert.classList.contains('user-info-box')) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            });
        }, 5000);
        
        // 전화번호 자동 하이픈 추가
        function formatPhoneNumber(input) {
            let value = input.value.replace(/[^\d]/g, '');
            if (value.length >= 10) {
                value = value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
            } else if (value.length >= 7) {
                value = value.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            } else if (value.length >= 3) {
                value = value.replace(/(\d{3})(\d{0,4})/, '$1-$2');
            }
            input.value = value;
        }
        
        // 숫자만 입력 허용
        function onlyNumbers(input) {
            input.value = input.value.replace(/[^\d]/g, '');
        }
    </script>
</body>
</html>
