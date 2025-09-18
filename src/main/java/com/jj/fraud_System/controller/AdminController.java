package com.jj.fraud_System.controller;

import com.jj.fraud_System.entity.Admin;
import com.jj.fraud_System.entity.AdminCode;
import com.jj.fraud_System.entity.GiftCard;
import com.jj.fraud_System.entity.User;
import com.jj.fraud_System.service.AdminCodeService;
import com.jj.fraud_System.service.AdminService;
import com.jj.fraud_System.service.GiftCardService;
import com.jj.fraud_System.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private AdminCodeService adminCodeService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private GiftCardService giftCardService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    // 관리자 로그인 페이지
    @GetMapping("/login")
    public String adminLogin() {
        return "admin/login";
    }
    
    // 패스워드 테스트 엔드포인트
    @GetMapping("/test-password")
    @ResponseBody
    public String testPassword() {
        adminService.testPasswordMatching("admin", "123");
        return "패스워드 테스트 완료 - 로그 확인하세요";
    }
    
    // 관리자 대시보드
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        logger.info("대시보드 접근 시작");
        
        try {
            logger.debug("사용자 데이터 조회 시작");
            List<User> users = userService.findAll();
            long userCount = users != null ? users.size() : 0;
            logger.debug("사용자 수: {}", userCount);
            
            logger.debug("상품권 데이터 조회 시작");
            List<GiftCard> giftCards = giftCardService.findAll();
            long giftCardCount = giftCards != null ? giftCards.size() : 0;
            logger.debug("상품권 수: {}", giftCardCount);
            
            logger.debug("관리자 코드 데이터 조회 시작");
            List<AdminCode> adminCodes = adminCodeService.findAll();
            long adminCodeCount = adminCodes != null ? adminCodes.size() : 0;
            logger.debug("관리자 코드 수: {}", adminCodeCount);
            
            model.addAttribute("userCount", userCount);
            model.addAttribute("giftCardCount", giftCardCount);
            model.addAttribute("adminCodeCount", adminCodeCount);
            
            logger.info("대시보드 데이터 설정 완료 - 사용자: {}, 상품권: {}, 관리자코드: {}", userCount, giftCardCount, adminCodeCount);
            
        } catch (Exception e) {
            logger.error("대시보드 데이터 조회 중 오류 발생", e);
            // 오류 발생 시 기본값 설정
            model.addAttribute("userCount", 0);
            model.addAttribute("giftCardCount", 0);
            model.addAttribute("adminCodeCount", 0);
        }
        
        logger.info("대시보드 페이지 반환");
        return "admin/dashboard";
    }
    
    // 비밀번호 변경 페이지
    @GetMapping("/change-password")
    public String changePassword() {
        return "admin/change-password";
    }
    
    // 비밀번호 변경 처리
    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPassword,
                               @RequestParam String newPassword,
                               @RequestParam String confirmPassword,
                               Principal principal,
                               RedirectAttributes redirectAttributes) {
        
        logger.info("비밀번호 변경 요청 시작 - 사용자: {}", principal.getName());
        
        if (!newPassword.equals(confirmPassword)) {
            logger.warn("비밀번호 확인 불일치 - 사용자: {}", principal.getName());
            redirectAttributes.addFlashAttribute("error", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            return "redirect:/admin/change-password";
        }
        
        // 새 비밀번호 길이 검증
        if (newPassword.length() < 8) {
            logger.warn("비밀번호 길이 부족 - 사용자: {}", principal.getName());
            redirectAttributes.addFlashAttribute("error", "새 비밀번호는 최소 8자 이상이어야 합니다.");
            return "redirect:/admin/change-password";
        }
        
        try {
            Admin admin = adminService.findByUsername(principal.getName());
            if (admin == null) {
                logger.error("관리자를 찾을 수 없음 - 사용자: {}", principal.getName());
                redirectAttributes.addFlashAttribute("error", "관리자 정보를 찾을 수 없습니다.");
                return "redirect:/admin/change-password";
            }
            
            logger.debug("관리자 정보 확인 완료 - ID: {}, 사용자명: {}", admin.getId(), admin.getUsername());
            
            // 현재 비밀번호 확인
            if (!passwordEncoder.matches(currentPassword, admin.getPassword())) {
                logger.warn("현재 비밀번호 불일치 - 사용자: {}", principal.getName());
                redirectAttributes.addFlashAttribute("error", "현재 비밀번호가 올바르지 않습니다.");
                return "redirect:/admin/change-password";
            }
            
            logger.debug("현재 비밀번호 확인 완료 - 사용자: {}", principal.getName());
            
            // 비밀번호 변경
            adminService.changePassword(principal.getName(), newPassword);
            logger.info("비밀번호 변경 완료 - 사용자: {}", principal.getName());
            
            redirectAttributes.addFlashAttribute("success", "비밀번호가 성공적으로 변경되었습니다.");
            
        } catch (Exception e) {
            logger.error("비밀번호 변경 중 오류 발생 - 사용자: " + principal.getName(), e);
            redirectAttributes.addFlashAttribute("error", "비밀번호 변경 중 오류가 발생했습니다.");
        }
        
        return "redirect:/admin/change-password";
    }
    
    // 코드 관리 페이지
    @GetMapping("/codes")
    public String codeManagement(Model model,
                               @RequestParam(defaultValue = "0") int page,
                               @RequestParam(defaultValue = "10") int size) {
        org.springframework.data.domain.Page<AdminCode> adminCodesPage = adminCodeService.findAllPaged(page, size);
        
        model.addAttribute("adminCodes", adminCodesPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", adminCodesPage.getTotalPages());
        model.addAttribute("totalElements", adminCodesPage.getTotalElements());
        model.addAttribute("size", size);
        model.addAttribute("hasPrevious", adminCodesPage.hasPrevious());
        model.addAttribute("hasNext", adminCodesPage.hasNext());
        
        return "admin/code-management";
    }
    
    // 코드 추가 처리
    @PostMapping("/codes")
    public String addCode(@RequestParam String adminName,
                        @RequestParam String codeNumber,
                        RedirectAttributes redirectAttributes) {
        
        if (adminCodeService.existsByCodeNumber(codeNumber)) {
            redirectAttributes.addFlashAttribute("error", "이미 존재하는 코드번호입니다.");
        } else {
            adminCodeService.createAdminCode(adminName, codeNumber);
            redirectAttributes.addFlashAttribute("success", "코드가 추가되었습니다.");
        }
        
        return "redirect:/admin/codes";
    }
    
    // 코드 수정 처리
    @PostMapping("/codes/edit/{id}")
    public String editCode(@PathVariable Long id,
                         @RequestParam String adminName,
                         @RequestParam String codeNumber,
                         RedirectAttributes redirectAttributes) {
        
        AdminCode adminCode = adminCodeService.findById(id);
        if (adminCode != null) {
            // 다른 코드가 같은 번호를 사용하는지 확인
            AdminCode existingCode = adminCodeService.findByCodeNumber(codeNumber);
            if (existingCode != null && !existingCode.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "이미 존재하는 코드번호입니다.");
            } else {
                adminCode.setAdminName(adminName);
                adminCode.setCodeNumber(codeNumber);
                adminCodeService.save(adminCode);
                redirectAttributes.addFlashAttribute("success", "코드가 수정되었습니다.");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "코드를 찾을 수 없습니다.");
        }
        
        return "redirect:/admin/codes";
    }
    
    // 코드 삭제 처리
    @PostMapping("/codes/delete/{id}")
    public String deleteCode(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        adminCodeService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "코드가 삭제되었습니다.");
        return "redirect:/admin/codes";
    }
    
    // 상품권 관리 페이지
    @GetMapping("/gift-cards")
    public String giftCardManagement(Model model, 
                                   @RequestParam(required = false) String search) {
        List<User> users;
        if (search != null && !search.trim().isEmpty()) {
            users = userService.searchByNameOrPhoneNumber(search, search);
        } else {
            users = userService.findAll();
        }
        
        model.addAttribute("users", users);
        model.addAttribute("search", search);
        return "admin/gift-card-management";
    }
    
    // 사용자 상세 페이지
    @GetMapping("/users/{id}")
    public String userDetail(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        if (user == null) {
            return "redirect:/admin/gift-cards";
        }
        
        List<GiftCard> giftCards = giftCardService.findByUserId(id);
        // 상품권 목록을 지급일 기준으로 내림차순 정렬 (최신순)
        giftCards.sort((a, b) -> b.getIssuedAt().compareTo(a.getIssuedAt()));
        
        model.addAttribute("user", user);
        model.addAttribute("giftCards", giftCards);
        
        return "admin/user-detail";
    }
    
    // 사용자 삭제 처리
    @PostMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        userService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "사용자가 삭제되었습니다.");
        return "redirect:/admin/gift-cards";
    }
    
    // 상품권 추가 처리
    @PostMapping("/users/{userId}/gift-cards")
    public String addGiftCard(@PathVariable Long userId,
                            @RequestParam Integer amount,
                            @RequestParam String issuedBy,
                            RedirectAttributes redirectAttributes) {
        
        User user = userService.findById(userId);
        if (user != null) {
            giftCardService.createGiftCard(user, amount, issuedBy);
            redirectAttributes.addFlashAttribute("success", "상품권이 추가되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "사용자를 찾을 수 없습니다.");
        }
        
        return "redirect:/admin/users/" + userId;
    }
    
    // 상품권 수정 처리
    @PostMapping("/gift-cards/edit/{id}")
    public String editGiftCard(@PathVariable Long id,
                             @RequestParam Integer amount,
                             @RequestParam String issuedBy,
                             @RequestParam Long userId,
                             RedirectAttributes redirectAttributes) {
        
        GiftCard giftCard = giftCardService.updateGiftCard(id, amount, issuedBy);
        if (giftCard != null) {
            redirectAttributes.addFlashAttribute("success", "상품권이 수정되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("error", "상품권을 찾을 수 없습니다.");
        }
        
        return "redirect:/admin/users/" + userId;
    }
    
    // 상품권 삭제 처리
    @PostMapping("/gift-cards/delete/{id}")
    public String deleteGiftCard(@PathVariable Long id,
                               @RequestParam Long userId,
                               RedirectAttributes redirectAttributes) {
        
        giftCardService.deleteById(id);
        redirectAttributes.addFlashAttribute("success", "상품권이 삭제되었습니다.");
        return "redirect:/admin/users/" + userId;
    }
}
