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
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.io.IOException;
import java.io.PrintWriter;

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
            
            // 상품권 금액별 통계 조회
            logger.debug("상품권 금액별 통계 조회 시작");
            Map<String, Object> giftCardStatistics = giftCardService.getGiftCardAmountStatistics();
            
            model.addAttribute("userCount", userCount);
            model.addAttribute("giftCardCount", giftCardCount);
            model.addAttribute("adminCodeCount", adminCodeCount);
            model.addAttribute("giftCardStatistics", giftCardStatistics);
            
            logger.info("대시보드 데이터 설정 완료 - 사용자: {}, 상품권: {}, 관리자코드: {}", userCount, giftCardCount, adminCodeCount);
            logger.info("상품권 통계 - 1만원: {}개({}원), 2만원: {}개({}원)", 
                giftCardStatistics.get("tenThousandCount"), 
                giftCardStatistics.get("tenThousandTotal"),
                giftCardStatistics.get("twentyThousandCount"), 
                giftCardStatistics.get("twentyThousandTotal"));
            
        } catch (Exception e) {
            logger.error("대시보드 데이터 조회 중 오류 발생", e);
            // 오류 발생 시 기본값 설정
            model.addAttribute("userCount", 0);
            model.addAttribute("giftCardCount", 0);
            model.addAttribute("adminCodeCount", 0);
            
            // 상품권 통계 기본값 설정
            Map<String, Object> defaultStatistics = new HashMap<>();
            defaultStatistics.put("tenThousandCount", 0L);
            defaultStatistics.put("twentyThousandCount", 0L);
            defaultStatistics.put("tenThousandTotal", 0);
            defaultStatistics.put("twentyThousandTotal", 0);
            model.addAttribute("giftCardStatistics", defaultStatistics);
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
                                   @RequestParam(required = false) String search,
                                   @RequestParam(defaultValue = "0") int page,
                                   @RequestParam(defaultValue = "10") int size) {
        
        try {
            logger.info("상품권 관리 페이지 접근 - search: {}, page: {}, size: {}", search, page, size);
            
            // 페이징을 위한 전체 사용자 수 계산
            List<User> allUsers;
            if (search != null && !search.trim().isEmpty()) {
                logger.debug("사용자 검색 실행: {}", search);
                allUsers = userService.searchByNameOrPhoneNumber(search, search);
            } else {
                logger.debug("전체 사용자 조회 실행");
                allUsers = userService.findAll();
            }
            
            logger.debug("전체 사용자 수: {}", allUsers.size());
            
            // ID 내림차순 정렬 (페이징 전에 정렬)
            allUsers.sort((a, b) -> Long.compare(b.getId(), a.getId()));
            
            // 페이징 계산
            int totalUsers = allUsers.size();
            int totalPages = totalUsers > 0 ? (int) Math.ceil((double) totalUsers / size) : 1;
            int startIndex = page * size;
            int endIndex = Math.min(startIndex + size, totalUsers);
            
            // 현재 페이지에 해당하는 사용자 목록 추출
            List<User> users;
            if (startIndex >= totalUsers) {
                // 페이지가 범위를 벗어난 경우 빈 리스트
                users = List.of();
            } else {
                users = allUsers.subList(startIndex, endIndex);
            }
            
            logger.debug("현재 페이지 사용자 수: {}", users.size());
            
            // 각 사용자별 추가 정보 (지급 횟수, 총액)
            for (User user : users) {
                try {
                    user.setGiftCardCount((int) giftCardService.countByUserId(user.getId()));
                    user.setTotalGiftCardAmount(giftCardService.sumAmountByUserId(user.getId()));
                } catch (Exception e) {
                    logger.warn("사용자 {} 정보 설정 중 오류: {}", user.getId(), e.getMessage());
                    user.setGiftCardCount(0);
                    user.setTotalGiftCardAmount(0);
                }
            }
            
            model.addAttribute("users", users);
            model.addAttribute("search", search);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalElements", totalUsers);
            model.addAttribute("size", size);
            model.addAttribute("endIndex", endIndex);
            model.addAttribute("hasPrevious", page > 0);
            model.addAttribute("hasNext", page < totalPages - 1);
            
            logger.info("상품권 관리 페이지 설정 완료 - 사용자: {}, 총 페이지: {}", users.size(), totalPages);
            
        } catch (Exception e) {
            logger.error("상품권 관리 페이지 처리 중 오류 발생", e);
            model.addAttribute("error", "데이터를 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("users", List.of());
            model.addAttribute("totalElements", 0);
            model.addAttribute("totalPages", 1);
            model.addAttribute("currentPage", 0);
        }
        
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
    
    // 블랙리스트 상태 변경 처리
    @PostMapping("/users/{userId}/blacklist")
    public String updateBlacklistStatus(@PathVariable Long userId,
                                      @RequestParam(required = false) String isBlacklisted,
                                      RedirectAttributes redirectAttributes) {
        
        logger.info("블랙리스트 상태 변경 요청 - 사용자 ID: {}, isBlacklisted 파라미터: {}", userId, isBlacklisted);
        
        User user = userService.findById(userId);
        if (user != null) {
            // 파라미터가 null이거나 빈 문자열인 경우 false로 처리
            boolean blacklistStatus = "on".equals(isBlacklisted);
            logger.info("사용자 찾음 - ID: {}, 이름: {}, 현재 블랙리스트 상태: {}, 새 상태: {}", 
                       user.getId(), user.getName(), user.getIsBlacklisted(), blacklistStatus);
            
            user.setIsBlacklisted(blacklistStatus);
            User savedUser = userService.save(user);
            logger.info("블랙리스트 상태 저장 완료 - 저장된 상태: {}", savedUser.getIsBlacklisted());
            
            if (blacklistStatus) {
                redirectAttributes.addFlashAttribute("success", "사용자가 블랙리스트에 등록되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("success", "사용자가 블랙리스트에서 해제되었습니다.");
            }
        } else {
            logger.error("사용자를 찾을 수 없음 - ID: {}", userId);
            redirectAttributes.addFlashAttribute("error", "사용자를 찾을 수 없습니다.");
        }
        
        return "redirect:/admin/users/" + userId;
    }
    
    // 상품권 추가 처리
    @PostMapping("/users/{userId}/gift-cards")
    public String addGiftCard(@PathVariable Long userId,
                            @RequestParam Integer amount,
                            @RequestParam String issuedBy,
                            RedirectAttributes redirectAttributes) {
        
        User user = userService.findById(userId);
        if (user != null) {
            // 블랙리스트 사용자 상품권 지급 제한
            if (user.getIsBlacklisted()) {
                redirectAttributes.addFlashAttribute("error", "블랙리스트에 등록된 사용자에게는 상품권을 지급할 수 없습니다.");
                return "redirect:/admin/users/" + userId;
            }
            
            // 총금액 제한 확인 (140,000원 이상 제한)
            int currentTotalAmount = giftCardService.sumAmountByUserId(userId);
            if (currentTotalAmount + amount > 140000) {
                redirectAttributes.addFlashAttribute("error", 
                    String.format("총 지급 한도(140,000원)를 초과합니다. 현재 총액: %,d원, 추가 요청: %,d원", 
                        currentTotalAmount, amount));
                return "redirect:/admin/users/" + userId;
            }
            
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
    
    // 엑셀 다운로드
    @GetMapping("/gift-cards/export")
    public void exportUsersToExcel(@RequestParam(required = false) String search,
                                 HttpServletResponse response) throws IOException {
        
        try {
            logger.info("사용자 엑셀 다운로드 요청 - search: {}", search);
            
            List<User> users;
            if (search != null && !search.trim().isEmpty()) {
                logger.debug("사용자 검색 실행: {}", search);
                users = userService.searchByNameOrPhoneNumber(search, search);
            } else {
                logger.debug("전체 사용자 조회 실행");
                users = userService.findAll();
            }
            
            logger.debug("다운로드할 사용자 수: {}", users.size());

        // 각 사용자별 추가 정보 (지급 횟수, 총액)
        for (User user : users) {
            try {
                user.setGiftCardCount((int) giftCardService.countByUserId(user.getId()));
                user.setTotalGiftCardAmount(giftCardService.sumAmountByUserId(user.getId()));
            } catch (Exception e) {
                logger.warn("사용자 {} 정보 설정 중 오류: {}", user.getId(), e.getMessage());
                user.setGiftCardCount(0);
                user.setTotalGiftCardAmount(0);
            }
        }
        
        // ID 내림차순 정렬
        users.sort((a, b) -> Long.compare(b.getId(), a.getId()));
        
        // CSV 형식으로 응답 설정
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_export.csv\"");
        
        // BOM 추가 (한글 깨짐 방지)
        response.getWriter().write("\uFEFF");
        
        PrintWriter writer = response.getWriter();
        
        // 헤더 작성
        writer.println("순번,이름,전화번호,생년월일,지급 횟수,총 지급액,가입일,블랙리스트 유무");
        
        // 데이터 작성
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            try {
                writer.printf("%d,%s,%s,%s,%d,%d,%s,%s%n",
                    users.size() - i, // 내림차순 순번
                    user.getName() != null ? user.getName() : "",
                    user.getPhoneNumber() != null ? user.getPhoneNumber() : "",
                    user.getBirthDate() != null ? user.getBirthDate().toString() : "",
                    user.getGiftCardCount(),
                    user.getTotalGiftCardAmount(),
                    user.getCreatedAt() != null ? user.getCreatedAt().toLocalDate() : "",
                    user.getIsBlacklisted() ? "예" : "아니오"
                );
            } catch (Exception e) {
                logger.warn("사용자 {} 데이터 작성 중 오류: {}", user.getId(), e.getMessage());
                // 기본값으로 작성
                writer.printf("%d,%s,%s,%s,%d,%d,%s,%s%n",
                    users.size() - i,
                    "",
                    "",
                    "",
                    0,
                    0,
                    "",
                    "아니오"
                );
            }
        }
        
            writer.flush();
            writer.close();
            logger.info("사용자 엑셀 다운로드 완료 - {}명", users.size());
            
        } catch (Exception e) {
            logger.error("사용자 엑셀 다운로드 중 오류 발생", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("다운로드 중 오류가 발생했습니다.");
        }
    }
    
    // 신규 사용자 등록 처리
    @PostMapping("/users/add")
    public String addUser(@RequestParam String name,
                         @RequestParam String phoneNumber,
                         @RequestParam String birthDate,
                         RedirectAttributes redirectAttributes) {
        
        logger.info("신규 사용자 등록 요청 - 이름: {}, 핸드폰: {}, 생년월일: {}", name, phoneNumber, birthDate);
        
        // 입력값 검증
        if (name == null || name.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "이름을 입력해주세요.");
            return "redirect:/admin/gift-cards";
        }
        
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "핸드폰 번호를 입력해주세요.");
            return "redirect:/admin/gift-cards";
        }
        
        if (birthDate == null || birthDate.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "생년월일을 입력해주세요.");
            return "redirect:/admin/gift-cards";
        }
        
        try {
            // 중복 사용자 확인 (이름과 핸드폰 번호로)
            User existingUser = userService.authenticate(name.trim(), phoneNumber.trim());
            if (existingUser != null) {
                logger.warn("중복 사용자 등록 시도 - 이름: {}, 핸드폰: {}", name, phoneNumber);
                redirectAttributes.addFlashAttribute("error", "동일한 이름과 핸드폰 번호를 가진 사용자가 이미 존재합니다.");
                return "redirect:/admin/gift-cards";
            }
            
            // 신규 사용자 생성
            User newUser = userService.createUser(name.trim(), phoneNumber.trim(), birthDate);
            logger.info("신규 사용자 등록 완료 - ID: {}, 이름: {}, 핸드폰: {}", newUser.getId(), name, phoneNumber);
            
            redirectAttributes.addFlashAttribute("success", 
                String.format("사용자 '%s'님(핸드폰: %s)이 성공적으로 등록되었습니다.", name, phoneNumber));
            
        } catch (Exception e) {
            logger.error("신규 사용자 등록 중 오류 발생 - 이름: {}, 핸드폰: {}", name, phoneNumber, e);
            redirectAttributes.addFlashAttribute("error", "사용자 등록 중 오류가 발생했습니다. 다시 시도해주세요.");
        }
        
        return "redirect:/admin/gift-cards";
    }
}
