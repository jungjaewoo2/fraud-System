package com.jj.fraud_System.service;

import com.jj.fraud_System.entity.User;
import com.jj.fraud_System.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public User authenticate(String name, String phoneNumber) {
        return userRepository.findByNameAndPhoneNumber(name, phoneNumber).orElse(null);
    }
    
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
    
    public List<User> findAll() {
        return userRepository.findAll();
    }
    
    public List<User> findByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }
    
    public List<User> searchByNameOrPhoneNumber(String name, String phoneNumber) {
        return userRepository.findByNameOrPhoneNumberContaining(name, phoneNumber);
    }
    
    public User save(User user) {
        return userRepository.save(user);
    }
    
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }
    
    public User createUser(String name, String phoneNumber, String birthDateStr) {
        User user = new User();
        user.setName(name);
        user.setPhoneNumber(phoneNumber);
        user.setIsBlacklisted(false); // 기본값 설정
        
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                LocalDate birthDate = LocalDate.parse(birthDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                user.setBirthDate(birthDate);
            } catch (Exception e) {
                // 날짜 파싱 오류 시 생년월일을 null로 설정
                user.setBirthDate(null);
            }
        }
        
        return save(user);
    }
    
    public User updateUser(Long id, String name, String phoneNumber, String birthDateStr) {
        User user = findById(id);
        if (user != null) {
            user.setName(name);
            user.setPhoneNumber(phoneNumber);
            
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                try {
                    LocalDate birthDate = LocalDate.parse(birthDateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    user.setBirthDate(birthDate);
                } catch (Exception e) {
                    user.setBirthDate(null);
                }
            } else {
                user.setBirthDate(null);
            }
            
            return save(user);
        }
        return null;
    }
}
