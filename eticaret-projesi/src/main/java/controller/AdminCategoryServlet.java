package controller;

import dao.CategoryDAO;
import model.Category;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
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
            Category c = new Category();
            c.setName(request.getParameter("name"));
            c.setDescription(request.getParameter("description"));
            c.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
            categoryDAO.addCategory(c);
        } 
        else if ("update".equals(action)) {
            Category c = new Category();
            c.setId(Integer.parseInt(request.getParameter("id")));
            c.setName(request.getParameter("name"));
            c.setDescription(request.getParameter("description"));
            c.setActive(Boolean.parseBoolean(request.getParameter("isActive")));
            categoryDAO.updateCategory(c);
        }
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryDAO.deleteCategory(id);
        }

        response.sendRedirect("categories");
    }
}