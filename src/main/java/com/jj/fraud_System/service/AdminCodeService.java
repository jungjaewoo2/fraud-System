package com.jj.fraud_System.service;

import com.jj.fraud_System.entity.AdminCode;
import com.jj.fraud_System.repository.AdminCodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class AdminCodeService {
    
    @Autowired
    private AdminCodeRepository adminCodeRepository;
    
    public List<AdminCode> findAll() {
        return adminCodeRepository.findAll();
    }
    
    public AdminCode findById(Long id) {
        return adminCodeRepository.findById(id).orElse(null);
    }
    
    public AdminCode findByCodeNumber(String codeNumber) {
        return adminCodeRepository.findByCodeNumber(codeNumber).orElse(null);
    }
    
    public AdminCode save(AdminCode adminCode) {
        return adminCodeRepository.save(adminCode);
    }
    
    public void deleteById(Long id) {
        adminCodeRepository.deleteById(id);
    }
    
    public boolean existsByCodeNumber(String codeNumber) {
        return adminCodeRepository.existsByCodeNumber(codeNumber);
    }
    
    public boolean validateCode(String codeNumber) {
        return existsByCodeNumber(codeNumber);
    }
    
    public AdminCode createAdminCode(String adminName, String codeNumber) {
        AdminCode adminCode = new AdminCode(adminName, codeNumber);
        return save(adminCode);
    }
    
    public AdminCode createAdminCode(String adminName, String codeNumber, Integer money) {
        AdminCode adminCode = new AdminCode(adminName, codeNumber, money);
        return save(adminCode);
    }
    
    // 페이징과 정렬이 적용된 조회 (최신 순으로 내림차순)
    public Page<AdminCode> findAllPaged(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return adminCodeRepository.findAll(pageable);
    }
}
