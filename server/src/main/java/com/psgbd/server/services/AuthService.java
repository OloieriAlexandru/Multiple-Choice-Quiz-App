package com.psgbd.server.services;

import com.psgbd.server.dtos.AuthRequestDTO;
import com.psgbd.server.dtos.AuthResponseDTO;

public interface AuthService {
    AuthResponseDTO register(AuthRequestDTO user);
}
