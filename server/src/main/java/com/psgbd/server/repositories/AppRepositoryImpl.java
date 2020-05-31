package com.psgbd.server.repositories;

import java.sql.*;

public class AppRepositoryImpl implements AppRepository, AutoCloseable {
    private Connection connection = null;
    private String connectionString;

    public AppRepositoryImpl(String connectionString) {
        this.connectionString = connectionString;
    }

    public boolean openConnection() {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            connection = DriverManager.getConnection(connectionString, "student", "student");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
        return true;
    }

    @Override
    public boolean insertNewUser(String email, String hash) {
        PreparedStatement preparedStatement = null;
        String query = "INSERT INTO utilizatori (email, hash) VALUES (?, ?)";

        try {
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, hash);

            preparedStatement.execute();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException ignored) {
                }
            }
        }
        return true;
    }

    @Override
    public String getUserHash(String email) {
        PreparedStatement preparedStatement = null;
        String response = null;

        try {
            preparedStatement = connection.prepareStatement("SELECT hash FROM utilizatori WHERE email = ?");
            preparedStatement.setString(1, email);

            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                response = rs.getString("hash");
            } else {
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException ignored) {
                }
            }
        }
        return response;
    }

    @Override
    public String getNextQuestion(String email, String questionResponse) {
        CallableStatement cstmt = null;
        String response = null;

        try {
            cstmt = connection.prepareCall("{? = call urmatoarea_intrebare(?,?)}");
            cstmt.registerOutParameter(1, Types.VARCHAR);
            cstmt.setString(2, email);
            cstmt.setString(3, questionResponse);
            cstmt.executeUpdate();

            response = cstmt.getString(1);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (cstmt != null) {
                try {
                    cstmt.close();
                } catch (SQLException ignored) {
                }
            }
        }
        return response;
    }

    @Override
    public void close() {
        try {
            connection.close();
        } catch (SQLException e) {
            System.out.println("Error when closing the connection to the database!");
            System.out.println(e.getSQLState());
        }
    }
}
