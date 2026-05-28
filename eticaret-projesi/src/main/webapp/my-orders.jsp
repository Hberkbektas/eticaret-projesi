<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Siparişlerim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home">Süper E-Ticaret</a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3">Hoş Geldin, ${sessionScope.currentUser.fullName}</span>
            <a href="home" class="btn btn-primary btn-sm me-3">Alışverişe Dön</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Çıkış Yap</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="mb-4">Geçmiş Siparişlerim</h2>
    
    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info shadow-sm">Henüz bir siparişiniz bulunmamaktadır.</div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive shadow-sm bg-white rounded">
                <table class="table align-middle text-center mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">Sipariş No</th>
                            <th scope="col">Sipariş Tarihi</th>
                            <th scope="col">Toplam Tutar</th>
                            <th scope="col">Durum</th>
                            <th scope="col">İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td class="fw-bold">#100${order.id}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm"/></td>
                                <td class="text-primary fw-bold">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 'Beklemede'}">
                                            <span class="badge bg-warning text-dark fs-6">${order.status}</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Tamamlandı'}">
                                            <span class="badge bg-success fs-6">${order.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary fs-6">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-info btn-sm text-white shadow-sm">Detay Gör</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>