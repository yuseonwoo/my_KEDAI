  <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title></title>
<!-- 유선우 제작페이지 -->
<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>

<style type = "text/css">
body, html {
  height: 100%;
  margin: 0;
  display: flex;
  justify-content: center; /* 수평 중앙 정렬 */
  align-items: center; /* 수직 중앙 정렬 */
  overflow: hidden;
}
#chatStatus {
  background-color: #f1f1f1; /* 배경 색상 설정 */
  padding: 3%; /* 패딩 설정 */
  border: 1px solid #ccc; /* 테두리 설정 */
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자 설정 */
  text-align: center; /* 텍스트 가운데 정렬 */
}

.form-control {
	/* width: 30%; */
	height: auto;
	margin-bottom:10px;
	width: 100%;
	height:50px;
}

#btnExitMessage{
	padding:5%;
	background-color: #e68c0e;
	color: #2c4459;
	font-weight: bold;
}
#btnExitMessage:hover{
	background-color: #2c4459;
	color: #e68c0e;
	
}

#btnSendMessage{
	padding:5%;
	background-color: #2c4459;
	color: #e68c0e;
	font-weight: bold;
}

#btnSendMessage:hover{
	background-color: #e68c0e;
	color: #2c4459;
}


.button_group{

	display: flex;
	gap: 10px;
}




.message_container{
	display: flex;
	flex-direction: column;
	align-items: center;
	width:800px;
	height: 300px;
	margin-right: 50px;
	
}

.message_body{
	
}

/*
#speechbubble{

.tooltip{
  position: absolute;
  top: 50%;
  left: 106%;
  margin-top:-7px;
  margin-left:-7px;
  border-width: 7px;
  border-style: solid;
  border-color:  transparent transparent transparent #555;
}
}
*/

/* common header에 있는 말풍선 참고하기 tooltip */

.chatUser {
	border: 1px solid black; 
	width: auto; 
	text-align: center;
	font-weight:bold;
	background-color: #ccc;
	height: 50px;
	margin-bottom:258%;
}


#btnSendMessage #btnExitMessage{
	margin-bottom: 120%;
}

#chatStatus {
	border-radius: 10px;
	font-weight: 700;
	color: #2c4459;
}

#chatting_box {
	width: 900px;
	height: 890px;
	
}
#secretId{
	display: inline-block;
	width: 500px;
	height: 500px;
}

</style> 




<!-- ==== #223.(웹채팅관련5) -->

<script type="text/javascript">

//=== !!! WebSocket 통신 프로그래밍은 HTML5 표준으로써 자바스크립트로 작성하는 것이다. !!! === //
// WebSocket(웹소켓)은 웹 서버로 소켓을 연결한 후 데이터를 주고 받을 수 있도록 만든 HTML5 표준이다. 
// 그런데 이러한 WebSocket(웹소켓)은 HTTP 프로토콜로 소켓 연결을 하기 때문에 웹 브라우저가 이 기능을 지원하지 않으면 사용할 수 없다. 
/*
>> 소켓(Socket)이란? 
  - 어떤 통신프로그램이 네트워크상에서 데이터를 송수신할 수 있도록 연결해주는 연결점으로써 
    IP Address와 port 번호의 조합으로 이루어진다. 
      또한 어떤 하나의 통신프로그램은 하나의 소켓(Socket)만을 가지는 것이 아니라 
      동일한 프로토콜, 동일한 IP Address, 동일한 port 번호를 가지는 수십개 혹은 수만 개의 소켓(Socket)을 가질 수 있다.

   =================================================================================================  
      클라이언트  소켓(Socket)                                         서버  소켓(Socket)
        211.238.142.70:7942 ◎------------------------------------------◎  211.238.142.72:9099
    // ip : postNumber -> 소켓
        클라이언트는 서버인 211.238.142.72:9099 소켓으로 클라이언트 자신의 정보인 211.238.142.70:7942 을 
        보내어 연결을 시도하여 연결이 이루어지면 서버는 클라이언트의 소켓인 211.238.142.70:7942 으로 데이터를 보내면서 통신이 이루어진다.
 ================================================================================================== 
        
        소켓(Socket)은 데이터를 통신할 수 있도록 해주는 연결점이기 때문에 통신할 두 프로그램(Client, Server) 모두에 소켓이 생성되야 한다.

    Server는 특정 포트와 연결된 소켓(Server 소켓)을 가지고 서버 컴퓨터 상에서 동작하게 되는데, 
     이 Server는 소켓을 통해 Cilent측 소켓의 연결 요청이 있을 때까지 기다리고 있다(Listening 한다 라고도 표현함).
    Client 소켓에서 연결요청을 하면(올바른 port로 들어왔을 때) Server 소켓이 허락을 하여 통신을 할 수 있도록 연결(connection)되는 것이다.
*/

	$(document).ready(function(){

		// $("div#mycontent").css({"background-color":"#cce0ff"});
	    // div#mycontent 는  /Board/src/main/webapp/WEB-INF/tiles/layout/layout-tiles1.jsp 파일의 내용에 들어 있는 <div id="mycontent"> 이다.
			
	    const url = window.location.host;	// 웹브라우저의 주소창의 포트까지 가져오는 것
	    //alert("url : " + url);  
	    // url : 192.168.10.198:9099
	    // url : 192.168.0.210:9099
	    
	    const pathname = window.location.pathname;	// 최초 '/' 부터 오른쪽에 있는 모든 경로를 알려준다. 
	    //alert("pathname : " + pathname);
	   // pathname : /KEDAI/chatting/multichat.kedai
		
	    const appCtx =  pathname.substring(0, pathname.lastIndexOf("/"));	// "전체 문자열".lastIndexOf("검사할 문자"); 
	    //alert("appCtx : " + appCtx);
	    // appCtx : /KEDAI/chatting
	    
	    const root = url + appCtx;
	    //alert("root : " + root);
	    // root : 192.168.0.210:9099/KEDAI/chatting
		// root : 192.168.10.198:9099/KEDAI/chatting	   
	    
		//const wsUrl = "ws://"+root+"/multichatstart.kedai";
	    
		const wsUrl = "ws://"+ "192.168.219.106:9099/KEDAI/chatting" +"/multichatstart.kedai";
	    
		//const wsUrl = "ws://"+ "192.168.219.106:9099/KEDAI/chatting" +"/multichatstart.kedai";
	    //alert("wsUrl : " + wsUrl)
	    // wsUrl : ws://192.168.10.198:9099/KEDAI/chatting/multichatstart.kedai
	    // 192.168.10.198:9099/KEDAI/chatting/multichatstart.kedai
	    // wsUrl : ws://192.168.0.210:9099/KEDAI/chatting/multichatstart.kedai
	 	// 웹소켓통신을 하기위해서는 http:// 을 사용하는 것이 아니라 ws:// 을 사용해야 한다. 
	    // "/multichatstart.kedai" 에 대한 것은 /WEB-INF/spring/config/websocketContext.xml 파일에 있는 내용이다. 
	    
	    const websocket = new WebSocket(wsUrl);
	    // 즉, const websocket = new WebSocket("ws://192.168.0.210:9099/board/chatting/multichatstart.action"); 이다. 
	    
	 	// >> ====== !!중요!! Javascript WebSocket 이벤트 정리 ====== << //
	    /*   -------------------------------------
	                      이벤트 종류             설명
	         -------------------------------------
	             onopen         WebSocket 연결
	             onmessage      메시지 수신
	             onerror        전송 에러 발생
	             onclose        WebSocket 연결 해제
	    */
	    
	    
	    // === 웹소켓에 최초로 연결이 되었을 경우에 실행되어지는 콜백함수 정의하기 === //
	    websocket.onopen = function(){
			// alert("웹소켓 연결됨");
			$("div#chatStatus").text("웹 채팅에 연결이 성공하였습니다."); 
			
			/*   
	           messageObj.message = "채팅방에 <span style='color: red;'>입장</span> 했습니다.";
	           messageObj.type = "all"; // messageObj.type = "all"; 은 "1 대 다" 채팅을 뜻하는 것이고, messageObj.type = "one"; 은 "1 대 1" 채팅을 뜻하는 것으로 하겠다.  
	           messageObj.to = "all";   // messageObj.to = "all"; 은 수신자는 모두를 뜻하는 것이고, messageObj.to = "eomjh"; 이라면  eomjh 인 사람과 1대1 채팅(귓속말)을 뜻하는 것으로 하겠다. 
	        */
	        
	    	// 또는 
			messageObj = {message : "채팅방에 <span style='color: red;'>입장</span> 했습니다."
			              ,type : "all"
			              ,to : "all"}; // 자바스크립트에서 객체의 데이터값 초기화 
                
		   	websocket.send(JSON.stringify(messageObj));
		               // JSON.stringify(자바스크립트객체) 는 자바스크립트객체를 JSON 표기법의 문자열(string)로 변환한다
		               // JSON.parse(JSON 표기법의 문자열) 는 JSON 표기법의 문자열(string)을 자바스크립트객체(object)로 변환해준다.
			/*
		       JSON.stringify({});                  // '{}'
		       JSON.stringify(true);                // 'true'
		       JSON.stringify('foo');               // '"foo"'
		       JSON.stringify([1, 'false', false]); // '[1,"false",false]'
		       JSON.stringify({ x: 5 });            // '{"x":5}'
			*/ 
	 	};
	 	
	    let messageObj = {};	// 자바스크립트 객체 생성함.
	    
	    // ==== 메시지 수신시 콜백함수 정의하기 ==== // 
	    websocket.onmessage = function(event){
	    	
	    	// event.data 는 수신되어진 메시지이다. 즉 지금은 「유선우 」이다. 
    		// if(event.data.substr(0,1)=="「" && event.data.substr(event.data.length-1)=="」") {
    	   if(event.data.substr(0,1)=="「") {
    		 //  alert(event.data); 
    		  $("div#connectingUserList").html(event.data);
           }
    	   /// ★
    	   else if(event.data.substr(0,1)=="⊇"){
    		  $("tbody#tbody").html(event.data);  
    	   }
           else {
           // 	event.data 는 수신받은 채팅 문자이다.
           		$("div#chatMessage").append(event.data);
          		$("div#chatMessage").append("<br>");
          		$("div#chatMessage").scrollTop(99999999);
           }
    	 // } // 이거 추가하면 엔터가 안쳐짐
	     };
	    
		 // === 웹소켓 연결 해제시 콜백함수 정의하기 === //
	     websocket.onclose = function(){
	          
	     }
	    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	  	// === 메시지 입력후 엔터하기 === //
        $("input#message").keyup(function(key){
          if(key.keyCode == 13) {
             $("input#btnSendMessage").click(); 
          }
        });
	    
   	    // === 메시지 보내기 === //
        let isOnlyOneDialog = false; // 귀속말 여부. true 이면 귀속말, false 이면 모두에게 공개되는 말 
       
        $("input#btnSendMessage").click(function(){
        	// console.log("1");
          if( $("input#message").val().trim() != "" ) {
        	  // console.log("2");
          	// ==== 자바스크립트에서 replace를 replaceAll 처럼 사용하기 ====
            // 자바스크립트에서 replaceAll 은 없다.
            // 정규식을 이용하여 대상 문자열에서 모든 부분을 수정해 줄 수 있다.
            // 수정할 부분의 앞뒤에 슬래시를 하고 뒤에 gi 를 붙이면 replaceAll 과 같은 결과를 볼 수 있다. 
            
            let messageVal = $("input#message").val();
            messageVal = messageVal.replace(/<script/gi, "&lt;script"); 
            // 스크립트 공격을 막으려고 한 것임.
               
               <%-- 
                messageObj = {message : messageVal
                           ,type : "all"
                           ,to : "all"}; 
               --%>
               // 또는
               messageObj = {}; // 자바스크립트 객체 생성함. 
               messageObj.message = messageVal;
               messageObj.type = "all";
               messageObj.to = "all";
               
               const to = $("input#to").val();
               
               // console.log("3" + );
               
               if( to != "" ){
            	   console.log("4");
                  	messageObj.type = "one";
                  	messageObj.to = to;
                  	console.log("type" + messageObj.type);
                  	console.log("to" + messageObj.to );
               }
               
               websocket.send(JSON.stringify(messageObj));
               // JSON.stringify() 는 값을 그 값을 나타내는 JSON 표기법의 문자열로 변환한다
            
               // 위에서 자신이 보낸 메시지를 웹소켓으로 보낸 다음에 자신이 보낸 메시지 내용을 웹페이지에 보여지도록 한다. 
               
               const now = new Date();
               let ampm = "오전 ";
               let hours = now.getHours();
               
               if(hours > 12) {
                    hours = hours - 12;
                    ampm = "오후 ";
               }
               
               if(hours == 0) {
                    hours = 12;
               }
               
               if(hours == 12) {
                 	ampm = "오후 ";
               }
               
               let minutes = now.getMinutes();
               if(minutes < 10) {
               		minutes = "0"+minutes;
               }
             
               const currentTime = ampm + hours + ":" + minutes; 
               
               if(isOnlyOneDialog == false) { // 귀속말이 아닌 경우
                  $("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>"); 
                                                                                                                                                                          /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
               }
               
               else { // 귀속말인 경우. 글자색을 빨강색으로 함.
                  $("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all; color: red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");
                                                                                                                                                                          /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
               }
               
               $("div#chatMessage").scrollTop(99999999);
               
               $("input#message").val("");
               $("input#message").focus();
               
               ///////////// 확인용 ///////////////
               // alert()
               //////////////////////////////////////////////
          }
          
       });
       ////////////////////////////////////////////////////
	    
       // 귀속말대화끊기 버튼은 처음에는 보이지 않도록 한다.
       $("button#btnAllDialog").hide();
       
       // 아래는 귓속말을 위해서 대화를 나누는 상대방의 이름을 클릭하면 상대방이름의 웹소켓id 를 알아와서 input태그인 귓속말대상웹소켓.getId()에 입력하도록 하는 것.
       
       $(document).on("click", "span.loginuserName", function(){
          /* span.loginuserName 은 
             com.spring.chatting.websockethandler.WebsocketEchoHandler 의 
             public void handleTextMessage(WebSocketSession wsession, TextMessage message) 메소드내에
             166번 라인에 기재해두었음.
          */
          
          const ws_id = $(this).prev().text();
       	 // console.log("prev-text : " + ws_id);
       	 // alert(ws_id);
          $("input#to").val(ws_id); 
           
           $("span#privateWho").text($(this).text());
           $("button#btnAllDialog").show(); // 귀속말대화끊기 버튼 보이기 
           $("input#message").css({'background-color':'black', 'color':'white'});
           $("input#message").attr("placeholder","귀속말 메시지 내용");
           
           isOnlyOneDialog = true; // 귀속말 대화임을 지정 
     
       });  
       
       
       // 귀속말대화끊기 버튼을 클릭한 경우에는 전체대상으로 채팅하겠다는 말이다.
       $("button#btnAllDialog").click(function(){
          
          $("input#to").val("");
          $("span#privateWho").text("");
          $("input#message").css({'background-color':'', 'color':''});
          $("input#message").attr("placeholder","메시지 내용");
          $(this).hide();
          
          isOnlyOneDialog = false; // 귀속말 대화가 아닌 모두에게 공개되는 대화임을 지정.
       });
       
       
       // 메시지 나가기 
       /*
       $(document).ready(function(){
    	   $(document).keydown(function(event){
    		   if(event.key == "Escape"){
    			   window.history.back();
    		   }
    	   })
    	   
       })
		*/
	}); // end of $(document).ready(function(){}---------------------------------------


</script>    
</head>
<body>
<div style="display: flex; height: 90%; margin-bottom: 3%;">
	<table style="border:solid 0px black; border-radius: 3px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);" class="chatUser">
		<thead>
			<tr>
				<th colspan="4" style="text-align:center;">[ 접속중인 직원 ]</th>
			</tr>	
			<tr>
				<th style="width: 70px; text-align: center;">사진</th>
				<th style="width: 70px; text-align: center;">이름</th>		
				<th style="width: 70px; text-align: center;">부서</th>	
				<th style="width: 70px; text-align: center;">직급</th>			
			</tr>
		</thead>
		<tbody id="tbody">
			<%-- <c:forEach var="logEmp" items="${requestScope.loginEmpInfoList}"> 
				<tr>
					<td style="width: 70px; text-align: center;">
						<img src="<%= ctxPath%>/resources/files/employees/${logEmp.imgfilename}" width=50px; height=50px;>
					</td>
					<td style="width: 70px; text-align: center;">${logEmp.name}</td>
					<td style="width: 70px; text-align: center;">${logEmp.dept_name}</td>
					<td style="width: 70px; text-align: center;">${logEmp.job_name}</td>
				</tr>
			</c:forEach> --%>
		</tbody> 
	</table>


<div class="container-fluid" style="width: 80%; height:90%; border-radius: 3px;">
   <div class="message_body">
      <div class="row" id="chatting_box" style="border: 0px solid black; width: 890px; height: 890px; margin-bottom: 15px; border-radius: 3%; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);">
         <div class="col-md-12 offset-md-1" style="overflow:hidden;">
            <div id="chatStatus"></div>
               <div style="width:100%;">
                  - 상대방의 대화내용이 검정색으로 보이면 채팅에 참여한 모두에게 보여지는 것입니다.<br>
                  - 상대방의 대화내용이 <span style="color: red; font-weight: bold">빨간색</span>으로 보이면 나에게만 보여지는 1:1 귓속말 입니다.<br>
                  - 1:1 채팅(귓속말)을 하시려면 예를 들어, 채팅시 보이는 [이순신]대화내용 에서 이순신을 클릭하시면 됩니다.
               </div>
               <input type="hidden" id="to" placeholder="귓속말대상웹소켓.getEmpid()"/>
               <br/>
                	  ♡ 귓속말대상 : <span id="privateWho" style="font-weight: bold; color: red;"></span>
               <br>
                  <button type="button" id="btnAllDialog" class="btn btn-secondary btn-sm">귀속말대화끊기</button>
               <br><br>
             		   ☆현재접속자명단:<br>
               <div id="connectingUserList" style="max-height: 100px; overFlow-y: auto; position:fixed;"></div>
               
               <div id="chatMessage" style="max-height: 500px; overFlow: auto;"></div>
               
               <div class="message_container" style="border: 0px solid red; position: fixed; bottom: -15%; right: 50px; transform: translateX(-40%);">
                  <input type="text" id="message" class="form-control" width="100px;" placeholder="메시지 내용"/>
                  
                  <div class = "button_group">
                     <input type="button" id="btnSendMessage" class="btn btn-success btn-sm my-3" value="메시지보내기" />
                     <input type="button" id="btnExitMessage" class="btn btn-danger btn-sm my-3 mx-3" onclick="javascript:location.href='<%=request.getContextPath() %>/index.kedai'" value="채팅방나가기" />
                  </div> 
               </div>
         </div>
      </div>
   </div>   
   </div>
   </div>
</body>
</html>