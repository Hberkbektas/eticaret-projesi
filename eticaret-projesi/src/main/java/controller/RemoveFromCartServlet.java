package controller;

import model.CartItem;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/remove-from-cart")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null) {
            CartItem targetItem = null;
            
            // 1. Önce silinmek istenen ürünü sepette buluyoruz
            for (CartItem item : cart) {
                if (item.getProduct().getId() == productId) {
                    targetItem = item;
                    break;
                }
            }

            // 2. Ürünü bulduysak adet kontrolü yapıyoruz
            if (targetItem != null) {
                if (targetItem.getQuantity() > 1) {
                    // Adet 1'den büyükse, sadece sayıyı 1 azalt
                    targetItem.setQuantity(targetItem.getQuantity() - 1);
                } else {
                    // Adet 1 ise, ürünü sepetten tamamen çıkar
                    cart.remove(targetItem);
                }
            }
        }
        
        response.sendRedirect("cart.jsp");
    }
}