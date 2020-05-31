package com.psgbd.server.dtos;

import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@NoArgsConstructor
public class AuthRequestDTO {
    private String email;

    public String getEmail() {
        return email;
    }
}
