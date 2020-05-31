package com.psgbd.server.config;

import com.psgbd.server.repositories.AppRepository;
import com.psgbd.server.repositories.AppRepositoryImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan("com.psgbd.server")
public class AppConfiguration {
    @Bean
    public AppRepository getAppRepository() throws Exception {
        AppRepository repository = new AppRepositoryImpl("jdbc:oracle:thin:@localhost:1521:xe");
        if (!repository.openConnection()) {
            throw new Exception("Failed to connect to the database!");
        }
        return repository;
    }
}
