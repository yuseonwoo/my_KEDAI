package com.spring.app.common;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MySMTPAuthenticator extends Authenticator {

	@Override
	public PasswordAuthentication getPasswordAuthentication() {
   
		// Gmail 의 경우 @gmail.com 을 제외한 아이디만 입력한다.
		return new PasswordAuthentication("91yerinjung","b j a d f q s m d s j o g q q l​"); 
		// "u a q v b p r b g he y u c c l" 은 Google 에 로그인 하기위한 앱비밀번호 이다.
	}
	
}
