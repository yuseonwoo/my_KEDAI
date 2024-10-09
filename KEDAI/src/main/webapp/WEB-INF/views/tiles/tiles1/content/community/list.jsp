<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
	.subject div {
		height: 30px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.add_btn {
		text-align: center;
		align-content: center;
		border: solid 1px #2c4459;
		background: none;
		color: #2c4459;
		font-size: 12pt;
		width: 120px;
		height: 40px;
		margin-left: 10px;
	}
	.add_btn:hover {
		text-decoration: none;
		border: none;
		background: #e68c0e;
		color: #fff;
	}
	table#boardTbl tr.boardList:hover {
      	cursor: pointer;
   	}
   	.search_btn {
		width: 60px;
		height: 30px;
		font-size: 16px;
		border: none;
		background: #2c4459;
		color: #fff;
		cursor: pointer;
	}
	.search_btn:hover {
		background: #e68c0e;
	}
	.subject:hover {
		cursor: pointer;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("input:text[name='searchWord']").bind("keydown", function(e){
			if(e.keyCode == 13){
				goSearch();
			}
		});
		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}){ // paraMap 에 넘겨준 값이 존재하는 경우에만 검색조건 및 검색어 값을 유지한다.
			$("select[name='searchType']").val("${requestScope.paraMap.searchType}");
			$("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
		}
	
		// 검색어 입력 시 자동글 완성하기 
		$("div#displayList").hide();
		
		$("input[name='searchWord']").keydown(function(){
			const wordLength = $(this).val().trim().length;
			
			if(wordLength == 0){
				$("div#displayList").hide();
			}
			else{
				if($("select[name='searchType']").val() == "subject" ||
				   $("select[name='searchType']").val() == "name"){
					
					$.ajax({
						url: "<%= ctxPath%>/community/wordSearchShow.kedai",
						type: "get",
						data: {"searchType":$("select[name='searchType']").val(),
							   "searchWord":$("input[name='searchWord']").val()},
						dataType: "json",
						success: function(json){
						//	console.log(JSON.stringify(json));
							
							if(json.length > 0){
								let v_html = ``;
								
								$.each(json, function(index, item){
									const word = item.word;
									const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
									const len = $("input[name='searchWord']").val().length;
									const result = word.substring(0, idx)+"<sapn style='color: #2c4459; font-weight: bold;'>"+word.substring(idx, idx+len)+"</span>"+word.substring(idx+len);
									
									v_html += `<span style='cursor: pointer;' class='result'>\${result}</span><br>`; 
								}); // end of $.each(json, function(index, item) ----------
								
								// 검색어 input 태그의 width 값 알아오기
								const input_width = $("input:text[name='searchWord']").css("width"); 

								// 검색결과 div의 width 크기를 검색어 입력 input 태그의 width와 일치시키기
								$("div#displayList").css({"width": input_width});
								
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
		}); // end of $("input[name='searchWord']").keyup(function(){}) ----------
		
		$(document).on("click", "span.result", function(e){
			const word = $(e.target).text();
			
			$("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력
			$("div#displayList").hide();
			goSearch();
		});
		
	}); // end of $(document).ready(function(){}) ----------
	
	function goSearch(){
		
		const frm = document.searchFrm;
		
		frm.method = "get";
		frm.action = "<%= ctxPath%>/community/list.kedai";
		frm.submit();
		
	} // end of function goSearch(){} ----------
	
	function goView(community_seq){
		
		const goBackURL = "${requestScope.goBackURL}";
		const frm = document.goViewFrm;
		
		frm.community_seq.value = community_seq;
		frm.goBackURL.value = goBackURL;
		
		if(${not empty requestScope.paraMap}) { // paraMap 에 넘겨준 값이 존재하는 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		
		// "get" 방식에서 & 는 전송될 데이터의 구분자로 사용되기 때문에 "post" 방식으로 보내줘야 한다.
		frm.method = "post";
		frm.action = "<%= ctxPath%>/community/view.kedai";
		frm.submit();
		
	} // end of function goView(board_seq){} ----------
</script>

<%-- content start --%>
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;커뮤니티</h3>

	<section>
		<div class="d-md-flex justify-content-md-end">
			<form name="searchFrm" style="min-width: 576px; position: relative;">
		   		<select name="searchType" style="height: 30px;">
		      		<option value="subject">글제목</option>
		      		<option value="content">글내용</option>
		      		<option value="subject_content">글제목+글내용</option>
		      		<option value="name">작성자</option>
		   		</select>
		   		
		   		<input type="text" name="searchWord" size="40" autocomplete="off" style="height: 30px;" /> 
		   		<input type="text" style="display: none;" /> 
		   		<button type="button" class="search_btn" onclick="goSearch()">검색</button>
		   		
		   		<div id="displayList" style="position: absolute; left: 0; border: solid 1px gray; border-top: 0px; height: 100px; margin-left: 24.0%; margin-top: 1px; background: #fff; overflow: hidden; overflow-y: scroll;">
				</div>
			</form>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%= ctxPath%>/community/add.kedai" class="btn add_btn">등록하기</a>
		</div>
		
		<table class="table table-bordered mt-3" id="communityTbl">
			<thead>
	       		<tr>
	       			<th style="width: 10%; text-align: center;">순번</th>
	         		<th style="width: 60%; text-align: center;" colspan="3">글제목</th>
	         		<th style="width: 20%; text-align: center;">작성일자</th>
	         		<th style="width: 10%; text-align: center;">조회수</th>
	       		</tr>
	   		</thead>
		
			<tbody>
				<c:if test="${not empty requestScope.communityList}">
					<c:forEach var="cvo" items="${requestScope.communityList}" varStatus="status">
						<tr>
							<td align="center" style="vertical-align: middle;">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
							<%-- 
		      					>>> 페이징 처리시 보여주는 순번 공식 <<<
		      					데이터개수-(페이지번호-1)*1페이지당보여줄개수-인덱스번호 => 순번
		      				--%>
		      				<td align="center" style="vertical-align: middle; align-items: center; width: 10%;"><span style="display: inline-block; width: 60px; height: 60px; border-radius: 50%; overflow: hidden;"><img style="width: 100%; height: 100%;" src="<%= ctxPath%>/resources/files/employees/${cvo.imgfilename}" /></span><span style="display: block;">${cvo.nickname}</span></td>
		      				<td style="vertical-align: middle; width: 45%;">
		      					<%-- === 댓글쓰기 및 파일첨부가 있는 게시판 시작 === --%>
		      					<%-- 첨부파일이 없는 경우 --%>
		      					<c:if test="${empty cvo.fk_community_seq}">
		      						<c:if test="${cvo.comment_count > 0}">
		      							<div class="subject" onclick="goView('${cvo.community_seq}')">[ ${cvo.category_name} ]&nbsp;&nbsp;${cvo.subject}&nbsp;&nbsp;<span style="color: #e68c0e; font-size: 12pt; font-weight: bold;"><i class="fa-regular fa-comment-dots fa-flip-horizontal" style="color: #e68c0e;"></i>&nbsp;${cvo.comment_count}</span>
		      								<br><br><div><span class="content">${cvo.content}</span></div>
		      							</div>
		      						</c:if>
		      						<c:if test="${cvo.comment_count == 0}">
		      							<div class="subject" onclick="goView('${cvo.community_seq}')">[ ${cvo.category_name} ]&nbsp;&nbsp;${cvo.subject}
		      								<br><br><div><span class="content">${cvo.content}</span></div>
		      							</div>
		      						</c:if>
		      					</c:if>
		      					
		      					<%-- 첨부파일이 있는 경우 --%>
		      					<c:if test="${not empty cvo.fk_community_seq}">
		      						<c:if test="${cvo.comment_count > 0}">
		      							<div class="subject" onclick="goView('${cvo.community_seq}')">[ ${cvo.category_name} ]&nbsp;&nbsp;${cvo.subject}&nbsp;&nbsp;<i class="fa-solid fa-paperclip"></i>&nbsp;&nbsp;<span style="color: #e68c0e; font-size: 12pt; font-weight: bold;"><i class="fa-regular fa-comment-dots fa-flip-horizontal" style="color: #e68c0e;"></i>&nbsp;${cvo.comment_count}</span>
		      								<br><br><div><span class="content">${cvo.content}</span></div>
		      							</div>
		      						</c:if>
		      						<c:if test="${cvo.comment_count == 0}">
		      							<div class="subject" onclick="goView('${cvo.community_seq}')">[ ${cvo.category_name} ]&nbsp;&nbsp;${cvo.subject}&nbsp;&nbsp;<i class="fa-solid fa-paperclip"></i>
	      									<br><br><div><span class="content">${cvo.content}</span></div>
		      							</div>
		      						</c:if>
		      					</c:if>
		      				</td>
		      				<td align="center" style="vertical-align: middle; width: 5%;"><img alt="heart" src="<%= ctxPath%>/resources/images/common/heart.png" width="50%" class="heart" /><span id="like_cnt" style="display: block;">${cvo.like_count}</span></td>
		      				<td align="center" style="vertical-align: middle;">${cvo.registerday}</td>
		      				<td align="center" style="vertical-align: middle;">${cvo.read_count}</td>
						</tr>
					</c:forEach>
				</c:if>
				
				<c:if test="${empty requestScope.communityList}">
					<tr class="communityList">
	      				<td colspan="6">커뮤니티에 데이터가 존재하지 않습니다.</td>
	      			</tr>
				</c:if>
			</tbody>
		</table>
		
		<div align="center" style="border: solid 0px gray; width: 50%; margin: 2% auto;">
			${requestScope.pageBar}
		</div>
	</section>
</div>

<%-- 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해 현재 페이지 주소를 뷰단으로 넘겨준다. --%>
<form name="goViewFrm">
	<input type="hidden" name="community_seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form> 
<%-- content end --%>