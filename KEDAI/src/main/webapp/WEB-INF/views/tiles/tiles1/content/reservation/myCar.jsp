<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
.itemTag {
    display: block;
    width: 340px;
    height: 48px; 
    border: 1px solid #00a1e4; 
    text-align: center; 
    margin: 16px auto; 
    color: #00a1e4; 
    font-size: 15px;
    line-height: 48px;
    font-weight: bold;
}	
.btnRegister button {
	border-radius: 25px;
	color: #fff;
	width: 200px;
	height: 50px;
}
.btnRegister button:nth-child(1) {
	background: #2c4459;
	margin-right: 10px;
}
.btnRegister button:nth-child(2) {
	background: #e68c0e;
}
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


// Function Declaration
function goEdit(){
    // 폼 제출 로직
    const frm = document.editFrm;
    frm.action = "<%= ctxPath%>/myCarEdit.kedai"; 
    frm.method = "post";
    frm.submit();
} // end of function goRegister() ----------

function goBack(){
	location.href="javascript:history.back();"
} // end of function goReset() ----------

function goRegister(){
	location.href=`<%= ctxPath%>/myCarRegister.kedai`;	
}
</script>



<%-- content start --%>	
<div style="border: 0px solid red; padding: 2% 0; width: 90%;">
<!-- Navigation Tabs -->
<ul class="nav nav-tabs" style="margin-bottom:4%;">
    <li class="nav-item">
        <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/myCar.kedai">차량정보</a>
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
        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/customer_Settlement.kedai">카셰어링정산(신청자)</a>
    </li>
</ul>
<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;나의 차량 정보</h3>
<hr style="color: gray;">
	<form name="editFrm" enctype="multipart/form-data" class="mt-5" style="border: 0px solid green;">
	<div style="border-top: 5px solid #2c4459; border-left: 1px solid lightgray; border-bottom: 1px solid lightgray; border-right: 1px solid lightgray; padding: 1% 0; display:flex;">
	        <c:if test="${not empty requestScope.myCar}">
	            <c:forEach var="car" items="${requestScope.myCar}">
	                <div class="col-4" style="border: 0px solid blue; text-align:center;">
	                    <br><br>
	                    <img src="<%= ctxPath %>/resources/files/car/${car.car_imgfilename}" style="width:90%; height: 300px;" />
	                    <br><br><br>
	                </div>
	                <div class="col-8" style="border: 0px solid red; padding-top:3%; padding-left: 3%;">
	                    <h4>차종&nbsp;&nbsp;<input type="text" style="font-size: 15pt; font-weight:bold; border:none;" name="car_type" id="car_type" value="${car.car_type}"/><span>차량번호&nbsp;</span><input type="text" name="car_num" id="car_num" style="font-size: 15pt; font-weight:bold; border:none; width:20%;" value="${car.car_num}"/><span>최대동승인원&nbsp;</span><input type="text" name="max_num" id="max_num" style="font-size: 15pt; font-weight:bold; border:none; width:10%;" value="${car.max_num}명"/></h4>
	                    <hr style="color: gray; width: 90%;">
	                    <div style="display: flex;">
	                        <div class="col-6" style="border-right: 2px solid lightgray;">
	                            <h4>운전 종별</h4>
	                            <div style="display: flex; align-items:center; width: 250px; margin: 0 auto; text-align: center; font-size: 30pt;">
	                                <i class="fa-solid fa-id-card"></i>&nbsp;&nbsp;
	                                <input type="text" style="font-size:23pt; width: 150px; border:none;" name="car_type" id="car_type" value="${car.license }"/>
	                            </div>
	                        </div>
	                        <div class="col-6">
	                            <h4>운전 경력</h4>
	                            <div style="display: flex; align-items: center; width: 200px; margin: 0 auto; text-align: center; font-size: 30pt;">
	                                <i class="fa-solid fa-car"></i>&nbsp;&nbsp;
	                                <input type="text" name="drive_year" id="drive_year" style="font-size:23pt; width: 150px; border:none;" value="${car.drive_year}">
	                            </div>
	                        </div>
	                    </div>
	                    <div style="display: flex; margin-top: 4%;">
	                        <div class="col-6" style="border-right: 2px solid lightgray;">
	                            <h4>보험가입여부</h4>
	                            <span style="display:block; text-align: center; font-size: 30pt;">
	                                <i class="fa-solid fa-circle-check"></i>
	                            </span>
	                        </div>
	                        <div class="col-6">
	                            <h4>약관동의여부</h4>
	                            <span style="display:block; text-align: center; font-size: 30pt;">
	                                <i class="fa-solid fa-circle-check"></i>
	                            </span>
	                        </div>
	                    </div>
	                </div>
	            </c:forEach>
		</c:if>
		<c:if test="${empty requestScope.myCar}">
			등록되어있는 차량이 없습니다.
		</c:if>
	</div>
	<div style="position: relative; left: 500px; top: 85px;">
		<div class="btnRegister">
		<c:if test="${empty requestScope.myCar}">
	        <button type="button" onclick="goRegister()">등록하기</button>
	    </c:if>
	    <c:if test="${not empty requestScope.myCar}">
	        <button type="button" onclick="goEdit()">수정하기</button>
	    </c:if>
	        <button type="reset" onclick="goBack()">뒤로가기</button>
	    </div>
	</div>
	</form>
</div>
