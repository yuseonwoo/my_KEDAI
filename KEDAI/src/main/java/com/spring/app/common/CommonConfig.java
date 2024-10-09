package com.spring.app.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
public class CommonConfig {
	@Bean
	public ObjectMapper objectMapper() {
		return new ObjectMapper();
	}

}
