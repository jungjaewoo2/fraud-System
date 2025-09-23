-- MySQL 데이터베이스용 초기 데이터 삽입

-- 기존 테이블에 is_blacklisted 컬럼 추가 (MySQL 호환)
SET @sql = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'user' 
     AND COLUMN_NAME = 'is_blacklisted') = 0,
    'ALTER TABLE user ADD COLUMN is_blacklisted BOOLEAN NOT NULL DEFAULT FALSE',
    'SELECT "Column already exists"'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 기존 테이블에 is_fraud_suspected 컬럼 추가 (MySQL 호환)
SET @sql2 = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'gift_card' 
     AND COLUMN_NAME = 'is_fraud_suspected') = 0,
    'ALTER TABLE gift_card ADD COLUMN is_fraud_suspected BOOLEAN NOT NULL DEFAULT FALSE',
    'SELECT "Column already exists"'
));
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- 관리자 계정 패스워드 업데이트 (비밀번호: 123)
UPDATE admin SET password = '$2a$10$luGYwvjsjHftusxnFJdDHegkYK.ubWP20iiB.uZ5S01Vr.QbVmB7m', updated_at = NOW() WHERE username = 'admin';

-- 기본 관리자 코드 생성
INSERT IGNORE INTO admin_code (admin_name, code_number, created_at, updated_at) VALUES 
('관리자1', 'CODE001', NOW(), NOW()),
('관리자2', 'CODE002', NOW(), NOW()),
('관리자3', 'CODE003', NOW(), NOW());
