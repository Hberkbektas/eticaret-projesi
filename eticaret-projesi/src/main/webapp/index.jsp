<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
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
    
    int cartCount = 0;
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart != null) {
        for (CartItem item : cart) {
            cartCount += item.getQuantity();
        }
    }
    request.setAttribute("cartCount", cartCount);
%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>E-Ticaret Ana Sayfa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home">Süper E-Ticaret</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hoş Geldin, ${sessionScope.currentUser.fullName}</span>
            <a href="my-orders" class="btn btn-outline-info btn-sm me-3 fw-bold">Siparişlerim</a>
            <a href="cart.jsp" class="btn btn-warning btn-sm me-3 fw-bold">Sepetim (${cartCount})</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Güvenli Çıkış Yap</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <h3 class="mb-4">Öne Çıkan Ürünler</h3>
    
    <div class="row mb-4">
        <div class="col-12">
            <div id="categoryContainer" class="d-flex flex-nowrap overflow-auto pb-2" style="scrollbar-width: thin;">
                <a href="home" class="btn ${empty param.categoryId ? 'btn-dark' : 'btn-outline-dark'} me-2 shadow-sm flex-shrink-0">Tüm Ürünler</a>
                
                <c:forEach var="cat" items="${categoryList}">
                    <a href="home?categoryId=${cat.id}" class="btn ${param.categoryId == cat.id ? 'btn-dark' : 'btn-outline-dark'} me-2 shadow-sm flex-shrink-0">
                        ${cat.name}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="row">
        <c:choose>
            <c:when test="${not empty productList}">
                <c:forEach var="p" items="${productList}">
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card h-100 shadow-sm border-0 rounded-3">
                            <img src="${p.imageUrl}" class="card-img-top p-3" alt="${p.name}" style="height: 200px; object-fit: contain;">
                            <div class="card-body border-top">
                                <h6 class="card-title fw-bold text-truncate" title="${p.name}">${p.name}</h6>
                                <p class="card-text text-muted small text-truncate" title="${p.description}">${p.description}</p>
                                <h5 class="text-primary fw-bold mb-0">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                                </h5>
                            </div>
                            <div class="card-footer bg-white border-0 pt-0 pb-3">
                                <div class="d-flex justify-content-between">
                                    <a href="product-detail?id=${p.id}" class="btn btn-outline-primary btn-sm w-50 me-1 fw-bold shadow-sm">Detay</a>
                                    <form action="${pageContext.request.contextPath}/add-to-cart" method="post" class="w-50 ms-1">
                                        <input type="hidden" name="productId" value="${p.id}">
                                        <button type="submit" class="btn btn-success btn-sm w-100 fw-bold shadow-sm">Sepete Ekle</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning shadow-sm">Bu kategoride henüz ürün bulunmamaktadır.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    window.addEventListener("beforeunload", function() {
        // Dikey pozisyonu kaydet
        localStorage.setItem("scrollPosition", window.scrollY);
        
        // Yatay (Kategori) pozisyonunu kaydet
        let catContainer = document.getElementById("categoryContainer");
        if(catContainer) {
            localStorage.setItem("catScrollPosition", catContainer.scrollLeft);
        }
    });

    window.addEventListener("load", function() {
        // Dikey pozisyonu geri yükle
        let scrollPosition = localStorage.getItem("scrollPosition");
        if (scrollPosition !== null) {
            window.scrollTo(0, parseInt(scrollPosition));
            localStorage.removeItem("scrollPosition"); 
        }
        
        // Yatay (Kategori) pozisyonunu geri yükle
        let catScrollPosition = localStorage.getItem("catScrollPosition");
        let catContainer = document.getElementById("categoryContainer");
        if (catScrollPosition !== null && catContainer) {
            catContainer.scrollLeft = parseInt(catScrollPosition);
            localStorage.removeItem("catScrollPosition");
        }
    });
</script>
</body>
</html>