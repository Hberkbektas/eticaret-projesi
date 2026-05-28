package controller;

import dao.ProductDAO;
import model.CartItem;
import model.Product;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    @SuppressWarnings("unchecked") // İŞTE O SARI ÇİZGİYİ YOK EDEN KOMUT BURADA!
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Butona tıklandığında gelen ürün ID'sini alıyoruz
        int productId = Integer.parseInt(request.getParameter("productId"));
        Product product = productDAO.getProductById(productId);

        if (product != null) {
            HttpSession session = request.getSession();
            
            // Oturumda (session) sepet var mı diye bakıyoruz
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            // Yoksa yeni, boş bir sepet oluşturuyoruz
            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }

            // Ürün zaten sepette varsa sadece adetini artır
            boolean itemExists = false;
            for (CartItem item : cart) {
                if (item.getProduct().getId() == productId) {
                    item.setQuantity(item.getQuantity() + 1);
                    itemExists = true;
                    break;
                }
            }

            // Ürün sepette yoksa listeye yeni olarak ekle
            if (!itemExists) {
                cart.add(new CartItem(product, 1));
            }
        }
        
        // İşlem bitince kullanıcıyı ana sayfaya geri fırlatıyoruz
        response.sendRedirect(request.getContextPath() + "/home");
    }
}