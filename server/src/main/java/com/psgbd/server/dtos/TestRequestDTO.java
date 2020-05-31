package com.psgbd.server.dtos;

import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@NoArgsConstructor
public class TestRequestDTO {
    private String email;
    private String hash;
    private String questionResponse;

    public String getEmail() {
        return email;
    }

    public String getHash() {
        return hash;
    }

    public String getQuestionResponse() {
        return questionResponse;
    }
}
