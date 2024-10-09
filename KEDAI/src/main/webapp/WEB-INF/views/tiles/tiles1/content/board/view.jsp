<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
	.orgfileName {
		color: #363636;
		text-decoration: none; 
	}
	.orgfileName:hover {
		color: #e68c0e;
	}
	.subject div {
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.moveColor {
		color: #e68c0e;
		cursor: pointer;
	}
	.list_btn:hover {
		color: #e68c0e;
	}
	.view_btn {
		border: solid 1px #2c4459;
		color: #2c4459;
		font-size: 12pt;
		width: 120px;
		height: 40px;
	}
	.view_btn:hover {
		border: none;
		background: #e68c0e;
		color: #fff;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("span.move").hover(function(e){
			$(e.target).addClass("moveColor");
		}, 
		function(e){
			$(e.target).removeClass("moveColor");
		});
		
	}); // end of $(document).ready(function(){}) ----------
	
	function goView(board_seq){
		
		const goBackURL = "${requestScope.goBackURL}";
		const frm = document.goViewFrm;
		
		frm.board_seq.value = board_seq;
		frm.goBackURL.value = goBackURL;
		
		if(${not empty requestScope.paraMap}) { // paraMap 에 넘겨준 값이 존재하는 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		
		// "get" 방식에서 & 는 전송될 데이터의 구분자로 사용되기 때문에 "post" 방식으로 보내줘야 한다.
		frm.method = "post";
		frm.action = "<%= ctxPath%>/board/view_2.kedai";
		frm.submit();
		
	} // end of function goView(board_seq) ----------
</script>

<%-- content start --%>
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<c:if test="${requestScope.bvo.fk_category_code == 1}">
		<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 사내공지 ]&nbsp;&nbsp;${requestScope.bvo.subject}</h3>
	</c:if>
	<c:if test="${requestScope.bvo.fk_category_code == 2}">
		<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 팝업일정 ]&nbsp;&nbsp;${requestScope.bvo.subject}</h3>
	</c:if>
	<c:if test="${requestScope.bvo.fk_category_code == 3}">
		<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 식단표 ]&nbsp;&nbsp;${requestScope.bvo.subject}</h3>
	</c:if>
	
	<c:if test="${not empty requestScope.bvo}">
		<div class="row mt-5">
			<div class="col-4" style="position: relative;">
				<table class="table table-bordered">
					<tr>
						<th style="width: 30%;">글번호</th>
						<td>${requestScope.bvo.board_seq}</td>
					</tr>
					<tr>
						<th style="width: 30%;">작성자</th>
						<td>${requestScope.bvo.name}</td>
					</tr>
					<tr>
						<th style="width: 30%;">조회수</th>
						<td>${requestScope.bvo.read_count}</td>
					</tr>
					<tr>
						<th style="width: 30%;">작성일자</th>
						<td>${requestScope.bvo.registerday}</td>
					</tr>
					<tr>
						<th style="width: 30%;">첨부파일</th>
						<td><a href="<%= ctxPath%>/board/download.kedai?board_seq=${requestScope.bvo.board_seq}" class="orgfileName">${requestScope.bvo.orgfilename}</a></td>
					</tr>
				</table>
				
				<div class="mt-5 subject">
					<div><i class="fa-solid fa-play"></i>&nbsp;&nbsp;이전글제목&nbsp;&nbsp;:&nbsp;&nbsp;<span class="move" onclick="goView('${requestScope.bvo.previousseq}')">${requestScope.bvo.previoussubject}</span></div>
					<br>
					<div><i class="fa-solid fa-play"></i>&nbsp;&nbsp;다음글제목&nbsp;&nbsp;:&nbsp;&nbsp;<span class="move" onclick="goView('${requestScope.bvo.nextseq}')">${requestScope.bvo.nextsubject}</span></div>
					<br>
					<button type="button" class="btn mr-3 pl-0 pr-0 list_btn" onclick="javascript:location.href='<%= ctxPath%>/board/list.kedai'">[ 전체목록보기 ]</button>
					<button type="button" class="btn mr-3 pl-0 pr-0 list_btn" onclick="javascript:location.href='<%= ctxPath%>${requestScope.goBackURL}'">[ 검색된결과목록보기 ]</button>
				</div>
			
				<div style="position: absolute; bottom: 0;">
					<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.empid == requestScope.bvo.fk_empid}">
						<button type="button" class="btn mr-3 view_btn" onclick="javascript:location.href='<%= ctxPath%>/board/edit.kedai?board_seq=${requestScope.bvo.board_seq}'">수정</button>
						<button type="button" class="btn mr-3 view_btn" onclick="javascript:location.href='<%= ctxPath%>/board/del.kedai?board_seq=${requestScope.bvo.board_seq}'">삭제</button>
					</c:if>
					
					<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.fk_job_code <= 7}"> <!-- 사원을 제외한 모든 직급 -->
						<button type="button" class="btn mr-3 view_btn" onclick="javascript:location.href='<%= ctxPath%>/board/add.kedai?subject=${requestScope.bvo.subject}&groupno=${requestScope.bvo.groupno}&fk_seq=${requestScope.bvo.board_seq}&depthno=${requestScope.bvo.depthno}'">답변글쓰기</button>
					</c:if>
				</div>
			</div>

			<div class="col-8">
				<div style="overflow: hidden; overflow-y: scroll; word-break: break-all; border: 1px solid #2c4459; padding: 3%; height: 680px;">${requestScope.bvo.content}</div>
			</div>
		</div>
	</c:if>
	
	<c:if test="${empty requestScope.bvo}">
		<div style="padding: 20px 0; font-size: 16pt; color: #2c4459;">존재하지 않는 글입니다.</div> 
	</c:if>
</div>

<%-- 이전글제목, 다음글제목 보기 --%>
<form name="goViewFrm">
	<input type="hidden" name="board_seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form> 
<%-- content end --%>