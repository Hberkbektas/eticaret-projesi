<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sisteme Kayıt Ol</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white text-center">
                    <h4>Yeni Hesap Oluştur</h4>
                </div>
                <div class="card-body">
                    
                    <%-- Eğer Servlet'ten bir hata mesajı gelirse (URL'de error=1 varsa) burası çalışır --%>
                    <% if("1".equals(request.getParameter("error"))) { %>
                        <div class="alert alert-danger">Kayıt sırasında bir hata oluştu. E-posta adresi kullanılıyor olabilir.</div>
                    <% } %>

                    <%-- Form verilerini doPost metoduna (RegisterServlet) gönderecek olan kısım --%>
                    <form action="${pageContext.request.contextPath}/register" method="POST" autocomplete="off">
                        
                        <div class="mb-3">
                            <label class="form-label">Ad Soyad</label>
                            <input type="text" class="form-control" name="fullName" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">E-posta Adresi</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Şifre</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Telefon</label>
                            <input type="text" class="form-control" name="phone">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Açık Adres</label>
                            <textarea class="form-control" name="address" rows="3"></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100">Kayıt Ol</button>
                    </form>
                    
                </div>
                <div class="card-footer text-center">
                    Zaten hesabınız var mı? <a href="login.jsp">Giriş Yap</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>