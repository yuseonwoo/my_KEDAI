<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
   String ctxPath = request.getContextPath();
%>   
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<style type="text/css">
    th {background-color: #e68c0e;}
    .subjectStyle {font-weight: bold; color: navy; cursor: pointer; }
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
.nav-tabs .nav-link.active {
    background-color: #2c4459; /* 활성화된 탭의 배경색 변경 */
    color: white; /* 활성화된 탭의 글자색 변경 */
    border-bottom-color: transparent; /* 활성화된 탭의 하단 선 제거 */
}
.nav-tabs .nav-item {
    flex: 1; /* 각 탭을 균등하게 분배 */
    text-align: center;
}

/* 모달 시작 */
.modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
    height: 80%;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

#calendar {
    height: 100%;
    width: 100%;
}

.fc-daygrid-day-clicked {
    position: relative;
    background-color: #f0f0f0;
}

.select-button {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 10;
    padding: 5px 10px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 3px;
    cursor: pointer;
}
.fc-daygrid-day-number{
   color:#2c4459;
}
/* 모달 끝 */    


</style>

<script type="text/javascript">
    
    $(document).ready(function(){
       
    	/* 날짜 바꾸기 시작 */
    	
        function convertDateFormat(start_date) {
            // 입력된 날짜 문자열을 확인하고 출력
//          console.log("Input Date: ", inputDate);

            // 날짜 문자열을 분리 (2024-07-17 00:00:00)
            const dateTimeParts = start_date.split(' ');
            const dateParts = dateTimeParts[0].split('-');
            const timeParts = dateTimeParts[1].split(':');

            // 연도, 월, 일, 시간, 분, 초 추출
            const year = dateParts[0];
            const month = dateParts[1] - 1; // 월은 0부터 시작
            const day = dateParts[2];
            const hours = timeParts[0];
            const minutes = timeParts[1];
            const seconds = timeParts[2];

            // Date 객체 생성 (년, 월, 일, 시, 분, 초)
            const date = new Date(year, month, day, hours, minutes, seconds);
//          console.log("Date Object: ", date);
//			Date Object:  Wed Jul 17 2024 00:00:00 GMT+0900 (한국 표준시)
            // 날짜 포맷 변경
            const formattedDate = date.toString();

            return date;
        }
	
        function parseDate(str, add) {
            var datePart = str.substring(0, 10);
            // 분리된 날짜에서 하이픈을 제거 (2024-01-01 -> 20240101)
            var formattedDate = datePart.replace(/-/g, '');

            var year = parseInt(formattedDate.substring(0, 4), 10);
            var month = parseInt(formattedDate.substring(4, 6), 10) - 1; // 월은 0부터 시작
            var day = parseInt(formattedDate.substring(6, 8), 10) + add;
            return new Date(year, month, day);
        }
        
        
        $('input[type="button"].subject').on('click', function() {
            
        	// 클릭된 버튼의 부모 <tr> 요소를 찾음
            var $tr = $(this).closest('tr');
            
            // 해당 <tr> 내의 <input> 요소 중 name이 last_date인 요소를 찾음
            var $lastDateInput = $tr.find('input[name="last_date"]');
            var $startDateInput = $tr.find('input[name="start_date"]');
            var $res_num = $tr.find('input[name="res_num"]');
            // last_date 입력 요소의 값을 가져옴
            let startDateValue = $startDateInput.val();
            let lastDateValue = $lastDateInput.val();
            let res_num = $res_num.val();
            // 콘솔에 값 출력 (확인용)
            console.log('start Date:', startDateValue);
            console.log('Last Date:', lastDateValue);
            // 필요시 해당 값을 다른 로직에 사용 가능
            // 예: 모달 창에 날짜 설정 등
        	resetModal(); // Ensure the modal is reset before showing
            modal.show();
      //    calendar.render();
            
            //////////////////////////////////////////////
            func_calendar_call(startDateValue, lastDateValue, res_num);
            /////////////////////////////////////////////
        });
  /*      
     var start_date = $("input:hidden[name='start_date']").val();
     var convertedstart_date = parseDate(start_date, 0);
     var last_date = $("input:hidden[name='last_date']").val();
     var convertedlast_date = parseDate(last_date, 1);
  */ 
  //////////////////////////////////////////////////////////////////////////////////////////////
  
     function func_calendar_call(startDateValue, lastDateValue, res_num){
	        var start_date = startDateValue;
	        var convertedstart_date = parseDate(start_date, 0);
	        var last_date = lastDateValue;
	        var convertedlast_date = parseDate(last_date, 1);
	     
	        alert("시작일자 : " + start_date + ", 종료일자 : " + last_date + ", res_num :" + res_num );
	       /* 모달 시작 */
	        var startDate = convertedstart_date;
	    	var endDate = convertedlast_date;
	       // Initialize the calendar
	        var calendarEl = document.getElementById('calendar');
	        var calendar = new FullCalendar.Calendar(calendarEl, {
	                initialView: 'dayGridMonth',
	                height: '100%',
	                dateClick: function(info) {
	                    // Remove existing select buttons
	                    $('.select-button').remove();
	                    // Remove background color from previously clicked cells
	                    $('.fc-daygrid-day').removeClass('fc-daygrid-day-clicked');
	                    // Add background color to clicked cell
	                    $(info.dayEl).addClass('fc-daygrid-day-clicked');

	                 // 새로운 select 버튼 생성
	                    var button = $('<button type="button" class="select-button" style="background-color: #2c4459;">선택</button>');
	                    // 버튼을 클릭된 셀에 추가
	                    $(info.dayEl).append(button);

	                    // 버튼에 클릭 이벤트 추가
	                    button.click(function() {
	                    //  alert('Date selected: ' + info.dateStr);
	                        $('#myModal').hide(); // 모달 닫기
	                        resetModal(); // 모달 내용 초기화
	                        // dateStr 값을 가지고 새로운 페이지로 이동
	                        goDetail(info.dateStr, res_num);
	                    });

	                },
	                validRange: {
	                    start: startDate, // 가져온 start_date
	                    end: endDate // 가져온 last_date
	                }
	        });
	        
	        calendar.render();
     }// end of func_calendar_call(startDateValue, lastDateValue, res_num)-------------------------
     ///////////////////////////////////////////////////////////////////////////////////////////////

     
	            // Get the modal
	            var modal = $('#myModal');

	            // Get the button that opens the modal
	            var btn = $('#openModalBtn');

	            // Get the <span> element that closes the modal
	            var span = $('.close');

	            // Function to reset the modal content
	             function resetModal() {
	                // Remove existing select buttons
	                $('.select-button').remove();
	                // Remove background color from previously clicked cells
	                $('.fc-daygrid-day').removeClass('fc-daygrid-day-clicked');
	            } 

	/*             // 모달창 키기 id은 status.index로 각각 설정해주고 해당 클래스를 불러온다.
	            $(document).on("click", "input.subject", function(){
	            	var $td = $(this).parent();
	            	alert("~~~ 확인용 : " + $td.find($("input:hidden[name='last_date']").val()));
	            	resetModal(); // Ensure the modal is reset before showing
	                modal.show();
	                calendar.render();
	            }); */

	/*             $('.subject').click(function(e) {
	                
	            	
	            	resetModal(); // Ensure the modal is reset before showing
	                modal.show();
	                calendar.render();
	                
	                
	            }); */
	            
				// When the user clicks on <span> (x), close the modal and reset content
	            span.click(function() {
	                modal.hide();
	                resetModal();
	            });

	            // When the user clicks anywhere outside of the modal, close it and reset content
	            $(window).click(function(event) {
	                if ($(event.target).is(modal)) {
	                    modal.hide();
	                    resetModal();
	                }
	            });

	            // Ensure reset when the modal is hidden
	            modal.on('hide', function() {
	                resetModal();
	            });
	       /* 모달 끝  */

	  //////////////////////////////////////////////////////////////////////////////////////////////
      
     
       
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
      if(${not empty requestScope.paraMap}){ /*  paraMap 에 넘겨준 값이 존재하는 경우에만 검색조건 및 검색어 값을 유지한다. */
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
                  url: "<%= ctxPath%>/carShare/searchShow_owner.kedai",
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
            if (selected == 'dp_name' || selected == 'ds_name' || selected == '' ) {
                $('input[name="searchWord"]').show();
                $('input[name="start"]').hide();
            } else if (selected == 'share_date') {
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

    // select 버튼 클릭시 새로운 페이지로 이동하는 함수
	function goDetail(dateStr, res_num) {
	    const frm = document.date_frm;
	    frm.method = "get";
	    frm.action = "<%= ctxPath %>/owner_Status_detail.kedai";
	    frm.date.value = dateStr; // 폼의 히든 필드에 날짜 값 설정
	    frm.res_num.value = res_num;
	    frm.submit();
	}
    
   function goSearch(){
      
      const frm = document.member_search_frm;
      
      frm.method = "get";
      frm.action = "<%= ctxPath%>/owner_Status.kedai";
      frm.submit();
      
   } // end of function goSearch(){} ----------

</script>

<div style="border: 0px solid red; padding: 2% 0; width: 90%;">
<form name="date_frm" method="get">
    <input type="hidden" name="date" value="">
    <input type="hidden" name="res_num" value="">
    <%-- ${requestScope.day_shareInfo.res_num} --%>
    <!-- 다른 필요한 폼 필드들 -->
</form>

<!-- Navigation Tabs -->
<ul class="nav nav-tabs" style="margin-bottom:4%;">
    <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/myCar.kedai">차량정보</a>
    </li>
    <li class="nav-item">
        <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/owner_Status.kedai">카셰어링현황(차주)</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/owner_Settlement.kedai">카셰어링정산(차주)</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_applyStatus.kedai">카셰어링신청현황(신청자)</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_Settlement.kedai">카셰어링정산(신청자)</a>
    </li>
</ul>
 
<div style="display: flex;  border: solid 0px red; width: 100%;">

    <div style="margin: auto; width: 100%">

        <div class="row">
	        <form name="member_search_frm" class="col-10">
	            <select name="searchType">
	               <option value="">검색대상</option>
	               <option value="dp_name">출발지</option>
	               <option value="ds_name">도착지</option>
	               <option value="share_date">셰어링 날짜</option>
	            </select>
	            &nbsp;
	            <input type="text" name="searchWord" placeholder = "검색어 입력"/>
	            <input type="text" style="display: none;" /> <%-- 조심할 것은 type="hidden" 이 아니다. --%> 
	            <!--  날짜 선택   -->
	            <input type="text" name="start" id="datepicker_start" maxlength="10" value="" style="padding: 5px; height: 22pt;" placeholder = "날짜선택" readonly/>
	            &nbsp;
	            <button type="button" class="btn btn-secondary" onclick="goSearch()">검색</button>
	        </form>
        </div>
        <div id="displayList" style="position: absolute; left: 0; border: solid 1px gray; border-top: 0px; height: 100px; margin-left: 7.8%; margin-top: 1px; background: #fff; overflow: hidden; overflow-y: scroll;">
        </div>
        
        <table style="width: 100%; margin-top: 1%;" class="table table-bordered">
            <thead>
                <tr>
                    <th style="width: 70px; text-align: center;">no</th>
                    <th style="width: 175px; text-align: center; border:none;">출발지</th>
                    <th style="width: 10px; text-align: center; border:none;"><i class="fa-solid fa-arrow-right"></i></th>
                    <th style="width: 175px; text-align: center; border:none;">도착지</th>
                    <th style="width: 200px; text-align: center;">셰어링 날짜</th>
                    <th style="width: 70px; text-align: center;">출발시간</th>
                    <th style="width: 70px; text-align: center;">조회</th>
                </tr>
            </thead>
            <tbody>
                <!-- The Modal -->
                <div id="myModal" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <span style="text-align:center; font-size: 20pt; font-weight:300;">조회하고 싶은 날짜를 선택하세요</span>
                        <div id="calendar"></div>
                    </div>
                </div>
            
                <c:if test="${not empty requestScope.owner_carShareList}">
                    <c:forEach var="owner_carShare" items="${requestScope.owner_carShareList}" varStatus="status">
                        <tr>
                           <td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
                            <form name="carShareFrm${status.index}">
                                <input type="hidden" name="res_num" value="${owner_carShare.res_num}"/>
                                <input type="hidden" name="start_date" value="${owner_carShare.start_date}">
						    	<input type="hidden" name="last_date" value="${owner_carShare.last_date}">
                            </form> 
                            <td align="center" style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${owner_carShare.dp_name}</td>
                            <td align="center" style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;"><i class="fa-solid fa-arrow-right"></i></td>
                            <td align="center" style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${owner_carShare.ds_name}</td>
                            <c:set var="startDate" value="${owner_carShare.start_date}" />
                            <c:set var="lastDate" value="${owner_carShare.last_date}" />
                            <td align="center">
                                <fmt:parseDate value="${startDate}" var="parsedStartDate" pattern="yyyy-MM-dd HH:mm:ss" />
                                <fmt:formatDate value="${parsedStartDate}" pattern="yyyy-MM-dd" />
                                ~
                                <fmt:parseDate value="${lastDate}" var="parsedLastDate" pattern="yyyy-MM-dd HH:mm:ss" />
                                <fmt:formatDate value="${parsedLastDate}" pattern="yyyy-MM-dd" />
                            </td>
                            <td align="center">${owner_carShare.start_time}</td>
                            <td align="center" style="background-color:#2c4459;">
                                <input type="button" value="날짜선택" style="border:none; background-color: #2c4459; color: white;" class="subject" id="openModalBtn${status.index}" />
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty requestScope.owner_carShareList}">
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
</div>
<form name="goViewFrm">
   <input type="hidden" name="board_seq" />
   <input type="hidden" name="goBackURL" />
   <input type="hidden" name="searchType" />
   <input type="hidden" name="searchWord" />
</form> 
<!--  검색대상이 셰어링 날짜일 경우 textform 이 아닌 datepicker 폼으로 변경하기 -->