package com.jj.fraud_System.repository;

import com.jj.fraud_System.entity.AdminCode;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface AdminCodeRepository extends JpaRepository<AdminCode, Long> {
    
    Optional<AdminCode> findByCodeNumber(String codeNumber);
    
    boolean existsByCodeNumber(String codeNumber);
    
    // 페이징된 결과를 반환 (기본적으로 JpaRepository에서 제공되는 findAll(Pageable)을 사용)
    Page<AdminCode> findAll(Pageable pageable);
}
