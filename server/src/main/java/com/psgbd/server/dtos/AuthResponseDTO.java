package com.psgbd.server.dtos;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class AuthResponseDTO {
    private String hash;

    public AuthResponseDTO(String hash) {
        this.hash = hash;
    }
}
