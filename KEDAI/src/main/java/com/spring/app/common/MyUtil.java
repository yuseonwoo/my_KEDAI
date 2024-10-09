package com.spring.app.common;

import javax.servlet.http.HttpServletRequest; 

public class MyUtil {

	// *** ? 다음의 데이터까지 포함한 현재 URL 주소를 알려주는 메소드를 생성 *** //
	public static String getCurrentURL(HttpServletRequest request) {
		
		String currentURL = request.getRequestURL().toString();
		
		String queryString = request.getQueryString();
		
		if(queryString != null) { // "GET" 방식일 경우
			currentURL += "?" + queryString;
		}
		
		String ctxPath = request.getContextPath();
		
		int beginIndex = currentURL.indexOf(ctxPath) + ctxPath.length(); 
		
		currentURL = currentURL.substring(beginIndex);
		
		return currentURL;
		
	} // end of public static String getCurrentURL(HttpServletRequest request) ----------
}