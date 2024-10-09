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

function request_payment(index, pf_empid, pf_res_num, nickname_applicant, email_applicant, nonpayment_amount) {

    console.log("pf_empid: ", pf_empid);
    console.log("pf_res_num: ", pf_res_num);
    console.log("nickname_applicant: ", nickname_applicant);
    console.log("email_applicant: ", email_applicant);
    console.log("nonpayment_amount: ", nonpayment_amount);
    //var formattedEmailApplicant = parseInt(email_applicant);
    frmnonpayment_amount = Math.floor(nonpayment_amount);
    $.ajax({
        url: "<%=ctxPath%>/request_payment_owner.kedai",
        type: 'GET',
        data: {
            pf_empid: pf_empid,
            pf_res_num: pf_res_num,
            nickname_applicant: nickname_applicant,
            email_applicant: email_applicant,
            nonpayment_amount: frmnonpayment_amount
        },
        success: function(response) {
            // 메일 전송이 성공한 경우 사용자에게 알림을 표시합니다.
            alert('메일이 성공적으로 전송되었습니다.');
        },
        error: function(xhr, status, error) {
            console.error('메일 전송 중 오류 발생:', error);
            console.log('상태 코드:', status);
            console.log('응답 텍스트:', xhr.responseText);
            alert('메일 전송 중 오류가 발생했습니다. 다시 시도해 주세요.');
        }
    });
}

</script>

<div style="border: 0px solid red; padding: 2% 0; width: 90%;">
    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs" style="margin-bottom:4%;">
        <li class="nav-item">
            <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/myCar.kedai">차량정보</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/owner_Status.kedai">카셰어링현황(차주)</a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/owner_Settlement.kedai">카셰어링정산(차주)</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_applyStatus.kedai">카셰어링신청현황(신청자)</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_Settlement.kedai">카셰어링정산(신청자)</a>
        </li>
    </ul>
     
    <div style="display: flex; border: solid 0px red; width: 100%;">
        <div style="margin: auto; width: 100%">
            <div style="overflow-x: auto;"> <!-- 가로 스크롤바 추가 -->
                <table style="width: 100%; margin-top: 1%;" class="table table-bordered">
                    <thead>
                        <tr>
                            <th style="text-align: center;">no</th>
                            <th style="text-align: center;">일자</th>
                            <th style="text-align: center;">출발예정시각</th>
                            <th style="text-align: center;">탑승자</th>
                            <th style="text-align: center;">탑승여부</th>
                            <th style="text-align: center;">탑승위치</th>
                            <th style="text-align: center;">탑승시간</th>
                            <th style="text-align: center;">하차위치</th>
                            <th style="text-align: center;">하차시간</th>
                            <th style="text-align: center;">이용시간</th>
                            <th style="text-align: center;">정산금액</th>
                            <th style="text-align: center;">결제금액</th>
                            <th style="text-align: center;">미결제금액</th>
                            <th style="text-align: center;">메일보내기</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${not empty requestScope.owner_SettlementList}">
                            <c:forEach var="owner_carShare" items="${requestScope.owner_SettlementList}" varStatus="status">
                                <tr>
                                    <td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
                                    <td align="center">${owner_carShare.share_date}</td>
                                    <td align="center">${owner_carShare.share_may_time}</td>
                                    <td align="center">${owner_carShare.nickname_applicant}</td>
                                    <c:if test="${not empty owner_carShare.getin_time and not empty owner_carShare.getout_time }">
                                        <td align="center"><i class="fa-solid fa-circle"></i></td>
                                    </c:if>
                                    <c:if test="${empty owner_carShare.getin_time or empty owner_carShare.getout_time }">
                                        <td align="center"><i class="fa-solid fa-xmark"></i></td>
                                    </c:if>
                                    <td align="center" class="rdp_name">${owner_carShare.rdp_name} </td>
                                    <td align="center"><input type="text" style="border: none; font-size: 15pt;" name="getin_time_${status.index}" value="${owner_carShare.getin_time}" readonly/></td>
                                    <td align="center" class="rds_name">${owner_carShare.rds_name}</td>
                                    <td align="center"><input type="text" style="border: none; font-size: 15pt;" name="getout_time_${status.index}" value="${owner_carShare.getout_time}" readonly/></td>
                                    <c:if test="${not empty owner_carShare.getin_time and not empty owner_carShare.getout_time }">
                                        <td align="center" style="color: red;">${owner_carShare.use_time}분</td>
                                    </c:if>
                                    <c:if test="${empty owner_carShare.getin_time or empty owner_carShare.getout_time }">
                                        <td align="center"><i class="fa-solid fa-xmark"></i></td>
                                    </c:if>
									<td align="center">
									    <c:choose>
									        <c:when test="${owner_carShare.settled_amount ne 0}">
									            <fmt:formatNumber value="${owner_carShare.settled_amount}" type="number" /><span>point</span>
									        </c:when>
									        <c:otherwise>
									            <i class="fa-solid fa-xmark"></i>
									        </c:otherwise>
									    </c:choose>
									</td>
									
									<td align="center">
									    <c:choose>
									        <c:when test="${owner_carShare.payment_amount ne 0}">
									            <fmt:formatNumber value="${owner_carShare.payment_amount}" type="number" /><span>point</span>
									        </c:when>
									        <c:otherwise>
									            <i class="fa-solid fa-xmark"></i>
									        </c:otherwise>
									    </c:choose>
									</td>
									
									<td align="center">
									    <c:choose>
									        <c:when test="${owner_carShare.settled_amount eq 0}">
									           	 이용전
									        </c:when>
									        <c:when test="${owner_carShare.nonpayment_amount ne 0.0}">
									            <fmt:formatNumber value="${owner_carShare.nonpayment_amount}" type="number" /><span>point</span>
									        </c:when>
									        <c:otherwise>
									            <i class="fa-solid fa-xmark"></i>
									        </c:otherwise>
									    </c:choose>
									</td>
									<c:if test="${owner_carShare.settled_amount eq 0}">
									    <td align="center"> </td>
									</c:if>
									<c:if test="${owner_carShare.settled_amount ne 0 && owner_carShare.payment_amount eq 0}">
									    <td align="center">
										    <button type="button" style="background-color:white;" 
										        onclick="request_payment('${status.index}', '${owner_carShare.pf_empid}', '${owner_carShare.pf_res_num}', '${owner_carShare.nickname_applicant}', '${owner_carShare.email_applicant}', '${owner_carShare.nonpayment_amount}')">
										        <i class="fa-solid fa-comments"></i>
										    </button>
										</td>
									</c:if>
                                	<c:if test="${owner_carShare.settled_amount ne 0 && owner_carShare.payment_amount ne 0}">
									    <td align="center">
										    결제완료
										</td>
									</c:if>
                                </tr>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty requestScope.owner_SettlementList}">
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