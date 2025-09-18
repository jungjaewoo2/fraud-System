package com.jj.fraud_System.controller;

import com.jj.fraud_System.entity.AdminCode;
import com.jj.fraud_System.entity.GiftCard;
import com.jj.fraud_System.entity.User;
import com.jj.fraud_System.service.AdminCodeService;
import com.jj.fraud_System.service.GiftCardService;
import com.jj.fraud_System.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Random;

@Controller
public class HomeController {
    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @Autowired
    private UserService userService;
    
    @Autowired
    private AdminCodeService adminCodeService;
    
    @Autowired
    private GiftCardService giftCardService;
    
    // 메인 로그인 페이지
    @GetMapping("/")
    public String home() {
        return "index";
    }
    
    // 사용자 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String name, 
                       @RequestParam String phoneNumber,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        
        // 기존 사용자 인증 시도
        User user = userService.authenticate(name, phoneNumber);
        
        // 사용자가 존재하지 않으면 새로 생성
        if (user == null) {
            // 임의의 생년월일 생성 (1970-2000년 사이)
            Random random = new Random();
            int year = 1970 + random.nextInt(31); // 1970-2000년
            int month = 1 + random.nextInt(12);   // 1-12월
            int day = 1 + random.nextInt(28);     // 1-28일 (모든 월에 안전한 범위)
            LocalDate randomBirthDate = LocalDate.of(year, month, day);
            
            user = userService.createUser(name, phoneNumber, randomBirthDate.toString());
        } else if (user.getBirthDate() == null) {
            // 기존 사용자의 생년월일이 null인 경우 임의의 생년월일 설정
            Random random = new Random();
            int year = 1970 + random.nextInt(31); // 1970-2000년
            int month = 1 + random.nextInt(12);   // 1-12월
            int day = 1 + random.nextInt(28);     // 1-28일 (모든 월에 안전한 범위)
            LocalDate randomBirthDate = LocalDate.of(year, month, day);
            
            user.setBirthDate(randomBirthDate);
            userService.save(user);
        }
        
        // 세션에 사용자 정보 저장 (인증코드 처리 시 필요)
        session.setAttribute("user", user);
        // RedirectAttributes에도 저장 (GET /verify-code에서 사용)
        redirectAttributes.addFlashAttribute("user", user);
        logger.debug("DEBUG: Login successful, user saved to session and flash attributes: " + user.getName() + " (ID: " + user.getId() + ")");
        return "redirect:/verify-code";
    }
    
    // 2차 인증 페이지
    @GetMapping("/verify-code")
    public String verifyCode(@ModelAttribute("user") User user, HttpSession session, Model model) {
        // RedirectAttributes에서 user가 없을 경우 세션에서 가져옴 (이전 코드와의 호환성을 위해)
        if (user == null || user.getId() == null) {
            user = (User) session.getAttribute("user");
            logger.debug("DEBUG: User not in flash attributes, retrieved from session: " + (user != null ? user.getName() : "null"));
        }

        logger.debug("DEBUG: /verify-code GET - User in session/flash: " + (user != null ? user.getName() : "null"));
        if (user == null) {
            logger.debug("DEBUG: User is null, redirecting to home");
            return "redirect:/";
        }
        model.addAttribute("user", user);
        logger.debug("DEBUG: User found, rendering verify-code page for: " + user.getName());
        return "verify-code";
    }
    
    // 2차 인증 처리
    @PostMapping("/verify-code")
    public String verifyCode(@RequestParam String codeNumber,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            logger.debug("DEBUG: User is null for POST /verify-code, redirecting to home");
            redirectAttributes.addFlashAttribute("error", "세션이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/";
        }
        
        logger.debug("DEBUG: Verifying code: " + codeNumber + " for user: " + user.getName());
        
        if (adminCodeService.validateCode(codeNumber)) {
            // 인증된 코드 정보를 세션에 저장
            var adminCode = adminCodeService.findByCodeNumber(codeNumber);
            if (adminCode != null) {
                session.setAttribute("verified", true);
                session.setAttribute("adminCode", adminCode);
                logger.debug("DEBUG: Admin code verified successfully, redirecting to gift-card page");
            } else {
                logger.warn("WARN: Admin code validated but findByCodeNumber returned null for: {}", codeNumber);
                redirectAttributes.addFlashAttribute("error", "인증 코드 처리 중 오류가 발생했습니다.");
                return "redirect:/verify-code";
            }
            return "redirect:/gift-card";
        } else {
            redirectAttributes.addFlashAttribute("error", "인증 코드가 올바르지 않습니다.");
            logger.debug("DEBUG: Invalid admin code for: " + codeNumber);
            return "redirect:/verify-code";
        }
    }
    
    // 상품권 지급 페이지
    @GetMapping("/gift-card")
    public String giftCard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        var adminCode = (AdminCode) session.getAttribute("adminCode");
        
        if (user == null || verified == null || !verified || adminCode == null) {
            return "redirect:/";
        }
        
        // 사용자의 기존 상품권 총 금액 계산
        List<GiftCard> existingGiftCards = giftCardService.findByUserId(user.getId());
        int totalAmount = existingGiftCards.stream()
                .mapToInt(GiftCard::getAmount)
                .sum();
        
        // 140,000원 제한 확인
        boolean isLimitExceeded = totalAmount >= 140000;
        
        model.addAttribute("user", user);
        model.addAttribute("adminCode", adminCode);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("isLimitExceeded", isLimitExceeded);
        model.addAttribute("remainingAmount", Math.max(0, 140000 - totalAmount));
        
        return "gift-card";
    }
    
    // 상품권 지급 처리
    @PostMapping("/gift-card")
    public String issueGiftCard(@RequestParam Integer amount,
                              @RequestParam String issuedBy,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        
        if (user == null || verified == null || !verified) {
            return "redirect:/";
        }
        
        // 사용자의 기존 상품권 총 금액 계산
        List<GiftCard> existingGiftCards = giftCardService.findByUserId(user.getId());
        int totalAmount = existingGiftCards.stream()
                .mapToInt(GiftCard::getAmount)
                .sum();
        
        // 140,000원 제한 확인
        if (totalAmount >= 140000) {
            redirectAttributes.addFlashAttribute("error", "지급 가능한 상품권 금액이 모두 지급되었습니다. (최대 140,000원)");
            return "redirect:/gift-card";
        }
        
        // 추가 지급 시 총 금액이 140,000원을 초과하는지 확인
        if (totalAmount + amount > 140000) {
            redirectAttributes.addFlashAttribute("error", 
                String.format("상품권 지급 후 총 금액이 140,000원을 초과합니다. (현재: %,d원, 지급 가능: %,d원)", 
                    totalAmount, 140000 - totalAmount));
            return "redirect:/gift-card";
        }
        
        giftCardService.createGiftCard(user, amount, issuedBy);
        redirectAttributes.addFlashAttribute("success", "상품권이 지급되었습니다.");
        
        return "redirect:/history";
    }
    
    // 상품권 사용이력 페이지
    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        
        if (user == null || verified == null || !verified) {
            return "redirect:/";
        }
        
        List<GiftCard> giftCards = giftCardService.findByUserId(user.getId());
        model.addAttribute("user", user);
        model.addAttribute("giftCards", giftCards);
        
        return "history";
    }
    
    // 상품권 수정 페이지
    @GetMapping("/history/edit/{id}")
    public String editGiftCard(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        
        if (user == null || verified == null || !verified) {
            return "redirect:/";
        }
        
        GiftCard giftCard = giftCardService.findById(id);
        if (giftCard == null || !giftCard.getUser().getId().equals(user.getId())) {
            return "redirect:/history";
        }
        
        model.addAttribute("giftCard", giftCard);
        return "edit-gift-card";
    }
    
    // 상품권 수정 처리
    @PostMapping("/history/edit/{id}")
    public String updateGiftCard(@PathVariable Long id,
                               @RequestParam Integer amount,
                               @RequestParam String issuedBy,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        
        if (user == null || verified == null || !verified) {
            return "redirect:/";
        }
        
        GiftCard giftCard = giftCardService.findById(id);
        if (giftCard != null && giftCard.getUser().getId().equals(user.getId())) {
            giftCardService.updateGiftCard(id, amount, issuedBy);
            redirectAttributes.addFlashAttribute("success", "상품권 정보가 수정되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "상품권을 찾을 수 없습니다.");
        }
        
        return "redirect:/history";
    }
    
    // 상품권 삭제 처리
    @PostMapping("/history/delete/{id}")
    public String deleteGiftCard(@PathVariable Long id,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        Boolean verified = (Boolean) session.getAttribute("verified");
        
        if (user == null || verified == null || !verified) {
            return "redirect:/";
        }
        
        GiftCard giftCard = giftCardService.findById(id);
        if (giftCard != null && giftCard.getUser().getId().equals(user.getId())) {
            giftCardService.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "상품권이 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "상품권을 찾을 수 없습니다.");
        }
        
        return "redirect:/history";
    }
    
    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
