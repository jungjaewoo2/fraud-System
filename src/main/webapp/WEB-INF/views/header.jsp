<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : '상품권 부정방지 시스템'}" /></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .mobile-container {
            max-width: 414px;
            margin: 0 auto;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
        }
        .btn-success {
            background: linear-gradient(45deg, #28a745, #1e7e34);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
        }
        .form-control {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 12px 20px;
        }
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        .navbar-brand {
            font-weight: bold;
            color: #007bff !important;
        }
        
        /* 모바일 친화적인 상품권 카드 스타일 */
        .gift-card-item {
            border-left: 4px solid #28a745;
            transition: transform 0.2s ease-in-out;
        }
        
        .gift-card-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        
        .info-row {
            display: flex;
            flex-direction: column;
            margin-bottom: 0.75rem;
        }
        
        .info-label {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            font-size: 1rem;
            font-weight: 500;
            color: #212529;
        }
        
        /* 모바일에서 버튼 크기 조정 */
        @media (max-width: 576px) {
            .btn-group-sm .btn {
                padding: 0.375rem 0.75rem;
                font-size: 0.875rem;
            }
        }
    </style>
</head>
<body>
    <div class="mobile-container">
        <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
            <div class="container-fluid">
                <a class="navbar-brand" href="/">
                    <i class="fas fa-shield-alt me-2"></i>
                    상품권 시스템
                </a>
                <c:if test="${sessionScope.user != null}">
                    <div class="navbar-nav ms-auto">
                        <span class="navbar-text me-3">
                            <i class="fas fa-user me-1"></i>
                            ${sessionScope.user.name}님
                        </span>
                        <a class="btn btn-outline-danger btn-sm" href="/logout">
                            <i class="fas fa-sign-out-alt me-1"></i>
                            로그아웃
                        </a>
                    </div>
                </c:if>
            </div>
        </nav>
        
        <div class="container-fluid px-4 py-3">
