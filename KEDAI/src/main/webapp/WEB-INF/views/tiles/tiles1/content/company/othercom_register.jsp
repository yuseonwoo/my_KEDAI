<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.spring.app.domain.PartnerVO"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	String ctxPath = request.getContextPath();

	PartnerVO partVO = (PartnerVO)request.getAttribute("partvo");
	Boolean isModify = (partVO != null);
	request.setAttribute("isModify", isModify);
%>

<style type="text/css">
div#myHead {
	height: 80px;
	background-color: #999;
}

div#row {
	display: flex !important;
}

div#register_com {
	width: calc(100vw - 250px);
	height: calc(100vh - 80px);
	display: flex;
	justify-content: center;
	align-items: center;
}

/* 여기서부터 시작 */
.clientWrap {
	width: 100%;

}

.clientWrap label {
	display: flex;
	flex-direction: column;
	margin-top: 20px;
}

.clientWrap label:first-of-type {
	margin-top: 0;
}

.clientWrap label span {
	font-size: 14px;
	line-height: 20px;
}

.clientWrap label input {
	font-size: 16px;
	height: 40px;
}

.clientWrap .clientHeader {
	display: flex;
	padding: 10px 0;
}

.clientWrap .clientHeader button {
	height: 40px;
	width: 40px;
	background-repeat: no-repeat;
	background-size: 16px;
	background-position: center;
}

.clientWrap .clientHeader h3 {
	font-size: 20px;
	line-height: 40px;
	margin-left: 20px;
	font-weight: 700;
}

.clientWrap .clientRegister {
	display: flex;
	border-top: 1px solid #ccc;
	padding-top: 20px;
}

.clientWrap .clientRegister>div {
	
}

.clientWrap .clientRegister .rgs-profile {
	width: calc(20% - 20px);
	margin-right: 20px;
}

.clientWrap .clientRegister .rgs-profile .imgbox {
	width:100%;
	display:flex;
	justify-content:center;
	align-items:center;
	overflow:hidden;
	border:1px solid red;
	
}

.clientWrap .clientRegister .rgs-profile .imgbox img {
	width: 100%;
	/* height:auto; */
}

.clientWrap .clientRegister .rgs-body {
	width: 80%;
}

.clientWrap .clientRegister .rgs-body .rgs-forms{
	display:flex;
}
.clientWrap .clientRegister .rgs-left {
	width: 50%;
	padding: 0 10px;
}

.clientWrap .clientRegister .rgs-right {
	width: 50%;
	padding: 0 10px;
}

.clientWrap .clientRegister .rgs-right .partnameflex .partnameinfo {
	width: 49%;
	padding: 0 auto;
	MARGIN:0 auto;
}


.clientWrap .clientRegister .rgs-right .partnameflex{
	display:flex;
}



.clientWrap .clientRegister .rgs-body .rgs-address{
	padding: 0 10px;
}
.clientWrap .clientRegister .rgs-body .rgs-address label{
	width: 50%;
	padding-right: 10px;
}
.clientWrap .clientRegister .rgs-body .rgs-address label span{
 display: block;
 display: flex;
}
.clientWrap .clientRegister .rgs-body .rgs-address label input[type=button]{
	margin-left: 10px;
}
.clientWrap .clientRegister .rgs-body .rgs-address input{
	width: 100%;
	font-size: 16px;
 	height: 40px  
}
.clientWrap .clientRegister .rgs-body .rgs-address input.addfield{
	margin-top: 10px
}
.clientWrap .clientRegister .rgs-body .rgs-address input.addfield:nth-of-type(1){
	margin-top: 0px
}
.clientWrap .clientConfirm {
	display: flex;
	justify-content: center;
	padding: 20px 0;
	border-top: 1px solid #ccc;
	margin-top: 20px;
}

.clientWrap .clientConfirm input {
	height: 40px;																
	background-color: #666;
	color: #fff;
	padding: 0 20px;
	margin: 0 5px;
	border-radius: 5px;
}

.chk_businum input[type="text"]
 {
	width:100%;
	margin-right:10px;
}

.chk_businum input[type="button"]{
	width: 50%;
}

.star,.error{
	font-size:12px;
	color:red;
	
}



</style>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">
	const partvo_partner_no = "${partvo.partner_no}";
	const isModify = (partvo_partner_no !== "");
	console.log("isModify : " + isModify);
	console.log("java - isModify : ${isModify}");
		
	let comAddr_chk = false;
	let partnerNo_chk = false;
	
	$(document).ready(function(){
		
		/* 거래처이름 유효성검사 시작 */
		$("input#partner_name").blur( (e) => {
			const partner_name = $("input#partner_name").val().trim();
			if (partner_name == "") {
			// 입력하지 않거나 공백만 입력했을 경우 
	     	 /*	
			   >>>> .prop() 와 .attr() 의 차이 <<<<	         
		            .prop() ==> form 태그내에 사용되어지는 엘리먼트의 disabled, selected, checked 의 속성값 확인 또는 변경하는 경우에 사용함. 
		            .attr() ==> 그 나머지 엘리먼트의 속성값 확인 또는 변경하는 경우에 사용함.
			 */
				
				$(".clientWrap :input").prop("disabled" ,true);
		        $("input#partner_name").prop("disabled", false);
		        $("input#partner_name").val("").focus();
				    
				//  $(e.target).next().show();
		    	//  또는
		        $("input#partner_name").parent().find("span.error").show();
			} else {
				// 공백이 아닌 글자를 입력했을 경우
				$(".clientWrap :input").prop("disabled" ,false);
				$("input#partner_name").parent().find("span.error").hide();
			}
			/* 거래처이름 유효성검사 끝 */
		});
	
		$("input#partner_type").blur( (e) => {
			/* 거래처 업종 유효성검사 시작 */
			const partner_type = $("input#partner_type").val().trim();
			if(partner_type == ""){
				// 입력하지 않거나 공백만 입력했을 경우 
				$(".clientWrap :input").prop("disabled", true);
				$("input#partner_type").prop("disabled", false);
		        $("input#partner_type").val("").focus();
		            
	       		// $("input#partner_type").next().show();
	            // 또는
		        $("input#partner_type").parent().find("span.error").show();
			}
			else{
				// 공백이 아닌 글자를 입력했을 경우
				$(".clientWrap :input").prop("disabled",false);
				$("input#partner_type").parent().find("span.error").hide();
			}
			/* 거래처 업종 유효성검사 끝 */
		});
		
		$("input#part_emp_name").blur( (e) => {
			/* 거래처담당 직원 유효성 검사 시작 */
			const part_emp_name = $("input#part_emp_name").val().trim();
				
				if(part_emp_name == ""){
			  // 입력하지 않거나 공백만 입력했을 경우 
			  $(".clientWrap :input").prop("disabled", true);
			  $("input#part_emp_name").prop("disabled", false);
		    $("input#part_emp_name").val("").focus();
		            
	      // $("input#part_emp_name").next().show();
	      // 또는
		    $("input#part_emp_name").parent().find("span.error").show();
				}
				else{
					// 공백이 아닌 글자를 입력했을 경우
					$(".clientWrap :input").prop("disabled",false);
					$("input#part_emp_name").parent().find("span.error").hide();
				}
			/* 거래처담당 직원 유효성 검사 시작 */
		});
		
		$("input#part_emp_rank").blur( (e) => {
			/* 거래처담당 직원 직급 유효성검사 끝 */
			const part_emp_rank = $("input#part_emp_rank").val().trim();
				
				if(part_emp_rank == ""){
			  // 입력하지 않거나 공백만 입력했을 경우 
			  $(".clientWrap :input").prop("disabled", true);
			  $("input#part_emp_rank").prop("disabled", false);
		    $("input#part_emp_rank").val("").focus();
		            
	      // $("input#part_emp_rank").next().show();
	      // 또는
		    $("input#part_emp_rank").parent().find("span.error").show();
				}
				else{
					// 공백이 아닌 글자를 입력했을 경우
					$(".clientWrap :input").prop("disabled",false);
					$("input#part_emp_rank").parent().find("span.error").hide();
				}
			/* 거래처담당 직원 직급 유효성검사 끝 */
		});
		
		
		
		
		
		
		$("input#part_emp_email").blur( (e) => {
			/* 거래처 담당직원 이메일 유효성검사 시작 */
			const part_emp_email = $("input#part_emp_email").val().trim();
			if (part_emp_email == "") {
	        // 입력하지 않거나 공백만 입력했을 경우 
	       $(".clientWrap :input").prop("disabled", true);
	       $("input#part_emp_email").prop("disabled", false);
	       $("input#part_emp_email").focus();
	       $("input#part_emp_email").parent().find("span.error").show();
	        // 중복된 숨기기 코드를 제거했습니다.
			} 
			else {
		  	$(".clientWrap :input").prop("disabled", false);
		    $("input#part_emp_email").parent().find("span.error").hide();
			const regExp_part_emp_email = new RegExp(/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i);
		    const bool = regExp_part_emp_email.test(part_emp_email); // $("input#part_emp_email").val() 대신 part_emp_email 사용

	      if (!bool) {
	      	$(".clientWrap :input").prop("disabled", true);
	        $("input#part_emp_email").prop("disabled", false);
	        $("input#part_emp_email").focus();
	        $("input#part_emp_email").parent().find("span#email_format.error").show();
	        $("input#part_emp_email").parent().find("span#email_empty.error").hide();
	      }
	      else {
	      	$(".clientWrap :input").prop("disabled", false);
	            
	        $("input#part_emp_email").parent().find("span#email_format.error").hide();
	        $("input#part_emp_email").parent().find("span#email_empty.error").hide();
			  }
			}
				/* 거래처 담당직원 이메일 유효성검사 끝 */
		});
		
		$("input#partner_no").blur( (e) => {
			_validatePartnerNo();
		});
		
		$("input#partner_url").blur( (e) => {
			console.log("url_blur");
			/* 거래처 홈페이지 유효성검사 시작 */	
			const partner_url = $("input#partner_url").val().trim();
			if (partner_url == "") {
		        // 입력하지 않거나 공백만 입력했을 경우 
		    	$(".clientWrap :input").prop("disabled", true);
		        $("input#partner_url").prop("disabled", false);
		        $("input#partner_url").focus();
		        $("input#partner_url").parent().find("span#url_empty.error").show();
		         // 중복된 숨기기 코드를 제거했습니다.
			} 
			else {
			  	$(".clientWrap :input").prop("disabled", false);
			    $("input#partner_url").parent().find("span.error").hide();
			
			    const regExp_partner_url = new RegExp(/(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/i);
			    const bool = regExp_partner_url.test(partner_url); 
		
			    console.log("url_reg : " + bool);
		      	if (!bool) {
		      		console.log("!bool");
			      	$(".clientWrap :input").prop("disabled", true);
			        $("input#partner_url").prop("disabled", false);
			        $("input#partner_url").focus();
			        $("input#partner_url").parent().find("span#url_format.error").show();
			        $("input#partner_url").parent().find("span#url_empty.error").hide();
		      	} 
		      	else {
		      		console.log("bool");
			   		$(".clientWrap :input").prop("disabled", false);
			           
			        $("input#partner_url").parent().find("span#url_format.error").hide();
			        $("input#partner_url").parent().find("span#url_empty.error").hide();
			  	}
			}
		});
		

	  
		$("input#fileInput").change( (e) => {
			/* 이미지 파일이름 유효성검사 시작 */	
			const fileInput = $("input#fileInput").val().trim();
			if(fileInput == ""){
					// 입력하지 않거나 공백만 입력했을 경우 
				$(".clientWrap :input").prop("disabled", true);
				$("input#fileInput").prop("disabled", false);
		    	$("input#fileInput").val("").focus();
		            
		    	$(e.target).parent().find("span.error").show();
		    	result = false;
			}
			else{
					// 공백이 아닌 글자를 입력했을 경우
				$(".clientWrap :input").prop("disabled",false);
				$("input#fileInput").parent().find("span.error").hide();
			}
		});
		
		$("input#partnerNo_chk").click(function(){// "사업자 등록번호" 가 이미 있는지 확인하는 이벤트  
			
			if(_validatePartnerNo() === false){
				return;
			}
				
	   	  	$.ajax({
				url:"<%=ctxPath%>/partnerNoCheck.kedai",
				data:{"partner_no":$("input#partner_no").val()},
				type:"post",
				async: true,
				dataType:"json",
				success: function(json){
				 if(json.isExists){
				 	 $("span#partNoChkResult").html("&nbsp;이미 등록된 사업자등록번호 입니다.").css({"color":"red"});
				 	  //$("input#partner_no").val("");
				 	  
				 }
				 else{
				  	$("span#partNoChkResult").html("&nbsp;등록가능한 사업자등록번호입니다.").css({"color":"blue"});
				 }
				},
				error: function(request, status, error){
				 		alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				 }
	   	  	});

	    });
			
			
		$("span.error").hide();
		$("input#partner_part_emp_name").focus();
	});// end of document------------------------------------------------------------------------------------	
	

	function _onSubmit() {
		let validateChk = false;
		console.log("등록 버튼 누름");
		
		// 유효성 검사 통과 시 submit 호출
		if (_validate()) {
			$("#partRegisterForm").attr("action", "othercom_register.kedai");
			$("#partRegisterForm").submit();
		}
	};
	
	function _onModify(){
		let validateChk = false;
		console.log("수정버튼 누름");
		
		// 유효성 검사 통과시 submit 호출
		if(_validate()){
			$("#partRegisterForm").attr("action", "othercom_register.kedai");
			$("#partRegisterForm").submit();
		}
	}
	
	
	
	
	function _validate() {
		/* 거래처이름 유효성검사 시작 */
		const partner_name = $("input#partner_name").val().trim();
		if (partner_name == "") {
			// 입력하지 않거나 공백만 입력했을 경우 
			alert("거래처이름을 입력하셔야 합니다.");
	        return false;
		}
     	 /*	
		   >>>> .prop() 와 .attr() 의 차이 <<<<	         
	            .prop() ==> form 태그내에 사용되어지는 엘리먼트의 disabled, selected, checked 의 속성값 확인 또는 변경하는 경우에 사용함. 
	            .attr() ==> 그 나머지 엘리먼트의 속성값 확인 또는 변경하는 경우에 사용함.
		*/
		/* 거래처이름 유효성검사 끝 */
		
		/* 거래처 업종 유효성검사 시작 */
		const partner_type = $("input#partner_type").val().trim();
		if(partner_type == ""){
			// 입력하지 않거나 공백만 입력했을 경우 
			alert("거래처 업종을 입력하셔야 합니다.");
	        return false;
		}
		/* 거래처 업종 유효성검사 끝 */	
			
		/* 거래처담당 직원 유효성 검사 시작 */
		const part_emp_name = $("input#part_emp_name").val().trim();
			if(part_emp_name == ""){
				// 입력하지 않거나 공백만 입력했을 경우 
				alert("거래처담당 직원을 입력하셔야 합니다.");
		        return false;
			}
		/* 거래처담당 직원 유효성 검사 끝 */
		
		/* 거래처담당 직원 직급유효성 검사 시작 */
		const part_emp_rank = $("input#part_emp_rank").val().trim();
			if(part_emp_rank == ""){
				// 입력하지 않거나 공백만 입력했을 경우 
				alert("거래처 직원 직급을 입력하셔야 합니다.");
		        return false;
		}
		/* 거래처담당 직원 직급 유효성 검사 끝 */

		/* 거래처 담당직원 이메일 유효성검사 시작 */
		const part_emp_email = $("input#part_emp_email").val().trim();
		if (part_emp_email == "") {
        // 입력하지 않거나 공백만 입력했을 경우 
        	alert("거래처 담당직원 이메일을 입력하셔야 합니다.");
		      return false;
		}
       
		const regExp_part_emp_email = new RegExp(/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i);
	    const email_bool = regExp_part_emp_email.test(part_emp_email); // $("input#part_emp_email").val() 대신 part_emp_email 사용

    	if (!email_bool) {
   	    	alert("거래처 담당직원 이메일 형식이 잘못되었습니다.");
      		return false;
     	}
		/* 거래처 담당직원 이메일 유효성검사 끝 */
   	
		const partner_no = $("input#partner_no").val().trim();
		
		if(partner_no == ""){
			alert("사업자 등록번호를 입력하셔야 합니다.");
		      return false;
			// 입력하지 않거나 공백만 입력했을 경우 
		}
    	const regExp_partner_no = new RegExp(/^[0-9]{3}-[0-9]{2}-[0-9]{5}$/);  
     	const partner_no_bool = regExp_partner_no.test($("input#partner_no").val());

    	if(!partner_no_bool) {
 			alert("사업자 등록번호 형식이 잘못되었습니다.");
	      	return false;
		}

		/* 거래처 홈페이지 유효성검사 시작 */	
		const partner_url = $("input#partner_url").val().trim();
		if (partner_url == "") {
        // 입력하지 않거나 공백만 입력했을 경우 
       		 alert("거래처 홈페이지를 입력하셔야 합니다.");
			 return false;
		}
	
	    const regExp_partner_url = new RegExp(/^((https?|ftp):\/\/)?(-\.)?([^\s\/?\.#-]+\.?)+(\/[^\s]*)?$/i);
	    const bool = regExp_partner_url.test(partner_url); // $("input#part_emp_email").val() 대신 part_emp_email 사용
      	if (!bool) {
    	  alert("거래처 홈페이지 형식이 잘못되었습니다.");
	      return false;
     	}
			
		/* 이미지 파일이름 유효성검사 시작 */	
		const fileInput = $("input#fileInput").val().trim();
		if(fileInput == "" && !isModify){
			// 입력하지 않거나 공백만 입력했을 경우 
			alert("이미지 파일을 등록하셔야 합니다.");
			return false;
		}
		
		const part_postcode = $("input#partner_postcode").val().trim();
		console.log("part_postcodes : "+part_postcode);
	   	const part_address = $("input#partner_address").val().trim();
	   	const partner_detailaddress = $("input#partner_detailaddress").val().trim();
	  
	   	if(part_postcode == "" || part_address == "" || partner_detailaddress == "") { 
	        alert("우편번호 및 주소를 입력하셔야 합니다.");
	        return false;
	  	}
		
		return true;
	}	

		
	/* 사업자등록번호 유효성 검사 시작 */
	const _validatePartnerNo = () => {
		let result = true;
		// 사업자등록번호 유효성검사 // 
	   
		$("input#partner_no").parent().parent().find("span#format.error").hide();
		$("input#partner_no").parent().parent().find("span#empty.error").hide();
		$("span#partNoChkResult").html("");
    	
		const partner_no = $("input#partner_no").val().trim();
			
		if(partner_no == ""){
				
			// 입력하지 않거나 공백만 입력했을 경우 
			$(".clientWrap :input").prop("disabled", true);
			$("input#partner_no").prop("disabled", false);
  			$("input#partner_no").focus();
   			$("input#partner_no").parent().parent().find("span#empty.error").show();
   
   			result = false;
		}
		else{
			$(".clientWrap :input").prop("disabled", false);
      		$("input#partner_no").parent().parent().find("span#empty.error").hide();
    		
    		const regExp_partner_no = new RegExp(/^[0-9]{3}-[0-9]{2}-[0-9]{5}$/);  
     		const bool = regExp_partner_no.test($("input#partner_no").val());

	    	if(!bool) {
	            $(".clientWrap :input").prop("disabled", true);
	            $("input#partner_no").prop("disabled", false);
	            $("input#partner_no").focus();
	            $("input#partner_no").parent().parent().find("span#format.error").show();
	            result = false;
	    	}
	    	else {
		       	$(".clientWrap :input").prop("disabled", false);
	    	}
		}
		// 성공
		$(".clientWrap :input").prop("disabled", false);
		partnerNo_chk = true; 
		
		return result;
	}
	/* 사업자등록번호 유효성 검사 끝 */
		
	


	// 이미지 상자안에 이미지 파일이 아닌 다른 파일이 오면 리셋시키기
	$("#fileInput").on('change', function(event){
		const file= this.files[0];
		if(file && file.type.startsWith('image/')){
		
		// 파일이 이미지인 경우
		console.log("이미지 파일이 선택되었습니다.");
		}
		else{
			// 선택한 파일이 이미지가 아닌 경우
			alert('이미지 파일을 선택해주세요!!');
			$(this).val(''); // 입력 초기화
		}
	
	})//이미지 상자안에 이미지 파일이 아닌 다른 파일이 오면 리셋시키기 끝
			
	// ==> 거래처 대표 이미지 파일선택을 하면 화면에 이미지를 미리 보여주기 시작 <<=== //
	$(document).on("change", "input#fileInput", function(e){
		
		const input_file = $(e.target).get(0);
		
		// 자바스크립트에서 file 객체의 실제 데이터(내용물)에 접근하기 위해 FileReader 객체를 생성하여 사용한다.
		const fileReader = new FileReader();
		
		fileReader.readAsDataURL(input_file.files[0]);
		// FileReader.readAsDataURL() --> 파일을 읽고, result속성에 파일을 나타내는 URL을 저장 시켜준다.
		
		fileReader.onload = function(){
		// FileReader.onload --> 파일 읽기 완료 성공시에만 작동하도록 하는 것임.
			
			// img태그 무조건쓰고 순수 자바스크립트로만 넣어야한다 미리보기는 이렇게!
			document.getElementById("previewImg").src = fileReader.result;
		
			console.log(fileReader.result);
		}
		
	})
	// ==> 거래처 대표 이미지 파일선택을 하면 화면에 이미지를 미리 보여주기 끝 <<=== //
	////////////////////////////////////////////////////////////////////////////////////
	

	$("#resetButton").on('click',function(){
		
		resetFrm();
	});
	////////////////////////////////////////////////////////////////////////////////////////	
	// Function Declaration		
	// 주소찾기
	$("input#partner_postcode").attr("readonly",true);
	$("input#partner_address").attr("readonly",true);
	$("input#partner_extraaddress").attr("readonly",true);

	function comDaumPostcode() {
		new daum.Postcode({
			oncomplete : function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수
	
				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if (data.userSelectedType === 'R') {
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if (data.bname !== ''
							&& /[동|로|가]$/g
									.test(data.bname)) {
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if (data.buildingName !== ''
							&& data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', '
								+ data.buildingName
								: data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if (extraAddr !== '') {
						extraAddr = ' ('
								+ extraAddr + ')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					document.getElementById("partner_extraaddress").value = extraAddr;
	
				} else {
					document.getElementById("partner_extraaddress").value = '';
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('partner_postcode').value = data.zonecode;
				document.getElementById("partner_address").value = addr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("partner_detailaddress").focus();
				
				const part_postcode = $("input#partner_postcode").val().trim();
				console.log("part_postcodes : "+part_postcode);
			   	const part_address = $("input#partner_address").val().trim();
			   	const partner_detailaddress = $("input#partner_detailaddress").val().trim();
			  
			   	if(part_postcode == "" || part_address == "" || partner_detailaddress == "") { 
			        alert("우편번호 및 주소를 입력하셔야 합니다.");
			        return false;
			  	}
			}
		}).open();
		
		$("input#partner_postcode").attr("readonly",true);
		$("input#partner_address").attr("readonly",true);
		$("input#partner_extraaddress").attr("readonly",true);
			
	}// end of function comDaumPostcode()-----------------------------	
	
		
	
	// Function Declaration (정보 등록)
	function partnerRegister(){
		
		let partComReg = true;
		
		const partComReg_list = document.querySelectorAll("");
		for(let i=0; i<partComReg_list.length; i++){
			const val=partComReg_list[i].value.trim();
			
			if(val == ""){
				alert("* 은 필수입력사항입니다.");
				partComReg = false;
				
				break;
			
			}
		} // end of for()-----------------------------------------
			
		if(!partnerNo_chk){	// "사업자등록번호 중복 확인"을 클릭하지 않았을 경우
			alert("사업자등록번호 중복확인을 클릭하셔야 합니다.");
			return;
		}
	}			
	
	function resetFrm(){
		$('#partRegisterForm')[0].reset();
		$('#fileInput').val('');
		$('#previewImg').attr('src','');
		$('span.error').hide();
		$('.clientWrap :input').prop('disabled', true);
		
	}
	
	
	
	
	
	
</script>

<div id="register_com" style="padding-right:10%;">
	<form id="partRegisterForm" name="" action="" method="Post" enctype="multipart/form-data" class="clientWrap">
		<input type="hidden" name="is_modify" id="is_modify" value="${isModify}">
		<div class="clientHeader">
			<%-- <button style="background-image: url(<%=ctxPath%>/resources/images/common/arrow-left-solid.svg)"  onclick="goToPrevPage()">
			</button> --%>
			<c:if test="${!isModify}"><h3>거래처등록하기</h3></c:if>
			<c:if test="${isModify}"><h3>거래처수정하기</h3></c:if>
		</div>
		<div class="clientRegister">
			<div class="rgs-profile">
				<div class="imgbox" style="width: 230px; height: 200px;">
					<c:if test="${!isModify}"><img id="previewImg" style="width: 100%; height: 100%;" /></c:if>
					<c:if test="${isModify}"><img src="<%= ctxPath%>/resources/files/company/${partvo.imgfilename}" id="previewImg" style="width: 100%; height: 100%;" /></c:if>
				</div>
				<br>
				<input type="file" name="attach" id="fileInput" value="fileInput" accept="image/*" />
				<span id="showPhoto" style="font-style:italic; font-size:12px; color:fff;">대표사진을 등록하세요&nbsp;<span class="star">*</span></span>
				<br> 
				<span class="error">대표사진은 필수 입력사항입니다.</span>
			</div>
			<div class="rgs-body">
				<div class="rgs-forms">
					<div class="rgs-left">
						<label> 
							<span>거래처명&nbsp;<span class="star">*</span></span> 
							<input type="text" name="partner_name" id="partner_name" value="${partvo.partner_name}" placeholder="거래처명을 입력하세요.">
							<span class="error">거래처명은 필수 입력사항입니다.</span>
						</label> 
						<label> 
							<span>거래처업종&nbsp;<span class="star">*</span></span> 
							<input type="text" name="partner_type" id="partner_type" value="${partvo.partner_type}" placeholder="거래처업종을 입력하세요.">
							<span class="error">거래처업종은 필수 입력사항입니다.</span>
						</label> 
						<div class="chk_businum">
						<label> 
							<span>사업자등록번호&nbsp;<span class="star">*</span></span> 
							<div style="display:flex;">
								<input type="text" <c:if test="${isModify}">readonly="readonly"</c:if> name="partner_no" id="partner_no" value="${partvo.partner_no}" class="" placeholder="사업자등록번호를 입력하세요."/>
								<%-- <c:if test="${isModify}" readonly /> --%>
								<c:if test="${not isModify}"><input type="button" id="partnerNo_chk" onclick="" value="중복확인"/></c:if>
								<span id="partNoChkResult"></span>
							</div>
							<span id="empty" class="error">사업자등록번호는 필수 입력사항입니다.</span> 
							<span id="format" class="error">사업자등록번호형식이 잘못되었습니다.</span>
						</label>
						</div> 
						<label> 
							<span>웹사이트&nbsp;<span class="star">*</span></span> 
							<input type="text" name="partner_url" id="partner_url" value="${partvo.partner_url}" placeholder="사이트주소를 입력하세요.">
							<span id="url_empty" class="error">거래처 웹사이트는 필수 입력사항입니다.</span>
							<span id="url_format" class="error">웹사이트 형식이 잘못되었습니다.</span>
						</label>
					</div>
					<div class="rgs-right">
						<div class="partnameflex">
							<label class="partnameinfo"> 
								<span>담당자명&nbsp;<span class="star">*</span></span>
								<input type="text" name="part_emp_name" id="part_emp_name" value="${partvo.part_emp_name}" placeholder="담당자명을 입력하세요.">
								<span class="error">담당자명은 필수 입력사항입니다.</span>
							</label> 
							<label class="partnameinfo"> 
								<span>담당자직급&nbsp;<span class="star">*</span></span>
								<input type="text" name="part_emp_rank" id="part_emp_rank" value="${partvo.part_emp_rank}" placeholder="담당자직급을 입력하세요.">
								<span class="error">담당자직급은 필수 입력사항입니다.</span>
							</label> 
						</div>
						
						<label> 
							<span>담당자부서</span> 
							<input type="text" name="part_emp_dept" value="${partvo.part_emp_dept}" placeholder="담당자부서를 입력하세요.">
						</label> 
						<label> 
							<span>담당자전화번호</span> 
							<input type="text" name="part_emp_tel" value="${partvo.part_emp_tel}" placeholder="담당자연락처를 입력하세요">
						</label> 
						<label>
							<span>담당자이메일&nbsp;<span class="star">*</span></span>
							<input type="text" name="part_emp_email" id="part_emp_email" value="${partvo.part_emp_email}" placeholder="담당자이메일을 입력하세요.">
							<span id="email_empty" class="error">담당자 이메일은 필수 입력사항입니다.</span>
							<span id="email_format" class="error">이메일 형식이 잘못되었습니다.</span>
						</label>
					</div>
				</div>
				<div class="rgs-address">
					<label>
						<span>주소&nbsp;<span class="star">*</span></span>
						
						<span>						
							<input type="text" name="partner_postcode" id="partner_postcode" value="${partvo.partner_postcode}" placeholder="우편번호">
							<input type="button" id="comAddr_chk" onclick="comDaumPostcode()" value="우편번호 찾기"> 
							<span class="error">거래처주소는 필수 입력사항입니다.</span>
						</span>
					</label>
					<input class="addfield" type="text" name="partner_address" id="partner_address" value="${partvo.partner_address}" placeholder="주소"> 
					<input class="addfield" type="text" name="partner_detailaddress" id="partner_detailaddress" value="${partvo.partner_detailaddress}" placeholder="상세주소"> 
					<input class="addfield" type="text" name="partner_extraaddress" id="partner_extraaddress" value="${partvo.partner_extraaddress}" placeholder="참고항목">
				</div>
			</div>
		</div>
		<div class="clientConfirm">
			<input type="reset" id="resetButton" value="취소">
			
						
			<c:if test="${!isModify}"><input type="button" onclick="_onSubmit()" value="등록"/></c:if>
			<c:if test="${(sessionScope.loginuser).fk_job_code eq '1'}">
				<c:if test="${isModify}">
					<input type="button" onclick="_onModify()" value="수정"/>
				</c:if>
			</c:if>
		</div>
	</form>
	<!--//들고가야함  -->
</div>