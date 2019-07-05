package com.osf.sp.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class URIController {

	@GetMapping("/views/**") 
	public String goPage(HttpServletRequest request) {
		String uri = request.getRequestURI();
		log.info("uri : {}", request.getRequestURI());
		String contextRoot = request.getContextPath();
		uri = uri.replace(contextRoot+"/views", "");
		return uri;
	}
}
