package com.jj.fraud_System.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "user")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    @Column(name = "phone_number", nullable = false, length = 20)
    private String phoneNumber;
    
    @Column(name = "birth_date")
    private LocalDate birthDate;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "is_blacklisted", nullable = false)
    private boolean isBlacklisted = false;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<GiftCard> giftCards = new ArrayList<>();
    
    @Transient
    private int giftCardCount;
    
    @Transient
    private int totalGiftCardAmount;
    
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
    public User() {}
    
    // 생성자
    public User(String name, String phoneNumber, LocalDate birthDate) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.birthDate = birthDate;
        this.isBlacklisted = false; // 기본값 설정
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public LocalDate getBirthDate() {
        return birthDate;
    }
    
    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
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
    
    public boolean getIsBlacklisted() {
        return isBlacklisted;
    }
    
    public void setIsBlacklisted(boolean isBlacklisted) {
        this.isBlacklisted = isBlacklisted;
    }
    
    public List<GiftCard> getGiftCards() {
        return giftCards;
    }
    
    public void setGiftCards(List<GiftCard> giftCards) {
        this.giftCards = giftCards;
    }

    public int getGiftCardCount() {
        return giftCardCount;
    }

    public void setGiftCardCount(int giftCardCount) {
        this.giftCardCount = giftCardCount;
    }

    public int getTotalGiftCardAmount() {
        return totalGiftCardAmount;
    }

    public void setTotalGiftCardAmount(int totalGiftCardAmount) {
        this.totalGiftCardAmount = totalGiftCardAmount;
    }
}
