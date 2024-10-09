<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>
<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css"
	href="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script src="<%=ctxPath%>/resources/jquery-ui/jquery-ui.min.js"></script>
<link rel="stylesheet"
	href="<%=ctxPath%>/resources/jquery-ui/jquery-ui.css">


<style type="text/css">
	div#title {
		font-size: 27px;
		margin: 3% 0 1% 0;
	}

	div#title2 {
		font-size: 25px;
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
	
	table#title_table th, table#meeting th, table#meeting td {
		padding: 0 0 0 3%;
	}
	
	table#approval th, table#approval td {
		padding: 0%;
	}
	
	table#approval{
		text-align: center;
	}
	
	.addApproval {
		text-align: center;
		border-bottom-width: 0.3px;
		border-bottom-style: solid;
		border-bottom-color: lightgrey;
	}
	
</style>

<script type="text/javascript">
	
	
</script>


<div id="total_contatiner">
	<form name="newDocFrm" enctype="multipart/form-data" style="display: flex;">
			<%-- 버튼이 form 태그 안에 있으면 무조건 get방식으로 submit되어진다. 유효성 검사를 하고 post방식으로 submit해주고 싶다면 무조건   type="button" 해야 한다. --%>

	<div id="leftside" class="col-md-4" style="width: 90%; padding: 0;">
		<div id="title">회의록</div>
		<table class="table left_table" id="title_table">
			<tr>
				<th>문서번호</th>
				<td></td>
				<th>기안일자</th>
				<td></td>
			</tr>
			<tr>
				<th>기안자</th>
				<td></td>
				<th>부서</th>
				<td></td>
			</tr>
		</table>
		<table class="table left_table" id="meeting">
			<tr>
				<th>회의일자</th>
				<td></td>
			</tr>
			<tr>
				<th>회의 주관 부서</th>
				<td></td>
			</tr>
			<tr>
				<th>회의 참석자</th>
				<td></td>
			</tr>
		</table>

		<div id="title2">
			결제라인
		</div>



		<table class="table left_table" id="approval">
			<tr style="text-align: center;">
				<th>순서</th>
				<th>소속</th>
				<th>직급</th>
				<th>성명</th>
			</tr>
		</table>
		
		<div class="htmlAdd">
			
		</div>
		
	</div>
	<div class="col-md-6" style="margin: 0; width: 100%">
		
			<table style="margin-left: 5%;" class="table" id="newDoc">
				<tr>
					<th style="width: 12%;">제목</th>
					<td></td>
				</tr>

				<tr>
					<td colspan='2'><div style="width: 100%; height: 500px;"
							id="doc_content"></div></td>
				</tr>
		    	<tr>
		       		<td width="12%" class="prodInputName">첨부한 파일</td>
		       		<td>
				    	<div id="fileDrop" class="fileDrop border border-secondary" style="font-size: 10pt;"><span id="fileInfo">이곳에 파일을 올려주세요.</span></div>
		       		</td>
		    	</tr>

			</table>
			<div style="text-align: right; margin: 18px 0 18px 0;">
			
			</div>
			<input type="hidden" name="fk_doctype_code" value="101"/>
		
		</div>
</form>
	</div>

</body>
</html>