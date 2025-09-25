package com.jj.fraud_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "admin_code")
public class AdminCode {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "admin_name", nullable = false, length = 100)
    private String adminName;
    
    @Column(name = "code_number", unique = true, nullable = false, length = 20)
    private String codeNumber;
    
    @Column(name = "money", nullable = false)
    private Integer money;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // 기본 생성자
    public AdminCode() {}
    
    // 생성자
    public AdminCode(String adminName, String codeNumber) {
        this.adminName = adminName;
        this.codeNumber = codeNumber;
    }
    
    public AdminCode(String adminName, String codeNumber, Integer money) {
        this.adminName = adminName;
        this.codeNumber = codeNumber;
        this.money = money;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getAdminName() {
        return adminName;
    }
    
    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
    
    public String getCodeNumber() {
        return codeNumber;
    }
    
    public void setCodeNumber(String codeNumber) {
        this.codeNumber = codeNumber;
    }
    
    public Integer getMoney() {
        return money;
    }
    
    public void setMoney(Integer money) {
        this.money = money;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
