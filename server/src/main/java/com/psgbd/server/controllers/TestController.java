package com.psgbd.server.controllers;

import com.psgbd.server.dtos.TestRequestDTO;
import com.psgbd.server.dtos.TestResponseDTO;
import com.psgbd.server.services.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/api/v1/tests")
public class TestController {
    @Autowired
    private TestService testService;

    @PostMapping
    public ResponseEntity<TestResponseDTO> getNextQuestion(@RequestBody final TestRequestDTO requestDTO) {
        TestResponseDTO response = testService.getNextQuestion(requestDTO);
        if (response == null) {
            return ResponseEntity.notFound().build();
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
