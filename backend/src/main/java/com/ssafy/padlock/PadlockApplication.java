package com.ssafy.padlock;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class PadlockApplication {

	public static void main(String[] args) {
		SpringApplication.run(PadlockApplication.class, args);
	}

}
