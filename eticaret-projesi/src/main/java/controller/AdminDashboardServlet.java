package controller;

import model.User;
import util.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // GÜVENLİK KONTROLÜ: Giriş yapılmadıysa veya rolü ADMIN değilse direkt login.jsp'ye yönlendir
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int totalProducts = 0, totalUsers = 0, totalOrders = 0, pendingOrders = 0;

        // Özet İstatistikleri Veritabanından Çekiyoruz
        try (Connection conn = DatabaseConnection.getConnection()) {
            ResultSet rs = conn.createStatement().executeQuery("SELECT COUNT(*) FROM products");
            if(rs.next()) totalProducts = rs.getInt(1);

            rs = conn.createStatement().executeQuery("SELECT COUNT(*) FROM users WHERE role='USER'");
            if(rs.next()) totalUsers = rs.getInt(1);

            rs = conn.createStatement().executeQuery("SELECT COUNT(*) FROM orders");
            if(rs.next()) totalOrders = rs.getInt(1);

            rs = conn.createStatement().executeQuery("SELECT COUNT(*) FROM orders WHERE status='Beklemede'");
            if(rs.next()) pendingOrders = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingOrders", pendingOrders);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}