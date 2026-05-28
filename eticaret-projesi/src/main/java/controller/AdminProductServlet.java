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

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Ürünleri ve formlarda listelenecek kategorileri çekiyoruz
        List<Product> productList = productDAO.getAllProducts();
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Product p = new Product();
            p.setName(request.getParameter("name"));
            p.setDescription(request.getParameter("description"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setImageUrl(request.getParameter("imageUrl"));
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId"))); // Kategori eklendi
            productDAO.addProduct(p);
        } 
        else if ("update".equals(action)) { // YENİ: Güncelleme İşlemi
            Product p = new Product();
            p.setId(Integer.parseInt(request.getParameter("id")));
            p.setName(request.getParameter("name"));
            p.setDescription(request.getParameter("description"));
            p.setPrice(Double.parseDouble(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setImageUrl(request.getParameter("imageUrl"));
            p.setCategoryId(Integer.parseInt(request.getParameter("categoryId"))); // Kategori eklendi
            productDAO.updateProduct(p);
        }
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.deleteProduct(id);
        }

        response.sendRedirect("products");
    }
}