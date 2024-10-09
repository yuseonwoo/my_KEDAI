<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<%
   String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예약 상세 정보</title>
 <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container_reservation_detail {
            width: 80%;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
            margin-top: 2%;
        }
        h1 {
            margin-bottom: 50px;
        }
        .details {
            margin-bottom: 30px;
        }
        .details div {
            margin-bottom: 10px;
        }
        .buttons {
            text-align: center;
        }
        .buttons a {
            display: inline-block;
            margin: 5px;
            padding: 10px 20px;
            font-size: 16px;
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            border-radius: 5px;
        }
        .buttons a.edit {
            background-color: #28a745;
        }
        .buttons a.cancel {
            background-color: #dc3545;
        }
        .buttons a.back {
            background-color: #6c757d;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: flex;
            align-items: center;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
            font-size: 16px;
        }
        .date-time-group {
            display: flex;
            align-items: center;
        }
        /* 공통 버튼 스타일 */
		button {
		    display: inline-block;
		    margin: 5px;
		    padding: 10px 20px;
		    font-size: 16px;
		    text-decoration: none;
		    border: none;
		    border-radius: 5px;
		    cursor: pointer;
		    color: #fff;
		    transition: background-color 0.3s ease, box-shadow 0.3s ease;
		}
		
		/* 예약 수정하기 버튼 스타일 */
		.editButton {
		    background-color: #28a745; /* 초록색 배경 */
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		.editButton:hover {
		    background-color: #218838; /* 호버 시 다크 초록색 */
		    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.2);
		}
		
		/* 예약 취소하기 버튼 스타일 */
		.delButton {
		    background-color: #dc3545; /* 빨간색 배경 */
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		.delButton:hover {
		    background-color: #c82333; /* 호버 시 다크 빨간색 */
		    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.2);
		}
		    
		.backButton {
		    background-color: #6c757d; /* 호버 시 버튼 색상 */
		}
 
		.backButton:hover {
		    background-color: #5a6268; /* 호버 시 버튼 색상 */
		}
		
		
        
    </style>
    
    
    <script>
    $(function() {
        populateTimeSelect();
        setInitialTimes();
        
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
       
       //	수정하기 기능 구현
       var reservationSeq = "${reservation.reservation_seq}"; // JSP 변수를 JavaScript 변수로 전달

       $(".editButton").on("click", function() {
           // 입력값을 가져옵니다.
           var startDate = $("#startDate").val(); // 예: "2024-07-25 (목)"
           var startTime = $("#startTime").val(); // 예: "13:00"
           var endDate = $("#endDate").val(); // 예: "2024-07-25 (목)"
           var endTime = $("#endTime").val(); // 예: "14:00"
           var purpose = $("#content").val();
           var reserver = $("#reserver_end").val();
           

           // 날짜와 시간을 포맷팅합니다.
           var formattedStartDateTime = startDate.substring(0, 10) + ' ' + startTime;
           var formattedEndDateTime = endDate.substring(0, 10) + ' ' + endTime;

           // 예약 데이터 객체를 생성합니다.
           var reservationData = {
               reserver: reserver,
               roomname: $("#roomName").text(), // 회의실 이름
               purpose: purpose,
               startDateTime: formattedStartDateTime,
               endDateTime: formattedEndDateTime,
           		    
           };

           // AJAX 요청을 보내 예약 데이터를 서버에 전송합니다.
           $.ajax({
               url: '<%= ctxPath%>/update_reservation.kedai?reservation_seq=' + encodeURIComponent("${reservation.reservation_seq}"), // URL에 쿼리 파라미터 추가
               type: 'POST',
               contentType: 'application/json',
               data: JSON.stringify(reservationData),
               success: function(response) {
                   if (response.success) {
                       alert("예약이 수정되었습니다.");
                       if (response.redirectUrl) {
                           window.location.href = response.redirectUrl;
                       }
                   } else {
                       alert("예약 수정에 실패하였습니다.");
                   }
               },
               error: function(error) {
                   alert("예약 수정 요청 중 오류가 발생했습니다.");
                   console.error("Error:", error);
               }
           });
       });
   	
    
    
       $(".delButton").on("click", function() {
    	    // 사용자에게 취소 확인 대화상자를 표시합니다.
    	    var confirmCancel = confirm("정말 취소하시겠습니까?\n취소된 예약은 복구 불가합니다.");
    	    
    	    // 사용자가 "확인"을 선택한 경우에만 AJAX 요청을 보냅니다.
    	    if (confirmCancel) {
    	        // AJAX 요청을 보내 예약 데이터를 서버에 전송합니다.
    	        $.ajax({
    	            url: '<%= ctxPath%>/delete_reservation.kedai?reservation_seq=' + encodeURIComponent("${reservation.reservation_seq}"), // URL에 쿼리 파라미터 추가
    	            type: 'POST',
    	            contentType: 'application/json',
    	            data: "json",
    	            success: function(response) {
    	                if (response.success) {
    	                    alert("예약이 취소되었습니다.");
    	                    if (response.redirectUrl) {
    	                        window.location.href = response.redirectUrl;
    	                    }
    	                } else {
    	                    alert("예약 취소에 실패하였습니다.");
    	                }
    	            },
    	            error: function(error) {
    	                alert("예약 취소 요청 중 오류가 발생했습니다.");
    	                console.error("Error:", error);
    	            }
    	        });
    	    } else {
    	        // 사용자가 "취소"를 선택한 경우 아무 작업도 하지 않습니다.
    	        //	console.log("예약 취소가 취소되었습니다.");
    	    }
    	});

	});	
    
	// 날짜 포맷팅 함수
	function formatDate(date) {
	        const year = date.getFullYear();
	        const month = ('0' + (date.getMonth() + 1)).slice(-2);
	        const day = ('0' + date.getDate()).slice(-2);
	        const dayOfWeek = ['일', '월', '화', '수', '목', '금', '토'][date.getDay()];
	        return year + '-' + month + '-' + day + ' (' + dayOfWeek + ')';
	    }

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
        startTimeSelect.empty(); // 기존 옵션 제거
        timeOptions.forEach(function(time) {
            startTimeSelect.append($("<option>").val(time).text(time));
        });

        // 종료 시간 드롭다운에 옵션 추가
        endTimeSelect.empty(); // 기존 옵션 제거
        timeOptions.forEach(function(time) {
            endTimeSelect.append($("<option>").val(time).text(time));
        });
    }

    function updateEndTimeOptions() {
        var startTime = $("#startTime").val();
        //	console.log("Start time value: ", startTime); // 디버깅을 위한 로그 추가

        if (!startTime) {
            console.error("Start time is not set. Ensure that start time is properly assigned.");
            return; // startTime이 null일 경우 함수 종료
        }

        var endTimeSelect = $("#endTime");
        var timeOptions = [];
        var startHour = parseInt(startTime.split(':')[0]);
        var startMinute = parseInt(startTime.split(':')[1]);

        // 09:00부터 22:00까지 30분 단위의 시간 옵션을 생성
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
            endTimeSelect.append($("<option>").val(time).text(time));
        });

        // 종료 시간을 시작 시간보다 30분 후로 설정
        var endTime = timeOptions.find(time => time >= formatTime(startHour, startMinute + 30));
        if (endTime) {
            endTimeSelect.val(endTime);
        }
    }

    function formatTime(hour, minute) {
        if (minute >= 60) {
            hour += Math.floor(minute / 60);
            minute = minute % 60;
        }
        var formattedHour = ('0' + hour).slice(-2);
        var formattedMinute = ('0' + minute).slice(-2);
        return formattedHour + ':' + formattedMinute;
    }

    function setInitialTimes() {
        var startTime = "${formattedStartTime}";
        var endTime = "${formattedEndTime}";

        $("#startTime").val(startTime);
        $("#endTime").val(endTime);

        updateEndTimeOptions();
    }
    
    
   
</script>
    
</head>
<body>
     <div class="container_reservation_detail">
        <h1>예약 상세 정보</h1>
        <c:if test="${empty reservation}">
            <p>예약 정보가 없습니다.</p>
        </c:if>
        <c:if test="${not empty reservation}">
            <div class="details">
                <div class="form-group">
                    <label for="roomName">회의실:<span style="margin: 0 10px;" id="roomName">${reservation.fk_room_name}</span></label>
                </div>
                <div class="form-group">
                    <label for="empId">예약자: <span style="margin: 0 10px;">${reservation.fk_empid}</span></label>
                </div>

                 <div class="form-group">
				    <label for="reservationDate">
				        예약일: 
				        <span class="date-time-group" style="margin: 0 10px;">
				            <input type="text" id="startDate" class="date-input" value="${formattedStartDate}" readonly>
				            <select id="startTime" class="form-control">
				                <option value="${formattedStartTime}">${formattedStartTime}</option>
				                <!-- 다른 시간 옵션도 여기에 추가할 수 있습니다 -->
				            </select>
				            ~
				            <input type="text" id="endDate" class="date-input" value="${formattedEndDate}" readonly>
				            <select id="endTime" class="form-control">
				                <option value="${formattedEndTime}">${formattedEndTime}</option>
				                <!-- 시간 옵션이 동적으로 추가될 것입니다 -->
				            </select>
				        </span>
				    </label>
				</div>
                <div class="form-group">
				    <label for="content">목적:
				    <span style="margin-left: 10px;">
				        <input type="text" id="content" value="${reservation.content}" style="width: 1000px;">
				    </span></label>
				</div>
            </div>
        </c:if>
        <div class="buttons">
            <button type="button" class="backButton" onclick="window.history.back();">목록으로 돌아가기</button>
             <button type="submit" class="editButton">예약 수정하기</button>
             <button type="submit" class="delButton">예약 취소하기</button>
        </div>
        
        <input type="hidden" id="reserver_end" value="${sessionScope.loginuser.empid}" />
    </div>
</body>
</html>