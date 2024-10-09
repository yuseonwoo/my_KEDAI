<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
    .header { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-right: 15%;
    }
    
    .date-navigation { 
        display: flex; 
        justify-content: center; 
        align-items: center; 
        padding-left: 45%;
        font-size: 35px;
    }
    
    .date-navigation button {
        margin: 0 10px;
        background-color: transparent;
        border: none;
        font-size: 35px;
        cursor: pointer;
    }
    
    table {         
        border-collapse: collapse; 
        width: 80%;
    }
    
    th, td { 
        border: 1px solid #ddd; 
        text-align: center;
    }
    
    .time-slot:hover {
        background-color: yellow;
        cursor: pointer;
    }

    .modal-dialog {
        max-width: 800px;
    }
    
    .modal-header, .modal-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .modal-body {
        display: flex;
        flex-direction: column;
        width: auto;
    }

    .form-group {
        margin-bottom: 1rem;
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

    .form-group label {
        display: block;
        margin-bottom: 5px;
    }

    .form-group input, .form-group textarea, .form-group select {
        padding: 8px;
    }
    
    .reserveBtn {
        padding: 22px;
        background-color: transparent;
    }

    .date-time-group {
        display: flex;
        align-items: center;
    }

    .date-input {
        margin-right: 10px;
        flex: 1;
    }

    .time-input {
        margin-right: 10px;
        width: 80px;
        text-align: center;
    }

    .checkbox-label {
        display: inline-block;
        margin-left: 10px;
    }

    .reservee {
        display: inline-block;
        background-color: #e0e0e0;
        padding: 5px 10px;
        border-radius: 5px;
    }

    .change-btn {
        margin-left: 10px;
        cursor: pointer;
    }
    
    .highlighted {
        background-color: blue !important;
        color: white;
    }
    
    #floorSelect {
        margin-right: 10px;
    }

    .search-button {
        cursor: pointer;
        font-size: 20px;
        border: none;
        background: none;
        color: #007bff;
    }

    #buttonContainer {
        display: none;
        margin-left: 10px;
    }
</style>

 <script type="text/javascript">
 $(document).ready(function(){
	 // 페이지 로드 시 초기화
	    showallsub();
	    setToday();
	    fetchReservations();

	    // 시간과 분 선택 옵션을 초기화
	    populateTimeSelect();
	   
	    // 전체 버튼 클릭 시 `showallsub()` 호출
	    $("#showAllButton").click(function() {
	        showallsub();
	    });
	    
    // 시간과 분 선택 옵션을 초기화
    populateTimeSelect();
    
   
    // 모달 표시 시 날짜와 시간을 설정
    $(document).on("click", ".reserveBtn", function() {
    	  var btn = $(this);
    	    var btnColor = btn.closest('td').css("background-color");
    	    
    	    // 파란색 버튼 클릭 시 예약 상세 페이지로 이동
    	    if (btnColor === "rgb(0, 0, 255)") {
    	        var reservationId = btn.data("reservation-id");
    	        if (reservationId) {
    	            window.location.href = "<%= ctxPath %>/reservation_detail.kedai?id=" + reservationId;
    	        }
    	    } else {
    	        // 버튼 클릭 시 startTime 설정
    	        var hour = btn.data('hour'); // 데이터에서 시간 정보를 가져옵니다
    	        var minute = btn.data('minute'); // 데이터에서 분 정보를 가져옵니다
    	        var startTime = formatTime(hour, minute); // startTime 포맷 설정 함수 호출
    	        $("#startTime").val(startTime); // startTime을 설정합니다
    	        
    	        $("#endDate").val($("#currentDate").text());
    	        updateEndTimeOptions();
    	        $("#reservationModal").modal("show");
    	    } 
    });

    
    // 시간과 분 옵션 생성 함수
     function populateTimeSelect() {
        var startTimeSelect = $("#startTime");
        var endTimeSelect = $("#endTime");
        var timeOptions = [];

        // 09:00부터 22:00까지 30분 단위의 시간 옵션을 생성
        for (var hour = 9; hour <= 21; hour++) {
            for (var minute = 0; minute < 60; minute += 30) {
                var formattedHour = ('0' + hour).slice(-2);
                var formattedMinute = ('0' + minute).slice(-2);
                var timeString = formattedHour + ':' + formattedMinute;

                timeOptions.push(timeString);
            }
        }

        // 시작 시간 드롭다운에 옵션 추가
        timeOptions.forEach(function(time) {
            startTimeSelect.append("<option value='" + time + "'>" + time + "</option>");
        });

        // 종료 시간 드롭다운에 옵션 추가
        timeOptions.forEach(function(time) {
            endTimeSelect.append("<option value='" + time + "'>" + time + "</option>");
        });
    }
   
     // 시작 시간이 변경될 때 종료 시간 드롭다운을 업데이트하는 함수
      // 종료 시간 드롭다운을 업데이트하는 함수
    function updateEndTimeOptions() {
    	  var startTime = $("#startTime").val();
    	    console.log("Start time value: ", startTime); // 디버깅을 위한 로그 추가

    	    if (!startTime) {
    	        console.error("Start time is not set. Ensure that start time is properly assigned.");
    	        return; // startTime이 null일 경우 함수 종료
    	    }

    	    var endTimeSelect = $("#endTime");
    	    var timeOptions = [];
    	    var startHour = parseInt(startTime.split(':')[0]);
    	    var startMinute = parseInt(startTime.split(':')[1]);

        // 30분 단위의 시간 옵션을 생성
        for (var hour = startHour; hour <= 22; hour++) {
            for (var minute = 0; minute < 60; minute += 30) {
                // 시작 시간보다 30분이 지나지 않은 시간은 제외
                if (hour > startHour || (hour === startHour && minute >= startMinute + 30)) {
                    if (hour < 22 || (hour === 22 && minute <= 0)) {
                        var formattedHour = ('0' + hour).slice(-2);
                        var formattedMinute = ('0' + minute).slice(-2);
                        var timeString = formattedHour + ':' + formattedMinute;
                        timeOptions.push(timeString);
                    }
                }
            }
        }
         // 종료 시간 드롭다운에 옵션 추가
         endTimeSelect.empty(); // 기존 옵션 제거
         timeOptions.forEach(function(time) {
             endTimeSelect.append("<option value='" + time + "'>" + time + "</option>");
         });


      // 종료 시간을 시작 시간보다 30분 후로 설정
         var endTime = timeOptions.find(time => time >= formatTime(startHour, startMinute + 30));
         if (endTime) {
             endTimeSelect.val(endTime);
         }
     }

     // 페이지 로드 시 드롭다운 초기화
     populateTimeSelect();

     // 모달 표시 시 날짜와 시간을 설정
     $(document).on("click", ".reserveBtn", function() {
    	 // 클릭한 버튼의 왼쪽 값 추출
    	 var leftValue = $(this).closest('tr').find('td:first').text().trim();

        // 모달 제목 업데이트
        $("#reservationModal .modal-title").text("예약: " + leftValue);
        
        
         var hour = $(this).data('hour');
         var minute = $(this).data('minute');

         // 시작 시간 설정
         var startTime = formatTime(hour, minute);

         // 모달에 값 설정
         $("#startTime").val(startTime);
         $("#endDate").val($("#currentDate").text());

         // 종료 시간 옵션 업데이트
         updateEndTimeOptions();

         // 모달 표시
         $("#reservationModal").modal("show");
         
     });
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	      

	
    // '종일' 체크박스 클릭 시
    $("#allDay").click(function() {
        var isChecked = $(this).is(":checked");
        if (isChecked) {
            $("#startTime").val("09:00").prop("disabled", true);
            $("#endTime").val("22:00").prop("disabled", true);
        } else {
            $("#startTime, #endTime").prop("disabled", false);
            updateEndTimeOptions();
        }
        
    });

	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	

	$("#startDate").datepicker({
        onSelect: function(dateText) {
            const selectedDate = $(this).datepicker("getDate");
            const formattedDate = formatDate(selectedDate);
            $(this).val(formattedDate); // 선택한 날짜를 예약일(input id="startDate")에 설정
        }
    });


   $("#endDate").datepicker({
        onSelect: function(dateText) {
        	 const selectedDate = $(this).datepicker("getDate");
             const formattedDate = formatDate(selectedDate);
             $(this).val(formattedDate); // 선택한 날짜를 예약일(input id="startDate")에 설정
        }
    });

     
    $(document).on("click", "#startDate", function() {
   	    // currentDate 버튼의 텍스트를 startDate input 필드에 설정
   	            // 예약일(input id="startDate") 클릭 시 달력 보이기
       	$("#startDate").datepicker("show");
   	    var currentDateText = document.getElementById('currentDate').innerText;
   	    document.getElementById('startDate').value = currentDateText;
   	});
    
    $(document).on("click", "#endDate", function() {
   	    // currentDate 버튼의 텍스트를 startDate input 필드에 설정
   	            // 예약일(input id="startDate") 클릭 시 달력 보이기
       	$("#endDate").datepicker("show");
   	    var currentDateText = document.getElementById('currentDate').innerText;
   	    document.getElementById('endDate').value = currentDateText;
   	});
    

    $(".close, #reserveCancel").on("click", function() {
        $("#reservationModal").hide();
    });

    $(".datepicker").datepicker({
        dateFormat: "yy-mm-dd"
    });

    
    // 오늘 날짜 설정
    const today = new Date();
    const formattedToday = formatDate(today);
    $("#currentDate").text(formattedToday);
    $("#startDate").val(formattedToday); // 예약일(input id="startDate")에 오늘 날짜 설정
    $("#endDate").val(formattedToday);
	
     

     
     // 예약 버튼 클릭 시 모달 내 날짜 및 시간 초기화
     $("#reserve_submit").on("click", function() {
    	 $("#reservationModal").hide();
    	 var startDate = $("#startDate").val(); // 포맷팅된 날짜
         var endDate = $("#endDate").val();   // 포맷팅된 날짜
         var startTime = $("#startTime").val();
         var endTime = $("#endTime").val();
         var purpose = $("#purpose").val();
         var reserver = $("#reserver_end").val();
         var allDay = $("#allDay").is(":checked");

         var subroom = $("#reservationModal .modal-title").text().split(": ")[1];

         $.ajax({
             url: '<%= ctxPath%>/getRoomData.kedai',
             method: 'GET',
             data: { subroom: subroom },
             success: function(response) {
            	 var data = response[0] || {};
                 var roomMainName = data.ROOMMAINNAME || ''; // "1층"
                 var roomSubName = data.ROOMSUBNAME || '';   // "102호"

                 // ROOMMAINNAME과 ROOMSUBNAME을 합쳐서 roomname을 생성합니다.
                 var roomname = roomMainName + roomSubName; // "1층102호"

                 var startDate = $("#startDate").val(); // 예: "2024-07-25 (목)"
                 var startTime = $("#startTime").val(); // 예: "13:00"
                 var endDate = $("#endDate").val(); // 예: "2024-07-25 (목)"
                 var endTime = $("#endTime").val(); // 예: "14:00"

                 // 날짜와 시간을 포맷팅
                 var formattedStartDateTime = startDate.substring(0, 10) + ' ' + startTime;
                 var formattedEndDateTime = endDate.substring(0, 10) + ' ' + endTime;

                 var reservationData = {
                     reserver: $("#reserver_end").val(),
                     roomname: roomname, // 합쳐진 roomname을 설정
                     purpose: $("#purpose").val(),
                     startDateTime: formattedStartDateTime,
                     endDateTime: formattedEndDateTime
                 };

                 $.ajax({
                     url: '<%= ctxPath%>/reserve.kedai',
                     type: 'POST',
                     contentType: 'application/json',
                     data: JSON.stringify(reservationData),
                     success: function(response) {
                         if (response.success) {
                             alert("예약이 완료되었습니다.");
                             $("#reservationModal").modal("hide");
                             window.location.href = response.redirectUrl;
                         } else {
                             alert("예약에 실패하였습니다.");
                         }
                     },
                     error: function(error) {
                         alert("예약 요청 중 오류가 발생했습니다.");
                         console.error("Error:", error);
                     }
                 });
             },
             error: function(error) {
                 console.error("Error:", error);
             }
         });
     });
 


     // 모달 닫기 버튼 클릭 시 모달 숨기기
     $(".close, #reserveCancel").on("click", function() {
         $("#reservationModal").modal("hide");
     });

     
 });



 
 
 // Ajax로 자산 목록 가져오기
	$.ajax({
	    url: "<%= ctxPath %>/roommain.kedai",
	    type: "GET",
	    dataType: "json", // 반환되는 데이터 타입 (JSON 형식)
	    success: function(json) {
	    	var assetOptions = "<option value=''>전체</option>";
            for (var i = 0; i < json.length; i++) {
                assetOptions += "<option value='" + json[i].roomMainSeq + "'>" + json[i].roomMainName + "</option>";
            }
            $("#assetSelect").html(assetOptions); // 자산 선택 드롭다운 업데이트

            // 돋보기 버튼 동적으로 추가
            var searchButtonHtml = '<button id="searchButton" class="search-button"><i class="fas fa-search"></i></button>';
            $("#buttonContainer").html(searchButtonHtml);

            // 자산 선택 드롭다운 변화 이벤트
            $('#assetSelect').change(function() {
                var selectedValue = $(this).val();
                
                if(!selectedValue){
                	 selectedRoomMainSeq = '0';
                     showallsub();
                     fetchReservations();
                }
                if (selectedValue) {
                    $("#buttonContainer").show(); // 선택된 값이 있으면 버튼 보이기
                    
                    var selectedRoomMainSeq = $(this).val(); // 선택된 roomMainSeq 값 가져오기

                    if (selectedRoomMainSeq > 1) {
                        $.ajax({
                            url: "<%= request.getContextPath() %>/roommain.kedai",
                            type: "GET",
                            dataType: "json",
                            data: {
                                roomMainSeq: selectedRoomMainSeq
                            },
                            success: function(json) {
                                var tableBody = $("#assetTableBody");
                                tableBody.empty(); // 기존 테이블 내용 초기화

                                json.forEach(function(item) {
                                    var roomSubSeq = item.roomSubSeq;
                                    var roomSubName = item.roomSubName;

                                    // 방 이름과 관련된 데이터가 있는 경우, 각 방 이름별로 시간 슬롯을 생성
                                    var row = $("<tr></tr>");
                                    var roomCell = $("<td>").text(roomSubName).addClass("room-name-cell");
                                    row.append(roomCell);

                                    for (var hour = 9; hour <= 21; hour++) {
                                        var cell1 = $("<td>")
                                            .addClass("time-slot")
                                            .data("hour", hour)
                                            .data("minute", "00")
                                            .append("<button class='reserveBtn' data-hour='" + hour + "' data-minute='00'></button>");

                                        var cell2 = $("<td>")
                                            .addClass("time-slot")
                                            .data("hour", hour)
                                            .data("minute", "30")
                                            .append("<button class='reserveBtn' data-hour='" + hour + "' data-minute='30'></button>");

                                        row.append(cell1);
                                        row.append(cell2);
                                    }

                                    tableBody.append(row); // 시간 슬롯이 포함된 행을 추가
                                });
                                fetchReservations();
                            },
                            error: function(request, status, error) {
                                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
                            }
                        });
                    } else {
                        // 선택이 해제된 경우, 두 번째 선택 박스 초기화
                        $("#additionalSelect").html("");
                    }
                    
                    
                } else {
                    $("#buttonContainer").hide(); // 전체가 선택되면 버튼 숨기기
                }
                
            });

            // 돋보기 버튼 클릭 이벤트
         // 돋보기 버튼 클릭 이벤트
            $('#searchButton').click(function() {
                var assetSelectValue = $('#assetSelect option:selected').val();
                var assetSelectText = $('#assetSelect option:selected').text().trim();
                
                // assetSelectValue를 사용하여 층 선택 여부를 판단
                if (assetSelectValue !== undefined && assetSelectValue !== null) {
                    if (assetSelectValue === '') {
                        alert("층을 선택해 주세요."); // 전체가 선택된 경우 경고 메시지
                    } else {
                        var imagePath = '<%= ctxPath %>/resources/images/room/' + assetSelectText + ' 도면도.jpg';
                        window.open(imagePath, '_blank'); // 새 탭에서 이미지 열기
                    }
                } else {
                    alert("층을 선택해 주세요."); // 전체가 선택된 경우 경고 메시지
                }
            });

	    
        },
        error: function(request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    });
	        
	  

	// 날짜 포맷팅 함수
	function formatDate(date) {
	        const year = date.getFullYear();
	        const month = ('0' + (date.getMonth() + 1)).slice(-2);
	        const day = ('0' + date.getDate()).slice(-2);
	        const dayOfWeek = ['일', '월', '화', '수', '목', '금', '토'][date.getDay()];
	        return year + '-' + month + '-' + day + ' (' + dayOfWeek + ')';
	    }
	
    // 시간을 HH:MM 형식으로 포맷팅하는 함수
    function formatTime(hour, minute) {
    	var formattedHour = ('0' + hour).slice(-2);
        var formattedMinute = ('0' + minute).slice(-2);
        return formattedHour + ':' + formattedMinute;
    }
	    
    function parseTime(timeString) {
        // 시간 문자열 "YYYY-MM-DD HH:mm:ss"에서 "HH:mm" 포맷으로 변환
        const timePart = timeString.split(' ')[1]; 
        return timePart.substring(0, 5); 
    }
	
	 // 오늘 날짜 설정
	    function setToday() {
	        const today = new Date();
	        const formattedToday = formatDate(today);
	        $("#currentDate").text(formattedToday);
	        $("#startDate").val(formattedToday);
	        $("#endDate").val(formattedToday);
	        
	        fetchReservations();
	    }


	    function changeDate(days) {
	        const currentDateElement = $("#currentDate");
	        const currentDateText = currentDateElement.text().split(' ')[0];
	        const currentDate = new Date(currentDateText);
	        currentDate.setDate(currentDate.getDate() + days);

	        const formattedDate = formatDate(currentDate);
	        currentDateElement.text(formattedDate);

	        // startDate와 endDate도 현재 날짜로 업데이트
	        $("#startDate").val(formattedDate);
	        $("#endDate").val(formattedDate);
	        
	        fetchReservations();
	    }

	    // 날짜 변경 버튼 클릭 핸들러
	    $(document).on("click", "[data-change-date]", function() {
	        const days = parseInt($(this).attr("data-change-date"));
	        changeDate(days);
	    });
	  
	    function showallsub() {
	        $.ajax({
	            url: "<%= ctxPath %>/roomall.kedai",
	            type: "GET",
	            dataType: "json", // 반환되는 데이터 타입 (JSON 형식)
	            success: function(json) {
	                var tableBody = $("#assetTableBody");
	                tableBody.empty(); // 기존 테이블 내용 초기화

	                json.forEach(function(item) {
	                    var roomSubSeq = item.roomSubSeq;
	                    var roomSubName = item.roomSubName;
	                    var row = $("<tr>");

	                    // 방 이름을 포함하는 셀을 생성하고 추가합니다
	                    var leftCell = $("<td>").text(roomSubName).addClass("room-name-cell");
	                    row.append(leftCell);

	                    for (var hour = 9; hour <= 21; hour++) {
	                        var cell1 = $("<td>")
	                            .addClass("time-slot")
	                            .data("hour", hour)
	                            .data("minute", "00")
	                            .data("roomname", roomSubName) // 방 이름을 설정
	                            .append("<button class='reserveBtn' data-hour='" + hour + "' data-minute='00'></button>");

	                        var cell2 = $("<td>")
	                            .addClass("time-slot")
	                            .data("hour", hour)
	                            .data("minute", "30")
	                            .data("roomname", roomSubName) // 방 이름을 설정
	                            .append("<button class='reserveBtn' data-hour='" + hour + "' data-minute='30'></button>");

	                        row.append(cell1);
	                        row.append(cell2);
	                    }

	                    tableBody.append(row); // 각 행을 테이블에 추가
	                });
	            },
	            error: function(request, status, error) {
	                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	            }
	        });
	    }

	    function fetchReservations() {
	        var selectedDate = $("#currentDate").text().substr(0, 10); // 현재 날짜 가져오기

	        $.ajax({
	            url: "<%= request.getContextPath() %>/getReservations.kedai",
	            type: "GET",
	            data: { date: selectedDate }, // 선택한 날짜로 요청
	            dataType: "json",
	            success: function(reservations) {
	                // 기존 강조 표시 제거
	                $("td.time-slot").removeClass("highlighted");

	                reservations.forEach(function(reservation) {
	                    var startReservationDate = reservation.startTime.substr(0, 10); // 예약 날짜
	                    var endReservationDate = reservation.endTime.substr(0, 10); // 예약 날짜
	                    var startTime = parseTime(reservation.startTime);
	                    var endTime = parseTime(reservation.endTime);
	                    var reservationRoomName = reservation.roomName;
	                    var reservationId = reservation.reserver;
	                    var reservation_seq = reservation.reservation_seq;

	                    // 예약 날짜가 현재 날짜와 일치하는 경우에만 처리
	                    if (startReservationDate === selectedDate) {
	                    	$("#reservationModal").hide();
	                        $("td.time-slot").each(function() {
	                            var self = this;
	                            var cellHour = $(this).data('hour');
	                            var cellMinute = $(this).data('minute');
	                            
	                            var $row = $(this).closest('tr');
	                            cellRoomName = $row.find('td.room-name-cell').text().trim();
	                            
	                            /* // assetSelect 요소의 값 가져오기
	                            var assetSelectValue = $('#assetSelect option:selected').text();
	                            if (assetSelectValue != "전체") {
	                                cellRoomName = assetSelectValue + cellRoomName;
	                            }
	                            */
	                            var cellTime = formatTime(cellHour, cellMinute);
 	                            
	                            $.ajax({
	                                url: '<%= request.getContextPath() %>/getRoomData.kedai',
	                                method: 'GET',
	                                data: { subroom: cellRoomName },
	                                success: function(response) {
	                                    if (Array.isArray(response) && response.length > 0) {
	                                        var data = response[0] || {};
	                                        var roomMainName = data.ROOMMAINNAME || '';
	                                        var roomSubName = data.ROOMSUBNAME || '';
	                                        var cellRoomFullName = roomMainName + roomSubName;
	                                        
	                                        if (cellRoomFullName === reservationRoomName && cellTime >= startTime && cellTime < endTime) {
	                                            $(self).addClass("highlighted");

	                                            $(self).off('click').on('click', function() {
	                                                window.location.href = "<%= request.getContextPath() %>/reservation_detail.kedai?reservation_seq=" + encodeURIComponent(reservation_seq);
	                                            });
	                                        }
	                                    } else {
	                                        console.warn("유효한 데이터가 없습니다.");
	                                    }
	                                },
	                                error: function(request, status, error) {
	                                    console.error("예약 정보 가져오기 오류:", {
	                                        readyState: request.readyState,
	                                        status: request.status,
	                                        statusText: request.statusText,
	                                        responseText: request.responseText
	                                    });
	                                }
	                            });
	                        });
	                    }
	                });
	            },
	            error: function(request, status, error) {
	                console.error("예약 정보 가져오기 오류:", {
	                    readyState: request.readyState,
	                    status: request.status,
	                    statusText: request.statusText,
	                    responseText: request.responseText
	                });
	            }
	        });
	    }



 </script>

 <div class="header">
    <div class="title">
        <h3 style="margin-top: 20%;">예약</h3>
    </div>
</div>
<div style="width: 85%;">
    <div class="assets" style="display: flex;">
       <!-- 자산 선택 드롭다운 -->
        <select id="assetSelect">
            <!-- Ajax 호출 후 동적으로 추가됩니다 -->
        </select>
        
        <!-- 버튼을 동적으로 추가할 컨테이너 -->
        <div id="buttonContainer"></div>
        <hr />
    </div>
</div>
<br>
<div class="header">
    <div class="date-navigation">
        <button onclick="changeDate(-1)">&lt;</button>
        <button id="currentDate"></button>
        <button onclick="changeDate(1)">&gt;</button>
        <button onclick="setToday()" style="font-size: 10pt;">오늘</button>
    </div>
</div>
<div id="datepicker" style="display:none;"></div>
<table>
    <thead>
        <tr>
            <td>
                <c:forEach var="hour" begin="9" end="21">
                    <th colspan="2">${hour}</th>
                </c:forEach>
            </td>
        </tr>
    </thead>
    <tbody id="assetTableBody">
        <!-- 여기에 예약 가능한 자산 목록을 Ajax로 가져오기 -->
    </tbody>
</table>
<hr style="margin-top: 1%; width: 85%;" />

<!-- 모달 -->
<div class="modal fade" id="reservationModal" tabindex="-1" role="dialog" aria-labelledby="reservationModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- 모달 헤더 -->
            <div class="modal-header">
                <h4 class="modal-title" id="reservationModalLabel">예약</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <!-- 모달 바디 -->
            <div class="modal-body">
                <form id="reservationForm">
                    <div class="form-group">
                        <label for="reservationDate">예약일</label>
                        <div class="date-time-group">
                            <input type="text" id="startDate" class="date-input" readonly>
                            <div class="form-group">
                                <select id="startTime" class="form-control">
                                    <!-- 시간 옵션이 동적으로 추가될 것입니다 -->
                                </select>
                            </div>
                            ~
                            <input type="text" id="endDate" class="date-input" readonly>
                            <div class="form-group">
                                <select id="endTime" class="form-control">
                                    <!-- 시간 옵션이 동적으로 추가될 것입니다 -->
                                </select>
                            </div>
                        </div>
                        <label for="allDay" class="checkbox-label">
                            <input type="checkbox" id="allDay"> 종일
                        </label>
                    </div>
                    <div class="form-group">
                        <label for="reserver">예약자</label>
                        <input type="text" class="form-control" id="reserver" value="${sessionScope.loginuser.name} ${sessionScope.loginuser.job_name}" readonly />
                    </div>
                    <div class="form-group">
                        <label for="purpose">목적</label>
                        <input type="text" class="form-control" id="purpose">
                    </div>
                </form>
            </div>
            <!-- 모달 푸터 -->
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="reserve_submit">확인</button>
                <button type="button" class="btn btn-secondary" id="reserveCancel" data-dismiss="modal">취소</button>
            </div>
            <input type="hidden" id="reserver_end" value="${sessionScope.loginuser.empid}" />
        </div>
    </div>
</div>
        
</body>
</html>