<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String ctxPath = request.getContextPath();
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  

<meta charset="UTF-8">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<style type="text/css">

a{
	color:#fff;
}
div.col-md-6 {
	padding-left:0;
	padding-right:40px;
}


.nav-tabs .nav-link.active {
    background-color: #2c4459; /* 활성화된 탭의 배경색 변경 */
    color: white; /* 활성화된 탭의 글자색 변경 */
    border-bottom-color: transparent; /* 활성화된 탭의 하단 선 제거 */
}
.nav-tabs .nav-item {
    text-align: center;
}

.app_total_contatiner{
	width:95%;  
	margin-right: auto; 
	margin-left:0;
	margin-top:0;
}

.table-hover tr {
	cursor: pointer;
}

button.reg {
	transition: color 0.2s; /* 부드러운 색상 전환 효과 */
}

button.reg:hover{
	color: #e68c0e;
	font-weight: bold;
}

.signImgModalBody {
	text-align: center; /* 내부 요소들을 가운데 정렬 */
}
        
</style>


<script type="text/javascript">
	$(document).ready(function(){
		/*
		$("table#memberTbl tr.memberInfo").click( e => {
			
		};*/
		
		$(document).on("change", "input.img_file", function(e){
			const input_file = $(e.target).get(0);
		
			const fileReader = new FileReader();
			fileReader.readAsDataURL(input_file.files[0]); 
			
			fileReader.onload = function(){
				document.getElementById("previewImg").src = fileReader.result;
			};
			
		}); // end of $(document).on("change", "input.img_file", function(e){}) ----------
		
	});
	
	function newDoc(){
		const frm = document.docTypeFrm;
		
		let docRadio = document.querySelectorAll(`input[name='doctype_code']`); 
		let isCheck = false; // 라디오의 선택 유무 검사용 
/* 		?docType=dayoffDoc */
	<%--	location.href=`<%= ctxPath%>/approval/newdoc.kedai?docType=\${docType}`; --%>
		for(let i=0; i < docRadio.length; i++){
			if(docRadio[i].checked) {
				isCheck = true; 
				break;
			}  
		}// end of for------------------ 
		if(isCheck == false){
			alert("양식을 선택해주세요.");
		    return; // 더 이상의 코드 실행 방지
		}
		
		frm.action = "<%= ctxPath%>/approval/newdoc.kedai";  
			// form 태그에 action 이 명기되지 않았으면 현재보이는 URL 경로로 submit 되어진다.
		//  frm.method = "get"; // form 태그에 method 를 명기하지 않으면 "get" 방식이다.
		frm.submit();
	}// end of function newDoc()------------------
	

	function goView(doc_no, fk_doctype_code){
		<%--location.href=`<%= ctxPath%>/view.action?seq=\${seq}&goBackURL=\${goBackURL}`;--%>
		<%-- 또는 location.href=`<%= ctxPath%>/view.action?seq=+seq`; --%>

		const goBackURL = "${requestScope.goBackURL}"; <%-- 문자열 : 쌍따옴표--%>
		// goBackURL = "/list.action?searchType=subject&searchWord=정화&currentShowPageNo=3"
		// &은 종결자. 그래서 			/list.action?searchType=subject 까지밖에 못 받아온다.

		<%--	
		아래처럼 get 방식으로 보내면 안된다. 왜냐하면 get방식에서 &는 전송될 데이터의 구분자로 사용되기 때문이다.
		location.href=`<%= ctxPath%>/view.action?seq=\${seq}&goBackURL=\${goBackURL}`;
		--%>

		<%-- 그러므로 &를 글자 그대로 인식하는 post 방식으로 보내야 한다.	아래에 #132에 표기된 form태그를 먼저 만든다.	--%>

		const frm = document.forms["goViewFrm"];
		frm.doc_no.value = doc_no;
		frm.fk_doctype_code.value = fk_doctype_code;

		frm.method = "post";
		frm.action = "<%= ctxPath%>/approval/viewOneDoc.kedai";
		frm.submit();

	}//end of goView(doc_no, fk_doctype_code)---------------------------
	
	// 서명 이미지 등록하기
	function imgReg(){
		
		
		var fileInput = document.getElementById('fileInput');
		if (fileInput.files.length === 0) {
		    alert('파일을 선택해 주세요.');
		    return;
		}
		
		var formData = new FormData();
		formData.append("attach", fileInput.files[0]);
		
	    $.ajax({
	        url: '<%= ctxPath%>/approval/singImfRegisterJSON.kedai', // 요청을 보낼 URL
	        type: 'POST', // HTTP 메서드
	        data: formData, // 서버로 보낼 데이터
	        processData: false, // jQuery가 데이터를 처리하지 않도록 설정
	        contentType: false, // jQuery가 콘텐츠 타입을 설정하지 않도록 설정
	        success: function(json) {
	            // 서버로부터의 성공적인 응답 처리
	            if (json.result == 1) {
	            	location.href="<%= ctxPath%>/approval/singImgEnd.kedai"; 
	            } else {
	                alert('이미지 업로드에 실패했습니다.');
	            }
	        },
	        error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
	    });
	}
	
</script>


<div style="border : 0px red solid;  padding: 2% 0; display:flex;">
<c:if test="${(sessionScope.loginuser).fk_dept_code != null}">
	<ul class="nav nav-tabs" style="margin-bottom:0;">
	    <li class="nav-item">
	        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/teamDocList.kedai">팀 문서함</a>
	    </li>
	    <li class="nav-item">
			<a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/nowApprovalList.kedai">결재 예정 문서</a>
		</li>
	    <li class="nav-item">
	        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/showMyApprovalList.kedai">나의 결재함</a>
	    </li>
	    <li class="nav-item">
	        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/showMyDocList.kedai">나의 상신 문서</a>
	    </li>
	</ul>
</c:if>
	
<!-- Navigation Tabs -->

<c:if test="${(sessionScope.loginuser).fk_dept_code == null}">
<ul class="nav nav-tabs" style="margin-bottom:0;">	
	<li class="nav-item">
      	<a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/nowApprovalList.kedai">결재 예정 문서</a>
  	</li>
	<li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/showMyApprovalList.kedai">나의 결재함</a>
    </li>
     <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/approval/allDocList.kedai">모든 문서함</a>
    </li>
</ul>
</c:if>

<c:if test="${(sessionScope.loginuser).fk_dept_code != null}">

<button class = "reg" type="button" data-toggle="modal" style="width: 150px; height:40px; margin-left: 35%; background-color:white; border : solid 1px black;" data-target="#newDocModal" >결재 작성하기</button>

</c:if>

<button class = "reg" type="button" data-toggle="modal" style="width: 150px; height:40px; margin-left: 1%;background-color:white; border : solid 1px black;" data-target="#signImgReg" >서명 등록하기</button>


</div>
	<!-- Modal -->
	<!-- Modal 구성 요소는 현재 페이지 상단에 표시되는 대화 상자/팝업 창입니다. -->
	<div class="modal fade" id="newDocModal">
		<div class="modal-dialog modal-dialog-centered">
	  	<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. -->
	    	<div class="modal-content">
	      
	      	<!-- Modal header -->
	      		<div class="modal-header">
	        		<h5 class="modal-title">결재 양식 선택</h5>
	        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	      		</div>
	      
	      	<!-- Modal body -->
	      		<form name="docTypeFrm">
		      		<div class="modal-body">
		      		<!--  라디오 버튼과 연결된 라벨(label)을 클릭했을 때 라디오 버튼이 체크되도록 하려면, 라벨의 for 속성과 라디오 버튼의 id 속성을 일치하게 해야 한다. -->
		      			<input type="radio" name="doctype_code" value="100" id="newdayoff" />
		      			<label for="newdayoff" style="margin-left: 1.5%;">휴가신청서</label> 
		      			<br>
		      			<input type="radio" name="doctype_code" value="101" id="newmeeting"/>
		      			<label for="newmeeting" style="margin-left: 1.5%;">회의록</label>
		      		</div>
		      
		      	<!-- Modal footer -->
		      		<div class="modal-footer">
		        		<button type="button" onclick="newDoc()" style="background-color:white; color:black; width:10%; height:30px; font-size:10pt; border: solid 1px gray; ">확인</button>
		        		<button type="button" style="background-color:white; color:black; width:10%; height:30px; font-size:10pt; border : solid 1px gray;" data-dismiss="modal">취소</button>
		      		</div>
	      		</form>
	    	</div>
	    	
	  	</div>
	</div>
	
	
		<!-- Modal -->
	<!-- Modal 구성 요소는 현재 페이지 상단에 표시되는 대화 상자/팝업 창입니다. -->
	<div class="modal fade" id="signImgReg">
		<div class="modal-dialog modal-dialog-centered">
	  	<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. -->
	    	<div class="modal-content">
	      
	      	<!-- Modal header -->
	      		<div class="modal-header">
	        		<h5 class="modal-title">서명 이미지 등록하기</h5>
	        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	      		</div>
	      
	      	<!-- Modal body -->
	      		<form name="singImgRegForm" enctype="multipart/form-data" >
		      		<div class="modal-body signImgModalBody">
		      		<!--  라디오 버튼과 연결된 라벨(label)을 클릭했을 때 라디오 버튼이 체크되도록 하려면, 라벨의 for 속성과 라디오 버튼의 id 속성을 일치하게 해야 한다. -->
		      			<div style="width: 200px; height: 230px; overflow: hidden; border: 1px solid #ddd; margin:auto; text-align : center;">
							<img id="previewImg" style="width: 100%; height: 100%;" />
						</div>
						<br>
	   					<input type="file" name="attach" class="infoData img_file" accept='image/*' />
		      		</div>
		      
		      	<!-- Modal footer -->
		      		<div class="modal-footer">
		        		<button type="button" onclick="imgReg()" style="background-color:white; color:black; width:10%; height:30px; font-size:10pt; border: solid 1px gray; ">확인</button>
		        		<button type="button" style="background-color:white; color:black; width:10%; height:30px; font-size:10pt; border : solid 1px gray;" data-dismiss="modal">취소</button>
		      		</div>
	      		</form>
	    	</div>
	    	
	  	</div>
	</div>

<div class="container-fluid app_total_contatiner">
	<div class="row">
<%-- <div id="11" class="col-md-4">	
 <h5 style="margin: 1.5% 1%; border : solid 0px red;">전자결재 홈</h5>
 <hr>
 <div style="height:100px;"><p style="padding:auto;">결재할 문서가 없습니다.<p>
 <hr>
 </div> --%>
 
 		<c:choose>
    		<c:when test="${sessionScope.loginuser.fk_job_code == '1'}">
        		<div id="leftDocList" class="col-md-12">
    		</c:when>
    		<c:otherwise>
        		<div id="leftDocList" class="col-md-6">
    	</c:otherwise>
		</c:choose>
			<div class="document_inProgress">
      			<div  style="display:flex; align-items: center;">
      				<span style="margin: 6px; font-size: 15pt;"> 결재할 문서 </span>
      		<%-- 	<span style="margin-left:auto; align-self: flex-end; padding: 1% 2%;" onclick="javascript:location.href='<%=request.getContextPath() %>/approval/nowApprovalList.kedai'">더보기</span>--%>	
      			</div>
      			<table class="table table-hover">
      				<thead>
        				<tr>
				            <th scope="col" style="width:15%">기안일</th>
				            <th scope="col" style="width:15%">유형</th>
				            <th scope="col" style="width:20%">서류번호</th>
				            <th scope="col" style="width:50%">제목</th>
				            
        				</tr>
      				</thead>
      				<tbody>
      					<c:if test="${not empty requestScope.nowApproval}">
      						<c:forEach var="nowApproval" items="${requestScope.nowApproval}" varStatus="status">
      							<c:if test="${status.index <= 9}"> <!-- 10개까지만 보이도록 설정 -->
	      							<tr onclick="goView('${nowApproval.doc_no}', '${nowApproval.doctype_code}')">
	      								<td>${nowApproval.created_date}</td>
	      								<td>${nowApproval.doctype_name}</td>
	      								<td>${nowApproval.doc_no}</td>
	      								<td>${nowApproval.doc_subject}
	      									<c:if test="${nowApproval.isAttachment eq 1}">
	      										&nbsp;<i class="fa-solid fa-paperclip"></i>
	      									</c:if>  								
	      								</td>
	      							<%-- 	<c:if test="${empty pre_status}">
	      									<td><span style="border : solid 0px green; background-color:gray; color:white; margin-top:10%;">미결재</span></td>
	      								</c:if>
	      								<c:if test="${not empty pre_status}">
	      									<td><span style="border : solid 0px green; background-color:#e68c0e; color:white; margin-top:10%;">결재중</span></td>
	      								</c:if>
	      								--%>
	      							</tr>
	      						</c:if>
      						</c:forEach>
      					</c:if>
      					<c:if test="${empty requestScope.nowApproval}">
      						<tr>
      							<td colspan="4" align="center"> 결재할 문서가 없습니다. </td>
      						</tr>
      					</c:if>
			        	<%-- 
			               <td>2024-01-01</td>
			               <td>증명서신청(회사)</td>
			               <td>김땡땡 사장님</td>
			               <td><span style="border : solid 0px green; background-color:green; color:white; margin-top:10%;">결재중</span></td>
			        	</tr>
			          	<tr>
			            	<td>2024-01-01</td>
			               	<td>증명서신청(회사)</td>
			               	<td>김땡땡 사장님</td>
			               	<td><span style="border : solid 0px green; background-color:green; color:white; margin-top:10%;">결재중</span></td>
			          	</tr>	--%>	
      				</tbody>
      			</table>
    		</div>
  		</div>
  		<c:if test="${sessionScope.loginuser.fk_job_code != '1'}">
   		<div id="33" class="col-md-6">	
     		<div class="document_approved">
      			<div  style="display:flex; align-items: center;">
      				<span style="margin: 1.5% 1%; font-size: 15pt;"> 기안 진행 문서 </span>
      		<%--	<span style="margin-left:auto; align-self: flex-end; padding: 1% 2%;" onclick="javascript:location.href='<%=request.getContextPath() %>/approval/showMyDocList.kedai'">더보기</span> --%>
      			</div>
      			<table class="table table-hover">
        			<thead>
          				<tr>
				            <th scope="col" style="width:15%">기안일</th>
				            <th scope="col" style="width:15%">유형</th>
				            <th scope="col" style="width:20%">서류번호</th>
				            <th scope="col" style="width:50%">제목</th>
						</tr>
        			</thead>
        			<tbody>
        				<c:if test="${not empty requestScope.myDocList}">
      						<c:forEach var="myDocList" items="${requestScope.myDocList}" varStatus="status">
      							<c:if test="${status.index <= 9}"> <!-- 10개까지만 보이도록 설정 -->
	      							<tr onclick="goView('${myDocList.doc_no}', '${myDocList.fk_doctype_code}')">
	      								<td>${myDocList.created_date}</td>
	      								<td>${myDocList.doctype_name}</td>
	      								<td>${myDocList.doc_no}</td>
	      								<td>${myDocList.doc_subject}
	      									<c:if test="${myDocList.isAttachment eq 1}">
	      										&nbsp;<i class="fa-solid fa-paperclip"></i>
	      									</c:if>  								
	      								</td>
	      							<%-- 	<c:if test="${empty pre_status}">
	      									<td><span style="background-color:gray; color:white; margin-top:10%;">미결재</span></td>
	      								</c:if>
	      								<c:if test="${not empty pre_status}">
	      									<td><span style="background-color:#e68c0e; color:white; margin-top:10%;">결재중</span></td>
	      								</c:if>--%>
	      							</tr>
	      						</c:if>
      						</c:forEach>
      					</c:if>
      					<c:if test="${empty requestScope.myDocList}">
      						<tr>
      							<td colspan="4" align="center"> 진행중인 기안 문서가 없습니다. </td>
      						</tr>
      					</c:if>
        			</tbody>
      			</table>
    		</div>
    	</div>
    	
    	</c:if>
	</div>
</div>
<form name="goViewFrm">
	<input type="hidden" name="doc_no" />
    <input type="hidden" name="fk_doctype_code" />
</form>   