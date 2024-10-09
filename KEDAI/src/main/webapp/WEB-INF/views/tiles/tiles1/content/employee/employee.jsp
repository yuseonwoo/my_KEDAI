 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%

   String ctxPath = request.getContextPath();

%>
<%-- 
<script type="text/javascript" src="<%= ctxPath%>/resources/js/employee.js"></script> --%>
<style type="text/css">

*{margin: 0;
 padding: 0;
 box-sizing:border-box;}

.employeeWrap{
	width: 100%;
	display: flex;
	justify-content:center;
	margin-top: 40px;
}
.employeeWrap .address{
	width: 90%;
	margin-left: -80px;
}
.employeeWrap .address .add-header{}
.employeeWrap .address .add-header h2{
	font-size: 20px;
	font-weight: 700;
	line-height: 40px;
}

.employeeWrap .address .search_bar{
	width:100%;
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
}
.employeeWrap .address .search_bar .sch_left{display: flex;}
.employeeWrap .address .search_bar .sch_left select{
	margin-right: 10px;
}
.employeeWrap .address .search_bar .sch_left input{
	height: 40px;
	outline:0;
}
.employeeWrap .address .search_bar .sch_left input[type=button]{
	padding : 0 20px;
}
.employeeWrap .address .search_bar .sch_right{
	display:flex;
	align-items: center;
}
.employeeWrap .address .search_bar .sch_right select{
	height: 40px;
}

.emp_table {
     width: 100%;
     margin-top: 20px;
}

.emp_table th,td {
	text-align:center;
	border-left: solid 1px gray;
	border-bottom: solid 1px gray;
	height: 56px;
	vertical-align: middle;
}
.emp_table th:first-of-type, .emp_table td:first-of-type{
	border-left:0;
}

th{
	background-color:#2c4459;
	color: white;
}

.nameStyle{
	font-weight:bold;
	/*  color:#c180ff;*/
	cursor:pointer;
}

tr:hover{
color:#2c4459;
}

.button {
	background-color: #2c4459;
}

.btn.btn-secondary {
    background-color:#2c4459;
    border-color: #c180ff;;
}
#upbar {
    padding-top: 1rem; 		/* 상단 패딩 */
    padding-bottom: 1%; 	/* 하단 패딩 */
    border: solid 1px red; 	/* 빨간색 실선 테두리 */
    display: flex; 			/* 플렉스 박스 레이아웃 */
    position: relative; 	/* 상대적 위치 지정 */
}

/* .pagenation{
	display:flex;
	justify-content: center;
} */

.pagenation button{}
/* .pagenation ul{
	display: flex;
} */

/* .pagenation ul li{} */

/* 팝업 버튼 요소 시작*/

.tempBtn {
    border: none;
    background-color: #ccc;
    cursor: pointer;
    margin-right: 40%;
}

 .tempBtn:hover img,
 .tempBtn:active img {
      filter: brightness(0.5); /* 이미지 밝기 조정 */
      transform: scale(0.95); /* 크기 축소 */
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); /* 그림자 추가 */
} 
/* 팝업 버튼 요소 끝 */

/* 팝업 내용 요소 시작 */
.popup-overlay-tree{
  
  display: none;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}
.popup-overlay-tree .popup{
	width: 70%;
	outline: 0px solid red;
	padding: 20px 60px;
	border-radius: 20px;
	position: relative;
	background-color: #fff;
}
.popup-overlay-tree .popup .header{
	font-size:22px;
	font-weight: 700;
}
.popup-overlay-tree .popup .section{} 
.popup-overlay-tree .popup .section .img-box{} 
.popup-overlay-tree .popup .section .img-box img{
	width:100%;
} 
.popup-overlay-tree .popup .close-btn img{
    position: flex;
    top: 10px;
    right: 10px;
}
.popup-overlay-tree .popup .close-btn button{
   
   cursor: pointer;
   border: none; 									/* 경계선 없애기 */
   background-color: #2c4459;  
}
.popup-overlay-tree .popup .close-btn button i{
   font-size: 20px;
   color: #fff;
}
.popup-overlay-tree .popup .close-btn img {
    width: 20px; 						/* 원하는 너비로 조정 */
    height: 20px; 					    /* 원하는 높이로 조정 */
    background-color: gray;
    border-radius:50%;
    display:none;
}

.popupHead{}

/* 팝업 내용 요소 끝 */   
   
/* 직원정보 볼 수있는 hover 요소 */
.hover{
	 background-color: #2c4459;  /* 원하는 배경색으로 변경 */

}
.hover td{
	 color: #e68c0e;
	 font-weight:700;
}
 .name-popup {
	position: fixed;
	top: 55%;
	left: 55%;
	transform: translate(-50%, -50%);
	display: none; /* 처음에는 보이지 않도록 설정 */
	background-color: white;
	padding: 20px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
	z-index: 1000; /* 다른 요소 위에 표시되도록 설정 */
	width: 65%;
	height:65%;
	border-radius:1%;
 }

.popup-content{
	display: inline-block;
}

.close-popup{
	position:absolute;
	top:0;
	right:0;
	background-color: gray;
	border:none;
	padding: 5px;
	cursor:pointer;
	border-radius:50%
	
}

.close-popup img{
	width:15px;
	height:15px;
}

.emp_table tr:hover{
	background-color:#2c4459;
	color:#e68c0e;
}

.form-control:focus {
    box-shadow: none;
    border-color: #BA68C8;
}

.profile-button {
    background: rgb(99, 39, 120);
    box-shadow: none;
    border: none;
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
    text-align: center;
   
}

.rounded-squre{
	border-radius:10px;
	width:150px;
	height:150px;
	object-fit:cover;
}

.container-border{
	border: 3px solid #e6ccff;
	border-radius:10px;
	margin-top:20%;
}
	
.popup-overlay-emp{
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0; left: 0;
	background-color: rgba(0,0,0,0.7);
	display:flex;
	justify-content: center;
	align-items: center;
	display: none;
}
.emp-detail.popup{
	width: 70%;
	/* outline: 2px solid red; */
	padding: 20px 60px;
	border-radius: 20px;
	position: relative;
	background-color: #ffffff;
}
.emp-detail .header{
	display: flex;
	justify-content: space-between;
}
.emp-detail .header h2{
	font-size: 24px;
	line-height: 40px;
	
}
.emp-detail .section{
	display: flex;
}
.emp-detail .section .article{}
.emp-detail .section .article.left{
	width: 25%;
	margin-top: 20px;
}
.emp-detail .section .article .img-box{
	width: 70%;
	/* margin: 0 auto; */
	
	background-color: #ccc;
}
.emp-detail .section .article .img-box img{
	width: 100%;
}
.emp-detail .section .article.right{
	width: 75%;
}
.emp-detail .section .article .input-forms{
	display: flex;
	flex-wrap: wrap;
}
.emp-detail .section .article .input-forms label{
	width: 50%;
	padding: 0 10px;
}
.emp-detail .section .article .input-forms label:nth-of-type(2)~label{
	margin-top:10px;
}
.emp-detail .section .article .input-forms label span{}
.emp-detail .section .article .input-forms label input{}
.emp-detail .section .article .input-address {
	padding: 0 10px;
	margin-top:10px;
}
.emp-detail .section .article .input-address label{
	width: 50%;
}
.emp-detail .section .article .input-address label span{
	display: flex;
	padding-right: 10px;
}
.emp-detail .section .article .input-address label input:last-of-type{
	margin-left: 10px
}
.emp-detail .section .article .input-address input{
	margin-top: 10px;
}
.emp-detail .section .article .input-btns{
	display: flex;
	justify-content: center;
	padding: 20px 0;
}
.emp-detail .section .article .input-btns button{}
.emp-detail.popup .close-btn{
	position: absolute;
	top: 20px; right: 20px;
}
.emp-detail.popup .close-btn button{
	width: 40px;
	height: 40px;
	background-color: #000;
	border-radius: 40px;
}
.emp-detail.popup .close-btn button{
	cursor: pointer;
   border: none; 									/* 경계선 없애기 */
   background-color: #2c4459;  
}
.emp-detail.popup .close-btn button i{
	font-size: 20px;
   color: #fff;
}

bigName{
	padding-bottom:20%;
}

.form-control{
	margin: 0 auto;
} 

.header{
	display : flex;
}

#xmark{
	border-radius :50%; 
	width:5%;
}

.pagenation {
	display: flex;
	margin-top: 20px;
}


.pagenation li.paging {
  background-color: #f2f2f2;
  border: none;
  color: #333;
  padding: 8px 16px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 4px 2px;
  cursor: pointer;
}

.paging:hover {
  background-color: #ddd;
  color: #2c4459;
}

.emp_table{
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
}

.emp_table th, .emp_table td {
    border: 1px solid #ddd; /* 테두리 추가 */
   /*  padding: 8px; /* 패딩 추가 */ */
    text-align: center; /* 중앙 정렬 */
    overflow: hidden; /* 내용이 넘칠 경우 숨김 처리 */
    white-space: nowrap; /* 줄 바꿈 방지 */
} 






</style>


<script type="text/javascript">
	
	$(document).ready(function() {

		/* 조직도 팝업 여는 함수 시작 시작 */
		$('.tempBtn').click(function() {
			$('.popup-overlay-tree').css({
				display : 'flex'
			});
		});

		// 팝업 닫기
		$('.close-btn').click(function() {
			$('.popup-overlay-tree').css({
				display : 'none'
			});
		});
		
		/* 조직도 팝업 여는 함수 시작 끝 */
		
		// 클릭 시 팝업
		$('.dept_name, .job_name, .name, .nickname, .dept_tel, .mobile, .email').click(function() {
			$('.popup-overlay-emp').css({
				display : 'flex'
			});
			// console.log('open popup')
		})

		// 닫기 버튼을 클릭하면 팝업 제거
		$('.popup-overlay-emp .close-btn').click(function() {
			$('.popup-overlay-emp').css({
				display : 'none'
			});
		});
	});

	
	$(document).ready(function(){
		$("input:text[name='searchWord']").bind("keydown", function(e){
			if(e.keyCode == 13){
				goSearch();
			}
		});
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}){ // paraMap 에 넘겨준 값이 존재하는 경우에만 검색조건 및 검색어 값을 유지한다.
			$("select[name='searchType']").val("${requestScope.paraMap.searchType}");
			$("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
		}
		
		// 검색어 입력시 자동글 완성하기
		$("div#displayList").hide();
		
		$("input[name='searchWord']").keydown(function(){
			const wordLength = $(this).val().trim().length;
			
			if(wordLength == 0){
				$("div#displayList").hide();
			}
			else{
				if($("select[name='searchType']").val() == "dept_name" ||
				   $("select[name='searchType']").val() == "job_name" ||
				   $("select[name='searchType']").val() == "name" ||
				   $("select[name='searchType']").val() == "nickname" ||
				   $("select[name='searchType']").val() == "mobile"){
					
					$.ajax({
						url: "<%=ctxPath%>/employee/wordSearchShowJSON.kedai",
						type: "get",
						data:{"searchType":$("select[name='searchType']").val(),
							  "searchWord":$("input[name='searchWord']").val()},
					    dataType:"json",
					    success: function(json){
					    	console.log(JSON.stringify(json));
					    	
					    	if(json.length > 0){
					    		let v_html = ``;
					    		
					    		$.each(json, function(index, item){
					    			const word = item.word;
					    			const idx = word. toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
					    			const len = $("input[name='searchWord']").val().length;
					   				const result = word.substring(0, idx)+"<span style='color: #2c4459; font-weight: bold;'>"+word.substring(idx, idx+len)+"</span>"+word.substring(idx+len);
					    		
					   				v_html += `<span style='cursor: pointer;' class='result'>\${result}</span><br>`;
					    		}); // end of $.each(json, function(index, item){}-------------------------------------
					    		
					    		// 검색어 input 태그의 width 값 알아오기
								const input_width = $("input[name='searchWord']").css("width");
					    		
								// 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
								$("div#displayList").css({"width":input_width});
								
								$("div#displayList").html(v_html);
								$("div#displayList").show();
					    	}
					    },
					    error: function(request, status, error){
					    	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					    }
					});
				}
			}
		});	
					
		$(document).on("click", "span.result", function(e){
			const word = $(e.target).text();
			
			$("input[name='searchWord']").val(word);// 텍스트박스에 검색된 결과의 문자열을 입력
			$("div#displayList").hide();
			goSearch();
		})
					
	});
	
	
	// 기본 월급에 세자리 마다 , 붙이기
	function formatNumber(num) {
	
		return parseFloat(num).toLocaleString('ko-KR');
	
	}
	
	// 클릭한 직원 상세정보 불러오는 이벤트
	$(document).on('click','#empInfo', function(e){
		const empid = $(this).find('.empid').text();
		// console.log('empid : ' + empid);	// 성공
		//console.log('aaaaaempid : ' + empid);
		$.ajax({
	 	      url: "<%=ctxPath%>/employeeDetail.kedai?empid=" + empid,
	 	      type:"get",
	 	      async:true,
	 	      dataType:"json",
	 	      data: {
	 	    	  "empid" :empid
	 	      },
	 	      success: function(json){
	 	    	// console.log(JSON.stringify(json)); //성공 [{"dept_code":"200","empid":"2013200-001","detailaddress":"511동","fk_job_code":"3","address":"서울 강서구 강서로 489-4","imgfilename":"20240716235810265812732265200.jpg","mobile":"IkVj3zk7v9KiWyZD1sebOw==","postcode":"07523","dept_name":"영업지원부","orgimgfilename":"김재욱.jpg","fk_dept_code":"200","hire_date":"2013-02-08","salary":"48000000","point":"0","extraaddress":" (가양동)","job_name":"상무","name":"김재욱","nickname":"Daniel","dept_tel":"070-1234-200","job_code":"3","email":"xyQQoXYPG/DaercU8LIgYrS/w1X04jC3f2rkZ5QOuOY="}]
	 	        if(json.length > 0){
	 	      		json.forEach(function(item){
	 	      			$('#empName').val(item.name);
	 	      			$('#empNickName').val(item.nickname);
	 	      			$('#empDepartment').val(item.dept_name);
	 	      			$('#empRank').val(item.job_name);
	 	      			$('#empEmail').val(item.email);
	 	      			$('#empPersonal-Tel').val(item.mobile.substring(0,3) + "-" + item.mobile.substring(3,7) + "-" + item.mobile.substring(7,11));
	 	      			$('#deptTel').val(item.dept_tel);
	 	      			$('#hireDate').val(item.hire_date);
	 	      			$('#salary').val(formatNumber(item.salary) + '원');
	 	      			$('#point').val(item.point);
	 	      			$('#empPostcode').val(item.postcode);
	 	      			$('#empAddress').val(item.address);
	 	      			$('#empDetailAddress').val(item.detailaddress);
	 	      			$('#empExtraAddress').val(item.extraaddress);
	 	      			$("#pop_partnerImg").attr("src", "<%= ctxPath%>/resources/files/employees/" + item.imgfilename);
	 	      			$("#gender").val(item.func_gender);
	 	      			$("#age").val(item.func_age);
	 	      			// console.log("empName : " + item.name);
	 	      		})
	 	        }
	 	        else{
	 	          alert("직원 상세 정보를 불러오지 못했습니다.");
	 	        }
	 	      },
	 	      error: function(request, status, error) {
	 	    	  
	 	      	// alert("11111code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	 	      }
	 	 });
	});
	
	function goSearch() {
		const frm = document.employee_search_frm;
		
		frm.method="get";
		frm.action ="<%=ctxPath%>/employee.kedai";
		frm.submit();
		
	} // end of function goSearch() ------------------------------
	
	
</script>


<div class="employeeWrap">
	<div class="address">
		<div class="add-header">
			<h2>사내연락망</h2>
		</div>
		
		<div class="search_bar">
			<div class="sch_left">
				<form name="employee_search_frm">
					<select name ="searchType">
						<option value="dept_name">부서</option>
						<option value="job_name">직위</option>
						<option value="name">이름</option>
						<option value="nickname">닉네임</option>
						<option value="mobile">휴대폰번호</option>
					</select>
					
					<input type="text" name="searchWord" />
					<input type="text" style="display: none;"/>
					
					<button type="button" onclick="goSearch()" style="border: 1px solid black; margin-left:3px;">검색</button>
				
					<div id="displayList" style="position: absolute; left: 0; border: solid 1px gray; border-top: 0px; height: 100px; margin-left: 10%; background: #fff; overflow: hidden; overflow-y: scroll;">
					</div>
				</form>
			</div>	
	     
		     <button class="tempBtn">
		     		조직도 보기
		     </button>
    	 
			 <!-- 팝업 오버레이 -->
			 <div class="popup-overlay-tree" id="popupOverlay">
			    <!-- 팝업 창 -->
			    <div class="popup">
			    	<div class="header">
			    		<div style="width : 98%"><h2>회사 조직도</h2></div>
			    		<button id="xmark" class="close-btn" style="">
							<i class="fa-solid fa-xmark"></i>
						</button>
			    	</div>
			    	<div class="section">
			    		<div class="img-box">
			    			<img src="<%= ctxPath%>/resources/images/common/ptree.png" alt="">
			    		</div>
			    	</div>
			    </div>
			</div>
			
		</div>
					
			<table class="emp_table" id="empTbl"><!-- id="empInfo" -->
			   <thead>
			       <tr>
			         <!--  <th id ="empid">ID</th> -->
			          <th id ="dept_name" style="width:10%;">부서</th>
			          <th id ="job_name" style="width:5%;">직위</th>
			          <th id="name" style="width:10%;">이름</th>
			          <th id="nickname" style="width:10%;">닉네임</th>
			          <th id="dept-tel" style="width:15%;">내선번호</th>
			          <th id="mobile" style="width:15%;">휴대폰번호</th>
			          <th id="email" style="width:20%;">E-MAIL</th>
			       </tr>
			   </thead>
			   <tbody>
			   <!-- ${requestScope.pagedResult.pageable.pageSize}  -->
			   <c:forEach var="empList" items="${requestScope.employeeList}" varStatus="status">
			 	   <fmt:parseNumber var="currentShowPageNO" value="${requestScope.currentShowPageNO}" />
			 	   <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}" />
			 	   
			 	   
			 	   <tr id="empInfo">
			 	     <td class="empid" hidden>${empList.empid}</td>
			 	   	<%--  <td class="empid type=hidden">${empList.empid}</td> <!-- 이렇게 하면 값까지 아예 날려버림 (empid 이용해서 값가져올 수 없음) --> --%>
			 	   	 <td class="dept_name" style="width:10%;">${empList.dept_name}</td>
		   			 <td class="job_name" style="width:5%;">${empList.job_name}</td>
		   			 <td class="name" style="width:10%;">${empList.name}</td>
		   			 <td class="nickname" style="width:10%;">${empList.nickname}</td>
		  			 <td class="dept_tel" style="width:15%;">${empList.dept_tel}</td>
		  			 <td class="mobile" style="width:15%;">${(empList.mobile).substring(0,3)}-${(empList.mobile).substring(3,7)}-${(empList.mobile).substring(7,11)}</td>
		  			 <td class="email" style="width:20%;">${empList.email}</td>
	  			   </tr>
	  			</c:forEach>   
		   		</tbody>
			</table>
		</div>	
	</div>		
				            
	<div align="center" style="border: solid 0px gray; width: 50%; margin: 2% auto;  height: 100px;">
		${requestScope.pageBar}
	</div>

	<%-- 팝업 클릭시 보이는 직원 상세 테이블 --%>
	<div class="popup-overlay-emp">
		<div class="emp-detail popup">
			<div class="header">
				<h2>직원정보 상세보기</h2>
			</div>
			<div class="section">
				<div class="article left">
					<div class="popupImg" style="width:200px; border: 1px solid red; height:200px; overflow: hidden;">
						<img id="pop_partnerImg" src="" alt="" style="object-fit:cover; width:100%; height:100%;">
					</div>
				</div>
					<div class="article right">
						<div class="input-forms">
							<label> 
								<span>이름</span> 
								<input type="text" class="form-control" id="empName" value="" readonly>
							</label> 
							<label> 
								<span>닉네임</span>
								<input type="text" class="form-control" id="empNickName" value="" readonly>
							</label> 
							<label> 
								<span>부서</span>
								<input type="text" class="form-control" id="empDepartment" value="" readonly>
							</label> 
							<label> 
								<span>직위</span> 
								<input type="text" class="form-control" id="empRank" value="" readonly>
							</label> 
							<label> 
								<span>Email</span> 
								<input type="text" class="form-control" id="empEmail" value="" readonly>
							</label> 
							<label> 
								<span>내선전화</span> 
								<input type="text" class="form-control" id="deptTel" readonly>
							</label>
							<label>
							 	<span>휴대폰번호</span>
							 	<input type="text" class="form-control" id="empPersonal-Tel" readonly>
							</label>
							
						<c:if test="${(sessionScope.loginuser).fk_job_code eq '1'}">
							<label> 
								<span>입사일자</span> 
								<input type="text" class="form-control" id="hireDate" readonly>
							</label>
							<label> 
								<span>성별</span> 
								<input type="text" class="form-control" id="gender" readonly>
							</label>
							<label> 
								<span>나이</span> 
								<input type="text" class="form-control" id="age" readonly>
							</label>
							<label> 
								<span>기본급여</span> 
								<input type="text" class="form-control" id="salary" readonly>
							</label>
							<label> 
								<span>포인트</span> 
								<input type="text" class="form-control" id="point" readonly>
							</label>
							</div>
								<div class="input-address">
									<label>
										<span>주소</span>
										<span>						
											<input type="text" id="empPostcode" placeholder="우편번호" class="form-control" readonly>
											<!-- <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" readonly> -->
										</span>					
									</label>
									<input type="text" id="empAddress" class="form-control" readonly>
									<input type="text" id="empDetailAddress" placeholder="상세주소"class="form-control" readonly>
									<input type="text" id="empExtraAddress" placeholder="참고항목"class="form-control" readonly>
								</div>
						</c:if>
					</div>
				</div>
				<div class="close-btn">
					<button><i class="fa-solid fa-xmark"></i></button>
				</div>
			</div>
		</div>




        





