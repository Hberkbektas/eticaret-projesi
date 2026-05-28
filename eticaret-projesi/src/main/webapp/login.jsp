<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sisteme Giriş Yap</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white text-center">
                    <h4>Kullanıcı Girişi</h4>
                </div>
                <div class="card-body">
                    
                    <%-- Kayıt başarılı olup bu sayfaya yönlendirildiğinde çıkacak yeşil mesaj --%>
                    <% if("1".equals(request.getParameter("success"))) { %>
                        <div class="alert alert-success text-center">
                            <strong>Harika!</strong> Kaydınız başarıyla oluşturuldu. Şimdi giriş yapabilirsiniz.
                        </div>
                    <% } %>

                    <%-- Giriş işleminde hata olursa (şifre yanlış vb.) çıkacak kırmızı mesaj --%>
                    <% if("1".equals(request.getParameter("error"))) { %>
                        <div class="alert alert-danger text-center">
                            E-posta veya şifre hatalı! Lütfen tekrar deneyin.
                        </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/login" method="POST" autocomplete="off">
                        
                        <div class="mb-3">
                            <label class="form-label">E-posta Adresi</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Şifre</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        
                        <button type="submit" class="btn btn-success w-100">Giriş Yap</button>
                    </form>
                    
                </div>
                <div class="card-footer text-center">
                    Hesabınız yok mu? <a href="register.jsp">Kayıt Ol</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>