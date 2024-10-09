<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">
th {
	background-color: #e68c0e;
}

.subjectStyle {
	font-weight: bold;
	color: navy;
	cursor: pointer;
}

a {
	text-decoration: none !important;
} /* 페이지바의 a 태그에 밑줄 없애기 */
</style>

<script type="text/javascript">
    $(document).ready(function(){
        $("span.subject").hover(function(e){
            $(e.target).addClass("subjectStyle");
        }, function(e){
            $(e.target).removeClass("subjectStyle");
        });       
        
		$("input:text[name='searchWord']").bind("keydown", function(e){
			if(e.keyCode == 13){
				goSearch();
			}
		});
		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}){ /* paraMap 에 넘겨준 값이 존재하는 경우에만 검색조건 및 검색어 값을 유지한다. */
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
			else {
				if($("select[name='searchType']").val() == "dp_name" ||
				   $("select[name='searchType']").val() == "ds_name" ||
				   $("select[name='searchType']").val() == "share_date" ){
					
					$.ajax({
						url: "<%=ctxPath%>/carShare/searchShow.kedai",
						type: "get",
						data: {"searchType":$("select[name='searchType']").val(),
							   "searchWord":$("input[name='searchWord']").val()},
					   	dataType: "json",	 
					   	success: function(json){
					   		console.log(JSON.stringify(json));
					   	
					   		if(json.length > 0){ // 검색된 데이터가 있는 경우
					   			let v_html = ``;
					   			
					   			$.each(json, function(index, item){
					   				const word = item.word;
					   				const idx = word.toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
					   				const len = $("input[name='searchWord']").val().length;
					   				const result = word.substring(0, idx)+"<span style='color: #2c4459; font-weight: bold;'>"+word.substring(idx, idx+len)+"</span>"+word.substring(idx+len);
					   				
					   				v_html += `<span style='cursor: pointer;' class='result'>\${result}</span><br>`;
					   			}); // end of $.each(json, function(index, item) ----------

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
		}); // end of $("input[name='searchWord']").keyup(function(){}) ----------
		
		$('select[name="searchType"]').change(function() {
            var selected = $(this).val();
            if (selected === 'dp_name' || selected === 'ds_name' || selected === '' ) {
                $('input[name="searchWord"]').show();
                $('input[name="start"]').hide();
            } else if (selected === 'share_date') {
                $('input[name="searchWord"]').hide();
                $('input[name="start"]').show();
            } else {
                $('input[name="searchWord"]').hide();
                $('input[name="start"]').hide();
            }
        }).trigger('change'); // 페이지 로드 시 초기 상태 설정
        
		$(document).on("click", "span.result", function(e){
			const word = $(e.target).text();
			
			$("input[name='searchWord']").val(word); // 텍스트박스에 검색된 결과의 문자열을 입력
			$("div#displayList").hide();
			goSearch(); 
		});
		
		   // === 전체 datepicker 옵션 일괄 설정하기 ===  
		   //     한번의 설정으로 $("input#fromDate"), $('input#toDate')의 옵션을 모두 설정할 수 있다.
		   $(function() {
		       //모든 datepicker에 대한 공통 옵션 설정
		       $.datepicker.setDefaults({
		            dateFormat: 'yy-mm-dd' //Input Display Format 변경
		           ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		           ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
		           ,changeYear: true //콤보박스에서 년 선택 가능
		           ,changeMonth: true //콤보박스에서 월 선택 가능                
		        // ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
		        // ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		        // ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
		        // ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
		           ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
		           ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
		           ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
		           ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
		           ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
		        // ,minDate: "-1M" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		        // ,maxDate: "+1M" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)                    
		       });
		   
		    });
		   
		   ///////////////////////////////////////////////////////////////////////
		   //=== jQuery UI 의 datepicker === //
		   $('input#datepicker_start').datepicker({
		        dateFormat: 'yy-mm-dd'  //Input Display Format 변경
		       ,showOtherMonths: true   //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		       ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
		       ,changeYear: true        //콤보박스에서 년 선택 가능
		       ,changeMonth: true       //콤보박스에서 월 선택 가능                
		   //  ,showOn: "both"          //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
		   //  ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		   //  ,buttonImageOnly: true   //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
		   //  ,buttonText: "선택"       //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
		       ,yearSuffix: "년"         //달력의 년도 부분 뒤에 붙는 텍스트
		       ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
		       ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
		       ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
		       ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
		   //  ,minDate: "-1M" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		   //  ,maxDate: "+1M" //최대 선택일자(+1D:하루후, +1M:한달후, +1Y:일년후)                
		   });
		   
		   
    }); // end of $(document).ready(function(){}) ----------

	function goSearch(){
		
		const frm = document.member_search_frm;
		
		frm.method = "get";
		frm.action = "<%=ctxPath%>/carShare.kedai";
		frm.submit();
		
	} // end of function goSearch(){} ----------
	
	
    function goRegister(){
        location.href=`<%=ctxPath%>/carRegister.kedai`;
    }

    function goApply(formName){
        const frm = document.forms[formName];
        frm.action = "<%=ctxPath%>/carApply_detail.kedai"; 
        frm.method = "post";
        frm.submit();
    }
</script>

<div style="display: flex; width: 100%;">
	<div style="margin: auto; padding: 3%; width: 100%">

		<h2 style="margin-bottom: 30px; border-bottom: 1px solid orange; border-top: 1px solid orange; width: 14%;">CAR SHARING</h2>
		<div class="row">
			<form name="member_search_frm" class="col-10">
				<select name="searchType">
					<option value="">검색대상</option>
					<option value="dp_name">출발지</option>
					<option value="ds_name">도착지</option>
					<option value="share_date">셰어링 날짜</option>
				</select> &nbsp;
				<input type="text" name="searchWord" placeholder="검색어 입력" /> 
				<input type="text" style="display: none;" /> <%-- 조심할 것은 type="hidden" 이 아니다. --%>
				<!--  날짜 선택   -->
				<input type="text" name="start" id="datepicker_start" maxlength="10" value="" style="padding: 5px; height: 22pt;" placeholder="날짜선택" readonly /> &nbsp;
				<button type="button" class="btn btn-secondary" onclick="goSearch()">검색</button>
			</form>
			<div class="col-2 d-md-flex justify-content-md-end">
				<button class="btn btn-secondary btn-sm btnUpdateComment" onclick="goRegister()">등록하기</button>
			</div>
		</div>
		<div id="displayList" style="position: absolute; left: 0; border: solid 1px gray; border-top: 0px; height: 100px; margin-left: 10.8%; margin-top: 1px; background: #fff; overflow: hidden; overflow-y: scroll;">
		</div>

		<table style="width: 100%; margin-top: 1%;" class="table table-bordered">
			<thead>
				<tr>
					<th style="width: 10px; text-align: center;">no</th>
					<th style="width: 175px; text-align: center; border: none;">출발지</th>
					<th style="width: 10px; text-align: center; border: none;"><i class="fa-solid fa-arrow-right"></i></th>
					<th style="width: 175px; text-align: center; border: none;">도착지</th>
					<th style="width: 70px; text-align: center;">차주 닉네임</th>
					<th style="width: 150px; text-align: center;">셰어링 날짜</th>
					<th style="width: 70px; text-align: center;">출발시간</th>
					<th style="width: 70px; text-align: center;">신청가능여부</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${not empty requestScope.carShareList}">
					<c:forEach var="carShare" items="${requestScope.carShareList}"
						varStatus="status">
						<tr>
							<td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
							<form name="carShareFrm${status.index}">
								<input type="hidden" name="res_num" value="${carShare.res_num}" />
							</form>
							<td align="center"
								style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${carShare.dp_name}</td>
							<td align="center"
								style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;"><i
								class="fa-solid fa-arrow-right"></i></td>
							<td align="center"
								style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${carShare.ds_name}</td>
							<td align="center">${carShare.nickname}</td>
							<c:set var="startDate" value="${carShare.start_date}" />
							<c:set var="lastDate" value="${carShare.last_date}" />
							<td align="center">
								<fmt:parseDate value="${startDate}" var="parsedStartDate" pattern="yyyy-MM-dd HH:mm:ss" /> 
								<fmt:formatDate	value="${parsedStartDate}" pattern="yyyy-MM-dd" /> 
								~ 
								<fmt:parseDate value="${lastDate}" var="parsedLastDate" pattern="yyyy-MM-dd HH:mm:ss" /> 
								<fmt:formatDate value="${parsedLastDate}" pattern="yyyy-MM-dd" />
							</td>
							<td align="center">${carShare.start_time}</td>
							<c:if test="${carShare.end_status == 1 && carShare.cancel_status == 1 && (carShare.start_date le requestScope.todayStr && carShare.last_date ge requestScope.todayStr) || carShare.start_date > requestScope.todayStr}">
								<td align="center" style="background-color: #2c4459;">
									<input type="button" style="border: none; background-color: #2c4459; color: white;" value="신청가능" class="subject" onclick="goApply('carShareFrm${status.index}')" />
								</td>
							</c:if>
							<c:if test="${carShare.end_status == 0 || carShare.cancel_status == 0 || !(carShare.start_date le requestScope.todayStr && carShare.last_date ge requestScope.todayStr) && carShare.start_date <= requestScope.todayStr}">
								<td align="center" style="color: #e68c0e;">신청불가능</td>
							</c:if>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty requestScope.carShareList}">
					<tr>
						<td colspan="7">데이터가 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div id="pageBar" align="center" style="border: solid 0px gray; width: 50%; margin: 3% auto;">
			${requestScope.pageBar}
		</div>
	</div>
</div>

<form name="goViewFrm">
	<input type="hidden" name="board_seq" /> 
	<input type="hidden" name="goBackURL" /> 
	<input type="hidden" name="searchType" /> 
	<input type="hidden" name="searchWord" />
</form>
<!--  검색대상이 셰어링 날짜일 경우 textform 이 아닌 datepicker 폼으로 변경하기 -->