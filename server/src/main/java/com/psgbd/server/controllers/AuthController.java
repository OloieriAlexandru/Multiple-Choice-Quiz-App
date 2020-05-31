package com.psgbd.server.controllers;

import com.psgbd.server.dtos.AuthRequestDTO;
import com.psgbd.server.dtos.AuthResponseDTO;
import com.psgbd.server.services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping
    public ResponseEntity<AuthResponseDTO> register(@RequestBody final AuthRequestDTO user) throws Exception {
        AuthResponseDTO response = authService.register(user);
        if (response != null) {
            return new ResponseEntity<>(response, HttpStatus.OK);
        }
        throw new Exception("Failed to create user");
    }
}
