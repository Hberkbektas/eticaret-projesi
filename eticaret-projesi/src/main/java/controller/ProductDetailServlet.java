package controller;

import dao.ProductDAO;
import model.Product;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL'den gelen id parametresini alıyoruz
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);
            
            if (product != null) {
                // Ürünü bulduysak JSTL'in okuması için request'e paketliyoruz
                request.setAttribute("product", product);
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
                return;
            }
        }
        
        // Ürün bulunamazsa ana sayfaya fırlat
        response.sendRedirect("home");
    }
}