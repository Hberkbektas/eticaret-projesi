package dao;

import model.CartItem;
import model.Order;
import util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // MÜŞTERİ İŞLEMİ: Sipariş Verme (Eski Kod Korundu)
    public boolean placeOrder(int userId, List<CartItem> cart, double totalAmount) {
        String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'Beklemede')";
        String insertItemSQL = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); 

            PreparedStatement orderStmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setDouble(2, totalAmount);
            orderStmt.executeUpdate();

            ResultSet rs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) { orderId = rs.getInt(1); }

            PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL);
            PreparedStatement stockStmt = conn.prepareStatement(updateStockSQL);

            for (CartItem item : cart) {
                double subtotal = item.getProduct().getPrice() * item.getQuantity();

                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getProduct().getId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setDouble(4, item.getProduct().getPrice());
                itemStmt.setDouble(5, subtotal);
                itemStmt.addBatch();

                stockStmt.setInt(1, item.getQuantity());
                stockStmt.setInt(2, item.getProduct().getId());
                stockStmt.addBatch();
            }

            itemStmt.executeBatch();
            stockStmt.executeBatch();
            conn.commit(); 
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // MÜŞTERİ İŞLEMİ: Kendi Siparişlerini Görme (Eski Kod Korundu)
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }

    // YENİ: ADMİN İŞLEMİ - Tüm Siparişleri Getir
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return orders;
    }

    // YENİ: ADMİN İŞLEMİ - Sipariş Durumunu Güncelle
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Yardımcı Metot
    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        return order;
    }
}