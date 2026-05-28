package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // XAMPP veritabanı ayarları
    private static final String URL = "jdbc:mysql://localhost:3306/eticaret_db?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // XAMPP'ta şifre genelde boştur

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // MySQL sürücüsünü yükle
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}