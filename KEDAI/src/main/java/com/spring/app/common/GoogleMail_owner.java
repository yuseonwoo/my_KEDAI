package com.spring.app.common;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class GoogleMail_owner {

	public void send_update_accept(String nickname, String owner_nickname, String recipient) throws Exception { 
	      
		 System.out.println("Sending email to: " + recipient);
		 
		// 1. 정보를 담기 위한 객체
		Properties prop = new Properties(); 
	       
		// 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
		//    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
		prop.put("mail.smtp.user", "91yerinjung@gmail.com"); 	             
	      
		// 3. SMTP 서버 정보 설정
		//    Google Gmail 인 경우 smtp.gmail.com
		prop.put("mail.smtp.host", "smtp.gmail.com");
	       
		prop.put("mail.smtp.port", "465");
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.debug", "true");
		prop.put("mail.smtp.socketFactory.port", "465");
		prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		prop.put("mail.smtp.socketFactory.fallback", "false");
       
		prop.put("mail.smtp.ssl.enable", "true");
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기가 가능하도록 한 것이다. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 한다.
	         
	    /*  
        	MAC 의 경우 이 주석문을 해제한다.
        	혹시나 465 포트에 연결할 수 없다는 에러메시지가 나오면 아래의 3개를 넣어주면 해결된다.
	       	prop.put("mail.smtp.starttls.enable", "true");
	        prop.put("mail.smtp.starttls.required", "true");
	        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
	    */ 
	       
		Authenticator smtpAuth = new MySMTPAuthenticator();
		Session ses = Session.getInstance(prop, smtpAuth);
	          
		// 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
		ses.setDebug(true);
	               
		// 메일의 내용을 담기 위한 객체 생성
		MimeMessage msg = new MimeMessage(ses);

		// 메일 제목 설정
		String subject = "[ KEDAI ] " + nickname + "님, " + owner_nickname + "님의 카셰어링 예약이 확정되었습니다.";
		msg.setSubject(subject);
	               
		// 보내는 사람의 메일주소
		String sender = "91yerinjung@gmail.com";
		Address fromAddr = new InternetAddress(sender);
		msg.setFrom(fromAddr);
	               
		// 받는 사람의 메일주소
		Address toAddr = new InternetAddress(recipient);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
	               
		// 메시지 본문의 내용과 형식, 캐릭터 셋 설정
		msg.setContent("<div style='width: 50%; margin: 3% auto; padding: 3% 5%; border: 1px solid #ddd;'>" + 
					   "        <div>" + 
					   "            <div style='color: #2c4459; font-size: 50px; font-weight: bold;'>KEDAI</div>" + 
					   "            <div style='border-top: 3px solid #2c4459; text-align: center; padding-top: 5%;'>" + 
					   "                <h2 style='color: #e68c0e;'>카셰어링 확정</h2>" + 
					   "                <h4 style='font-weight: 100;'>" + 
					   "                    안녕하세요 <span style='font-weight: bold;'>"+nickname+"</span> 님,<br>" + owner_nickname +"님과의 카셰어링 예약이 확정되었습니다.<br> 자세한 내용은 마이페이지 카셰어링 신청현황에서 볼수 있습니다."+
					   "                </h4>" + 
					   "            </div>" + 
					   "        </div>" + 
					   "</div>", "text/html;charset=UTF-8");
               
		// 메일 발송하기
		Transport.send(msg);
	       
	} // end of public void send_certification_code(String recipient, String certification_code) throws Exception --------
	
	public void send_update_deny(String nickname, String owner_nickname, String recipient, String deny_reason) throws Exception { 
	      
		 System.out.println("Sending email to: " + recipient);
		 
		// 1. 정보를 담기 위한 객체
		Properties prop = new Properties(); 
	       
		// 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
		//    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
		prop.put("mail.smtp.user", "91yerinjung@gmail.com"); 	             
	      
		// 3. SMTP 서버 정보 설정
		//    Google Gmail 인 경우 smtp.gmail.com
		prop.put("mail.smtp.host", "smtp.gmail.com");
	       
		prop.put("mail.smtp.port", "465");
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.debug", "true");
		prop.put("mail.smtp.socketFactory.port", "465");
		prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		prop.put("mail.smtp.socketFactory.fallback", "false");
       
		prop.put("mail.smtp.ssl.enable", "true");
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기가 가능하도록 한 것이다. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 한다.
	         
	    /*  
        	MAC 의 경우 이 주석문을 해제한다.
        	혹시나 465 포트에 연결할 수 없다는 에러메시지가 나오면 아래의 3개를 넣어주면 해결된다.
	       	prop.put("mail.smtp.starttls.enable", "true");
	        prop.put("mail.smtp.starttls.required", "true");
	        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
	    */ 
	       
		Authenticator smtpAuth = new MySMTPAuthenticator();
		Session ses = Session.getInstance(prop, smtpAuth);
	          
		// 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
		ses.setDebug(true);
	               
		// 메일의 내용을 담기 위한 객체 생성
		MimeMessage msg = new MimeMessage(ses);

		// 메일 제목 설정
		String subject = "[ KEDAI ] " + nickname + "님, " + owner_nickname + "님과의 카셰어링 예약이 취소되었습니다.";
		msg.setSubject(subject);
	               
		// 보내는 사람의 메일주소
		String sender = "91yerinjung@gmail.com";
		Address fromAddr = new InternetAddress(sender);
		msg.setFrom(fromAddr);
	               
		// 받는 사람의 메일주소
		Address toAddr = new InternetAddress(recipient);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
	               
		// 메시지 본문의 내용과 형식, 캐릭터 셋 설정
		msg.setContent("<div style='width: 50%; margin: 3% auto; padding: 3% 5%; border: 1px solid #ddd;'>" + 
					   "        <div>" + 
					   "            <div style='color: #2c4459; font-size: 50px; font-weight: bold;'>KEDAI</div>" + 
					   "            <div style='border-top: 3px solid #2c4459; text-align: center; padding-top: 5%;'>" + 
					   "                <h2 style='color: #e68c0e;'>카셰어링 취소</h2>" + 
					   "                <h4 style='font-weight: 100;'>" + 
					   "                    안녕하세요 <span style='font-weight: bold;'>"+nickname+"</span> 님,<br>" + owner_nickname +"님이 '"+ deny_reason + "' 와 같은 사유로 카셰어링 예약을 취소하였습니다. <br>다른 카셰어링 예약을 이용해주세요 감사합니다."+
					   "                </h4>" + 
					   "            </div>" + 
					   "        </div>" + 
					   "</div>", "text/html;charset=UTF-8");
               
		// 메일 발송하기
		Transport.send(msg);
	       
	} // end of public void send_certification_code(String recipient, String certification_code) throws Exception --------
	
	
	public void request_payment(String nickname, String owner_nickname, String recipient, String nonpayment_amount) throws Exception { 
	      
		 System.out.println("Sending email to: " + recipient);
		 
		// 1. 정보를 담기 위한 객체
		Properties prop = new Properties(); 
	       
		// 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
		//    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
		prop.put("mail.smtp.user", "91yerinjung@gmail.com"); 	             
	      
		// 3. SMTP 서버 정보 설정
		//    Google Gmail 인 경우 smtp.gmail.com
		prop.put("mail.smtp.host", "smtp.gmail.com");
	       
		prop.put("mail.smtp.port", "465");
		prop.put("mail.smtp.starttls.enable", "true");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.debug", "true");
		prop.put("mail.smtp.socketFactory.port", "465");
		prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		prop.put("mail.smtp.socketFactory.fallback", "false");
      
		prop.put("mail.smtp.ssl.enable", "true");
		prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기가 가능하도록 한 것이다. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 한다.
	         
	    /*  
       	MAC 의 경우 이 주석문을 해제한다.
       	혹시나 465 포트에 연결할 수 없다는 에러메시지가 나오면 아래의 3개를 넣어주면 해결된다.
	       	prop.put("mail.smtp.starttls.enable", "true");
	        prop.put("mail.smtp.starttls.required", "true");
	        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
	    */ 
	       
		Authenticator smtpAuth = new MySMTPAuthenticator();
		Session ses = Session.getInstance(prop, smtpAuth);
	          
		// 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
		ses.setDebug(true);
	               
		// 메일의 내용을 담기 위한 객체 생성
		MimeMessage msg = new MimeMessage(ses);

		// 메일 제목 설정
		String subject = "[ KEDAI ] " + nickname + "님, " + owner_nickname + "님께서 카셰어링 정산을 요청하셨습니다.";
		msg.setSubject(subject);
	               
		// 보내는 사람의 메일주소
		String sender = "91yerinjung@gmail.com";
		Address fromAddr = new InternetAddress(sender);
		msg.setFrom(fromAddr);
	               
		// 받는 사람의 메일주소
		Address toAddr = new InternetAddress(recipient);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
	               
		// 메시지 본문의 내용과 형식, 캐릭터 셋 설정
		msg.setContent("<div style='width: 50%; margin: 3% auto; padding: 3% 5%; border: 1px solid #ddd;'>" + 
					   "        <div>" + 
					   "            <div style='color: #2c4459; font-size: 50px; font-weight: bold;'>KEDAI</div>" + 
					   "            <div style='border-top: 3px solid #2c4459; text-align: center; padding-top: 5%;'>" + 
					   "                <h2 style='color: #e68c0e;'>이용금액 :" + nonpayment_amount + "point</h2>" + 
					   "                <h4 style='font-weight: 100;'>" + 
					   "                    안녕하세요 <span style='font-weight: bold;'>"+nickname+"</span> 님,<br>" + owner_nickname +"님이 미결제된 '"+ nonpayment_amount + "' point 정산을 요청하셨습니다. <br> 빠른 시일내에 정산 부탁드립니다. 감사합니다."+
					   "                </h4>" + 
					   "            </div>" + 
					   "        </div>" + 
					   "</div>", "text/html;charset=UTF-8");
              
		// 메일 발송하기
		Transport.send(msg);
	       
	} // end of public void send_certification_code(String recipient, String certification_code) throws Exception --------
	
}