package com.psgbd.server.services;

import com.psgbd.server.dtos.TestRequestDTO;
import com.psgbd.server.dtos.TestResponseDTO;

public interface TestService {
    TestResponseDTO getNextQuestion(TestRequestDTO requestDTO);
}
