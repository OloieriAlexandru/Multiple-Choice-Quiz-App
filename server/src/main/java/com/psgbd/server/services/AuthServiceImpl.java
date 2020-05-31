package com.psgbd.server.services;

import com.google.common.hash.Hashing;
import com.psgbd.server.dtos.AuthRequestDTO;
import com.psgbd.server.dtos.AuthResponseDTO;
import com.psgbd.server.repositories.AppRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.Date;

@Service
public class AuthServiceImpl implements AuthService {
    @Autowired
    private AppRepository appRepository;

    @Override
    public AuthResponseDTO register(AuthRequestDTO user) {
        Date date = new Date(System.currentTimeMillis());
        String hashedString = user.getEmail() + date.toString();
        String hash = Hashing.sha256().hashString(hashedString, StandardCharsets.UTF_8).toString();

        if (!appRepository.insertNewUser(user.getEmail(), hash)) {
            return null;
        }

        return new AuthResponseDTO(hash);
    }
}
