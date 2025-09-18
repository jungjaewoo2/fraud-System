# 상품권 부정방지 시스템

## 프로젝트 개요

상품권 부정방지를 위한 웹 기반 시스템으로, 사용자 인증과 상품권 관리 기능을 제공합니다.

### 주요 기능

#### 사용자 페이지 (모바일 최적화)
- **사용자 로그인**: 이름과 핸드폰 번호로 인증
- **2차 인증**: 관리자 코드 번호 입력
- **상품권 지급**: 1만원, 2만원 상품권 선택 지급
- **상품권 사용이력**: 지급 내역 조회 및 수정/삭제

#### 관리자 페이지 (PC 최적화)
- **관리자 로그인**: 아이디/패스워드 인증
- **비밀번호 변경**: 보안 강화를 위한 비밀번호 변경
- **코드 관리**: 2차 인증용 코드 번호 등록/수정/삭제
- **상품권 관리**: 사용자별 상품권 지급 내역 관리

## 기술 스택

### Backend
- **Java 21**
- **Spring Boot 3.5.4**
- **Spring Security** (인증/인가)
- **Spring Data JPA** (데이터 접근)
- **MySQL 8.0** (데이터베이스)
- **Maven 3.6+** (빌드 도구)

### Frontend
- **HTML5, CSS3, JavaScript**
- **Bootstrap 5** (UI 프레임워크)
- **JSP** (뷰 템플릿)
- **JSTL** (JSP 표준 태그 라이브러리)
- **Font Awesome** (아이콘)

## 프로젝트 구조

```
fraud-System/
├── src/
│   ├── main/
│   │   ├── java/com/jj/fraud_System/
│   │   │   ├── config/              # 설정 클래스
│   │   │   │   └── SecurityConfig.java
│   │   │   ├── controller/          # 컨트롤러
│   │   │   │   ├── HomeController.java
│   │   │   │   └── AdminController.java
│   │   │   ├── entity/              # JPA 엔티티
│   │   │   │   ├── Admin.java
│   │   │   │   ├── AdminCode.java
│   │   │   │   ├── User.java
│   │   │   │   └── GiftCard.java
│   │   │   ├── repository/          # 데이터 접근 계층
│   │   │   │   ├── AdminRepository.java
│   │   │   │   ├── AdminCodeRepository.java
│   │   │   │   ├── UserRepository.java
│   │   │   │   └── GiftCardRepository.java
│   │   │   ├── service/             # 비즈니스 로직
│   │   │   │   ├── AdminService.java
│   │   │   │   ├── AdminCodeService.java
│   │   │   │   ├── UserService.java
│   │   │   │   └── GiftCardService.java
│   │   │   ├── FraudSystemApplication.java
│   │   │   └── ServletInitializer.java
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── db/
│   │   │       └── init.sql
│   │   └── webapp/
│   │       ├── assets/              # 정적 리소스
│   │       │   ├── css/
│   │       │   │   └── style.css
│   │       │   ├── js/
│   │       │   │   └── app.js
│   │       │   └── images/
│   │       ├── uploads/             # 업로드 파일
│   │       └── WEB-INF/views/       # JSP 뷰
│   │           ├── admin/           # 관리자 페이지
│   │           │   ├── login.jsp
│   │           │   ├── dashboard.jsp
│   │           │   ├── code-management.jsp
│   │           │   ├── change-password.jsp
│   │           │   ├── gift-card-management.jsp
│   │           │   └── user-detail.jsp
│   │           ├── *.jsp            # 사용자 페이지
│   │           ├── header.jsp       # 공통 헤더
│   │           └── footer.jsp       # 공통 푸터
│   └── test/                        # 테스트 코드
├── pom.xml                          # Maven 설정
└── README.md                        # 프로젝트 문서
```

## 설치 및 실행

### 1. 사전 요구사항
- Java 21 이상
- Maven 3.6 이상
- MySQL 8.0 이상

### 2. 데이터베이스 설정
```sql
CREATE DATABASE faud_System;
```

### 3. 애플리케이션 설정
`src/main/resources/application.properties` 파일에서 데이터베이스 연결 정보를 확인하고 필요시 수정:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/faud_System?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=topy1004
```

### 4. 빌드 및 실행
```bash
# 프로젝트 빌드
mvn clean compile

# 패키지 생성
mvn package

# 애플리케이션 실행
mvn spring-boot:run
```

### 5. 접속
- **사용자 페이지**: http://localhost:8080
- **관리자 페이지**: http://localhost:8080/admin/login

## 기본 계정 정보

### 관리자 계정
- **아이디**: admin
- **비밀번호**: 123

### 기본 관리자 코드
- 관리자1: CODE001
- 관리자2: CODE002
- 관리자3: CODE003

## 주요 기능 설명

### 사용자 플로우
1. **로그인**: 이름과 핸드폰 번호 입력
2. **2차 인증**: 관리자 코드 번호 입력
3. **상품권 지급**: 금액 선택 및 담당자 입력
4. **이력 조회**: 지급된 상품권 목록 확인
5. **수정/삭제**: 상품권 정보 수정 또는 삭제

### 관리자 플로우
1. **로그인**: 관리자 계정으로 로그인
2. **코드 관리**: 2차 인증용 코드 등록/관리
3. **사용자 관리**: 등록된 사용자 목록 확인
4. **상품권 관리**: 사용자별 상품권 지급 내역 관리

## 보안 기능

- **Spring Security**: 인증 및 인가 처리
- **BCrypt**: 비밀번호 암호화
- **세션 관리**: 사용자 세션 관리
- **CSRF 보호**: CSRF 공격 방지 (개발 편의상 비활성화)

## 개발 가이드

### 새로운 기능 추가
1. Entity 클래스 생성/수정
2. Repository 인터페이스 생성
3. Service 클래스에 비즈니스 로직 구현
4. Controller에 API 엔드포인트 추가
5. JSP 뷰 템플릿 생성/수정

### 데이터베이스 스키마 변경
1. Entity 클래스 수정
2. `init.sql` 파일 업데이트
3. 마이그레이션 스크립트 작성 (필요시)

## 문제 해결

### 자주 발생하는 문제
1. **데이터베이스 연결 오류**
   - MySQL 서버 상태 확인
   - 연결 정보 확인
   - 방화벽 설정 확인

2. **JSP 페이지 로딩 오류**
   - Tomcat Embed Jasper 의존성 확인
   - 뷰 리졸버 설정 확인

3. **빌드 오류**
   - Java 버전 확인 (21 이상 필요)
   - Maven 버전 확인 (3.6 이상 필요)

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 연락처

프로젝트 관련 문의사항이 있으시면 이슈를 등록해주세요.
