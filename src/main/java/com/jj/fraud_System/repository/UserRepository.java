package com.jj.fraud_System.repository;

import com.jj.fraud_System.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByNameAndPhoneNumber(String name, String phoneNumber);
    
    List<User> findByPhoneNumber(String phoneNumber);
    
    @Query("SELECT u FROM User u WHERE u.name LIKE %:name% OR u.phoneNumber LIKE %:phoneNumber%")
    List<User> findByNameOrPhoneNumberContaining(@Param("name") String name, @Param("phoneNumber") String phoneNumber);
}
