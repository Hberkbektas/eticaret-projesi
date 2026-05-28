<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Siparişleri Yönet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-danger shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">Yönetim Paneli</a>
        <div class="d-flex">
            <a href="dashboard" class="btn btn-outline-light btn-sm me-3">Özet Ekrana Dön</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-dark btn-sm shadow-sm">Güvenli Çıkış</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h3 class="text-secondary mb-4">Sistemdeki Tüm Siparişler</h3>

    <div class="table-responsive bg-white shadow-sm rounded-3">
        <table class="table table-hover align-middle text-center mb-0">
            <thead class="table-light">
                <tr>
                    <th>Sipariş No</th>
                    <th>Kullanıcı ID</th>
                    <th>Tarih</th>
                    <th>Toplam Tutar</th>
                    <th>Mevcut Durum</th>
                    <th>Durum Güncelle</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td class="fw-bold">#100${order.id}</td>
                        <td>${order.userId}</td>
                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm"/></td>
                        <td class="text-primary fw-bold">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'Beklemede'}">
                                    <span class="badge bg-warning text-dark">${order.status}</span>
                                </c:when>
                                <c:when test="${order.status == 'Tamamlandı'}">
                                    <span class="badge bg-success">${order.status}</span>
                                </c:when>
                                <c:when test="${order.status == 'İptal Edildi'}">
                                    <span class="badge bg-danger">${order.status}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-info text-dark">${order.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form action="orders" method="post" class="d-flex justify-content-center">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <select name="status" class="form-select form-select-sm w-auto me-2">
                                    <option value="Beklemede" ${order.status == 'Beklemede' ? 'selected' : ''}>Beklemede</option>
                                    <option value="Hazırlanıyor" ${order.status == 'Hazırlanıyor' ? 'selected' : ''}>Hazırlanıyor</option>
                                    <option value="Kargoya Verildi" ${order.status == 'Kargoya Verildi' ? 'selected' : ''}>Kargoya Verildi</option>
                                    <option value="Tamamlandı" ${order.status == 'Tamamlandı' ? 'selected' : ''}>Tamamlandı</option>
                                    <option value="İptal Edildi" ${order.status == 'İptal Edildi' ? 'selected' : ''}>İptal Edildi</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary shadow-sm">Güncelle</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orderList}">
                    <tr>
                        <td colspan="6" class="text-muted py-4">Sistemde henüz hiçbir sipariş bulunmamaktadır.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>