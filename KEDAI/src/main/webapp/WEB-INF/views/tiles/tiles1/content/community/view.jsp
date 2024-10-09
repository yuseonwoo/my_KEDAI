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
	.orgfileName a {
		color: #363636;
		text-decoration: none; 
	}
	.orgfileName a:hover {
		color: #e68c0e;
	}
	input {
		padding-left: 1%;
	}
	.subject div {
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
	.moveColor {
		color: #2c4459;
		font-weight: bold;
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
	.add_btn {
		border: solid 1px #2c4459;
		color: #2c4459;
		font-size: 12pt;
		width: 80px;
		height: 40px;
	}
	.add_btn:hover {
		border: none;
		background: #e68c0e;
		color: #fff;
	}
	td.comment {
		text-align: center;
	}
	.btnUpdateComment,
	.btnDeleteComment {
		border: solid 1px #2c4459;
		color: #2c4459;
		font-size: 9pt;
		width: 60px;
		height: 30px;
	}
	.btnUpdateComment:hover,
	.btnDeleteComment:hover {
		border: none;
		background: #e68c0e;
		color: #fff;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
	
		goViewComment(1); // 페이징처리를 한 댓글 읽어오기
		
		$("span.move").hover(function(e){
			$(e.target).addClass("moveColor");
		}, 
		function(e){
			$(e.target).removeClass("moveColor");
		});
		
		// 첨부파일명 조회하기
		$.ajax({
			url: "<%= ctxPath%>/community/getOrgFilenameJSON.kedai",
			data: {"fk_community_seq":"${requestScope.cvo.community_seq}"},
			type: "get",
            dataType: "json",
            success: function(json){
            //	console.log(JSON.stringify(json));
            	
            	if(json.length > 0){
					let v_html = ``;
					
					$.each(json, function(index, item){
						const orgfileName = item.orgfileName;
						
						v_html += `<a href="<%= ctxPath%>/community/download.kedai?fk_community_seq=${requestScope.cvo.community_seq}&orgfilename=\${orgfileName}"><span>\${orgfileName}</span></a>&nbsp;&nbsp;`;
					}); // end of $.each(json, function(index, item) ----------
							
					$("div.orgfileName").html(v_html);
            	}
            },
            error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
					
		// 댓글쓰기(Ajax 로 처리)
		$("input:text[name='content']").bind("keydown", function(e){
			if(e.keyCode == 13){ // enter 인 경우
				goAddWrite();
			}
		});
		
		// 댓글 수정하기(Ajax 로 처리)
		let origin_comment_content = "";
		
		$(document).on("click", "button.btnUpdateComment", function(e){
			const $btn = $(e.target);
			
			if($(e.target).text() == "수정"){
				const $content = $(e.target).parent().parent().children("td:nth-child(2)"); // $content 에서 $ 는 선택자(태그)를 의미한다.
				origin_comment_content = $(e.target).parent().parent().children("td:nth-child(2)").text();
				
				// 댓글 내용을 수정할 수 있도록 input 태그 만들기
				$content.html(`<input id='comment_update' type='text' value='\${origin_comment_content}' size='25' />`); // \ 가 있어야 변수로 인식한다.
			
				$(e.target).text("완료");
				$(e.target).next().next().text("취소"); // $(e.target).next().next() 은 삭제 버튼이다.
			
				$(document).on("keydown", "input#comment_update", function(e){
					if(e.keyCode == 13){ // enter 인 경우
						$btn.click();
					}
				});
			}
			else if($(e.target).text() == "완료"){
				// 수정 후 댓글 내용
				const content = $(e.target).parent().parent().children("td:nth-child(2)").children("input").val();
				
				$.ajax({
					url: "${pageContext.request.contextPath}/community/updateComment.kedai",
					type: "post",
					data: {"comment_seq":$(e.target).next().val(), // 수정해야 할 댓글번호
						   "content":content},
				   	dataType: "json",
					success: function(json){
					//	console.log(JSON.stringify(json));
					
						const currentShowPageNo = $(e.target).parent().parent().find("input.currentShowPageNo").val(); // "수정" 을 클릭한 곳
						goViewComment(currentShowPageNo);
						
						$(e.target).text("수정");
						$(e.target).next().next().text("삭제");
					},
		            error: function(request, status, error){
		            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		            }
				});
			}
		}); 
		
		// 댓글 수정 취소 & 댓글 삭제(Ajax 로 처리)
		$(document).on("click", "button.btnDeleteComment", function(e){
			
			if($(e.target).text() == "취소"){
				const $content = $(e.target).parent().parent().children("td:nth-child(2)");
				$content.html(`\${origin_comment_content}`);
				
				$(e.target).text("삭제");
				$(e.target).prev().prev().text("수정");
				
			}
			else if($(e.target).text() == "삭제"){
				if(confirm("정말로 댓글을 삭제하시겠습니까?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/community/deleteComment.kedai",
						type: "post",
						data: {"comment_seq":$(e.target).prev().val(), // 삭제해야 할 댓글번호
							   "fk_community_seq":${requestScope.cvo.community_seq}}, // 댓글이 삭제되면 commentCount 도 변경되어야 한다.
					   	dataType: "json",
						success: function(json){
						//	console.log(JSON.stringify(json));
							
							alert("댓글이 삭제되었습니다.");
							goViewComment(1); // 페이징처리를 한 댓글 읽어오기 => 삭제 후 무조건 1 페이지로 이동한다.
						},
			            error: function(request, status, error){
			            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			            }
					});
				}
			}
		
		}); 
		
	}); // end of $(document).ready(function(){}) ----------
	
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
		frm.action = "<%= ctxPath%>/community/view_2.kedai";
		frm.submit();
		
	} // end of function goView(community_seq) ----------
	
	function goAddWrite(){
		
		const comment_content = $("input:text[name='content']").val().trim();
		if(comment_content == ""){
			alert("댓글 내용을 입력하세요.");
  			return; 
		}
		
		goAddWrite_noAttach();
		
	} // end of function goAddWrite() ----------
	
	function goAddWrite_noAttach(){
		
		const queryString = $("form[name='addWriteFrm']").serialize();
		// .serialize() => form 태그 내의 모든  name 값을 키값으로 만들어서 보내준다.
		
		$.ajax({
			url: "<%= ctxPath%>/community/addComment.kedai",
			data: queryString, 
			type: "post",
            dataType: "json",
            success: function(json){
            //	console.log(JSON.stringify(json));
            	
            	if(json.n == 0){
            	//	alert(json.name + "님의 포인트는 300점을 초과할 수 없으므로 댓글쓰기가 불가합니다.");
            		alert(json.name + "님의 댓글 등록이 실패했습니다.");
            	}
            	else{
            		goViewComment(1); // 페이징처리를 한 댓글 읽어오기
            	}
            	
            	$("input:text[name='content']").val("");
            },
            error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	
	} // end of function goAddWrite_noAttach() ----------
	
	function goViewComment(currentShowPageNo){
		
		$.ajax({
			url: "<%= ctxPath%>/community/commentList.kedai",
			data: {"fk_community_seq":"${requestScope.cvo.community_seq}",
				   "currentShowPageNo":currentShowPageNo},
			dataType: "json",
			success: function(json){
			//	console.log(JSON.stringify(json));
				
				let v_html = "";
				
				if(json.length > 0){
					$.each(json, function(index, item){
						v_html += "<tr>";
						
						v_html += "<td class='comment'>"+(item.totalCount-(currentShowPageNo-1)*item.sizePerPage-index)+"</td>";
						<%-- 
	                		>>> 페이징 처리시 보여주는 순번 공식 <<<
	    			                    데이터개수 - (페이지번호 - 1) * 1페이지당보여줄개수 - 인덱스번호 => 순번 
    			       	--%>
	    			    v_html += "<td>"+item.content+"</td>";
	    			    v_html += "<td class='comment'>"+item.nickname+"</td>";
            			v_html += "<td class='comment'>"+item.registerday+"</td>";
            			
            			if(${sessionScope.loginuser != null} && "${sessionScope.loginuser.empid}" == item.fk_empid){
            				v_html += "<td class='comment'><button class='btn btnUpdateComment'>수정</button><input type='hidden' value='"+item.comment_seq+"' />&nbsp;<button class='btn btnDeleteComment'>삭제</button><input type='hidden' value='"+currentShowPageNo+"' class='currentShowPageNo' /></td>";
            			}
            			else{
            				v_html += "<td></td>"
            			}
						
						v_html += "</tr>";
						
						
					}); // end of $.each(json, function(index, item){}) ----------
				}
				else{
					v_html += "<tr>";
					v_html += 	"<td colspan='5' class='comment'>댓글이 존재하지 않습니다.</td>";
					v_html += "</tr>";
				}
				
				$("tbody#commentDisplay").html(v_html);
				
				// 페이지바 함수 호출
				if(json.totalCount != undefined && json.sizePerPage != undefined){
					const totalPage = Math.ceil(json[0].totalCount / json[0].sizePerPage);
					// 12 / 5 = 2.4 ==> Math.ceil(2.4) ==> 3
				
					makeCommentPageBar(currentShowPageNo, totalPage);
				}
			},
            error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
		
	} // end of function goViewComment(currentShowPageNo) ----------
	
	function makeCommentPageBar(currentShowPageNo, totalPage){
		
		const blockSize = 5; // blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수
		
		let loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수 => blockSize(5) 까지만 증가
		let pageNo = Math.floor((currentShowPageNo-1)/blockSize)*blockSize+1;
		/*
			currentShowPageNo 가 3페이지인 경우
			((3-1)/5)*5+1 => (2/5)*5+1 => Math.floor(0.4)*5+1 => 0*5+1 => 1
		*/
		
		let pageBar_HTML = "<ul style='list-style: none;'>";
		
		// [처음][이전] 만들기 
		if(pageNo != 1){
			pageBar_HTML += "<li style='display: inline-block; width: 60px; font-size: 12pt;'><a href='javascript:goViewComment(1)' style='color: #363636;'>[처음]</a></li>"; 
			pageBar_HTML += "<li style='display: inline-block; width: 60px; font-size: 12pt;'><a href='javascript:goViewComment("+(pageNo-1)+")' style='color: #363636;'>[이전]</a></li>"; 
		}
		
		while(!(loop > blockSize || pageNo > totalPage)) {
			if(pageNo == currentShowPageNo) {
				pageBar_HTML += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"+pageNo+"</li>";
			}
			else{
				pageBar_HTML += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='javascript:goViewComment("+pageNo+")' style='color: #363636;'>"+pageNo+"</a></li>";
			}
			
			loop++;
        	pageNo++;
		} // end of while() ----------
		
		// [다음][마지막] 만들기
		if(pageNo <= totalPage) {
			pageBar_HTML += "<li style='display: inline-block; width: 60px; font-size: 12pt;'><a href='javascript:goViewComment("+pageNo+")' style='color: #363636;'>[다음]</a></li>"; 
			pageBar_HTML += "<li style='display: inline-block; width: 60px; font-size: 12pt;'><a href='javascript:goViewComment("+totalPage+")' style='color: #363636;'>[마지막]</a></li>"; 
		}
		
		pageBar_HTML += "</ul>";
		
		$("div#pageBar").html(pageBar_HTML);
		
	} // end of function makeCommentPageBar(currentShowPageNo, totalPage) ----------
	
	function golikeAdd(community_seq){
		
		if(${empty sessionScope.loginuser}) {
        	alert("먼저 로그인 후 '좋아요' 를 눌러주세요.");
         	return; 
      	}
		
		const likedIcon = document.querySelector('.icon-liked');
        const notLikedIcon = document.querySelector('.icon-not-liked');
        let isLikeAdd = false;

        if (likedIcon.style.display == 'none') {
            likedIcon.style.display = 'inline'; 
            notLikedIcon.style.display = 'none';
            isLikeAdd = true;
        } else {
            likedIcon.style.display = 'none'; 
            notLikedIcon.style.display = 'inline';
            isLikeAdd = false;
        }
        
        if(isLikeAdd){
        	$.ajax({
    			url: "<%= ctxPath%>/community/likeAdd.kedai",
    			data: {"fk_community_seq":community_seq,
    				   "fk_empid":"${sessionScope.loginuser.empid}"},
    		   	dataType: "json",
    			success: function(json){
    			//	console.log(JSON.stringify(json));
    				
    				alert(json.msg); 
    				
    				if(json.n == 0){
    					likedIcon.style.display = 'none'; 
    		            notLikedIcon.style.display = 'inline';
    				}
    			},
                error: function(request, status, error){
                	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                }
    				
    		});
        }
        else{
        	$.ajax({
    			url: "<%= ctxPath%>/community/likeMinus.kedai",
    			data: {"fk_community_seq":community_seq,
    				   "fk_empid":"${sessionScope.loginuser.empid}"},
    		   	dataType: "json",
    			success: function(json){
    				console.log(JSON.stringify(json));
    				
    				alert(json.msg);
    			},
                error: function(request, status, error){
                	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
                }
    				
    		});
        }
      
	} // end of function golikeAdd(community_seq) ----------
</script>

<%-- content start --%>
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<div class="row">
		<div class="col-6">
			<c:if test="${requestScope.cvo.fk_category_code == 1}">
				<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 동호회 ]&nbsp;&nbsp;${requestScope.cvo.subject}</h3>
			</c:if>
			<c:if test="${requestScope.cvo.fk_category_code == 2}">
				<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 건의함 ]&nbsp;&nbsp;${requestScope.cvo.subject}</h3>
			</c:if>
			<c:if test="${requestScope.cvo.fk_category_code == 3}">
				<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;[ 사내소식 ]&nbsp;&nbsp;${requestScope.cvo.subject}</h3>
			</c:if>
		</div>
		<c:if test="${sessionScope.loginuser.empid != requestScope.cvo.fk_empid}">
			<div class="col-6 d-md-flex justify-content-md-end" data-toggle="tooltip" data-placement="left" title="좋아요 누르기">
				<span class="like_btn" onclick="golikeAdd('${requestScope.cvo.community_seq}')">
					<i class="fa-regular fa-heart fa-2x icon-not-liked" style="cursor: pointer;"></i>
					<i class="fa-solid fa-heart fa-2x icon-liked" style="color: #f43434; display: none; cursor: pointer;"></i>
				</span>
			</div>
		</c:if>
	</div>
	
	<c:if test="${not empty requestScope.cvo}">
		<div class="row mt-5">
			<div class="col-5" style="position: relative;">
				<table class="table table-bordered">
					<tr>
						<th style="width: 20%;">글번호</th>
						<td style="width: 30%;">${requestScope.cvo.community_seq}</td>
						<th style="width: 20%;">작성자</th>
						<td style="width: 30%;">${requestScope.cvo.nickname}</td>
					</tr>
					<tr>
						<th style="width: 20%;">조회수</th>
						<td style="width: 30%;">${requestScope.cvo.read_count}</td>
						<th style="width: 20%;">작성일자</th>
						<td style="width: 30%;">${requestScope.cvo.registerday}</td>
					</tr>
					<tr>
						<th style="width: 20%;">첨부파일</th>
						<c:if test="${empty requestScope.cvo.fk_community_seq}">
							<td colspan="3"></td>
						</c:if>
						<c:if test="${not empty requestScope.cvo.fk_community_seq}">
							<td colspan="3"><div style="height: 50px; overflow-y: scroll;" class="orgfileName"></div></td>
						</c:if>
					</tr>
				</table>
				
				<div class="mt-3 subject">
					<div><i class="fa-solid fa-play"></i>&nbsp;&nbsp;이전글제목&nbsp;&nbsp;:&nbsp;&nbsp;<span class="move" onclick="goView('${requestScope.cvo.previousseq}')">${requestScope.cvo.previoussubject}</span></div>
					<br>
					<div><i class="fa-solid fa-play"></i>&nbsp;&nbsp;다음글제목&nbsp;&nbsp;:&nbsp;&nbsp;<span class="move" onclick="goView('${requestScope.cvo.nextseq}')">${requestScope.cvo.nextsubject}</span></div>
					<br>
					<button type="button" class="btn mr-3 pl-0 pr-0 list_btn" onclick="javascript:location.href='<%= ctxPath%>/community/list.kedai'">[ 전체목록보기 ]</button>
					<button type="button" class="btn mr-3 pl-0 pr-0 list_btn" onclick="javascript:location.href='<%= ctxPath%>${requestScope.goBackURL}'">[ 검색된결과목록보기 ]</button>
				</div>
		
				<div class="mt-3" style="overflow: hidden; overflow-y: scroll; word-break: break-all; border: 1px solid #2c4459; padding: 3%; height: 300px;">${requestScope.cvo.content}</div>
				
				<br><br><br>
				
				<div class="mt-3" style="position: absolute; bottom: 0;">
					<c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.empid == requestScope.cvo.fk_empid}">
						<button type="button" class="btn view_btn mr-3" onclick="javascript:location.href='<%= ctxPath%>/community/edit.kedai?community_seq=${requestScope.cvo.community_seq}'">수정</button>
						<button type="button" class="btn view_btn" onclick="javascript:location.href='<%= ctxPath%>/community/del.kedai?community_seq=${requestScope.cvo.community_seq}'">삭제</button>
					</c:if>
				</div>
			</div>
			
			<div class="col-7">
				<%-- 댓글쓰기 폼 추가 --%>
				<c:if test="${not empty sessionScope.loginuser}">
					<div class="d-md-flex justify-content-between">
						<h3><i class="fa-solid fa-comment-dots"></i>&nbsp;&nbsp;댓글</h3>
						<div>
							<button type="button" class="btn add_btn mr-3" onclick="goAddWrite()">등록</button>
		                	<button type="reset" class="btn add_btn">취소</button>
						</div>
					</div>
					<form name="addWriteFrm" id="addWriteFrm" class="mt-3">
						<table class="table">
							<tr>
		                  		<th style="width: 15%;">작성자</th>
	               				<td>
	               					<input type="hidden" name="fk_empid" value="${sessionScope.loginuser.empid}" readonly />
	               					<input type="hidden" name="name" value="${sessionScope.loginuser.name}" readonly />
	               					<input type="text" name="nickname" value="${sessionScope.loginuser.nickname}" readonly />
	               				</td>
							</tr>
							
							<tr>
								<th style="width: 15%;">내용</th>
								<td>
	                  				<input type="text" name="content" size="90" maxlength="1000" placeholder="댓글을 남겨보세요." style="height: 30px;" />
	                  				<%-- 댓글에 달리는 원게시물 글번호(댓글의 부모글 글번호) --%>
	                  				<input type="hidden" name="fk_community_seq" value="${requestScope.cvo.community_seq}" readonly />
	                  			</td>
							</tr>
						</table>
					</form>
				</c:if>
				
				<%-- 댓글 내용 보여주기 --%>
				<table class="table" style="margin-top: 10%; margin-bottom: 2%;">
	         		<thead>
	         			<tr>
	           			 	<th style="width: 8%;  text-align: center;">순번</th>
	           			 	<th style="width: 30%; text-align: center;">내용</th>
				            <th style="width: 10%; text-align: center;">작성자</th>
				            <th style="width: 20%; text-align: center;">작성일자</th>
				            <th style="width: 15%; text-align: center;">수정/삭제</th>
	         			</tr>
	         		</thead>
	         		<tbody id="commentDisplay"></tbody>
	      		</table>
	      		
	      		<div style="display: flex; margin-bottom: 50px;">
	          		<div id="pageBar" style="margin: auto; text-align: center;"></div>
	       		</div>
			</div>
		</div>
	</c:if>
	
	<c:if test="${empty requestScope.cvo}">
		<div style="padding: 20px 0; font-size: 16pt; color: #2c4459;">존재하지 않는 글입니다.</div> 
	</c:if>
</div>

<%-- 이전글제목, 다음글제목 보기 --%>
<form name="goViewFrm">
	<input type="hidden" name="community_seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form> 
<%-- content end --%>