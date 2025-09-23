package com.jj.fraud_System.service;

import com.jj.fraud_System.entity.GiftCard;
import com.jj.fraud_System.entity.User;
import com.jj.fraud_System.repository.GiftCardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
    
    public long countByUserId(Long userId) {
        return giftCardRepository.countByUserId(userId);
    }
    
    public int sumAmountByUserId(Long userId) {
        return giftCardRepository.sumAmountByUserId(userId);
    }
    
    /**
     * 상품권 금액별 통계를 조회합니다.
     * @return 금액별 개수와 총합계가 포함된 Map
     */
    public Map<String, Object> getGiftCardAmountStatistics() {
        List<GiftCard> allGiftCards = findAll();
        
        // 1만원, 2만원 상품권 개수 계산
        long tenThousandCount = allGiftCards.stream()
                .mapToLong(giftCard -> giftCard.getAmount() == 10000 ? 1 : 0)
                .sum();
                
        long twentyThousandCount = allGiftCards.stream()
                .mapToLong(giftCard -> giftCard.getAmount() == 20000 ? 1 : 0)
                .sum();
        
        // 1만원, 2만원 상품권 총 금액 계산
        int tenThousandTotal = allGiftCards.stream()
                .mapToInt(giftCard -> giftCard.getAmount() == 10000 ? giftCard.getAmount() : 0)
                .sum();
                
        int twentyThousandTotal = allGiftCards.stream()
                .mapToInt(giftCard -> giftCard.getAmount() == 20000 ? giftCard.getAmount() : 0)
                .sum();
        
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("tenThousandCount", tenThousandCount);
        statistics.put("twentyThousandCount", twentyThousandCount);
        statistics.put("tenThousandTotal", tenThousandTotal);
        statistics.put("twentyThousandTotal", twentyThousandTotal);
        
        return statistics;
    }
}
