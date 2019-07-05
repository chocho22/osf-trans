package com.osf.sp.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class UserController {
	
	@CrossOrigin("http://localhost:4200")
	@PostMapping("/login")
	public @ResponseBody Map<String,String> doLogin(@RequestBody Map<String,String> param) {
		param.put("login", "no");
		if("test".equals(param.get("id"))) {
			if("test".equals(param.get("pwd"))) {
				param.put("login", "ok");
			}
		}
		return param;
	}
}






