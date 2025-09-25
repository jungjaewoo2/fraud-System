package com.jj.fraud_System.repository;

import com.jj.fraud_System.entity.GiftCard;
import com.jj.fraud_System.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.time.LocalDateTime;

@Repository
public interface GiftCardRepository extends JpaRepository<GiftCard, Long> {
    
    List<GiftCard> findByUser(User user);
    
    List<GiftCard> findByUserId(Long userId);
    
    @Query("SELECT gc FROM GiftCard gc WHERE gc.user.id = :userId ORDER BY gc.issuedAt DESC")
    List<GiftCard> findByUserIdOrderByIssuedAtDesc(@Param("userId") Long userId);
    
    @Query("SELECT gc FROM GiftCard gc JOIN gc.user u WHERE u.name LIKE %:name% OR u.phoneNumber LIKE %:phoneNumber%")
    List<GiftCard> findByUserNameOrPhoneNumberContaining(@Param("name") String name, @Param("phoneNumber") String phoneNumber);

    @Query("SELECT COUNT(gc) FROM GiftCard gc WHERE gc.user.id = :userId")
    long countByUserId(@Param("userId") Long userId);

    @Query("SELECT COALESCE(SUM(gc.amount), 0) FROM GiftCard gc WHERE gc.user.id = :userId")
    int sumAmountByUserId(@Param("userId") Long userId);
    
    @Query("SELECT gc FROM GiftCard gc WHERE gc.user.id = :userId AND gc.issuedAt BETWEEN :startDate AND :endDate ORDER BY gc.issuedAt DESC")
    List<GiftCard> findByUserIdAndIssuedAtBetween(@Param("userId") Long userId, 
                                                  @Param("startDate") LocalDateTime startDate, 
                                                  @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT gc FROM GiftCard gc WHERE gc.issuedBy = :codeNumber AND gc.issuedAt BETWEEN :startDate AND :endDate ORDER BY gc.issuedAt DESC")
    List<GiftCard> findByIssuedByAndIssuedAtBetweenOrderByIssuedAtDesc(@Param("codeNumber") String codeNumber,
                                                                       @Param("startDate") LocalDateTime startDate,
                                                                       @Param("endDate") LocalDateTime endDate);
}
