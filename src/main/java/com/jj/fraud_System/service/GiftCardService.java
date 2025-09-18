package com.jj.fraud_System.service;

import com.jj.fraud_System.entity.GiftCard;
import com.jj.fraud_System.entity.User;
import com.jj.fraud_System.repository.GiftCardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class GiftCardService {
    
    @Autowired
    private GiftCardRepository giftCardRepository;
    
    public List<GiftCard> findByUser(User user) {
        return giftCardRepository.findByUser(user);
    }
    
    public List<GiftCard> findByUserId(Long userId) {
        return giftCardRepository.findByUserIdOrderByIssuedAtDesc(userId);
    }
    
    public List<GiftCard> findAll() {
        return giftCardRepository.findAll();
    }
    
    public GiftCard findById(Long id) {
        return giftCardRepository.findById(id).orElse(null);
    }
    
    public GiftCard save(GiftCard giftCard) {
        return giftCardRepository.save(giftCard);
    }
    
    public void deleteById(Long id) {
        giftCardRepository.deleteById(id);
    }
    
    public GiftCard createGiftCard(User user, Integer amount, String issuedBy) {
        GiftCard giftCard = new GiftCard(user, amount, issuedBy);
        return save(giftCard);
    }
    
    public GiftCard updateGiftCard(Long id, Integer amount, String issuedBy) {
        GiftCard giftCard = findById(id);
        if (giftCard != null) {
            giftCard.setAmount(amount);
            giftCard.setIssuedBy(issuedBy);
            return save(giftCard);
        }
        return null;
    }
    
    public List<GiftCard> searchByUserNameOrPhoneNumber(String name, String phoneNumber) {
        return giftCardRepository.findByUserNameOrPhoneNumberContaining(name, phoneNumber);
    }
}
