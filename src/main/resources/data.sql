-- MySQL 데이터베이스용 초기 데이터 삽입

-- 관리자 계정 패스워드 업데이트 (비밀번호: 123)
UPDATE admin SET password = '$2a$10$luGYwvjsjHftusxnFJdDHegkYK.ubWP20iiB.uZ5S01Vr.QbVmB7m', updated_at = NOW() WHERE username = 'admin';

-- 기본 관리자 코드 생성
INSERT IGNORE INTO admin_code (admin_name, code_number, created_at, updated_at) VALUES 
('관리자1', 'CODE001', NOW(), NOW()),
('관리자2', 'CODE002', NOW(), NOW()),
('관리자3', 'CODE003', NOW(), NOW());
