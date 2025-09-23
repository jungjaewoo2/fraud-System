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

import java.net.URLDecoder;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.logging.log4j.LogManager;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestClient;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import jakarta.servlet.http.HttpSession;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Random;

@Controller
public class HomeController {
    private final String CLIENT_ID = "01a8212d-ba42-4671-9ae3-c84dc92bf0a7"; // NICE API APP 등록 시 발급받은 Client ID
    private final String CLIENT_SECRET = "5251259299e2c5cb6bfbb96415245f3e"; // NICE API APP 등록 시 발급받은 Client Secret
    private final String ACCESS_TOKEN = "89090d9c-a38e-4575-975a-584c984bc5a7"; // 기관토큰 발급 API 요청 시 리턴값
    private final String PRODUCT_ID = "2101979031";

    private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

//    String host = "http://localhost:8080";

    String host = "https://www.flyco88.com";


    @Autowired
    private UserService userService;
    
    @Autowired
    private AdminCodeService adminCodeService;
    
    @Autowired
    private GiftCardService giftCardService;
    
    // 메인 로그인 페이지
    @GetMapping("/")
    public String home(Model model, HttpSession session) {
                // Authorization 헤더를 위한 인증 문자열 생성 및 Base64 인코딩
                Date date = new Date();
                long CURRENT_TIMESTAMP = date.getTime()/1000;
                String crypto_auth = ACCESS_TOKEN + ":" + CURRENT_TIMESTAMP + ":" + CLIENT_ID;
                String CRYPTO_BASE64_AUTH = Base64.getEncoder().encodeToString(crypto_auth.getBytes());
        
                ObjectMapper objectMapper = new ObjectMapper();
        
                // 날짜 및 시간 (YYYYMMDDHHiiss 형식)
                LocalDateTime currentDateTime = LocalDateTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
                String req_dtim = currentDateTime.format(formatter);
                StringBuilder stringBuilder = new StringBuilder(13);
        
                for (int i = 0; i < 13; i++) {
                    int digit = (int)(Math.random() * 10); // 0에서 9 사이의 숫자 생성
                    stringBuilder.append(digit);
                }
                String randomNumber = stringBuilder.toString();
                String req_no = "REQ" + req_dtim + randomNumber;
        
        
                // 요청 body 구성
                ObjectNode requestDataHeader = objectMapper.createObjectNode();
                requestDataHeader.put("CNTY_CD", "ko");
                ObjectNode requestDataBody = objectMapper.createObjectNode();
        
                requestDataBody.put("req_dtim", req_dtim);
                requestDataBody.put("req_no", req_no);
                requestDataBody.put("enc_mode", "1");
        
                ObjectNode CRYPTO_DATA = objectMapper.createObjectNode();
                CRYPTO_DATA.set("dataHeader", requestDataHeader);
                CRYPTO_DATA.set("dataBody", requestDataBody);
        
                try {
        
                    RestClient restClient = RestClient.create();
                    ResponseEntity<String> CRYPTO_RESPONSE = restClient.post()
                            .uri("https://svc.niceapi.co.kr:22001/digital/niceid/api/v1.0/common/crypto/token")
                            .contentType(MediaType.APPLICATION_JSON)
                            .header("Authorization", "bearer " + CRYPTO_BASE64_AUTH)
                            .header("ProductID", PRODUCT_ID)
                            .body(CRYPTO_DATA)
                            .retrieve()
                            .toEntity(String.class);
        
                    Map<String, Object> CRYPTO_RESPONSE_DATA = objectMapper.readValue(CRYPTO_RESPONSE.getBody(), HashMap.class);
                    Map<String, String> dataHeader = (Map<String, String>) CRYPTO_RESPONSE_DATA.get("dataHeader");
        
                    // 상세응답코드
                    // (1) 게이트웨이 결과 코드 확인
                    if (!"1200".equals(dataHeader.get("GW_RSLT_CD"))) {
                        makeGW_RSLT_MSG(dataHeader.get("GW_RSLT_CD"));
                    }
        
                    // (2) 응답 코드 확인
                    Map<String, String> dataBody = (Map<String, String>) CRYPTO_RESPONSE_DATA.get("dataBody");
                    if (!"P000".equals(dataBody.get("rsp_cd"))) {
                        make_res_msg(dataBody.get("rsp_cd"));
                    }
        
                    // (3) 최종 응답값 검증
                    if (!"0000".equals(dataBody.get("result_cd"))) {
                        make_result_msg(dataBody.get("result_cd"));
                    }
        
                    // 응답 데이터에서 필요한 값 추출
                    String token_version_id = dataBody.get("token_version_id");
                    String site_code = dataBody.get("site_code");
                    String token_val = dataBody.get("token_val");
        
        
                    /*
                    * 가이드 3. API 호출 > Key 생성 부분 확인
                    * 반드시 암호화 토큰 요청 - 응답값을 사용해 주세요
                    * 암호화 토큰 요청값(req_dtim, req_no)과  응답값을 조합하여 originalString 생성
                    * */
        
                    String originalString = req_dtim.trim() + req_no.trim() + token_val.trim();
        
                    /*
                     * 대칭키(key, iv), 무결성키(hmac_key) 생성
                     * (1) CRYPTO_RESULT_VALUE : original-string 을 SHA-256 암호화 후 base64 인코딩
                     * (2) key, iv, hmac_key 규격에 맞게 substring
                     */
        
                    MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
                    messageDigest.update(originalString.getBytes());
                    byte[] encodedOriginal = messageDigest.digest();
                    String CRYPTO_RESULT_VALUE = Base64.getEncoder().encodeToString(encodedOriginal);
        
                    String key = CRYPTO_RESULT_VALUE.substring(0, 16);
                    String iv = CRYPTO_RESULT_VALUE.substring(CRYPTO_RESULT_VALUE.length() - 16);
                    String hmac_key = CRYPTO_RESULT_VALUE.substring(0, 32);
        
                    // 복호화 시 필요하므로 저장 (예제에서는 세션 사용)
                    Map<String, Object> sessionMap = new HashMap<>();
                    sessionMap.put("key", key);
                    sessionMap.put("iv", iv);
                    sessionMap.put("hmac_key", hmac_key);
        
                    session.setAttribute("sessionMap", sessionMap);
        
                    /*
                    * 개발가이드 3. API 호출 > 요청데이터(plain_data) 생성
                    * 예제에서는 필수값인 sitecode, requestno, returnurl 로 작성했으나
                    * 필요하신 경우 가이드를 활용하여 커스텀 해 주세요
                    * */
                    ObjectNode plain_data = objectMapper.createObjectNode();
                    plain_data.put("sitecode", site_code);
                    plain_data.put("requestno", req_no);
                    /*
                     * returnurl : 프로토콜, 도메인 (포트번호 있다면 포트번호) 입력 => 반드시 부모창과 일치하게 설정 부탁드립니다.
                     * 예 1) https://회원사도메인/api/v1/checkPlusSuccess
                     * 예 2) http://localhost:8080/api/v1/checkPlusSuccess
                     * 예 3) 서버 / 클라이언트와 분리되어 있는 상황이라면 클라이언트의 주소(혹은 앱의 schema로 작성 요청)
                     *      => methodtype ; "get" 으로 필수 설정, 클라이언트에서 파라미터로 전달 된 결과데이터(암호화 되어 있음) 을 받아
                     *                       서버로 복호화 요청하는 프로세스로 진행
                     * */
                    plain_data.put("returnurl", host + "/api/v1/checkPlusSuccess");
                    // plain_data.put("methodtype","get");
        
                    // enc_data 생성 => json-string 데이터를 aes 암호화 후 base64 인코딩
                    String json_string = plain_data.toString();
                    SecretKey secretKey = new SecretKeySpec(key.getBytes(), "AES");
                    var c = Cipher.getInstance("AES/CBC/PKCS5Padding");
                    c.init(Cipher.ENCRYPT_MODE, secretKey, new IvParameterSpec(iv.getBytes()));
                    byte[] encrypted = c.doFinal(json_string.trim().getBytes());
                    String enc_data = Base64.getEncoder().encodeToString(encrypted);
        
                    // integrity_value 생성 => enc_data를 hmac 무결성 처리
                    Mac mac = Mac.getInstance("HmacSHA256");
                    SecretKeySpec sks = new SecretKeySpec(hmac_key.getBytes(), "HmacSHA256");
                    mac.init(sks);
                    byte[] hmac256 = mac.doFinal(enc_data.getBytes());
                    String integrity_value = Base64.getEncoder().encodeToString(hmac256);
        
                    // 최종적으로 본인인증 시 필요한 값
                    model.addAttribute("token_version_id", token_version_id);
                    model.addAttribute("enc_data", enc_data);
                    model.addAttribute("integrity_value", integrity_value);
        
                }catch (Exception e) {
                    e.printStackTrace();
                }
        return "index";
    }
    
    // 사용자 로그인 처리
    @PostMapping("/login")
    public String login(@RequestParam String name, 
                       @RequestParam String phoneNumber,
                       @RequestParam(required = false) String privacyAgree,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        
        // 개인정보 동의 체크 확인
        if (privacyAgree == null || !privacyAgree.equals("on")) {
            redirectAttributes.addFlashAttribute("error", "개인정보 처리방침에 동의해야 로그인할 수 있습니다.");
            return "redirect:/";
        }
        
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
    public String verifyCode(@ModelAttribute("user") User user, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
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
        
        // 블랙리스트 사용자 접근 제한
        if (user.getIsBlacklisted()) {
            logger.warn("BLACKLIST: Blocked access for blacklisted user: " + user.getName() + " (ID: " + user.getId() + ")");
            redirectAttributes.addFlashAttribute("error", "블랙리스트에 등록된 사용자입니다. 접근이 제한되었습니다.");
            return "redirect:/";
        }
        
        // 사용자의 총 상품권 금액 계산
        List<GiftCard> existingGiftCards = giftCardService.findByUserId(user.getId());
        int totalAmount = existingGiftCards.stream()
                .mapToInt(GiftCard::getAmount)
                .sum();
        
        // 140,000원 이상 사용자 접근 제한
        if (totalAmount >= 140000) {
            logger.warn("LIMIT EXCEEDED: Blocked access for user with total amount: " + totalAmount + " (ID: " + user.getId() + ")");
            redirectAttributes.addFlashAttribute("error", 
                String.format("총 상품권 금액이 140,000원 이상입니다. (현재 총액: %,d원) 추가 상품권 지급이 불가능합니다.", totalAmount));
            return "redirect:/";
        }
        
        model.addAttribute("user", user);
        model.addAttribute("totalAmount", totalAmount);
        logger.debug("DEBUG: User found, rendering verify-code page for: " + user.getName() + " (Total amount: " + totalAmount + ")");
        logger.info("INFO: Returning verify-code view for user: " + user.getName() + " (ID: " + user.getId() + ")");
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
        
        // 오늘 지급된 금액 계산
        int dailyAmount = giftCardService.getTodayAmountByUserId(user.getId());
        
        // 140,000원 제한 확인
        boolean isLimitExceeded = totalAmount >= 140000;
        
        // 1일 20,000원 제한 확인
        boolean isDailyLimitExceeded = dailyAmount >= 20000;
        
        // 다음 지급 가능 시간 계산 (내일 00:00)
        String nextAvailableTime = "";
        if (isDailyLimitExceeded) {
            LocalDateTime tomorrow = LocalDateTime.now().plusDays(1).withHour(0).withMinute(0).withSecond(0);
            nextAvailableTime = tomorrow.toString().substring(0, 16).replace('T', ' ');
        }
        
        model.addAttribute("user", user);
        model.addAttribute("adminCode", adminCode);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("dailyAmount", dailyAmount);
        model.addAttribute("isLimitExceeded", isLimitExceeded);
        model.addAttribute("isDailyLimitExceeded", isDailyLimitExceeded);
        model.addAttribute("nextAvailableTime", nextAvailableTime);
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
        
        // 오늘 지급된 금액 계산
        int dailyAmount = giftCardService.getTodayAmountByUserId(user.getId());
        
        // 1일 20,000원 제한 확인
        if (dailyAmount >= 20000) {
            redirectAttributes.addFlashAttribute("error", 
                "동일한 사용자에게 1일 기준으로 20,000원 이상 지급할 수 없습니다. 내일 다시 시도해주세요.");
            return "redirect:/gift-card";
        }
        
        // 추가 지급 시 일일 금액이 20,000원을 초과하는지 확인
        if (dailyAmount + amount > 20000) {
            redirectAttributes.addFlashAttribute("error", 
                String.format("오늘 지급 후 일일 금액이 20,000원을 초과합니다. (현재: %,d원, 지급 가능: %,d원)", 
                    dailyAmount, 20000 - dailyAmount));
            return "redirect:/gift-card";
        }
        
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



        /**
     * NICE API 응답의 GW_RSLT_CD 에 따라 상세 오류 메시지를 구성하고 RuntimeException 을 발생시킵니다.
     * 예제이므로, 귀사 비지니스에 따라 수정 가능합니다.
     * @param GW_RSLT_CD NICE API 응답의 GW_RSLT_CD 코드
     * @throws RuntimeException GW_RSLT_CD 에 해당하는 오류 메시지를 포함하는 예외
     */
    public void makeGW_RSLT_MSG(String GW_RSLT_CD) {
        String detail_message = switch (GW_RSLT_CD) {
            case "1300" -> "request body 가 비었습니다.";
            case "1400" -> "잘못된 요청";
            case "1401" -> "인증 필요";
            case "1402" -> "권한 없음";
            case "1403" -> "서비스 사용 중지됨";
            case "1404" -> "서비스를 찾을 수 없음";
            case "1500" -> "서버 내부 오류 : 데이터 형식 오류입니다. 요청 body 가 dataHeader/dataBody 로 나누어져있는지 확인";
            case "1501" -> "보호된 서비스에서 엑세스가 거부되었습니다.";
            case "1502" -> "보호된 서비스에서 응답이 잘못되었습니다.";
            case "1503" -> "일시적으로 사용할 수 없는 서비스";
            case "1700" -> "엑세스가 허용되지 않습니다 : CLient ID";
            case "1701" -> "엑세스가 허용되지 않습니다 : Service URI";
            case "1702" -> "엑세스가 허용되지 않습니다 : CLient ID + Client_IP";
            case "1703" -> "엑세스가 허용되지 않습니다 : CLient ID + Service URI";
            case "1705" -> "엑세스가 허용되지 않습니다 : CLient ID + Black List Client IP";
            case "1706" -> "엑세스가 허용되지 않습니다 : CLient ID + Product Code";
            case "1707" -> "엑세스가 허용되지 않습니다 : Product Code + Service URI";
            // 1711 ~ 1716 계좌 인증에서 발생
            case "1711" -> "거래 제한된 요일입니다.";
            case "1712" -> "거래 제한된 시간입니다.";
            case "1713" -> "거래 제한된 요일/시간입니다.";
            case "1714" -> "거래 제한된 일자입니다.";
            case "1715" -> "거래 제한된 일자/시간입니다.";
            case "1716" -> "공휴일 거래가 제한된 서비스입니다.";
            case "1717" -> "SQL 인젝션, XSS 방어";
            case "1800" -> "잘못된 토큰 => 기관토큰 재발급 후 확인,요청 Header 의 current_time_stamp(UTC) 가 실제 시간과 3분 이상 차이날 시 발생";
            case "1801" -> "잘못된 클라이언트 정보";
            case "1900" -> "초과된 연결횟수";
            case "1901" -> "초과 된 토큰 조회 실패";
            case "1902" -> "초과된 토근 체크 실패";
            case "1903" -> "초과된 접속자 수";
            case "1904" -> "전송 크기 초과";
            case "1905" -> "접속량이 너무 많음";
            case "1906" -> "상품이용 한도초과";
            case "1907" -> "API 이용 주기 초과";
            default ->
                    "알 수 없는 오류코드(GW_RSLT_CD) : " + GW_RSLT_CD + ", 요청 시각, client_id 를 niceid_support@nice.co.kr 로 문의";
        };

        String error_message = String.format("GW_RSLT_CD 오류 발생: %s %s , 개발가이드 > FAQ 를 참고해 주세요", GW_RSLT_CD, detail_message);
        System.err.println("NICE_API 에러 : " + error_message);
        throw new RuntimeException(error_message);
    }

    /**
     * 응답 코드(rsp_cd)에 따른 오류 메시지를 생성하고 RuntimeException을 발생시킵니다.
     * 예제이므로, 귀사 비즈니스에 따라 수정 가능합니다.
     * @param rsp_cd 응답 코드
     * @throws RuntimeException rsp_cd 에 해당하는 오류 메시지를 포함하는 예외
     */
    public void make_res_msg(String rsp_cd) {
        String detail_message = switch (rsp_cd) {
            case "EAPI2500" -> "맵핑정보 없음";
            case "EAPI2510" -> "잘못된 요청";
            case "EAPI2530" -> "응답전문 맵핑 오류";
            case "EAPI2540" -> "대응답 정보 없음";
            case "EAPI2550" -> "숫자타입 입력 오류";
            case "EAPI2560" -> "실수타입 입력 오류";
            case "EAPI2561" -> "실수형 타입 길이정보 문법 에러( 형식 : [전체길이,실수부길이])";
            case "EAPI2562" -> "실수형 타입 논리 에러(전체 길이는 소수부 길이보다 커야합니다.";
            case "EAPI2563" -> "실수형 타입 파싱 에러(입력값을 실수값으로 변환할 수 없습니다.)";
            case "EAPI2564" -> "실수형 타입 정수부 길이 에러";
            case "EAPI2565" -> "실수형 타입 소수부 길이 에러";
            case "EAPI2600" -> "내부 시스템 오류";
            case "EAPI2700" -> "외부 시스템 연동 오류";
            case "EAPI2701" -> "타임아웃 발생";
            case "EAPI2702" -> "DISCONNECTION_OK";
            case "EAPI2703" -> "DISCONNECTION_FAIL";
            case "EAPI2704" -> "RESULT_OK";
            case "EAPI2705" -> "RESULT_FAIL";
            case "EAPI2892" -> "반복부 카운터 에러(지정된 건수보다 크거나 작습니다.";
            case "EAPI5001" -> "schema 검증정보가 없습니다.";
            case "EAPI5002" -> "schema 검증 실패";
            case "S603" -> "내부 DB오류.";
            case "E998" -> "서비스 권한 오류 : 정지된 계약인지 확인.";
            case "E999" -> "내부 시스템 오류 : 사용할 수 있는 API 목록인지 확인.";
            default -> "알 수 없는 오류코드(rsp_cd) : " + rsp_cd + ", 요청 시각, client_id 를 niceid_support@nice.co.kr 로 문의";
        };

        String error_message = String.format("rsp_cd 오류 발생: %s %s: FAQ 참고해 주세요", rsp_cd, detail_message);
        System.err.println("NICE_API 에러 : " + error_message);
        throw new RuntimeException(error_message);
    }

    /**
     * result_cd 결과 코드에 따른 오류 메시지를 생성하고 RuntimeException을 발생시킵니다.
     * 예제이므로, 귀사 비즈니스에 따라 수정 가능합니다.
     * @param result_cd 결과 코드
     * @throws RuntimeException result_cd 에 해당하는 오류 메시지를 포함하는 예외
     */
    public void make_result_msg(String result_cd) {
        String detail_message = switch (result_cd) {
            case "0001" -> "필수 입력값 오류 : 요청한 dataBody 확인, req_dtim, req_no, enc_mode 비어있는 값 없는지 확인, 규격 확인";
            case "0003" -> "OTP 발급 회원사 아님 [계약건 확인이 필요함] => 요청 시각, client_id 를 niceid_support@nice.co.kr 로 문의";
            case "0099" -> "인증 필요";
            default -> "알 수 없는 오류코드(result_cd) : " + result_cd + ", 요청 시각, client_id 를 niceid_support@nice.co.kr 로 문의";
        };

        String error_message = String.format("result_cd 오류 발생: %s %s : FAQ 참고해 주세요", result_cd, detail_message);
        System.err.println("NICE_API 에러 : " + error_message);
        throw new RuntimeException(error_message);
    }

}
