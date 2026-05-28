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
    <title>Ürünleri Yönet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary m-0">Ürün Listesi</h3>
        <button type="button" class="btn btn-success fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#addProductModal">
            + Yeni Ürün Ekle
        </button>
    </div>

    <div class="table-responsive bg-white shadow-sm rounded-3">
        <table class="table table-hover align-middle mb-0 text-center">
            <thead class="table-light">
                <tr>
                    <th>Görsel</th>
                    <th>ID</th>
                    <th>Ürün Adı</th>
                    <th>Fiyat</th>
                    <th>Stok</th>
                    <th>İşlem</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${productList}">
                    <tr>
                        <td><img src="${p.imageUrl}" alt="${p.name}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;"></td>
                        <td class="fw-bold">#${p.id}</td>
                        <td>${p.name}</td>
                        <td class="text-primary fw-bold"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₺" maxFractionDigits="2"/></td>
                        <td>
                            <span class="badge ${p.stock > 10 ? 'bg-success' : 'bg-danger'}">${p.stock}</span>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-warning fw-bold shadow-sm me-2 text-dark" data-bs-toggle="modal" data-bs-target="#editProductModal${p.id}">
                                Düzenle
                            </button>
                            
                            <form action="products" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${p.id}">
                                <button type="submit" class="btn btn-sm btn-danger shadow-sm fw-bold" onclick="return confirm('Bu ürünü silmek istediğinize emin misiniz?');">Sil</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">Yeni Ürün Ekle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="products" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-2">
                        <label class="form-label fw-bold">Ürün Adı</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold">Kategori</label>
                        <select name="categoryId" class="form-select" required>
                            <option value="">-- Kategori Seçiniz --</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-bold">Açıklama</label>
                        <textarea name="description" class="form-control" rows="2" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Fiyat (₺)</label>
                            <input type="number" step="0.01" name="price" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Stok Adedi</label>
                            <input type="number" name="stock" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Görsel URL</label>
                        <input type="text" name="imageUrl" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold">Kaydet ve Sisteme Ekle</button>
                </form>
            </div>
        </div>
    </div>
</div>

<c:forEach var="p" items="${productList}">
    <div class="modal fade" id="editProductModal${p.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold">Ürünü Düzenle (#${p.id})</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="products" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${p.id}">
                        
                        <div class="mb-2">
                            <label class="form-label fw-bold">Ürün Adı</label>
                            <input type="text" name="name" class="form-control" value="${p.name}" required>
                        </div>
                        
                        <div class="mb-2">
                            <label class="form-label fw-bold">Kategori</label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="cat" items="${categoryList}">
                                    <option value="${cat.id}" ${p.categoryId == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-2">
                            <label class="form-label fw-bold">Açıklama</label>
                            <textarea name="description" class="form-control" rows="2" required>${p.description}</textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-2">
                                <label class="form-label fw-bold">Fiyat (₺)</label>
                                <input type="number" step="0.01" name="price" class="form-control" value="${p.price}" required>
                            </div>
                            <div class="col-md-6 mb-2">
                                <label class="form-label fw-bold">Stok Adedi</label>
                                <input type="number" name="stock" class="form-control" value="${p.stock}" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Görsel URL</label>
                            <input type="text" name="imageUrl" class="form-control" value="${p.imageUrl}" required>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 fw-bold text-dark">Değişiklikleri Kaydet</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

</body>
</html>