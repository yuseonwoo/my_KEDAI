<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<% boolean hasComment = false; %>
<style type="text/css">
div#title {
	font-size: 27px;
	margin: 3% 0 1% 0;
}

div#title2 {
	font-size: 20px;
	 font-weight: bold; 
	margin: 0 0 1% 0;
}

table.left_table {
	width: 100%;
	border-bottom-width: 0.5px;
	border-bottom-style: solid;
	border-bottom-color: lightgrey;
}

table.left_table th {
	width: 25%;
	background-color: #EBEBEB;
}

table#title_table td {
	width: 25%;
	padding: 0 0 0 3%;
}

table#title_table th, table#docInfo th, table#docInfo td {
	padding: 0 0 0 3%;
}

table#approval th, table#approval td {
	padding: 0%;
}

table#approval{
	text-align: center;
}

table.left_table input {
	height: 15pt;
}

table.approvalList {
    max-width: 100%; /* 테이블 전체 너비를 설정할 수 있습니다. */
    border-collapse: collapse; /* 테이블 셀의 경계를 병합합니다. */
    max-height: 190px;
}

table.approvalList, .approvalList th, .approvalList td{
    border: 1px solid black; /* 테이블, th, td에 1px 두께의 검은 선을 설정합니다. */
    padding: 8px; /* 셀 안의 여백을 설정할 수 있습니다. */
    text-align: center; /* 셀 안의 텍스트를 가운데 정렬할 수 있습니다. */
}

div#fileList a {
    text-decoration: none; /* 상속된 링크 스타일 */
    color: black; 
}

a.downloadatag:hover {
    color: #e68c0e;/* 또는 원하는 색상으로 변경 */
}

.modal-body{
	height:300px;
}

.bodyInModal{
	display: flex;
	padding: 10px 20px;
}

.imgInfo {
    height: 100px;
    width: 100px;
    padding: 0;
}
.imgInfo > img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    margin-right: 5%;
}
.strInfo {
    flex: 1;
    padding : 0 3%;
}
.strInfo textarea {
    width: 100%;
    height: 100px;
    overflow-y: auto; /* 세로 스크롤 활성화 */
}

</style>

<script type="text/javascript">
$(document).ready(function(){
	
	if (${requestScope.docvo.isAttachment} == 1) {
		goViewApprovalInfo();
	}
	
	
	$(document).on("click", "button.btn_ok_outside", function(){
		$('#commentModal').find('button.btn_reject_Modal').hide();
    	$('button.btn_ok_Modal').show();
    });
	
	$(document).on("click", "button.btn_reject_outside", function(){
    	$('button.btn_ok_Modal').hide();
    	$('button.btn_reject_Modal').show();
    });

	
}); // end of $(document).ready(function())-----------------------------------


function goViewApprovalInfo(){
	
	$.ajax({
		url:"<%= ctxPath%>/approval/docfileListShow.kedai",
		type:"get",
		data:{"doc_no": "${requestScope.docvo.doc_no}"}, 
		dataType:"json",
		success :function(json){
			//console.log(JSON.stringify(json));
			/*
			[{"filename":"Electrolux냉장고_사용설명서_2024071918094832625998492500.pdf","org_filename":"Electrolux냉장고_사용설명서","doc_no":"KD24-101-5","filesize":"791567","file_no":"4"},{"filename":"쉐보레전면_2024071918094832625999624800.jpg","org_filename":"쉐보레전면","doc_no":"KD24-101-5","filesize":"131110","file_no":"5"}]
			또는
			[]
			*/
			
			$("#fileList").text();
			let v_html = ``;
			$.each(json, function(index, item){	
				
				let fileSize = parseInt(item.filesize, 10); // 10은 10진수
	            if (isNaN(fileSize)) {
	                fileSize = 0; // NaN일 경우 기본값으로 0 설정
	            }
	            fileSize = fileSize / 1024 / 1024; // 파일의 크기를 MB로 변환
	            fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1); // 소수점 자리수 설정
				
	            v_html += "<a class='downloadatag' href='<%= ctxPath %>/approval/downloadDocfile.kedai?seq=" + item.file_no + "'>"
               			 + item.org_filename + "(" + fileSize  + "MB)</a>&nbsp;&nbsp;&nbsp;&nbsp;";
			});
			
		//	const input_width = $("input[name='searchWord']").css("width");// 검색어 input태그 width값 알아오기			
		//	$("div#displayList").css({"width":input_width});// 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
			$("#fileList").html(v_html);
		},
		error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
        }
	});// end of $.ajax---------------------
}

function btnOk(doc_no, level_no, fk_doctype_code){
	
	<%--location.href=`<%= ctxPath%>/view.action?seq=\${seq}&goBackURL=\${goBackURL}`;--%>
	<%-- 또는 location.href=`<%= ctxPath%>/view.action?seq=+seq`; --%>
	
	const goBackURL = "${requestScope.goBackURL}" <%-- 문자열 : 쌍따옴표--%>
	// goBackURL = "/list.action?searchType=subject&searchWord=정화&currentShowPageNo=3"
	// &은 종결자. 그래서 			/list.action?searchType=subject 까지밖에 못 받아온다.

<%--	
	아래처럼 get 방식으로 보내면 안된다. 왜냐하면 get방식에서 &는 전송될 데이터의 구분자로 사용되기 때문이다.
	location.href=`<%= ctxPath%>/view.action?seq=\${seq}&goBackURL=\${goBackURL}`;
	--%>
	
<%-- 그러므로 &를 글자 그대로 인식하는 post 방식으로 보내야 한다. 
	아래에 #132에 표기된 form태그를 먼저 만든다.	--%>
	const frm = document.appfrm;
	// hidden 필드에 doc_no 값을 설정
    frm.doc_no.value = doc_no;
	frm.fk_doctype_code.value= fk_doctype_code;
    frm.level_no.value = level_no;
	frm.method = "post";
	frm.action = "<%= ctxPath%>/approval/appOk.kedai";
	frm.submit();
	
	
	alert("결재 완료 되었습니다.");
}

function btnReject(doc_no){
	const frm = document.appfrm;
	// hidden 필드에 doc_no 값을 설정
    frm.doc_no.value = doc_no;
	frm.method = "post";
	frm.action = "<%= ctxPath%>/approval/appReject.kedai";
	frm.submit();
}


/*
function formatFileSize(size) {
    if (size < 1024){
    	return size + ' bytes';
    } 
    else if (size < 1048576){
    	return (size / 1024).toFixed(1) + ' KB';
    }
    else 
    	return (size / 1048576).toFixed(1) + ' MB';
}

*/
</script>



<div id="total_contatiner">
	<c:if test="${requestScope.docvo.fk_doctype_code eq '100'}">
		<c:set var="offvo" value="${requestScope.docvo.dayoffvo}" />
	</c:if>
	<c:if test="${requestScope.docvo.fk_doctype_code eq '101'}">
		<c:set var="mvo" value="${requestScope.docvo.minutesvo}" />
	</c:if>
	<c:set var="avo" value="${requestScope.docvo.approvalvoList}" />
	<c:set var="dvo" value="${requestScope.docvo}" />
	<form name ="appfrm">
	<div style="display: flex;">
		<div id="leftside" class="col-md-4" style="width: 90%; padding: 0;">
			<div id="title">${docvo.doctype_name}</div>
			<table class="table left_table" id="title_table">
				<tr>
					<th>문서번호</th>
					<td>${docvo.doc_no}</td>
					<th>기안일자</th>
					<td>${docvo.created_date}</td>
				</tr>
				<tr>
					<th>기안자</th>
					<td>${docvo.name}</td>
					<th>부서</th>
					<td>${docvo.dept_name}</td>
				</tr>
			</table>
				<table class="table left_table" id="docInfo">
			<c:if test="${requestScope.docvo.fk_doctype_code eq '101'}">
				<tr>
					<th>회의일자</th>
					<td>${mvo.meeting_date}</td>
				</tr>
				<tr>
					<th>회의 주관 부서</th>
					<td>${mvo.host_dept}</td>
				</tr>
				<tr>
					<th>회의 참석자</th>
					<td>${mvo.attendees}</td>
				</tr>
			</c:if>
			<c:if test="${requestScope.docvo.fk_doctype_code eq '100'}">
				<tr>
					<th>날짜</th>
					<td>${offvo.startdate}&nbsp;~&nbsp;${offvo.enddate}</td>
				</tr>
				<tr>
					<th>반차여부</th>
					<td>시작일 ( 
						<c:choose>
							 <c:when test="${offvo.start_half eq 0}">
							 	해당없음
							 </c:when>
							 <c:when test="${offvo.start_half eq 1}">
							 	오전
							 </c:when>
							 <c:when test="${offvo.start_half eq 2}">
							 	오후
							 </c:when>
						</c:choose>
						)<br>종료일(
						<c:choose>
							<c:when test="${offvo.end_half eq 0}">
							 	해당없음
							 </c:when>
							 <c:when test="${offvo.end_half eq 1}">
							 	오전
							 </c:when>
							 <c:when test="${offvo.end_half eq 2}">
							 	오후
							 </c:when>
						</c:choose>)
					</td>
				</tr>
				<input type="hidden" name="offdays" value="${offvo.offdays}" />	
			</c:if>
			</table>
			
			<div id="title2">
				결재라인
			</div>
			
			<c:if test="${not empty avo}">
				<table class="approvalList">
			        <tr>
			            <th rowspan="3" style="width:20px;">승인</th>
			            <c:forEach var="item" items="${avo}">
			            	<th style="height:25px; width:150px;">${item.job_name}</th>
			            </c:forEach>
			        </tr>
			      	<tr>
			      		<c:forEach var="item" items="${avo}">
			      			<td>
			      				<div style="height:100px;">${item.sign_img}</div>
			            		<div style="height:25px;" >${item.name}</div>
			            	</td>
			            </c:forEach>
			        </tr>
			        <tr>
			         	<c:forEach var="item" items="${avo}">
			      			<td style="height:25px;">${item.approval_date}</td>
			            </c:forEach>
			        </tr>
				</table>
			</c:if>
		</div>
		
		
		<div class="col-md-6 right_content" style="margin: 0; width: 100%; height:100vh; overflow-y:auto; overflow-x:hidden;">
			<table style="margin-left: 5%;" class="table" >
				<tr>
					<th style="width: 12%;">제목</th>
					<td style="height:23pt;">${docvo.doc_subject}</td>
				</tr>
	
				<tr>
					<td colspan='2'>${docvo.doc_content}</td>
				</tr>
	    		<tr>
	       			<td width="12%" class="prodInputName">첨부파일</td>
	       			<td><div id="fileList">첨부된 파일이 없습니다.</div></td>
	    		</tr>
			</table>
			
			<div style="text-align: right; margin: 18px 0 18px 0;">
				<c:if test="${isNowApproval == true}">
					<button type="button" class="btn btn-dark btn-sm mr-4 btn_ok_outside" data-toggle="modal" data-target="#commentModal" data-action="approve">
						결재하기
					</button>
					<button type="button" class="btn btn-primary btn-sm btn_reject_outside" data-toggle="modal" data-target="#commentModal" data-action="reject">
						반려하기
					</button>
				</c:if>
			</div>
			
			<div style="padding-left:5%;">
				<div id="title2">결재의견</div>
				<table class="table appCommentList" style="margin: 0; width: 100%;">
				    <c:forEach var="item" items="${avo}">
				    	<c:if test="${not empty item.approval_comment}">
				    		<% hasComment = true; %>
				    		<tr>
				            	<td rowspan="2" style="height: 90px; width:90px; padding:0;">
			            			<img style="width: 100%; height: 100%; border-radius: 50%; margin-top:5%;" src="<%= ctxPath%>/resources/files/employees/${item.imgfilename}" />
			            		</td>
			            		<td style="height: 20px; text-align:left;">${item.name} ${item.job_name}</td>
			            		<td style="text-align:right; padding-right:3%;">${item.approval_date}</td>
			        		</tr>
			        		<tr>
			        			<td style="width: 60%;">${item.approval_comment}</td>
			        			<td></td>
			        		</tr>
			    		</c:if>
			        </c:forEach>
			        <c:if test="${hasComment == false}">
						<tr>
           					<td colspan="3">결재 의견이 없습니다.</td>
       					</tr>
					</c:if>
				</table>
					
			</div>				
		</div>
		<!--  오른쪽 div -->
		
		
			
		<!-- Modal -->
		<!-- Modal 구성 요소는 현재 페이지 상단에 표시되는 대화 상자/팝업 창입니다. -->
		<div class="modal" id="commentModal">
			<div class="modal-dialog modal-dialog-centered modal-lg h-75" >
			<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. .modal-dialog 클래스를 사용하여 <div> 요소에 크기 클래스를 추가합니다.-->
				<div class="modal-content">
					<!-- Modal header -->
					<div class="modal-header">
						<h5 class="modal-title">결재의견</h5>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<!-- Modal body -->
					<div class="modal-body">
						<div class="bodyInModal">
							<div class="imgInfo">
								<img src="<%= ctxPath%>/resources/files/employees/${(sessionScope.loginuser).imgfilename}" />
							</div>
							<div class="strInfo">
								<div style="margin-bottom: 10px;">${(sessionScope.loginuser).name} ${(sessionScope.loginuser).job_name}</div>
								<div><textarea name="approval_comment" placeholder="기안의견을 입력하세요(선택)" rows="3"></textarea></div>
							</div>	
						</div>
					</div>
					
				<!-- Modal footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-danger my_close" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary btn_ok_Modal" style="display:none;" onclick="btnOk('${dvo.doc_no}', '${requestScope.level_no_str}', '${dvo.fk_doctype_code}')">결재하기</button>
                		<button type="button" class="btn btn-primary btn_reject_Modal" style="display:none;"  onclick="btnReject('${dvo.doc_no}')">반려하기</button>
					</div>
				</div>
			</div>
		</div>
		 <input type="hidden" name="doc_no" id="doc_no_field" />
		 <input type="hidden" name="level_no" id="level_no_field" />
		 <input type="hidden" name="fk_doctype_code" id="fk_doctype_code" />	
	
		
	</div>
		</form>
</div>
</body>
</html>