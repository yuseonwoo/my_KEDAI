<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경하기</title>
<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<style type="text/css">
	.form-group input {
		width: 400px;
		height: 60px;
		padding: 0 10px;
		outline: none;
		border: 1px solid #2c4459;
		box-sizing: border-box;
		color: #363636;
	}
	.pwdUpdate_btn {
		width: 100%;
		height: 60px;
		font-size: 18px;
		border: none;
		background: #2c4459;
		color: #fff;
		cursor: pointer;
	}
	.pwdUpdate_btn:hover {
		background: #e68c0e;
	}
	a {
		text-decoration: none;
		color: #363636;
	}
	a:hover {
		font-weight: bold;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("button#btnSubmit").click(function(){
			
			const pwd = $("input:password[name='pwd']").val();
			const new_pwd = $("input:password[name='new_pwd']").val();
			
			if(pwd != new_pwd){
				alert("비밀번호가 일치하지 않습니다.");
				$("input:password[name='pwd']").val("");
				$("input:password[name='new_pwd']").val("");
				return;
			}
			else{
				const regExp_pwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
		        // 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
				const bool = regExp_pwd.test(pwd);
		        
		        if(!bool){
		        	alert("비밀번호는 영문자,숫자,특수기호가 혼합된 8~15 글자로 입력하세요.");
		        	$("input:password[name='pwd']").val("");
					$("input:password[name='new_pwd']").val("");
					return;
		        }
		        else{
		        	const frm = document.pwdUpdateEndFrm;
		        	frm.action = "<%= ctxPath%>/login/pwdUpdateEnd.kedai"; 
	           		frm.method = "post";
	           		frm.submit();
		        }
		        
			}
			
		}); // end of $("button#btnSubmit").click(function(){}) ----------
		
	}); // end of $(document).ready(function(){}) ----------
</script>	
</head>
<body>
	<c:if test="${requestScope.method == 'GET'}">
		<div style="margin: 4% auto; text-align: center;">
			<div style="width: 400px; margin: 0 auto; margin-bottom: 3%;">
				<img alt="logo" src="<%= ctxPath%>/resources/images/common/logo_ver4.png" width="100%" class="img-fluid" />
			</div>
			
			<form name="pwdUpdateEndFrm" style="width: 400px; margin: 0 auto;">
	        	<div style="text-align: left;"><i class="fa-regular fa-circle-check"></i>&nbsp;&nbsp;비밀번호 변경하기</div>
		  		<br>
	        	<div class="form-row">    
	            	<div class="form-group" style="margin-bottom: 3%;">
	               		<input type="password" class="form-control" name="pwd" id="pwd" value="" placeholder="새로운 비밀번호" />
	               	</div>
	   
	            	<div class="form-group" style="margin-bottom: 3%;">
	               		<input type="password" class="form-control" name="new_pwd" id="new_pwd" value="" placeholder="새로운 비밀번호 확인" /> 
	            	</div>
	            	
	            	<input type="hidden" name="empid" value="${requestScope.empid}" />
	         	</div>
	         </form>
	         
	         <div style="width: 400px; margin: 0 auto;">
	         	<button type="button" class="pwdUpdate_btn" id="btnSubmit">비밀번호 변경하기</button>
	         </div>        
		</div>
	</c:if>
</body>
</html>