package com.psgbd.server.repositories;

public interface AppRepository {
    boolean openConnection();

    boolean insertNewUser(String email, String hash);

    String getUserHash(String email);

    String getNextQuestion(String email, String questionResponse);
}
