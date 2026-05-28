<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Güvenlik: Giriş yapmamışsa veya Admin değilse kov!
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Yönetim Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-danger shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">Yönetim Paneli</a>
        <div class="d-flex">
            <span class="text-white me-3 mt-1">Yetkili: ${sessionScope.currentUser.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark btn-sm shadow-sm">Güvenli Çıkış</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4 text-secondary">Sistem Genel Özeti</h2>
    
    <div class="row">
        <div class="col-md-3 mb-4">
            <div class="card text-white bg-primary h-100 shadow border-0">
                <div class="card-body text-center py-4">
                    <h5 class="card-title text-uppercase fs-6 opacity-75">Toplam Ürün</h5>
                    <h1 class="display-4 fw-bold mt-2">${totalProducts}</h1>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card text-white bg-success h-100 shadow border-0">
                <div class="card-body text-center py-4">
                    <h5 class="card-title text-uppercase fs-6 opacity-75">Kayıtlı Müşteri</h5>
                    <h1 class="display-4 fw-bold mt-2">${totalUsers}</h1>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card text-white bg-warning text-dark h-100 shadow border-0">
                <div class="card-body text-center py-4">
                    <h5 class="card-title text-uppercase fs-6 opacity-75">Toplam Sipariş</h5>
                    <h1 class="display-4 fw-bold mt-2">${totalOrders}</h1>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="card text-white bg-danger h-100 shadow border-0">
                <div class="card-body text-center py-4">
                    <h5 class="card-title text-uppercase fs-6 opacity-75">Bekleyen Sipariş</h5>
                    <h1 class="display-4 fw-bold mt-2">${pendingOrders}</h1>
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-12">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header bg-white fw-bold fs-5 py-3 border-bottom">Yönetim Paneli Modülleri</div>
                <div class="card-body p-4">
                    <p class="text-muted">Aşağıdaki butonları kullanarak sistemdeki ürünleri, kategorileri ve siparişleri yönetebilirsiniz.</p>
                    <div class="mt-3">
                        <a href="products" class="btn btn-outline-primary btn-lg me-2 px-4 shadow-sm">Ürünleri Yönet</a>
                        <a href="categories" class="btn btn-outline-success btn-lg me-2 px-4 shadow-sm">Kategorileri Yönet</a>
                        <a href="orders" class="btn btn-outline-warning text-dark btn-lg me-2 px-4 shadow-sm">Siparişleri Yönet</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>