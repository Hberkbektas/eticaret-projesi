package controller;

import dao.OrderDAO;
import model.CartItem;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (currentUser != null && cart != null && !cart.isEmpty()) {
            double totalAmount = 0;
            for (CartItem item : cart) {
                totalAmount += item.getProduct().getPrice() * item.getQuantity();
            }
            
            // Siparişi veritabanına kaydet ve stokları düşür
            boolean isSuccess = orderDAO.placeOrder(currentUser.getId(), cart, totalAmount);
            
            if(isSuccess) {
                session.removeAttribute("cart"); // PDF İsteri: Sepeti Temizle
                response.sendRedirect("success.jsp");
                return;
            }
        }
        response.sendRedirect("cart.jsp");
    }
}