<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String ctxPath = request.getContextPath();
    //     /KEDAI
%>
<style type="text/css">
    .register input {
        width: 360px;
        border: none;
        border-bottom: 1px solid #2c4459;
        margin-top: 8px;
    }
    span.star {
        font-weight: bold;
        font-size: 15pt;
        color: #e68c0e;
    }
    span.error {
        font-size: 12pt;
        color: #e68c0e;
    }
    span#idCheckResult,
    span#emailCheckResult {
        font-size: 12pt;
    }
    button#idcheck,
    button#emailcheck,
    button#zipcodeSearch {
        border: solid 1px #2c4459;
        border-radius: 25px;
        background: none;
        color: #2c4459;
        font-size: 10pt;
        width: 120px;
        height: 40px;
        margin-left: 10px;
    }
    button#idcheck:hover,
    button#emailcheck:hover,
    button#zipcodeSearch:hover {
        border: none;
        background: #e68c0e;
        color: #fff;
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
</style>
<script src="<%=ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("span.error").hide();
        $("input#empid").focus();

        // 이미지 미리 보여주기
        $(document).on("change", "input.img_file", function(e){
            const input_file = $(e.target).get(0);

            const fileReader = new FileReader();
            fileReader.readAsDataURL(input_file.files[0]); 

            fileReader.onload = function(){
                document.getElementById("previewImg").src = fileReader.result;
            };
        });
        
        //값 가리키기
        var maxNumSelect = document.getElementById("max_num");
        var carMaxNum = document.getElementById("input_max_num").value; 
        
        var licenseSelect = document.getElementById("license");
        var license = document.getElementById("input_license").value; 
        
        var drive_yearSelect = document.getElementById("drive_year");
        var drive_year = document.getElementById("input_drive_year").value; 
        
        
        for (var i = 0; i < maxNumSelect.options.length; i++) {
            if (maxNumSelect.options[i].value == carMaxNum) {
                maxNumSelect.selectedIndex = i;
                break;
            }
        }
        
        for (var i = 0; i < licenseSelect.options.length; i++) {
            if (licenseSelect.options[i].value == license) {
            	licenseSelect.selectedIndex = i;
                break;
            }
        }
        
        for (var i = 0; i < drive_yearSelect.options.length; i++) {
            if (drive_yearSelect.options[i].value == drive_year) {
            	drive_yearSelect.selectedIndex = i;
                break;
            }
        }
        
        // 약관동의와 보럼은 체크되어있어야함.
            var radioToCheck = document.getElementById("yesInsurance"); // 체크할 라디오 버튼의 ID
            if (radioToCheck) {
                radioToCheck.checked = true;
            }

            // 체크박스 체크
            var checkboxToCheck = document.getElementById("agree"); // 체크할 체크박스의 ID
            if (checkboxToCheck) {
                checkboxToCheck.checked = true;
            }
        
    }); 

    // Function Declaration
    function goEdit() {
	       
	    
		// 차종
		var car_type = document.getElementById('car_type').value.trim();
		if(car_type == ""){
			$(".requiredInfo :input").prop("disabled", true);
			$("input#car_type").prop("disabled", false);
			$("input#car_type").focus();
			$("input#car_type").parent().find("span.error").show();
			return false;
		}
		else{
			$("input#car_type").parent().find("span.error").hide();
		}
		
		// 차량번호
		var car_num = document.getElementById('car_num').value.replace(/\s+/g, '');			// 차량번호 입력시 내부의 공백도 모두 제거
//		console.log("~~~ 확인용 : "+ car_num);
		if(car_num == ""){
			$(".requiredInfo :input").prop("disabled", true);
			$("input#car_num").prop("disabled", false);
			$("input#car_num").focus();
			$("input#car_num").parent().find("span.error").show();
			return false;
		}
		else{
			const regex = /\d{2,3}[가-힣]{1}\d{4}/gm;
			const bool = regex.test(car_num);
	        if(!bool) { // 생년월일이 정규표현식에 위배된 경우
				$(".requiredInfo :input").prop("disabled", true);
				$("input#car_num").prop("disabled", false);
	        	$("input#car_num").val("");
				$("input#car_num").focus();
				$("input#car_num").parent().find("span.error").show();
				return false;
	        }
	        else { 
	        	$("input#car_num").prop("disabled", false);
	        	$("input#car_num").focus();
	        	$("input#car_num").parent().find("span.error").hide();
	        }
		}
		
		// 보험가입 여부
        var noradio = document.getElementById('noInsurance');
        var yesradio = document.getElementById('yesInsurance');
        
        if(noradio.checked) {
//          $('span#insuranceError').show();
            $("input#noInsurance").parent().find("span.error").show();
            return false;
        } 
        if(yesradio.checked){
        	$('span#insuranceError').hide();
        }
        else if(!noradio.checked && !yesradio.checked){
        	$("input#noInsurance").parent().find("span.error").show();
        	return false;
        	
        }
        
        // 약관동의
        const checkbox_checked_length = $("input:checkbox[id='agree']:checked").length; 
        if(checkbox_checked_length == 0) {
            $('span#error_agree').show();
            return false;
        }
        
        // span.error 가 뜨는 순간 함수가 마지막에 return되도록 한다.
        
        // 폼 제출 로직
        const frm = document.registerFrm;
        frm.action = "<%= ctxPath%>/myCarEditEnd.kedai"; 
        frm.method = "post";
        frm.submit();
    }


    function goBack(){
    	location.href="javascript:history.back();"
    } // end of function goReset() ----------
</script>

<div style="border: 0px solid red; padding: 5% 0;">
    <h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;나의 차량 정보 등록</h3>

    <form name="registerFrm" enctype="multipart/form-data" class="row mt-5" style="border: 0px solid green;">
        <div class="col-2" style="border: 0px solid blue;">
        <c:forEach var="car" items="${requestScope.myCar}">
            <h6>차량 사진등록</h6>
            <div style="width: 200px; height: 230px; overflow: hidden; border: 1px solid #ddd;">
                <img src="<%= ctxPath %>/resources/files/car/${car.car_imgfilename}" id="previewImg" style="width: 100%; height: 100%;" />
            </div>
            <br>
            <input type="file" name="attach" class="infoData img_file" accept='image/*' />
            </c:forEach>
        </div>

        <div class="col-10 row" id="empRegister">
            <div class="col-6 register" style="border: 0px solid blue;">
                <h5>운전자 정보 확인 및 작성<span style="font-size: 8pt; color: #e68c0e;">&nbsp;&nbsp;기본정보는 변경불가합니다. *표시만 입력해주세요.</span></h5><br>
                <div style="position: relative;">
                    <h6>사원아이디</h6>
                    <input type="text" name="empid" id="empid" maxlength="30" class="requiredInfo" value="${sessionScope.loginuser.empid }" readonly/>
                    <br>
                </div>
                <div class="mt-3">
                    <h6>성명</h6>
                    <input type="text" name="name" id="name" maxlength="30" class="requiredInfo" value="${sessionScope.loginuser.name }" readonly/>
                </div>
                <div class="mt-3">
                    <h6>닉네임</h6>
                    <input type="text" name="nickname" id="nickname" maxlength="30" value="${sessionScope.loginuser.nickname }" readonly/>
                </div>
                <div class="mt-3" style="position: relative;">
                    <h6>이메일</h6>
                    <input type="text" name="email" id="email" maxlength="60" class="requiredInfo" value="${sessionScope.loginuser.email }" readonly />
                </div>
                <div class="mt-3">
                    <h6>연락처</h6>
                    <div style="display: flex;">
                        <div>
                            <input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" style="width: 93px;" readonly>
                            &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
                        </div>
                        <div>
                            <input type="text" name="hp2" id="hp2" class="requiredInfo" size="6" maxlength="4" value="${sessionScope.loginuser.mobile.substring(3, 7)}" style="width: 93px; text-align: center;" readonly>
                            &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
                        </div>
                        <div>
                            <input type="text" name="hp3" id="hp3" class="requiredInfo" size="6" maxlength="4" value="${sessionScope.loginuser.mobile.substring(sessionScope.loginuser.mobile.length() - 4)}" style="width: 93px; text-align: center;" readonly>
                        </div>
                    </div>
                </div>
                <div class="mt-3" style="display: flex;">
				<c:forEach var="car" items="${requestScope.myCar}">
                    <div>
                    <h6>운전 종별&nbsp;<span class="star">*</span></h6>
                    <input type="hidden" id="input_license" value="${car.license}"/>
                        <select name="license" id="license" class="requiredInfo" style="width: 170px;" value="${car.license }">
                           <option value="2종">2종</option>
                           <option value="1종">1종</option>
                           <option value="대형(1종)">대형(1종)</option>
                        </select>   
                    </div>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <div>
                    <h6>운전 경력&nbsp;<span class="star">*</span></h6>
                    <input type="hidden" id="input_drive_year" value="${car.drive_year}"/>
                    <select name="drive_year" id="drive_year" class="requiredInfo" style="width: 170px;" value="${car.drive_year }">
                           <option value="3년 이상">3년 이상</option>
                           <option value="2년 이상 3년 미만">2년 이상 3년 미만</option>
                           <option value="1년 이상 2년 미만">1년 이상 2년 미만</option>
                           <option value="1년 미만">1년 미만</option>
                    </select>  
                    </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-6 register" style="border: 0px solid blue; position: relative;">
				<c:forEach var="car" items="${requestScope.myCar}">
                <h5>차량 정보 확인 및 작성<span style="font-size: 8pt; color: #e68c0e;">&nbsp;&nbsp;* 표시는 필수입력 사항입니다.</span></h5><br>
                <div style="position: relative;">
                    <h6>차종&nbsp;<span class="star">*</span><span class="error" id="carTypeError">&nbsp;필수</span></h6>
                    <input type="text" name="car_type" id="car_type" size="6" maxlength="20" class="requiredInfo" placeholder="차종" value="${car.car_type}"/>
                </div>
                <div class="mt-3">
                    <h6>차량번호&nbsp;<span class="star">*</span><span class="error" id="carNumError" style="font-size: 8pt;">&nbsp;필수 차량번호를 올바르게 입력하세요.</span></h6>
                    <input type="text" name="car_num" id="car_num" size="6" maxlength="20" class="requiredInfo" placeholder="차량번호" value="${car.car_num}"/>    
                </div>
                <div class="mt-3" style="border: solid 0px red;">
                    <h6>보험가입 여부&nbsp;<span class="star">*</span><span class="error" id="insuranceError" style="font-weight:300; font-size: 8pt;"> 보험가입이 안되어있을시, 차량 등록이 불가능합니다.</span></h6>
                    <input type="radio" name="insurance" value="0" id="noInsurance" style="width:10px;"/><label for="noInsurance">가입안함</label> 
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="insurance" value="1" id="yesInsurance" style="width:10px;"/>
                    <label for="yesInsurance">가입함</label>
                </div>
                <div>
                    <h6>최대 탑승 인원&nbsp;<span class="star">*</span></h6>
                    <input type="hidden" id="input_max_num" value="${car.max_num}"/>
                    <select name="max_num" id="max_num" class="requiredInfo" style="width: 170px;" >
                           <option value="1">1</option>
                           <option value="2">2</option>
                           <option value="3">3</option>
                           <option value="4">4</option>
                    </select>  
                </div>
                <div class="mt-3" style="position: relative;">
                    <h6>약관동의&nbsp;<span class="star">*</span><span class="error" id="error_agree">&nbsp;필수동의</span></h6>
                    <iframe src="<%= ctxPath%>/iframe_agree/carRegister_agree.html" width="60%" style="border: solid 1px navy;"></iframe><br>
                    <label for="agree">이용약관에 동의합니다.(필수)&nbsp;&nbsp;</label><input type="checkbox" id="agree" style="width: 20px;"/>
                </div>
                </c:forEach>
            </div>
            <div class="mt-3" style="position: relative; left: 300px;">
                <div class="btnRegister">
                    <button type="button" onclick="goEdit()">수정하기</button>
                    <button type="reset" onclick="goBack()">뒤로가기</button>                
                </div>
            </div>
        </div>
    </form>
</div>
