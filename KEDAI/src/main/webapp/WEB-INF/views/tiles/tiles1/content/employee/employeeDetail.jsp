<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
    
<%
   String ctxPath = request.getContextPath();
%>      
        

<title>직원정보 상세보기(관리자)</title>



<script type="text/javascript">

</script>

<style type="text/css">

body {
    background:white;
    align:center;
}

.form-control:focus {
    box-shadow: none;
    border-color: #BA68C8;
}

.profile-button {
    background: rgb(99, 39, 120);
    box-shadow: none;
    border: none;
    margin-bottom : 3%;
}

.profile-button:hover {
    background: #682773;
}

.profile-button:focus {
    background: #682773;
    box-shadow: none;
}

.profile-button:active {
    background: #682773;
    box-shadow: none;
}

.back:hover {
    color: #682773;
    cursor: pointer;
}

.labels {
    font-size: 11px;
}



.rounded-squre{
	border-radius:10px;
	width:150px;
	height:150px;
	object-fit:cover;
}

.container-border{
	border: 3px solid #e6ccff ;
	border-radius:10px;
	/* width:60% */;
	
}

bigName{
	padding-bottom:20%;
}

perList{
	margin-left:20%;
}

</style>

<script type="text/javascript"></script>



	<div id="bigName" style="border:solid 1px red; padding-left:12%; position:relative;">
    	<h2>직원정보 상세보기</h2>
	</div>
		<div class="container container-border rounded row" style="border:solid 3px #e6ccff; width:100%; padding-bottom:3%;"> 
    	
    	<!-- 사진 들어가는 세로 박스 시작  -->
    	<div class="col-2" style="border:solid 0px red;"> 
            <div class="d-flex flex-column align-items-center text-center p-3 py-5">
	            <div id = "img-container">
	            	<div class="pt-5;">
	            		<img class="rounded-squre" style="border: solid 1px black;" src="<%= ctxPath%>/resources/images/picture.png">
	            	</div>
	            </div>
            </div> 
        </div>
        <!-- 사진 들어가는 세로 박스 끝 -->
        
        <div class="col-5">
        	<div class="col-md-12" >
                <label class="labels">이름</label>
                <input type="text" class="form-control" value="유선우" readonly>
            </div>
            <div class="col-md-12">
                <label class="labels">부서</label>
                <input type="text" class="form-control" value="디자인부" readonly>
            </div> 
            <div class="col-md-12">
                <label class="labels">직위</label>
                <input type="text" class="form-control" value="부장" readonly>
            </div> 
            <div class="col-md-12">
                <label class="labels">Email</label>
                <input type="text" class="form-control" value="qwldnjs@hanmail.net" readonly>
            </div> 
            <div class="col-md-12">
                <label class="labels">회사전화</label>
                <input type="text" class="form-control"  value="000#" readonly>
            </div> 
            <div class="col-md-12">
                <label class="labels">본사주소</label>
                <input type="text" class="form-control"  value="한남동 112-13번지 유엔빌리지" readonly>
            </div>
            <div class="col-md-12">
                <label class="labels">휴대전화</label>
                <input type="text" class="form-control"  value="010-2222-3333" readonly>
            </div>
        </div>
        
        <div class="col-5">
        	<div class="col-md-12">
                <label class="labels">주민번호</label>
                <input type="text" class="form-control"  value="000#" readonly>
            </div> 
           	<div class="col-md-12">
                <label class="labels">상세주소</label>
                <input type="text" class="form-control"  value="000#" readonly>
            </div> 
            <div class="col-md-12">
                <label class="labels">입사일자</label>
                <input type="text" class="form-control"  value="010-2222-3333" readonly>
            </div>
            
            <!-- 버튼 부분__ -->
            <div class="text-center;" style="padding-left:18%; padding-top:50%;">
	            <button class="btn btn-primary profile-button" type="button">수정하기</button>	
	            <button class="btn btn-primary profile-button" type="button">저장하기</button>
	            <button class="btn btn-primary profile-button" type="button">삭제하기</button>
	        </div> 
	        <!-- 버튼 부분 -->
	        
        </div>
    </div>
