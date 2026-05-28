package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Tarayıcıdan gelecek "/register" isteklerini bu sınıf karşılayacak
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    // Veritabanı işlemleri için mutfağımızı (UserDAO) çağırıyoruz
    private UserDAO userDAO = new UserDAO();

    // Formlar "POST" metoduyla gönderildiği için doPost kullanıyoruz
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Türkçe karakterlerin (ş, ğ, ç vb.) bozulmaması için çok önemli iki ayar
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Müşterinin siparişini alıyoruz (Formdaki name etiketlerine göre)
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // 2. Gelen bilgileri bir "User" kutusuna (nesnesine) koyuyoruz
        User newUser = new User(fullName, email, password, phone, address);

        // 3. Kutuyu mutfağa teslim edip "Bunu veritabanına kaydet" diyoruz
        boolean isRegistered = userDAO.registerUser(newUser);

        // 4. Mutfaktan gelen sonuca göre müşteriye cevap veriyoruz
        if (isRegistered) {
            // Kayıt başarılıysa, giriş sayfasına yönlendir (ve URL'ye success=1 ekle)
            response.sendRedirect("login.jsp?success=1");
        } else {
            // Hata olursa, tekrar kayıt sayfasına gönder (URL'ye error=1 ekle)
            response.sendRedirect("register.jsp?error=1");
        }
    }
}  