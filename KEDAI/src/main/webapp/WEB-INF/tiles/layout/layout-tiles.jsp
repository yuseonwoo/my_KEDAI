<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KEDAI</title>
<%-- Required meta tags --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" >

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%= ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 

<%-- Highcharts --%>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.1/code/modules/accessibility.js"></script>

<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<%-- jQuery 에서  ajax로 파일을 업로드 할때 가장 널리 사용하는 방법 : ajaxForm --%> 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery.form.min.js"></script>

<%-- 우편번호 API --%> 
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style type="text/css">		
	* {
		box-sizing: border-box;
	  	margin: 0;
	  	padding: 0;
	}
	body {
		font-family: "Noto Sans KR", sans-serif !important;
		color: #363636;
		overflow-x: hidden;
		overflow-y: hidden;
	}
	li {
	  	list-style: none;
	}
	a {
	  	text-decoration: none;
	  	color: #fff;
	}
	a:hover {
		color: #e68c0e;
	}
	input {
		outline: none;
	}
	button {
		border: none;
		cursor: pointer;
	}
	.clearfix::after {
	 	content: "";
	  	clear: both;
	  	display: block;
	  	line-height: 0;
	}
	#myHeader {
		min-height: 50px;	
		background: #2c4459;
		align-content: center;
	}
	#mySide,
	#myContent {
		min-height: 1200px;			
	}
</style>
</head>
<body>
	<div id="myContainer">
		<div class="pl-0 pr-0" id="myHeader">
			<tiles:insertAttribute name="header" />
		</div>

		<div class="row">
			<div class="col col-2 pr-0 container" id="mySide">
				<tiles:insertAttribute name="side" />
			</div>

			<div class="col col-10 pl-0 pr-0" id="myContent">
				<tiles:insertAttribute name="content" />
			</div>
		</div>
	</div>
</body>
</html>