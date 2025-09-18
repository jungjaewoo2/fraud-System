/**
 * 상품권 부정방지 시스템 JavaScript
 */

// 전역 변수
const App = {
    // 설정
    config: {
        autoHideAlert: 5000, // 알림 자동 숨김 시간 (밀리초)
        phoneNumberPattern: /^010-\d{4}-\d{4}$/, // 전화번호 패턴
        codeNumberPattern: /^CODE\d{3}$/ // 코드 번호 패턴
    },

    // 초기화
    init: function() {
        this.setupEventListeners();
        this.setupAutoHideAlerts();
        this.setupPhoneNumberFormatting();
        this.setupFormValidation();
    },

    // 이벤트 리스너 설정
    setupEventListeners: function() {
        // 전화번호 포맷팅
        document.addEventListener('input', function(e) {
            if (e.target.name === 'phoneNumber') {
                App.formatPhoneNumber(e.target);
            }
        });

        // 숫자만 입력 허용
        document.addEventListener('input', function(e) {
            if (e.target.classList.contains('numbers-only')) {
                e.target.value = e.target.value.replace(/[^\d]/g, '');
            }
        });

        // 엔터키로 폼 제출
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') {
                const form = e.target.closest('form');
                if (form) {
                    form.submit();
                }
            }
        });
    },

    // 자동 알림 숨김 설정
    setupAutoHideAlerts: function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                if (alert.classList.contains('alert-dismissible')) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            });
        }, this.config.autoHideAlert);
    },

    // 전화번호 포맷팅 설정
    setupPhoneNumberFormatting: function() {
        const phoneInputs = document.querySelectorAll('input[name="phoneNumber"]');
        phoneInputs.forEach(function(input) {
            input.addEventListener('input', function() {
                App.formatPhoneNumber(this);
            });
        });
    },

    // 폼 유효성 검사 설정
    setupFormValidation: function() {
        const forms = document.querySelectorAll('form[data-validate]');
        forms.forEach(function(form) {
            form.addEventListener('submit', function(e) {
                if (!App.validateForm(this)) {
                    e.preventDefault();
                }
            });
        });
    },

    // 전화번호 포맷팅
    formatPhoneNumber: function(input) {
        let value = input.value.replace(/[^\d]/g, '');
        
        if (value.length >= 10) {
            value = value.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        } else if (value.length >= 7) {
            value = value.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
        } else if (value.length >= 3) {
            value = value.replace(/(\d{3})(\d{0,4})/, '$1-$2');
        }
        
        input.value = value;
    },

    // 폼 유효성 검사
    validateForm: function(form) {
        let isValid = true;
        const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
        
        inputs.forEach(function(input) {
            if (!App.validateInput(input)) {
                isValid = false;
            }
        });
        
        return isValid;
    },

    // 개별 입력 필드 유효성 검사
    validateInput: function(input) {
        const value = input.value.trim();
        let isValid = true;
        
        // 필수 필드 검사
        if (input.hasAttribute('required') && !value) {
            this.showInputError(input, '필수 입력 항목입니다.');
            isValid = false;
        }
        
        // 전화번호 검사
        if (input.name === 'phoneNumber' && value && !this.config.phoneNumberPattern.test(value)) {
            this.showInputError(input, '올바른 전화번호 형식이 아닙니다. (010-1234-5678)');
            isValid = false;
        }
        
        // 코드 번호 검사
        if (input.name === 'codeNumber' && value && !this.config.codeNumberPattern.test(value)) {
            this.showInputError(input, '올바른 코드 형식이 아닙니다. (CODE001)');
            isValid = false;
        }
        
        if (isValid) {
            this.clearInputError(input);
        }
        
        return isValid;
    },

    // 입력 오류 표시
    showInputError: function(input, message) {
        input.classList.add('is-invalid');
        
        let feedback = input.parentNode.querySelector('.invalid-feedback');
        if (!feedback) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            input.parentNode.appendChild(feedback);
        }
        feedback.textContent = message;
    },

    // 입력 오류 제거
    clearInputError: function(input) {
        input.classList.remove('is-invalid');
        const feedback = input.parentNode.querySelector('.invalid-feedback');
        if (feedback) {
            feedback.remove();
        }
    },

    // 알림 메시지 표시
    showAlert: function(message, type = 'info', duration = 5000) {
        const alertContainer = document.querySelector('.alert-container') || this.createAlertContainer();
        
        const alert = document.createElement('div');
        alert.className = `alert alert-${type} alert-dismissible fade show`;
        alert.innerHTML = `
            <i class="fas fa-${this.getAlertIcon(type)} me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        alertContainer.appendChild(alert);
        
        // 자동 숨김
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, duration);
    },

    // 알림 아이콘 가져오기
    getAlertIcon: function(type) {
        const icons = {
            'success': 'check-circle',
            'danger': 'exclamation-triangle',
            'warning': 'exclamation-circle',
            'info': 'info-circle'
        };
        return icons[type] || 'info-circle';
    },

    // 알림 컨테이너 생성
    createAlertContainer: function() {
        const container = document.createElement('div');
        container.className = 'alert-container position-fixed';
        container.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
        document.body.appendChild(container);
        return container;
    },

    // 로딩 상태 표시
    showLoading: function(button, text = '처리 중...') {
        const originalText = button.innerHTML;
        button.innerHTML = `<span class="loading-spinner"></span> ${text}`;
        button.disabled = true;
        
        return function() {
            button.innerHTML = originalText;
            button.disabled = false;
        };
    },

    // 확인 대화상자
    confirm: function(message, callback) {
        if (confirm(message)) {
            callback();
        }
    },

    // 모달 표시
    showModal: function(modalId) {
        const modal = new bootstrap.Modal(document.getElementById(modalId));
        modal.show();
    },

    // 모달 숨김
    hideModal: function(modalId) {
        const modal = bootstrap.Modal.getInstance(document.getElementById(modalId));
        if (modal) {
            modal.hide();
        }
    },

    // 데이터 가져오기 (AJAX)
    fetchData: function(url, options = {}) {
        const defaultOptions = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        };
        
        return fetch(url, { ...defaultOptions, ...options })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .catch(error => {
                console.error('Error:', error);
                this.showAlert('데이터를 가져오는 중 오류가 발생했습니다.', 'danger');
                throw error;
            });
    },

    // 데이터 전송 (AJAX)
    sendData: function(url, data, options = {}) {
        const defaultOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        };
        
        return fetch(url, { ...defaultOptions, ...options })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .catch(error => {
                console.error('Error:', error);
                this.showAlert('데이터 전송 중 오류가 발생했습니다.', 'danger');
                throw error;
            });
    },

    // 로컬 스토리지 헬퍼
    storage: {
        set: function(key, value) {
            try {
                localStorage.setItem(key, JSON.stringify(value));
            } catch (e) {
                console.error('LocalStorage set error:', e);
            }
        },
        
        get: function(key) {
            try {
                const item = localStorage.getItem(key);
                return item ? JSON.parse(item) : null;
            } catch (e) {
                console.error('LocalStorage get error:', e);
                return null;
            }
        },
        
        remove: function(key) {
            try {
                localStorage.removeItem(key);
            } catch (e) {
                console.error('LocalStorage remove error:', e);
            }
        }
    },

    // 유틸리티 함수들
    utils: {
        // 숫자에 콤마 추가
        formatNumber: function(num) {
            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        },
        
        // 날짜 포맷팅
        formatDate: function(date, format = 'YYYY-MM-DD') {
            const d = new Date(date);
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            const hours = String(d.getHours()).padStart(2, '0');
            const minutes = String(d.getMinutes()).padStart(2, '0');
            
            return format
                .replace('YYYY', year)
                .replace('MM', month)
                .replace('DD', day)
                .replace('HH', hours)
                .replace('mm', minutes);
        },
        
        // 랜덤 문자열 생성
        generateRandomString: function(length = 8) {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            let result = '';
            for (let i = 0; i < length; i++) {
                result += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return result;
        },
        
        // 딥 클론
        deepClone: function(obj) {
            return JSON.parse(JSON.stringify(obj));
        },
        
        // 디바운스
        debounce: function(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }
    }
};

// DOM 로드 완료 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    App.init();
});

// 전역 함수들 (하위 호환성을 위해)
window.formatPhoneNumber = App.formatPhoneNumber;
window.showAlert = App.showAlert;
window.showLoading = App.showLoading;
