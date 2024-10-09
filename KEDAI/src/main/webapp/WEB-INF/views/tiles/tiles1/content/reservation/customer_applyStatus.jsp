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
        <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/customer_applyStatus.kedai">카셰어링신청현황(신청자)</a>
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
                            <th style="text-align: center;">차주</th>
                            <th style="text-align: center;">출발지</th>
                            <th style="text-align: center;">도착지</th>
                            <th style="text-align: center;">진행여부</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${not empty requestScope.customer_applyStatusList}">
                            <c:forEach var="customer_applyStatus" items="${requestScope.customer_applyStatusList}" varStatus="status">
                                <tr>
                                    <td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
                                    <td align="center">${customer_applyStatus.share_date}</td>
                                    <td align="center">${customer_applyStatus.share_may_time}</td>
                                    <td align="center">${customer_applyStatus.nickname_owner}</td>
                                    <td align="center" class="rdp_name">${customer_applyStatus.rdp_name} </td>
                                    <td align="center" class="rds_name">${customer_applyStatus.rds_name}</td>
									<c:if test="${customer_applyStatus.accept_yon eq 0 && empty customer_applyStatus.getin_time && empty customer_applyStatus.getout_time }">
										<td align="center">확인중</td>
									</c:if>
									<c:if test="${customer_applyStatus.accept_yon eq 1 && empty customer_applyStatus.getin_time && empty customer_applyStatus.getout_time }">
										<td align="center">탑승전</td>
									</c:if>
									<c:if test="${customer_applyStatus.accept_yon eq 2 }">
										<td align="center">탑승거부</td>
									</c:if>
									<c:if test="${customer_applyStatus.accept_yon eq 1 && not empty customer_applyStatus.getin_time && empty customer_applyStatus.getout_time }">
										<td align="center">탑승중</td>
									</c:if>
									<c:if test="${customer_applyStatus.accept_yon eq 1 && not empty customer_applyStatus.getin_time && not empty customer_applyStatus.getout_time && customer_applyStatus.nonpayment_amount ne 0}">
										<td align="center">결제전</td>
									</c:if>
									<c:if test="${customer_applyStatus.accept_yon eq 1 && not empty customer_applyStatus.getin_time && not empty customer_applyStatus.getout_time && customer_applyStatus.nonpayment_amount eq 0 && customer_applyStatus.payment_amount ne 0}">
										<td align="center">결제완료</td>
									</c:if>
                                </tr>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty requestScope.customer_applyStatusList}">
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

