package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import model.Category;
import model.Product;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO(); // YENİ

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // URL'den kategori ID'si gelip gelmediğine bakıyoruz
        String categoryIdParam = request.getParameter("categoryId");
        List<Product> productList;

        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            // Seçili kategori varsa filtrelenmiş ürünleri getir
            int categoryId = Integer.parseInt(categoryIdParam);
            productList = productDAO.getProductsByCategory(categoryId);
        } else {
            // Yoksa tüm ürünleri getir
            productList = productDAO.getAllProducts();
        }

        // Kategorileri de üst menüde göstermek için çekiyoruz
        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList); // YENİ
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}