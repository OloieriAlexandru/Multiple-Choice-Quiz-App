package com.psgbd.server.dtos;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class TestResponseDTO {
    private String response;

    public TestResponseDTO(String response) {
        this.response = response;
    }
}
