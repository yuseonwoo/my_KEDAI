<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
 	String ctxPath = request.getContextPath();
	//     /KEDAI
%>

<link href='<%=ctxPath %>/resources/fullcalendar_5.10.1/main.min.css' rel='stylesheet' />
<style type="text/css">

div.scheduler_topbar, div.schedulerMain{
	display:flex;
}

form#searchScheduleFrm{
	margin-left : 300px;
}

div#calList_left{
	width:15%; margin-top:4%; font-size: 12pt;
}

div#calInfo_right{
	width: 70%; 
	margin-right: 10%;
	height: calc(100vh - 80px);
}

/* ========== full calendar css 시작 ========== */
.fc-header-toolbar {
	height: 30px;
}

.fc-daygrid , .fc-daygrid-day-number {
    color: #000;
    text-decoration: none;
    background-color: transparent;
    cursor: pointer;
} 

.fc-scrollgrid-sync-inner a,
.fc-scrollgrid-sync-inner a:hover,
.fc-daygrid-day-top a, 
.fc-daygrid-day-top a:hover,
.fc-daygrid ,
.fc-daygrid-event-harness a,
a.fc-daygrid-event{
	    color: #000;
	    text-decoration: none;
	    background-color: transparent;
	    cursor: pointer;
	} 


.fc-sat { color: #0000FF; }    /* 토요일 */
.fc-sun { color: #FF0000; }    /* 일요일 */
/* ========== full calendar css 끝 ========== */

ul{
	list-style: none;
}

button.btn_normal{
	background-color: #990000;
	border: none;
	color: white;
	width: 50px;
	height: 30px;
	font-size: 12pt;
	padding: 3px 0px;
	border-radius: 10%;
}

button.btn_edit{
	border: none;
	background-color: #fff;
}

div#calendar_full{
	height:calc(100vh - 200px);
}


div.fc-button-group button{
	padding:0;
	margin:0;
}

</style>


<!-- full calendar에 관련된 script -->
<script src='<%=ctxPath %>/resources/fullcalendar_5.10.1/main.min.js'></script>
<script src='<%=ctxPath %>/resources/fullcalendar_5.10.1/ko.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

<script type="text/javascript">

$(document).ready(function(){
	
	// === 사내 캘린더에 사내캘린더 소분류 보여주기 ===
	showCompanyCal();

	// === 내 캘린더에 내캘린더 소분류 보여주기 ===
	showmyCal();
	
	// === 사내캘린더 체크박스 전체 선택/전체 해제 === //
	$("input:checkbox[id=allComCal]").click(function(){
		var bool = $(this).prop("checked");
		$("input:checkbox[name=com_smcatgono]").prop("checked", bool);
	});// end of $("input:checkbox[id=allComCal]").click(function(){})-------
	
	
	// === 내캘린더 체크박스 전체 선택/전체 해제 === //
	$("input:checkbox[id=allMyCal]").click(function(){		
		var bool = $(this).prop("checked");
		$("input:checkbox[name=my_smcatgono]").prop("checked", bool);
	});// end of $("input:checkbox[id=allMyCal]").click(function(){})-------
	
	// === 사내캘린더에 속한 특정 체크박스를 클릭할 경우 === 
	$(document).on("click","input:checkbox[name=com_smcatgono]",function(){	
		var bool = $(this).prop("checked");
		
		if(bool){ // 체크박스에 클릭한 것이 체크된 것이라면 
			
			var flag=false;
			
			$("input:checkbox[name=com_smcatgono]").each(function(index, item){
				var bChecked = $(item).prop("checked");
				
				if(!bChecked){     // 체크되지 않았다면 
					flag=true;     // flag 를 true 로 변경
					return false;  // 반복을 빠져 나옴.
				}
			}); // end of $("input:checkbox[name=com_smcatgono]").each(function(index, item){})---------

			if(!flag){ // 사내캘린더 에 속한 서브캘린더의 체크박스가 모두 체크가 되어진 경우라면 			
                $("input#allComCal").prop("checked",true); // 사내캘린더 체크박스에 체크를 한다.
			}
			
			var com_smcatgonoArr = document.querySelectorAll("input.com_smcatgono");
		    
			com_smcatgonoArr.forEach(function(item) {
		         item.addEventListener("change", function() {  // "change" 대신에 "click" 을 해도 무방함.
		         //	 console.log(item);
		        	 calendar.refetchEvents();  // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
		         });
		    });// end of com_smcatgonoArr.forEach(function(item) {})---------------------

		}
		
		else {
			   $("input#allComCal").prop("checked",false);
		}
		
	});// end of $(document).on("click","input:checkbox[name=com_smcatgono]",function(){})--------
	
	

	// === 내캘린더 에 속한 특정 체크박스를 클릭할 경우 === 
	$(document).on("click","input:checkbox[name=my_smcatgono]",function(){	
		var bool = $(this).prop("checked");
		
		if(bool){ // 체크박스에 클릭한 것이 체크된 것이라면 
			
			var flag=false;
			
			$("input:checkbox[name=my_smcatgono]").each(function(index, item){
				var bChecked = $(item).prop("checked");
				
				if(!bChecked){    // 체크되지 않았다면 
					flag=true;    // flag 를 true 로 변경
					return false; // 반복을 빠져 나옴.
				}
			}); // end of $("input:checkbox[name=my_smcatgono]").each(function(index, item){})---------

			if(!flag){	// 내캘린더 에 속한 서브캘린더의 체크박스가 모두 체크가 되어진 경우라면 	
                $("input#allMyCal").prop("checked",true); // 내캘린더 체크박스에 체크를 한다.
			}
			
			var my_smcatgonoArr = document.querySelectorAll("input.my_smcatgono");
		      
			my_smcatgonoArr.forEach(function(item) {
				item.addEventListener("change", function() {   // "change" 대신에 "click" 을 해도 무방함.
				 // console.log(item); 
					calendar.refetchEvents();  // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
		        });
		    });// end of my_smcatgonoArr.forEach(function(item) {})---------------------

		}
		
		else {
			   $("input#allMyCal").prop("checked",false);
		}
		
	});// end of $(document).on("click","input:checkbox[name=my_smcatgono]",function(){})--------
	
	

	// 검색할 때 필요한 datepicker
	// 모든 datepicker에 대한 공통 옵션 설정
    $.datepicker.setDefaults({
         dateFormat: 'yy-mm-dd'  // Input Display Format 변경
        ,showOtherMonths: true   // 빈 공간에 현재월의 앞뒤월의 날짜를 표시
        ,showMonthAfterYear:true // 년도 먼저 나오고, 뒤에 월 표시
        ,changeYear: true        // 콤보박스에서 년 선택 가능
        ,changeMonth: true       // 콤보박스에서 월 선택 가능                
        ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
        ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
        ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
        ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트             
    });
	
    // input 을 datepicker로 선언
    $("input#fromDate").datepicker();                    
    $("input#toDate").datepicker();
    	    
    // From의 초기값을 한달전 날짜로 설정
    $('input#fromDate').datepicker('setDate', '-1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
    
    // To의 초기값을 오늘 날짜로 설정
//  $('input#toDate').datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
	
    // To의 초기값을 한달후 날짜로 설정
    $('input#toDate').datepicker('setDate', '+1M'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)	
	
	
	
	// ==== 풀캘린더와 관련된 소스코드 시작(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //
	var calendarEl = document.getElementById('calendar_full');
        
    var calendar = new FullCalendar.Calendar(calendarEl, {
	 // === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 시작 === //
     //	googleCalendarApiKey : "자신의 Google API KEY 입력",
        /*
            >> 자신의 Google API KEY 을 만드는 방법 <<
            1. 먼저 크롬 웹브라우저를 띄우고, 자신의 구글 계정으로 로그인 한다.
            2. https://console.developers.google.com 에 접속한다. 
            3. "API  API 및 서비스" 에서 "사용자 인증 정보" 를 클릭한다.
            4. ! 이 페이지를 보려면 프로젝트를 선택하세요 에서 "프로젝트 만들기" 를 클릭한다.
            5. 프로젝트 이름은 자동으로 나오는 값을 그대로 두고 그냥 "만들기" 버튼을 클릭한다. 
            6. 상단에 보여지는 사용자 인증 정보 옆의  "+ 사용자 인증 정보 만들기" 를 클릭하여 보여지는 API 키를 클릭한다.
                            그러면 API 키 생성되어진다.
            7. 생성된 API 키가  자신의 Google API KEY 이다.
            8. 애플리케이션에 대한 정보를 포함하여 OAuth 동의 화면을 구성해야 합니다. 에서 "동의 화면 구성" 버튼을 클릭한다.
            9. OAuth 동의 화면 --> User Type --> 외부를 선택하고 "만들기" 버튼을 클릭한다.
           10. 앱 정보 --> 앱 이름에는 "웹개발테스트"
                     --> 사용자 지원 이메일에는 자신의 구글계정 이메일 입력
                             하단부에 보이는 개발자 연락처 정보 --> 이메일 주소에는 자신의 구글계정 이메일 입력 
           11. "저장 후 계속" 버튼을 클릭한다. 
           12. 범위 --> "저장 후 계속" 버튼을 클릭한다.
           13. 테스트 사용자 --> "저장 후 계속" 버튼을 클릭한다.
           14. "API  API 및 서비스" 에서 "라이브러리" 를 클릭한다.
               Google Workspace --> Google Calendar API 를 클릭한다.
               "사용" 버튼을 클릭한다. 
        */
    	googleCalendarApiKey : "AIzaSyASM5hq3PTF2dNRmliR_rXpjqNqC-6aPbQ",
        eventSources :[ 
            {
            //  googleCalendarId : '대한민국의 휴일 캘린더 통합 캘린더 ID'
                googleCalendarId : 'ko.south_korea#holiday@group.v.calendar.google.com'
              , color: 'white'   // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object
              , textColor: 'red' // 옵션임! 옵션참고 사이트 https://fullcalendar.io/docs/event-source-object 
            } 
        ],
     // === 구글캘린더를 이용하여 대한민국 공휴일 표시하기 끝 === //

        initialView: 'dayGridMonth',
        locale: 'ko',
        selectable: true,
	    editable: false,
	    headerToolbar: {
	    	  left: 'prev,next today',
	          center: 'title',
	          right: 'dayGridMonth dayGridWeek dayGridDay'
	    },
	    dayMaxEventRows: true, // for all non-TimeGrid views
	    views: {
	      timeGrid: {
	        dayMaxEventRows: 3 // adjust to 6 only for timeGridWeek/timeGridDay
	      }
	    },
		
	    // ===================== DB 와 연동하는 법 시작 ===================== //
   		events:function(info, successCallback, failureCallback) {

	    	 $.ajax({
                 url: '<%= ctxPath%>/scheduler/allSchedule.kedai',
                 data:{"empid":$('input#empid').val()},
                 dataType: "json",
                 success:function(json) {
                	 
                	 console.log("재확인 :" ,json);
                	 /*
                	    json 의 값 예
                	    [{"cal_enddate":"2021-11-26 18:00:00.0","fk_lgcatgono":"2","color":"#009900","scheduleno":"1","fk_smcatgono":"4","cal_subject":"파이널 프로젝트 코딩","cal_startdate":"2021-11-08 09:00:00.0","fk_empid":"seoyh"},{"cal_enddate":"2021-11-29 13:50:00.0","fk_lgcatgono":"1","color":"#990008","scheduleno":"2","fk_smcatgono":"7","cal_subject":"팀원들 점심식사","cal_joinuser":"leess,eomjh","cal_startdate":"2021-11-29 12:50:00.0","fk_empid":"seoyh"},{"cal_enddate":"2021-12-02 20:00:00.0","fk_lgcatgono":"1","color":"#300bea","scheduleno":"3","fk_smcatgono":"11","cal_subject":"팀원들 뒤풀이 여행","cal_joinuser":"leess,eomjh","cal_startdate":"2021-12-01 09:00:00.0","fk_empid":"seoyh"}]
                	 */
                	 var events = [];
                     if(json.length > 0){
                         
                             $.each(json, function(index, item) {
                                    var cal_startdate = moment(item.cal_startdate).format('YYYY-MM-DD HH:mm:ss');
                                    var cal_enddate = moment(item.cal_enddate).format('YYYY-MM-DD HH:mm:ss');
                                    var cal_subject = item.cal_subject;
                                    console.log("Processing item:", item); // 추가된 로그: 현재 처리 중인 아이템
                                    
                                   // 사내 캘린더로 등록된 일정을 풀캘린더 달력에 보여주기 
                                   // 일정등록시 사내 캘린더에서 선택한 소분류에 등록된 일정을 풀캘린더 달력 날짜에 나타내어지게 한다.
                                   	if( $("input:checkbox[name=com_smcatgono]:checked").length <= $("input:checkbox[name=com_smcatgono]").length ){
                                   		for(var i=0; i<$("input:checkbox[name=com_smcatgono]:checked").length; i++){
	                                    	if($("input:checkbox[name=com_smcatgono]:checked").eq(i).val() == item.fk_smcatgono){
	   			                                 //alert("캘린더 소분류 번호 : " + $("input:checkbox[name=com_smcatgono]:checked").eq(i).val());
	   			                      
	                                			   events.push({
	   			                                	            id: item.scheduleno,
	   			                                                title: item.cal_subject,
	   			                                                start: cal_startdate,
	   			                                                end: cal_enddate,
	   			                                        	    url: "<%= ctxPath%>/scheduler/detailSchedule.kedai?scheduleno="+item.scheduleno,
	   			                                                color: item.cal_color,
	   			                                                cid: item.fk_smcatgono  // 사내캘린더 내의 서브캘린더 체크박스의 value값과 일치하도록 만들어야 한다. 그래야만 서브캘린더의 체크박스와 cid 값이 연결되어 체크시 풀캘린더에서 일정이 보여지고 체크해제시 풀캘린더에서 일정이 숨겨져 안보이게 된다. 
	   			                                   }); // end of events.push({})---------
	   		                                   }
	                                	   
	                                   }// end of for-------------------------------------
	                                 
                                   }// end of if-------------------------------------------
                                    
                                  
                                  // 내 캘린더로 등록된 일정을 풀캘린더 달력에 보여주기
                                  // 일정등록시 내 캘린더에서 선택한 소분류에 등록된 일정을 풀캘린더 달력 날짜에 나타내어지게 한다.
                                  	if( $("input:checkbox[name=my_smcatgono]:checked").length <= $("input:checkbox[name=my_smcatgono]").length ){
                                  		console.log("1");
	                                   	for(var i=0; i<$("input:checkbox[name=my_smcatgono]:checked").length; i++){
	                                   		console.log("2");
	                                		if($("input:checkbox[name=my_smcatgono]:checked").eq(i).val() == item.fk_smcatgono && item.fk_empid == "${sessionScope.loginuser.empid}" ){
	                                			console.log("3");
	                                			//   alert("캘린더 소분류 번호 : " + $("input:checkbox[name=my_smcatgono]:checked").eq(i).val());
	                                			   events.push({
	   			                                	            id: item.scheduleno,
	   			                                                title: item.cal_subject,
	   			                                                start: cal_startdate,
	   			                                                end: cal_enddate,
	   			                                        	    url: "<%= ctxPath%>/scheduler/detailSchedule.kedai?scheduleno="+item.scheduleno,
	   			                                                color: item.cal_color,
	   			                                                cid: item.fk_smcatgono  // 내캘린더 내의 서브캘린더 체크박스의 value값과 일치하도록 만들어야 한다. 그래야만 서브캘린더의 체크박스와 cid 값이 연결되어 체크시 풀캘린더에서 일정이 보여지고 체크해제시 풀캘린더에서 일정이 숨겨져 안보이게 된다. 
	   			                                   }); // end of events.push({})---------
	                                			   console.log("4");
	                                		}
	                                		console.log("5");
	                                   }// end of for-------------------------------------
                                   
                                   }// end of if-------------------------------------------

                                 
                                  // 공유받은 캘린더(다른 사용자가 내캘린더로 만든 것을 공유받은 경우임)
                                  if (item.fk_lgcatgono==1 && item.fk_empid != "${sessionScope.loginuser.empid}" && (item.cal_joinuser).indexOf("${sessionScope.loginuser.empid}") != -1 ){  
                                        
  	                                   events.push({
  	                                	   			id: "0",  // "0" 인 이유는  배열 events 에 push 할때 id는 고유해야 하는데 위의 사내캘린더 및 내캘린더에서 push 할때 id값으로 item.scheduleno 을 사용하였다. item.scheduleno 값은 DB에서 1 부터 시작하는 시퀀스로 사용된 값이므로 0 값은 위의 사내캘린더나 내캘린더에서 사용되지 않으므로 여기서 고유한 값을 사용하기 위해 0 값을 준 것이다. 
  	                                                title: item.cal_subject,
  	                                                start: cal_startdate,
  	                                                end: cal_enddate,
  	                                        	    url: "<%= ctxPath%>/scheduler/detailSchedule.kedai?scheduleno="+item.scheduleno,
  	                                                color: item.cal_color,
  	                                                cid: "0"  // "0" 인 이유는  공유받은캘린더 에서의 체크박스의 value 를 "0" 으로 주었기 때문이다.
  	                                   }); // end of events.push({})--------- 
  	                                   
  	                           		}// end of if------------------------- 
                              
                             }); // end of $.each(json, function(index, item) {})-----------------------
                         }                             
                         
                      // console.log(events);                       
                         successCallback(events);                               
                  },
				  error: function(request, status, error){
			            alert("111111code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			      }	
                                            
          }); // end of $.ajax()--------------------------------
        
        }, // end of events:function(info, successCallback, failureCallback) {}---------
 
        // ===================== DB 와 연동하는 법 끝 ===================== //
        
		// 풀캘린더에서 날짜 클릭할 때 발생하는 이벤트(일정 등록창으로 넘어간다)
        dateClick: function(info) {
      	 // alert('클릭한 Date: ' + info.dateStr); // 클릭한 Date: 2021-11-20
      	    $(".fc-day").css('background','none'); // 현재 날짜 배경색 없애기
      	    info.dayEl.style.backgroundColor = '#b1b8cd'; // 클릭한 날짜의 배경색 지정하기
      	    $("form > input[name=chooseDate]").val(info.dateStr);
      	    
      	    var frm = document.dateFrm;
      	    frm.method="POST";
      	    frm.action="<%= ctxPath%>/scheduler/insertSchedule.kedai";
      	    frm.submit();
      	  },
      	  
      	 // === 사내캘린더, 내캘린더, 공유받은캘린더의 체크박스에 체크유무에 따라 일정을 보여주거나 일정을 숨기게 하는 것이다. === 
    	 eventDidMount: function (arg) {
	            var arr_calendar_checkbox = document.querySelectorAll("input.calendar_checkbox"); 
	            // 사내캘린더, 내캘린더, 공유받은캘린더 에서의 모든 체크박스임
	            
	            arr_calendar_checkbox.forEach(function(item) { // item 이 사내캘린더, 내캘린더, 공유받은캘린더 에서의 모든 체크박스 중 하나인 체크박스임
		              if (item.checked) { 
		            	// 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스중 체크박스에 체크를 한 경우 라면
		                
		            	if (arg.event.extendedProps.cid === item.value) { // item.value 가 체크박스의 value 값이다.
		                	 console.log("일정을 보여주는 cid : "  + arg.event.extendedProps.cid);
		                	 console.log("일정을 보여주는 체크박스의 value값(item.value) : " + item.value);
		                    
		                	arg.el.style.display = "block"; // 풀캘린더에서 일정을 보여준다.
		                }
		              } 
		              
		              else { 
		            	// 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스중 체크박스에 체크를 해제한 경우 라면
		                
		            	if (arg.event.extendedProps.cid === item.value) {
		            		 console.log("일정을 숨기는 cid : "  + arg.event.extendedProps.cid);
		                	 console.log("일정을 숨기는 체크박스의 value값(item.value) : " + item.value);
		                	
		            		arg.el.style.display = "none"; // 풀캘린더에서 일정을  숨긴다.
		                }
		              }
	            });// end of arr_calendar_checkbox.forEach(function(item) {})------------
	      }
  });
    
  calendar.render();  // 풀캘린더 보여주기
  
  
  var arr_calendar_checkbox = document.querySelectorAll("input.calendar_checkbox"); 
  // 사내캘린더, 내캘린더, 공유받은캘린더 에서의 체크박스임
  
  arr_calendar_checkbox.forEach(function(item) {
	  item.addEventListener("change", function () {
      // console.log(item);
		 calendar.refetchEvents(); // 모든 소스의 이벤트를 다시 가져와 화면에 다시 표시합니다.
    });
  });
  //==== 풀캘린더와 관련된 소스코드 끝(화면이 로드되면 캘린더 전체 화면 보이게 해줌) ==== //

  
  // 검색 할 때 엔터를 친 경우
  $("input#searchWord").keyup(function(event){
	 if(event.keyCode == 13){ 
		 goSearch();
	 }
  });
 
    
  // 모달 창에서 입력된 값 초기화 시키기 //
  $("button.modal_close").on("click", function(){
	  var modal_frmArr = document.querySelectorAll("form[name=modal_frm]");
	  for(var i=0; i<modal_frmArr.length; i++) {
		  modal_frmArr[i].reset();
	  }
  });
  
  
  
  
}); // end of $(document).ready(function(){})==============================

//~~~~~~~ Function Declartion ~~~~~~~

// === 사내 캘린더 소분류 추가를 위해 +아이콘 클릭시 ===
function addComCalendar(){
	$('#modal_addComCal').modal('show'); // 모달창 보여주기	
}// end of function addComCalendar(){}--------------------
	
//=== 사내 캘린더 추가 모달창에서 추가 버튼 클릭시 ===
function goAddComCal(){
	
	if($("input.add_com_smcatgoname").val().trim() == ""){
 		  alert("추가할 사내캘린더 소분류명을 입력하세요!!");
 		  return;
 	}
	
 	else {
 		 $.ajax({
 			 url: "<%= ctxPath%>/scheduler/addComCalendar.kedai",
 			 type: "post",
 			 data: {"com_smcatgoname": $("input.add_com_smcatgoname").val(), 
 				    "fk_empid": "${sessionScope.loginuser.empid}"},
 			 dataType: "json",
 			 success:function(json){
 				 if(json.n != 1){
  					alert("이미 존재하는 '사내캘린더 소분류명' 입니다.");
  					return;
  				 }
 				 else if(json.n == 1){
 					 $('#modal_addComCal').modal('hide'); // 모달창 감추기				
 					 alert("사내 캘린더에 "+$("input.add_com_smcatgoname").val()+" 소분류명이 추가되었습니다.");
 					 
 					 $("input.add_com_smcatgoname").val("");
 					 showCompanyCal();  // 사내 캘린더 소분류 보여주기
 				 }
 			 },
 			 error: function(request, status, error){
  	            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
    	     }	 
 		 });
 	  }
	
}// end of function goAddComCal(){}------------------------------------
	

//=== 사내 캘린더내의 서브캘린더 수정 모달창 나타나기 === 
function editComCalendar(smcatgono, smcatgoname){
	$('#modal_editComCal').modal('show'); // 모달 보이기
	$("input.edit_com_smcatgono").val(smcatgono);
	$("input.edit_com_smcatgoname").val(smcatgoname);
}// end of function editComCalendar(smcatgono, smcatgoname){}----------------------
	

//=== 사내 캘린더내의 서브캘린더 수정 모달창에서 수정하기 클릭 === 
function goEditComCal(){
	
	if($("input.edit_com_smcatgoname").val().trim() == ""){
		  alert("수정할 사내캘린더 소분류명을 입력하세요!!");
		  return;
	}
	else{
		$.ajax({
			url:"<%= ctxPath%>/scheduler/editCalendar.kedai",
			type: "post",
			data:{"smcatgono":$("input.edit_com_smcatgono").val(), 
				  "smcatgoname": $("input.edit_com_smcatgoname").val(), 
				  "empid":"${sessionScope.loginuser.empid}",
				  "caltype":"2"  // 사내캘린더
			     },
			dataType:"json",
			success:function(json){
				if(json.n == 0){
					alert($("input.edit_com_smcatgoname").val()+"은(는) 이미 존재하는 캘린더 명입니다.");
					return;
				 }
				if(json.n == 1){
					$('#modal_editComCal').modal('hide'); // 모달 숨기기
					alert("사내 캘린더명을 수정하였습니다.");
					showCompanyCal();
				}
			},
			 error: function(request, status, error){
		            alert("22222222222code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
		});
	  }
	
}// end of function goEditComCal(){}--------------------------------
	

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //	

//=== 내 캘린더 소분류 추가를 위해 +아이콘 클릭시 ===
function addMyCalendar(){
	$('#modal_addMyCal').modal('show');	
}// end of function addMyCalendar(){}-----------------
	

//=== 내 캘린더 추가 모달창에서 추가 버튼 클릭시 === 
function goAddMyCal(){
	
	if($("input.add_my_smcatgoname").val().trim() == ""){
		  alert("추가할 내캘린더 소분류명을 입력하세요!!");
		  return;
	}
	
	else {
		  $.ajax({
			 url: "<%= ctxPath%>/scheduler/addMyCalendar.kedai",
			 type: "post",
			 data: {"my_smcatgoname": $("input.add_my_smcatgoname").val(), 
				    "fk_empid": "${sessionScope.loginuser.empid}"},
			 dataType: "json",
			 success:function(json){
				 
				 if(json.n!=1){
					alert("이미 존재하는 '내캘린더 소분류명' 입니다.");
					return;
				 }
				 else if(json.n==1){
					 $('#modal_addMyCal').modal('hide'); // 모달창 감추기
					 alert("내 캘린더에 "+$("input.add_my_smcatgoname").val()+" 소분류명이 추가되었습니다.");
					 
					 $("input.add_my_smcatgoname").val("");
				 	 showmyCal(); // 내 캘린더 소분류 보여주기
				 }
			 },
			 error: function(request, status, error){
	            alert("33333333333code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 	     }	 
		 });
	  }
	
}// end of function goAddMyCal(){}-----------------------


// === 내 캘린더에서 내캘린더 소분류 보여주기  === //
function showmyCal(){
	$.ajax({
		url:"<%= ctxPath%>/scheduler/showMyCalendar.kedai",
	 	type:"get",
	 	data:{"fk_empid":"${sessionScope.loginuser.empid}"},
	 	dataType:"json",
	 	success:function(json){
			var html = "";
		 	if(json.length > 0){
				html += "<table style='width:80%;'>";	 
			 
			 	$.each(json, function(index, item){
					html += "<tr style='font-size: 11pt;  height:20px; margin-bottom:2px;'>";
				 	html += "<td style='width:76%;'><input type='checkbox' name='my_smcatgono' class='calendar_checkbox my_smcatgono' style='margin-right: 3px;' value='"+item.smcatgono+"' checked id='my_smcatgono_"+index+"' checked/><label style='margin:0; ' for='my_smcatgono_"+index+"'>"+item.smcatgoname+"</label></td>";   
				 	html += "<td style='width:12%;'><button class='btn_edit editCal' data-target='editCal' onclick='editMyCalendar("+item.smcatgono+",\""+item.smcatgoname+"\")'><i class='fas fa-edit'></i></button></td>"; 
				 	html += "<td style='width:12%;'><button class='btn_edit delCal' onclick='delCalendar("+item.smcatgono+",\""+item.smcatgoname+"\")'><i class='fas fa-trash'></i></button></td>";
			     	html += "</tr>";
			 	});
			 
			 	html += "</table>";
		 	}
		 
		 	$("div#myCal").html(html);
	 	},
	 	error: function(request, status, error){
            alert("44444444444code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
     	}	 	
	});
}// end of function showmyCal()---------------------	


//=== 내 캘린더내의 서브캘린더 수정 모달창 나타나기 === 
function editMyCalendar(smcatgono, smcatgoname){
	$('#modal_editMyCal').modal('show');  // 모달 보이기
	$("input.edit_my_smcatgono").val(smcatgono);
	$("input.edit_my_smcatgoname").val(smcatgoname);
}// end of function editMyCalendar(smcatgono, smcatgoname){}-----------------------
	
	

//=== 내 캘린더내의 서브캘린더 수정 모달창에서 수정 클릭 === 
function goEditMyCal(){
	
	if($("input.edit_my_smcatgoname").val().trim() == ""){
		  alert("수정할 내캘린더 소분류명을 입력하세요!!");
		  return;
	}
	else{
		 $.ajax({
			url:"<%= ctxPath%>/scheduler/editCalendar.kedai",
			type: "post",
			data:{"smcatgono":$("input.edit_my_smcatgono").val(), 
				  "smcatgoname": $("input.edit_my_smcatgoname").val(), 
				  "empid":"${sessionScope.loginuser.empid}",
				  "caltype":"1"  // 내캘린더
				  },
			dataType:"json",
			success:function(json){
				if(json.n == 0){
					alert($("input.edit_com_smcatgoname").val()+"은(는) 이미 존재하는 캘린더 명입니다.");
					return;
				 }
				if(json.n == 1){
					$('#editMyCal').modal('hide'); // 모달 숨기기
					alert("내캘린더명을 수정하였습니다.");
					showmyCal(); 
				}
			},
			 error: function(request, status, error){
		            alert("5555555555code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
		});
	  }
	
}// end of function goEditMyCal(){}-------------------------------------
	

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//		


// === (사내캘린더 또는 내캘린더)속의 소분류 카테고리 삭제하기 === 
function delCalendar(smcatgono, smcatgoname){ // smcatgono => 캘린더 소분류 번호, smcatgoname => 캘린더 소분류 명
	
	var bool = confirm(smcatgoname + " 캘린더를 삭제 하시겠습니까?");
	
	if(bool){
		$.ajax({
			url:"<%= ctxPath%>/scheduler/deleteSubCalendar.kedai",
			type: "post",
			data:{"smcatgono":smcatgono},
			dataType:"json",
			success:function(json){
				if(json.n==1){
					alert(smcatgoname + " 캘린더를 삭제하였습니다.");
					location.href="javascript:history.go(0);"; // 페이지 새로고침
				}
			},
			error: function(request, status, error){
		            alert("66666666code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		    }
		});
	}
	
}// end of function delCalendar(smcatgono, smcatgoname){}------------------------



//=== 사내 캘린더에서 사내캘린더 소분류  보여주기  === //
function showCompanyCal(){
	$.ajax({
		 url:"<%= ctxPath%>/scheduler/showCompanyCalendar.kedai",
		 type:"get",
		 dataType:"json",
		 success:function(json){
				 var html = "";
				 
				 if(json.length > 0){
					 html += "<table style='width:80%;'>";
					 
					 $.each(json, function(index, item){
						 html += "<tr style='font-size: 11pt; height:20px; margin-bottom:2px;'>";
						 html += "<td style='width:76%;'><input type='checkbox' name='com_smcatgono' class='calendar_checkbox com_smcatgono' style='margin-right: 3px;' value='"+item.smcatgono+"' checked id='com_smcatgono_"+index+"'/><label for='com_smcatgono_"+index+"' style='margin:0;' >"+item.smcatgoname+"</label></td>";  
						 
						 <%-- 사내 캘린더 추가를 할 수 있는 직원은 직위코드가 3 이면서 부서코드가 4 에 근무하는 사원이 로그인 한 경우에만 가능하도록 조건을 걸어둔다. 
						 if("${sessionScope.loginuser.fk_pcode}" =='3' && "${sessionScope.loginuser.fk_dcode}" == '4') { --%>
						 if("${sessionScope.loginuser.fk_job_code}" =='1') {
							 html += "<td style='width:12%;'><button class='btn_edit' data-target='editCal' onclick='editComCalendar("+item.smcatgono+",\""+item.smcatgoname+"\")'><i class='fas fa-edit'></i></button></td>";  
							 html += "<td style='width:12%;'><button class='btn_edit delCal' onclick='delCalendar("+item.smcatgono+",\""+item.smcatgoname+"\")'><i class='fas fa-trash'></i></button></td>";
						 }
						 
						 html += "</tr>";
					 });
				 	 
					 html += "</table>";
				 }
			 
				 $("div#companyCal").html(html);
		},
		error: function(request, status, error){
	           alert("777777777code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
       }	 	
	});
	
}
	
// === 검색 기능 === //
function goSearch(){

	if( $("#fromDate").val() > $("#toDate").val() ) {
		alert("검색 시작날짜가 검색 종료날짜 보다 크므로 검색할 수 없습니다.");
		return;
	}
    
	if( $("select#searchType").val()=="" && $("input#searchWord").val()!="" ) {
		alert("검색대상 선택을 해주세요!!");
		return;
	}
	
	if( $("select#searchType").val()!="" && $("input#searchWord").val()=="" ) {
		alert("검색어를 입력하세요!!");
		return;
	}
	
   	var frm = document.searchScheduleFrm;
    frm.method="get";
    frm.action="<%= ctxPath%>/scheduler/searchSchedule.kedai";
    frm.submit();
	
}// end of function goSearch(){}--------------------------


</script>

<div id="scheduler_main" style="width:100%;">

	<div class="scheduler_topbar">
	<input type="hidden" value="${sessionScope.loginuser.empid}" id="empid"/>
		<h3>일정 관리</h3>
		
			<form id="searchScheduleFrm" name="searchScheduleFrm">
		<%-- 
			<div>
				<input type="text" id="fromDate" name="cal_startdate" style="width: 90px;" readonly="readonly">&nbsp;&nbsp;-&nbsp;&nbsp; 
				<input type="text" id="toDate" name="cal_enddate" style="width: 90px;" readonly="readonly">&nbsp;&nbsp;
				<select id="searchType" name="searchType" style="height: 30px;">
					<option value="">검색대상선택</option>
					<option value="cal_subject">제목</option>
					<option value="cal_content">내용</option>
					<option value="cal_joinuser">공유자</option>
				</select>&nbsp;&nbsp;	
				<input type="text" id="searchWord" value="" style="height: 30px; width:150px;" name="searchWord"/>&nbsp;&nbsp;
				<select id="sizePerPage" name="sizePerPage" style="height: 30px;">
					<option value="">보여줄개수</option>
					<option value="10">10</option>
					<option value="15">15</option>
					<option value="20">20</option>
				</select>&nbsp;&nbsp;
				<input type="hidden" name="empid" value="${sessionScope.loginuser.empid}"/>
				<button type="button" class="btn_normal" style="display: inline-block;" onclick="goSearch()">검색</button>
			</div>
			--%>
			<input type="hidden" name="empid" value="${sessionScope.loginuser.empid}"/>
		</form>
	</div>
	
	
	<div class="schedulerMain">
		<div id="calList_left">
			<input type="hidden" value="${sessionScope.loginuser.empid}" id="loginuser_id"/>
			<input type="checkbox" id="allComCal" class="calendar_checkbox" checked/>&nbsp;&nbsp;<label for="allComCal" style="width:50%; color:#e68c0e; font-weight: bold; text-decoration: underline; text-decoration-color: #2c4459; text-decoration-thickness: 1px; /* 밑줄 두께 */ ">사내 캘린더</label>
			<c:if test="${sessionScope.loginuser.fk_job_code =='1'}"> 
				 	<button class="btn_edit" onclick="addComCalendar()"><i class="fa-regular fa-calendar-plus"></i></button>
			</c:if>
			
			<%-- 사내 캘린더를 보여주는 곳 --%>
			<div id="companyCal" style="margin-left: 15px; margin-bottom:10px;"></div> 
			
			<input type="checkbox" id="allMyCal" class="calendar_checkbox" checked/>&nbsp;&nbsp;<label for="allMyCal" style="width:50%">내 캘린더</label>
			<button class="btn_edit" onclick="addMyCalendar()"><i class="fa-regular fa-calendar-plus"></i></button>
				
			<%-- 내 캘린더를 보여주는 곳 --%>
			<div id="myCal" style="margin-left: 15px; margin-bottom:10px;"></div>
			
			<input type="checkbox" id="sharedCal" class="calendar_checkbox" value="0" checked/>&nbsp;&nbsp;<label for="sharedCal">공유받은 캘린더</label> 
		</div>
		
		<div id="calInfo_right" style="float: right;">
			 <%-- 풀캘린더가 보여지는 엘리먼트  --%>
			<div id="calendar_full" style="margin: 0;" ></div>
		</div>
	</div>
</div>

<%-- === 사내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_addComCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">사내 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="add_com_smcatgoname"/></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td>
     			</tr>
     		</table>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goAddComCal()">추가</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%-- === 사내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_editComCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">사내 캘린더 수정</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
       	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="edit_com_smcatgoname"/><input type="hidden" value="" class="edit_com_smcatgono"></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td>
     			</tr>
     		</table>
       	</form>	
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditComCal()">수정</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%-- === 내 캘린더 추가 Modal === --%>
<div class="modal fade" id="modal_addMyCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">내 캘린더 추가</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
          <form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="add_my_smcatgoname" /></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td> 
     			</tr>
     		</table>
     		</form>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addMy" class="btn btn-success btn-sm" onclick="goAddMyCal()">추가</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%-- === 내 캘린더 수정 Modal === --%>
<div class="modal fade" id="modal_editMyCal" role="dialog" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
    
      <!-- Modal header -->
      <div class="modal-header">
        <h4 class="modal-title">내 캘린더 수정</h4>
        <button type="button" class="close modal_close" data-dismiss="modal">&times;</button>
      </div>
      
      <!-- Modal body -->
      <div class="modal-body">
      	<form name="modal_frm">
       	<table style="width: 100%;" class="table table-bordered">
     			<tr>
     				<td style="text-align: left; ">소분류명</td>
     				<td><input type="text" class="edit_my_smcatgoname"/><input type="hidden" value="" class="edit_my_smcatgono"></td>
     			</tr>
     			<tr>
     				<td style="text-align: left;">만든이</td>
     				<td style="text-align: left; padding-left: 5px;">${sessionScope.loginuser.name}</td>
     			</tr>
     		</table>
       	</form>
      </div>
      
      <!-- Modal footer -->
      <div class="modal-footer">
      	<button type="button" id="addCom" class="btn btn-success btn-sm" onclick="goEditMyCal()">수정</button>
          <button type="button" class="btn btn-danger btn-sm modal_close" data-dismiss="modal">취소</button>
      </div>
      
    </div>
  </div>
</div>

<%-- === 마우스로 클릭한 날짜의 일정 등록을 위한 폼 === --%>     
<form name="dateFrm">
	<input type="hidden" name="chooseDate" />	
</form>	
