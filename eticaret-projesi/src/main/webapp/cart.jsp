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
    <title>Sepetim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home">Süper E-Ticaret</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hoş Geldin, ${sessionScope.currentUser.fullName}</span>
            <a href="my-orders" class="btn btn-outline-info btn-sm me-3 fw-bold">Siparişlerim</a>
            <a href="home" class="btn btn-primary btn-sm me-3">Alışverişe Dön</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Güvenli Çıkış Yap</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Alışveriş Sepetim</h2>
    
    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="alert alert-info shadow-sm">Sepetinizde henüz ürün bulunmamaktadır. Ana sayfaya dönüp alışverişe başlayabilirsiniz.</div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive shadow-sm bg-white rounded">
                <table class="table align-middle text-center mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Ürün Görseli</th>
                            <th scope="col">Ürün Adı</th>
                            <th scope="col">Birim Fiyat</th>
                            <th scope="col">Adet</th>
                            <th scope="col">Toplam</th>
                            <th scope="col">İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="totalAmount" value="0" />
                        <c:forEach var="item" items="${sessionScope.cart}">
                            <c:set var="itemTotal" value="${item.product.price * item.quantity}" />
                            <c:set var="totalAmount" value="${totalAmount + itemTotal}" />
                            <tr>
                                <td>
                                    <img src="${item.product.imageUrl}" width="80" class="img-thumbnail shadow-sm" alt="ürün">
                                </td>
                                <td class="fw-bold">${item.product.name}</td>
                                <td>
                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <span class="badge bg-secondary fs-6">${item.quantity}</span>
                                </td>
                                <td class="text-primary fw-bold">
                                    <fmt:formatNumber value="${itemTotal}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/remove-from-cart" method="post">
                                        <input type="hidden" name="productId" value="${item.product.id}">
                                        <button type="submit" class="btn btn-danger btn-sm shadow-sm">Kaldır</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot class="table-light">
                        <tr>
                            <td colspan="5" class="text-end fs-5"><strong>Genel Toplam:</strong></td>
                            <td class="fs-4 text-success fw-bold">
                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
            
            <div class="text-end mt-4">
                <form action="${pageContext.request.contextPath}/checkout" method="post">
                    <button type="submit" class="btn btn-success btn-lg shadow px-5">Siparişi Tamamla</button>
                </form>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>