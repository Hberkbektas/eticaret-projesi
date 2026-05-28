<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    <title>${product.name} - Ürün Detayı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home">Süper E-Ticaret</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hoş Geldin, ${sessionScope.currentUser.fullName}</span>
            <a href="my-orders" class="btn btn-outline-info btn-sm me-3 fw-bold">Siparişlerim</a>
            <a href="cart.jsp" class="btn btn-warning btn-sm me-3 fw-bold">Sepetim</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Güvenli Çıkış Yap</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="card shadow border-0 rounded-4 p-4">
        <div class="row g-5">
            <div class="col-md-5 text-center">
                <img src="${product.imageUrl}" class="img-fluid rounded shadow-sm" alt="${product.name}">
            </div>
            <div class="col-md-7">
                <h1 class="fw-bold mb-3">${product.name}</h1>
                <p class="badge bg-info text-dark fs-6 mb-3">Kategori: Genel</p>
                <h2 class="text-primary fw-bold mb-4">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                </h2>
                <h5 class="fw-bold">Ürün Açıklaması:</h5>
                <p class="text-muted fs-5 mb-4">${product.description}</p>
                <div class="mb-4">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <h5 class="text-success fw-bold">Stokta Var (${product.stock} Adet)</h5>
                        </c:when>
                        <c:otherwise>
                            <h5 class="text-danger fw-bold">Stokta Yok</h5>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="d-flex align-items-center">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <form action="${pageContext.request.contextPath}/add-to-cart" method="post" class="me-3">
                                <input type="hidden" name="productId" value="${product.id}">
                                <button type="submit" class="btn btn-success btn-lg shadow px-5 fw-bold">Sepete Ekle</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary btn-lg shadow px-5 fw-bold me-3" disabled>Sepete Ekle</button>
                        </c:otherwise>
                    </c:choose>
                    <a href="home" class="btn btn-outline-dark btn-lg">Geri Dön</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>