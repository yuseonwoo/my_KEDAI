<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<style type="text/css">
    /* 360px 이하 */  /* 일반적으로 휴대폰 세로 */
    @media screen and (max-width: 360px){
       div#search {
          padding-left: 0 !important;
       }
       
       div#nav button {
          width: 100%;
       }   
    }
    
    /* 361px ~ 767px 이하 */  /* 일반적으로 휴대폰 가로 */
    @media screen and (min-width: 361px) and (max-width: 767px){
       div#search {
          padding-left: 0 !important;
       }
       
       div#nav button {
          width: 100%;
       }
    } 
    
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

/* 텍스트 상자 시작 */
.tooltip {
    position: relative;
    display: inline-block;
    cursor: pointer;
}

.tooltip .tooltiptext {
    visibility: hidden;
    width: 200px;
    background-color: #555;
    color: #fff;
    text-align: center;
    border-radius: 5px;
    padding: 5px 0;
    position: absolute;
    z-index: 1;
    bottom: 125%; /* 위치 조정 */
    left: 50%;
    margin-left: -100px;
    opacity: 0;
    transition: opacity 0.3s;
}

.tooltip .tooltiptext::after {
    content: "";
    position: absolute;
    top: 100%; /* 화살표 위치 조정 */
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: #555 transparent transparent transparent;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
    opacity: 1;
}
/* 텍스트 상자 끝 */

table {
    white-space: nowrap; /* 테이블 셀 안의 내용이 줄 바꿈되지 않도록 함 */
}
</style>

<script type="text/javascript">
$(document).ready(function() {
    // 기존 로직 유지
});

function formatDateToDB(date) {
    var year = date.getFullYear();
    var month = ('0' + (date.getMonth() + 1)).slice(-2);
    var day = ('0' + date.getDate()).slice(-2);
    var hours = ('0' + date.getHours()).slice(-2);
    var minutes = ('0' + date.getMinutes()).slice(-2);
    var seconds = ('0' + date.getSeconds()).slice(-2);
    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

function showButtons(id) {
    var element = document.getElementById(id);
    if (element.style.display === "none") {
        element.style.display = "block";
    } else {
        element.style.display = "none";
    }
}

function showCurrentTime(buttonType, rowId) {
    var currentTime = new Date();
    var formattedTime = formatDateToDB(currentTime);
    var driveInButton = document.getElementById('drive_in_btn_' + rowId);
    var driveOutButton = document.getElementById('drive_out_btn_' + rowId);
    
    // pf_res_num과 pf_empid 가져오기
    var pf_res_num = document.getElementById('pf_res_num_' + rowId).value;
    var pf_empid = document.getElementById('pf_empid_' + rowId).value;
    var getin_time = document.getElementById('getin_time_' + rowId).value;
    var getout_time = document.getElementById('getout_time_' + rowId).value;
    
    if (buttonType === 'drive_in') {
        document.getElementById('drive_in_time_' + rowId).value = formattedTime;
        alert("승차 시간: " + formattedTime);
        driveOutButton.disabled = false;

        $.ajax({
            url: '<%= ctxPath %>/mobile_time.kedai',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                drive_in_time: formattedTime,
                row_id: rowId,
                pf_res_num: pf_res_num,
                pf_empid: pf_empid,
                getin_time: getin_time,
                getout_time: getout_time
            }),
            success: function(response) {
                console.log("Drive-in time updated successfully.");
                location.reload(); // 페이지 새로고침
            },
            error: function(error) {
                console.error("Error updating drive-in time:", error);
            }
        });
    } else if (buttonType === 'drive_out') {
        document.getElementById('drive_out_time_' + rowId).value = formattedTime;
        alert("하차 시간: " + formattedTime);

        $.ajax({
            url: '<%= ctxPath %>/mobile_time.kedai',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                drive_out_time: formattedTime,
                row_id: rowId,
                pf_res_num: pf_res_num,
                pf_empid: pf_empid,
                getin_time: getin_time,
                getout_time: getout_time
            }),
            success: function(response) {
                console.log("Drive-out time updated successfully.");
                alert("ajax 성공~~~");
                location.reload(); // 페이지 새로고침
            },
            error: function(error) {
                console.error("Error updating drive-out time:", error);
                alert("~~~error :" +  error);
            }
        });

        driveInButton.disabled = true;
    }
}
</script>

<div style="border: 0px solid red; padding: 2% 0; width: 90%;">

    <div style="display: flex; border: solid 0px red; width: 100%;">
        <div style="margin: auto; width: 100%">
        <div>${requestScope.todayStr }</div>
            <div style="overflow-x: auto;"> <!-- 가로 스크롤바 추가 -->
                <table style="width: 100%; margin-top: 1%;" class="table table-bordered">
                    <thead>
                        <tr>
                        	<th style="text-align: center;">no</th>
                            <th style="text-align: center;">출발예정시각</th>
                            <th style="text-align: center;">탑승자</th>
                            <th style="text-align: center;">탑승위치</th>
                            <th style="text-align: center;">하차위치</th>
                            <th style="text-align: center;">승차</th>
                            <th style="text-align: center;">하차</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${not empty requestScope.owner_SettlementList_mobile}">
							<c:forEach var="owner_carShare" items="${requestScope.owner_SettlementList_mobile}" varStatus="status">
							    <tr>
							        <input type="hidden" id="pf_res_num_${status.index}" value="${owner_carShare.pf_res_num}" />
							        <input type="hidden" id="pf_empid_${status.index}" value="${owner_carShare.pf_empid}" />
							        <input type="hidden" id="getin_time_${status.index}" value="${owner_carShare.getin_time}" />
							        <input type="hidden" id="getout_time_${status.index}" value="${owner_carShare.getout_time}" />
							        <td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
							        <td align="center">${owner_carShare.share_may_time}</td>
							        <td align="center">${owner_carShare.nickname_applicant}</td>
							        <td align="center" class="rdp_name">${owner_carShare.rdp_name}</td>
							        <td align="center" class="rds_name">${owner_carShare.rds_name}</td>
							        <c:choose>
                                        <c:when test="${not empty owner_carShare.getin_time && empty owner_carShare.getout_time}">
                                            <td align="center" class="drive_in">
                                                <button id="drive_in_btn_${status.index}" onclick="showCurrentTime('drive_in', ${status.index})" disabled>승차</button>
                                                <input type="hidden" id="drive_in_time_${status.index}" name="drive_in_time_${status.index}" />
                                            </td>
                                            <td align="center" class="drive_out">
                                                <button id="drive_out_btn_${status.index}" onclick="showCurrentTime('drive_out', ${status.index})">하차</button>
                                                <input type="hidden" id="drive_out_time_${status.index}" name="drive_out_time_${status.index}" />
                                            </td>
                                        </c:when>
                                        <c:when test="${not empty owner_carShare.getin_time && not empty owner_carShare.getout_time}">
                                            <td align="center">완료</td>
                                            <td align="center">완료</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td align="center" class="drive_in">
                                                <button id="drive_in_btn_${status.index}" onclick="showCurrentTime('drive_in', ${status.index})">승차</button>
                                                <input type="hidden" id="drive_in_time_${status.index}" name="drive_in_time_${status.index}" />
                                            </td>
                                            <td align="center" class="drive_out">
                                                <button id="drive_out_btn_${status.index}" onclick="showCurrentTime('drive_out', ${status.index})" disabled>하차</button>
                                                <input type="hidden" id="drive_out_time_${status.index}" name="drive_out_time_${status.index}" />
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
							    </tr>
							</c:forEach>
                        </c:if>
                        <c:if test="${empty requestScope.owner_SettlementList_mobile}">
                            <tr>
                                <td colspan="13">데이터가 존재하지 않습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div> <!-- 가로 스크롤바 끝 -->
            <div id="pageBar" align="center" style="border: solid 0px gray; width: 50%; margin: 1.5% auto;">
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
