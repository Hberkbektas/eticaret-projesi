package controller;

import dao.OrderDAO;
import model.Order;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        List<Order> orders = orderDAO.getOrdersByUserId(currentUser.getId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("my-orders.jsp").forward(request, response);
    }
}