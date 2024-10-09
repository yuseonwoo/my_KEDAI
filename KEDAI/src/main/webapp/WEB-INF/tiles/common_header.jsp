<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String ctxPath = request.getContextPath();
	//	   /KEDA
	
	// ==== #221. (웹채팅관련3) ==== 
    // 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) 
	InetAddress inet = InetAddress.getLocalHost();
 	// String serverIP = inet.getHostAddress();
 	String serverIP = "3.34.186.198";				// 아마존에 있는  ec2 ip
 	// System.out.println("serverIP : " + serverIP);
 	// serverIP : 192.168.0.210
 	
 	// 서버 포트번호 알아오기
 	int portnumber = request.getServerPort();
	// System.out.println("portnumber : " + portnumber);
 	// portnumber : 9099
 	
 	String serverName = "http://"+serverIP+":"+portnumber;
 	// System.out.println("serverName : " + serverName);
 	// serverName : http://192.168.0.210:9099
%>
<style type="text/css">
	.form-control:active, 
	.form-control:focus { 
		border: none; 
		box-shadow: none; 
		text-transform: none !important;
	}
	input::-ms-clear,
	input::-ms-reveal {
		display: none;
		width: 0;
		height: 0;
	}
	input::-webkit-search-decoration,
	input::-webkit-search-cancel-button,
	input::-webkit-search-results-button,
	input::-webkit-search-results-decoration {
		display: none;
	}
	.search_input {
		position: relative;
		border: none;
	 	border-radius: 25px;
	 	padding: 2% 0% 2% 8%;
	}
	.search_input:focus {
		outline: none;
	}
	.btn:active, .btn:focus { 
		border: none; 
		box-shadow: none; 
	}
	/* tooltip */
	.tooltipbottom {
  		position: relative;
	}
	.tooltiptext {
  		width: 80px;
  		background-color: #e68c0e;
  		font-size: 10pt;
  		color: #fff;
  		text-align: center;
  		border-radius: 5px;
  		padding: 5px 0;
  		position: absolute;
  		z-index: 1;
  		bottom: -70%;
  		left: 65%;
 	 	margin-left: -50px;
  		opacity: 0;
  		transition: opacity 0.3s;
	}
	.tooltiptext::after {
  		content: "";
  		position: absolute;
  		top: -28%;
  		left: 50%;
  		margin-left: -5px;
  		border-width: 5px;
  		border-style: solid;
  		border-color: transparent transparent #e68c0e transparent;
	}
	.tooltipbottom:hover .tooltiptext {
  		opacity: 1;
	}
	.autocomplete-items {
		position: absolute;
	  	width: 105%;
	  	border: 1px solid #e68c0e;
	  	border-bottom: none;
	  	border-top: none;
	  	z-index: 999;
	  	top: 105%;
	  	left: 0;
	  	right: 0;
	}
	.autocomplete-items div {
		padding: 10px;
	  	cursor: pointer;
	  	background-color: #fff;
	}
	.autocomplete-items div:hover {
	 	color: #e68c0e;
		text-decoration: underline; 
	}
	.autocomplete-active {
		color: #e68c0e !important;
		text-decoration: underline;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){

		$("button.word_search_btn").click(function(){
			goMenuFind();
		});
		
		$("input:text[name='searchMenu']").bind("keyup", function(e){
			if(e.keyCode == 13){
				goMenuFind();
			}
		});
		
	}); // end of $(document).ready(function(){}) ----------
	
	function goMenuFind(){
		
		const searchMenu = $("input:text[name='searchMenu']").val().trim();

		if(searchMenu == ""){
			alert("검색어를 입력하세요.");
			return;
		}
		
		const frm = document.menuFindFrm;
        frm.action = "<%= ctxPath%>/index/menuFind.kedai";
        frm.method = "get";
   	  	frm.submit();
		
	} // end of function goFind() ----------
</script>

<%-- header start --%>
<div class="container-fluid">
	<nav class="row navbar navbar-expand-lg pl-3 pr-3 pt-0 pb-0">
		<a class="col-md-6 navbar-brand" href="<%= ctxPath%>/index.kedai"><img alt="logo" src="<%= ctxPath%>/resources/images/common/logo_ver2.png" width="25%" /></a>
		<div class="col-md-6 d-md-flex justify-content-md-end" id="navbarSupportedContent" style="display: flex;">
			<form class="form-inline ml-auto my-2 mr-3 my-lg-0" style="position: relative;" autocomplete="off" name="menuFindFrm">
	      		<input class="mr-sm-2 mb-0 search_input autocomplete" id="myInput" type="text" placeholder="Search" name="searchMenu">
	      		<button class="btn my-2 my-sm-0 word_search_btn" type="submit" style="position: absolute; right: -5%;"><img alt="btn_search" src="<%= ctxPath%>/resources/images/common/btn_search.png" width="80%" /></button>
	    	</form>
	    	&nbsp;&nbsp;&nbsp;
	    	<ul class="navbar-nav" style="display: contents;">
		    	<li class="nav-item tooltipbottom">
		        	<span class="tooltiptext">로그아웃</span>
		        	<a class="nav-link" href="<%= ctxPath%>/logout.kedai" style="text-align: center;"><img alt="login" src="<%= ctxPath%>/resources/images/common/login.png" width="60%" /></a>
		      	</li>
		      	<li class="nav-item tooltipbottom">
		      		<span class="tooltiptext">알림</span>
		        	<a class="nav-link" href="#" style="text-align: center;"><img alt="alarm" src="<%= ctxPath%>/resources/images/common/alarm.png" width="60%" /></a>
		      	</li>
		      	<li class="nav-item tooltipbottom">
		      		<span class="tooltiptext">웹채팅</span>
		        	<a class="nav-link" href="<%= serverName%><%= ctxPath%>/chatting/multichat.kedai" style="text-align: center;"><img alt="alarm" src="<%= ctxPath%>/resources/images/common/chat.png" width="60%" /></a>
		      	</li>
		    </ul>
		</div>
	</nav>
</div>

<script type="text/javascript">
	function autocomplete(inp, arr) {
			var currentFocus;
	
			inp.addEventListener("input", function(e) {
	  		var a, b, i, val = this.value;
	  
	  		closeAllLists();
	  		if (!val) { return false;}
	  		currentFocus = -1;
	  
	  		a = document.createElement("DIV");
	  		a.setAttribute("id", this.id + "autocomplete-list");
	  		a.setAttribute("class", "autocomplete-items");
	  	
	  		this.parentNode.appendChild(a);
	 
	  		for (i = 0; i < arr.length; i++) {
	    		if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
	      			b = document.createElement("DIV");
	      			b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
	   				b.innerHTML += arr[i].substr(val.length);
	      			b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
	      			b.addEventListener("click", function(e) {
	          			inp.value = this.getElementsByTagName("input")[0].value;
	          			closeAllLists();
	      			});
	      			a.appendChild(b);
	    		}
	  		}
			});
	
			inp.addEventListener("keydown", function(e) {
	  		var x = document.getElementById(this.id + "autocomplete-list");
	  		if (x) x = x.getElementsByTagName("div");
	  		if (e.keyCode == 40) { // key down
				currentFocus++;
	    		addActive(x);
	  		} 
	  		else if (e.keyCode == 38) { // key up
	    		currentFocus--;
	    		addActive(x);
	  		} 
	  		else if (e.keyCode == 13) { // enter
	    		e.preventDefault();
	    		if (currentFocus > -1) {
	      			if (x) x[currentFocus].click();
	    		}
	  		}
			});
			
			function addActive(x) {
			if (!x) return false;
		    removeActive(x);
		    if (currentFocus >= x.length) currentFocus = 0;
		    if (currentFocus < 0) currentFocus = (x.length - 1);
			x[currentFocus].classList.add("autocomplete-active");
			}
			
	  	function removeActive(x) {
	    	for (var i = 0; i < x.length; i++) {
	      		x[i].classList.remove("autocomplete-active");
	   	 	}
	  	}
	  	
			function closeAllLists(elmnt) {
			var x = document.getElementsByClassName("autocomplete-items");
			for (var i = 0; i < x.length; i++) {
	  			if (elmnt != x[i] && elmnt != inp) {
	    			x[i].parentNode.removeChild(x[i]);
	  			}
			}
			}
	
			document.addEventListener("click", function (e) {
	  		closeAllLists(e.target);
			});
	}
	
	var sideMenu = ["전자결재", "급여명세서", "회의실예약", "게시판", "커뮤니티", "카쉐어", "통근버스", "사내연락망", "거래처정보", "일정관리"];
	autocomplete(document.getElementById("myInput"), sideMenu);
</script>
<%-- header end --%>