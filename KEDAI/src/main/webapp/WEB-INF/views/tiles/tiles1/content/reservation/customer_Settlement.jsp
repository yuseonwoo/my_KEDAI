<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
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
</style>

<script type="text/javascript">
function goPayment(index, nonpayment_amount, empid_owner, pf_empid) {
    const now = new Date();

    let month = now.getMonth() + 1;
    if (month < 10) {
        month = "0" + month;
    }

    let date = now.getDate();
    if (date < 10) {
        date = "0" + date;
    }

    let strNow = now.getFullYear() + "년 " + month + "월 " + date + "일";

    // nonpayment_amount 값을 정수로 변환
    let intNonpaymentAmount = Math.floor(nonpayment_amount);
/* 
    // 파라미터 값 출력
    console.log("nonpayment_amount:", intNonpaymentAmount);
    console.log("empid_owner:", empid_owner);
    console.log("pf_empid:", pf_empid); */

    if (confirm("*** 카셰어링 정산하기 ***\n\n" + strNow + "\n" + intNonpaymentAmount + "point 를 결제하시겠습니까?")) {
        $.ajax({
            url: "<%= ctxPath %>/payment.kedai",
            type: "GET",
            data: {
                nonpayment_amount: intNonpaymentAmount,
                empid_owner: empid_owner,
                pf_empid: pf_empid
            },
            success: function(response) {
                alert("포인트 정산이 완료되었습니다.");
                location.href = "<%= ctxPath %>/index.kedai";
            },
            error: function(xhr, status, error) {
                alert("포인트 정산에 실패하였습니다. 다시 시도해 주세요.");
            }
        });
    }
}

</script>



<%-- content start --%>	
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
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/owner_Settlement.kedai">카셰어링정산(차주)</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_applyStatus.kedai">카셰어링신청현황(신청자)</a>
    </li>
    <li class="nav-item">
        <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/customer_Settlement.kedai">카셰어링정산(신청자)</a>
    </li>
</ul>



    <div style="display: flex; border: solid 0px red; width: 100%;">
        <div style="margin: auto; width: 100%">
            <div style="overflow-x: auto;"> <!-- 해당 페이지에서는 미결제건만 볼수 있음 -->
                <table style="width: 100%; margin-top: 1%;" class="table table-bordered">
                    <thead>
                        <tr>
                            <th style="text-align: center;">no</th>
                            <th style="text-align: center;">일자</th>
                            <th style="text-align: center;">차주</th>
                            <th style="text-align: center;">탑승시간</th>
                            <th style="text-align: center;">탑승위치</th>
                            <th style="text-align: center;">하차시간</th>
                            <th style="text-align: center;">하차위치</th>
                            <th style="text-align: center;">이용시간</th>
                            <th style="text-align: center;">정산금액</th>
                            <th style="text-align: center;">결제금액</th>
                            <th style="text-align: center;">미결제금액</th>
                            <th style="text-align: center;">결제하기</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${not empty requestScope.customer_SettlementList}">
                            <c:forEach var="customer_Settlement" items="${requestScope.customer_SettlementList}" varStatus="status">
                            	
                                <tr>
                                    <td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
                                    <td align="center">${customer_Settlement.share_date}</td>
                                    <td align="center">${customer_Settlement.nickname_owner}</td>
                                    <td align="center">${customer_Settlement.getin_time}</td>
                                    <td align="center" class="rdp_name">${customer_Settlement.rdp_name} </td>
                                    <td align="center">${customer_Settlement.getout_time}</td>
                                    <td align="center" class="rds_name">${customer_Settlement.rds_name}</td>
                                    <td align="center">${customer_Settlement.use_time}분</td>
                                    <td align="center">
                                        <fmt:formatNumber value="${customer_Settlement.settled_amount}" type="number" maxFractionDigits="0"/><span>point</span>
                                    </td>
                                    <td align="center">
                                        <fmt:formatNumber value="${customer_Settlement.payment_amount}" type="number" maxFractionDigits="0"/><span>point</span>
                                    </td>
                                    <td align="center">
                                        <fmt:formatNumber value="${customer_Settlement.nonpayment_amount}" type="number" maxFractionDigits="0"/><span>point</span>
                                    </td>
									<c:if test="${customer_Settlement.payment_amount == 0}">
									    <td align="center" style="background-color:#2c4459;">
									        <button type="button" style="border:none; background-color: #2c4459; color: white; font-size: 15pt; font-weight:300;" 
									                onclick="goPayment(${status.index}, ${customer_Settlement.nonpayment_amount}, '${customer_Settlement.empid_owner}', '${customer_Settlement.pf_empid}')">PAY</button>
									    </td>
									</c:if>
									<c:if test="${customer_Settlement.payment_amount != 0}">
									    <td align="center">
									        결제완료
									    </td>
									</c:if>

                                </tr>
                                
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty requestScope.customer_SettlementList}">
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

