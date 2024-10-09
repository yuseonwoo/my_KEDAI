<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
	input {
		padding-left: 1%;
	}
	.del_btn {
		border: solid 1px #2c4459;
		color: #2c4459;
		font-size: 12pt;
		width: 120px;
		height: 40px;
	}
	.del_btn:hover {
		border: none;
		background: #e68c0e;
		color: #fff;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		// 삭제 버튼을 클릭한 경우
		$("button#btnDel").click(function(){
			
			// 비밀번호 유효성 검사하기
     		const pwd = $("input:password[name='pwd']").val();
     		if(pwd == ""){
     			alert("비밀번호를 입력하세요.");
     			return; // 종료
     		}
     		else{
     			if("${requestScope.bvo.pwd}" != pwd){
     				alert("입력하신 비밀번호가 일치하지 않습니다.");
         			return; // 종료
     			}
     		}
     		
     		if(confirm("정말로 글을 삭제하시겠습니까?")){
     			// 폼(form)을 전송(submit)
         		const frm = document.delFrm;
         		frm.method = "post";
         		frm.action = "<%= ctxPath%>/board/delEnd.kedai";
         		frm.submit();
     		}
     		
		});
		
	}); // end of $(document).ready(function(){}) ----------
</script>

<%-- content start --%>
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<div>
   		<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;글삭제하기</h3>
	</div>

	<form name="delFrm" class="mt-5">
		<div>
			<label for="pwd" style="width: 10%;">비밀번호</label>
			<input type="password" name="pwd" id ="pwd" maxlength="20" />
			<input type="hidden" name="board_seq" value="${requestScope.bvo.board_seq}" />
		</div>
		
		<div class="mt-5">
	   		<button type="button" class="btn del_btn mr-3" id="btnDel">삭제</button>
	       	<button type="button" class="btn del_btn" onclick="javascript:history.back()">취소</button>
	   	</div>
	</form>
</div>
<%-- content end --%>