package com.jj.fraud_System.service;

import com.jj.fraud_System.entity.Admin;
import com.jj.fraud_System.repository.AdminRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class AdminService {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminService.class);
    
    @Autowired
    private AdminRepository adminRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public Admin authenticate(String username, String password) {
        logger.info("Admin 인증 시도 - 사용자명: {}", username);
        
        Optional<Admin> adminOpt = adminRepository.findByUsername(username);
        if (adminOpt.isPresent()) {
            Admin admin = adminOpt.get();
            logger.debug("Admin 정보 조회 성공 - ID: {}, 저장된 패스워드 해시: {}", admin.getId(), admin.getPassword());
            
            boolean passwordMatches = passwordEncoder.matches(password, admin.getPassword());
            logger.info("패스워드 매칭 결과: {}", passwordMatches);
            
            if (passwordMatches) {
                logger.info("Admin 인증 성공 - 사용자명: {}", username);
                return admin;
            } else {
                logger.warn("패스워드 불일치 - 사용자명: {}, 입력된 패스워드: {}", username, password);
            }
        } else {
            logger.warn("Admin을 찾을 수 없음 - 사용자명: {}", username);
        }
        return null;
    }
    
    public Admin findByUsername(String username) {
        return adminRepository.findByUsername(username).orElse(null);
    }
    
    public Admin save(Admin admin) {
        return adminRepository.save(admin);
    }
    
    public void changePassword(String username, String newPassword) {
        Admin admin = findByUsername(username);
        if (admin != null) {
            admin.setPassword(passwordEncoder.encode(newPassword));
            adminRepository.save(admin);
        }
    }
    
    public boolean existsByUsername(String username) {
        return adminRepository.existsByUsername(username);
    }
    
    public List<Admin> findAll() {
        return adminRepository.findAll();
    }
    
    // 패스워드 매칭 테스트 메소드
    public void testPasswordMatching(String username, String inputPassword) {
        logger.info("=== 패스워드 매칭 테스트 시작 ===");
        logger.info("입력된 사용자명: {}", username);
        logger.info("입력된 패스워드: {}", inputPassword);
        
        Admin admin = findByUsername(username);
        if (admin != null) {
            logger.info("데이터베이스에서 조회된 패스워드 해시: {}", admin.getPassword());
            
            // 직접 BCrypt 매칭 테스트
            boolean matches = passwordEncoder.matches(inputPassword, admin.getPassword());
            logger.info("BCrypt 매칭 결과: {}", matches);
            
            // 새로운 해시 생성 테스트
            String newHash = passwordEncoder.encode(inputPassword);
            logger.info("입력된 패스워드로 생성된 새로운 해시: {}", newHash);
            
            // 새 해시와 입력 패스워드 매칭 테스트
            boolean newMatches = passwordEncoder.matches(inputPassword, newHash);
            logger.info("새 해시와 입력 패스워드 매칭 결과: {}", newMatches);
        } else {
            logger.error("사용자를 찾을 수 없습니다: {}", username);
        }
        logger.info("=== 패스워드 매칭 테스트 완료 ===");
    }
}
