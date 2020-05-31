package com.psgbd.server.services;

import com.psgbd.server.dtos.TestRequestDTO;
import com.psgbd.server.dtos.TestResponseDTO;
import com.psgbd.server.repositories.AppRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestServiceImpl implements TestService {
    @Autowired
    private AppRepository appRepository;

    @Override
    public TestResponseDTO getNextQuestion(TestRequestDTO requestDTO) {
        String userHash = appRepository.getUserHash(requestDTO.getEmail());
        if (!userHash.equals(requestDTO.getHash())) {
            return null;
        }

        String response = appRepository.getNextQuestion(requestDTO.getEmail(), requestDTO.getQuestionResponse());
        return new TestResponseDTO(response);
    }
}
