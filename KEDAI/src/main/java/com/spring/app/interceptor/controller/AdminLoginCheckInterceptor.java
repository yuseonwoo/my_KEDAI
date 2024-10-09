package com.spring.app.interceptor.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.app.domain.MemberVO;

public class AdminLoginCheckInterceptor implements HandlerInterceptor {

	// preHandle() 메소드는 지정된 컨트롤러의 동작 이전에 호출된다. => preHandle() 메소드에서 false를 리턴하면 다음 내용(Controller의 동작)을 실행하지 않는다.
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		// 로그인 여부 검사
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser == null || (loginuser != null && !loginuser.getNickname().equals("Admin") )) { // 로그인이 되지 않았거나 로그인 되어진 사용자가 관리자가 아닌 경우
			String message = "로그인이 필요한 페이지입니다.\\n관리자로 로그인 후 이용해주세요.";
			String loc = request.getContextPath()+"/login.kedai";
         
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
         
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			try {
				dispatcher.forward(request, response);
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
         
			return false;
		}
      
		return true;
	}
	
}
