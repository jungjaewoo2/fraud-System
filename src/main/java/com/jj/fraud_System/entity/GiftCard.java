package com.jj.fraud_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "gift_card")
public class GiftCard {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(name = "amount", nullable = false)
    private Integer amount;
    
    @Column(name = "issued_by", nullable = false, length = 100)
    private String issuedBy;
    
    @Column(name = "issued_at")
    private LocalDateTime issuedAt;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "is_fraud_suspected", nullable = false)
    private boolean isFraudSuspected = false;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (issuedAt == null) {
            issuedAt = LocalDateTime.now();
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // 기본 생성자
    public GiftCard() {}
    
    // 생성자
    public GiftCard(User user, Integer amount, String issuedBy) {
        this.user = user;
        this.amount = amount;
        this.issuedBy = issuedBy;
        this.isFraudSuspected = false; // 기본값 설정
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public Integer getAmount() {
        return amount;
    }
    
    public void setAmount(Integer amount) {
        this.amount = amount;
    }
    
    public String getIssuedBy() {
        return issuedBy;
    }
    
    public void setIssuedBy(String issuedBy) {
        this.issuedBy = issuedBy;
    }
    
    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }
    
    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
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
    
    public boolean getIsFraudSuspected() {
        return isFraudSuspected;
    }
    
    public void setIsFraudSuspected(boolean isFraudSuspected) {
        this.isFraudSuspected = isFraudSuspected;
    }
}
