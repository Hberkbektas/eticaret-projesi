<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Kategorileri Yönet</title>
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
        <h3 class="text-secondary m-0">Kategori Listesi</h3>
        <button type="button" class="btn btn-success fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
            + Yeni Kategori Ekle
        </button>
    </div>

    <div class="table-responsive bg-white shadow-sm rounded-3">
        <table class="table table-hover align-middle mb-0 text-center">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Kategori Adı</th>
                    <th>Açıklama</th>
                    <th>Durum</th>
                    <th>İşlem</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${categoryList}">
                    <tr>
                        <td class="fw-bold">#${c.id}</td>
                        <td class="fw-bold text-primary">${c.name}</td>
                        <td class="text-muted">${c.description}</td>
                        <td>
                            <c:choose>
                                <c:when test="${c.active}"><span class="badge bg-success">Aktif</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">Pasif</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-warning fw-bold shadow-sm me-2 text-dark" data-bs-toggle="modal" data-bs-target="#editCategoryModal${c.id}">
                                Düzenle
                            </button>
                            <form action="categories" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${c.id}">
                                <button type="submit" class="btn btn-sm btn-danger shadow-sm fw-bold" onclick="return confirm('Bu kategoriyi silmek, ona ait ürünlerin hata vermesine neden olabilir! Silmek istediğinize emin misiniz?');">Sil</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">Yeni Kategori Ekle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="categories" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Kategori Adı</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Kategori Açıklaması</label>
                        <textarea name="description" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Durum</label>
                        <select name="isActive" class="form-select">
                            <option value="true">Aktif (Sitede Görünsün)</option>
                            <option value="false">Pasif (Sitede Görünmesin)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold">Kaydet ve Ekle</button>
                </form>
            </div>
        </div>
    </div>
</div>

<c:forEach var="c" items="${categoryList}">
    <div class="modal fade" id="editCategoryModal${c.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold">Kategoriyi Düzenle (#${c.id})</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="categories" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${c.id}">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Kategori Adı</label>
                            <input type="text" name="name" class="form-control" value="${c.name}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Kategori Açıklaması</label>
                            <textarea name="description" class="form-control" rows="3" required>${c.description}</textarea>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold">Durum</label>
                            <select name="isActive" class="form-select">
                                <option value="true" ${c.active ? 'selected' : ''}>Aktif</option>
                                <option value="false" ${!c.active ? 'selected' : ''}>Pasif</option>
                            </select>
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