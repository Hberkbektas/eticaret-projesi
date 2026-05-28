<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setHeader("Expires", "0"); 

    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sipariş Başarılı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home">Süper E-Ticaret</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hoş Geldin, <%= currentUser.getFullName() %></span>
            <a href="my-orders" class="btn btn-outline-info btn-sm me-3 fw-bold">Siparişlerim</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Güvenli Çıkış Yap</a>
        </div>
    </div>
</nav>

<div class="container mt-5 text-center">
    <div class="card shadow p-5 border-0 rounded-4">
        <h1 class="text-success mb-4 display-4">🎉 Tebrikler!</h1>
        <h3 class="mb-3">Siparişiniz başarıyla alınmıştır.</h3>
        <p class="text-muted fs-5">Bizi tercih ettiğiniz için teşekkür ederiz. Ürünleriniz en kısa sürede hazırlanıp kargoya verilecektir.</p>
        <div class="mt-4">
            <a href="home" class="btn btn-primary btn-lg shadow-sm px-5 py-2">Alışverişe Devam Et</a>
        </div>
    </div>
</div>

</body>
</html>