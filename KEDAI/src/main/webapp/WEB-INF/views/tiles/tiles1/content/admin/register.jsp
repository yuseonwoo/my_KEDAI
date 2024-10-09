<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
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

<script type="text/javascript">
	let b_idcheck_click = false; 
	let b_emailcheck_click = false; 
	let b_zipcodeSearch_click = false;
	
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
			
		}); // end of $(document).on("change", "input.img_file", function(e){}) ----------
		
		///////////////////////////////////////////////////////////////
		
		$("input#pwd").blur( (e) => { 

	        const regExp_pwd = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
	        // 숫자/문자/특수문자 포함 형태의 8~15자리 이내의 암호 정규표현식 객체 생성
	        
	        const bool = regExp_pwd.test($(e.target).val());

	        if(!bool){ // 암호가 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true); 
	            $(e.target).prop("disabled", false); 
	            $(e.target).val("").focus(); 
	            $(e.target).parent().find("span.error").show();
	        }
	        else{ 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().find("span.error").hide();
	        }

	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#pwdcheck").blur( (e) => { 

	        if( $("input#pwd").val() != $(e.target).val() ){ 
	            $("div#empRegister :input").prop("disabled", true); 
	            $("input#pwd").prop("disabled", false);  
	            $(e.target).prop("disabled", false); 
	            $("input#pwd").val("").focus(); 
	            $(e.target).val("");
	            $(e.target).parent().find("span.error").show();
	        }
	        else{ 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().find("span.error").hide();
	        }

	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#jubun1").blur( (e) => {
      
	        const regExp_jubun1 = new RegExp(/^([0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1,2][0-9]|3[0,1]))$/);
	     	// 생년월일을 검사해주는 정규표현식 객체 생성
	        
	        const bool = regExp_jubun1.test($(e.target).val());   
	        
	        if(!bool) { // 생년월일이 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true);  
	            $(e.target).prop("disabled", false); 
	            $(e.target).parent().siblings("span.error").show();
	            $(e.target).val("").focus(); 
	        }
	        else { 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().siblings("span.error").hide();
	        }
	        
	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#jubun2").blur( (e) => {
      
	        const regExp_jubun2 = new RegExp(/^[1-4]\d{6}$/);
	     	// 주민등록번호 7자리를 검사해주는 정규표현식 객체 생성
	        
	        const bool = regExp_jubun2.test($(e.target).val());   
	        
	        if(!bool) { // 주민등록번호 7자리가 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true);  
	            $(e.target).prop("disabled", false); 
	            $(e.target).parent().siblings("span.error").show();
	            $(e.target).val("").focus(); 
	        }
	        else { 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().siblings("span.error").hide();
	        }
	        
	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#email").blur( (e) => { 

	        const regExp_email = new RegExp(/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i);  
			// 이메일 정규표현식 객체 생성
			
	        const bool = regExp_email.test($(e.target).val());
	
	        if(!bool){ // 이메일이 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true); 
	            $(e.target).prop("disabled", false); 
	            $(e.target).val("").focus(); 
	            $(e.target).parent().find("span.error").show();
	        }
	        else{ 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().find("span.error").hide();
	        }
	
	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#hp2").blur( (e) => {
      
	        const regExp_hp2 = new RegExp(/^[1-9][0-9]{3}$/);  
	        // 연락처 국번(숫자 4자리인데 첫번째 숫자는 1-9 이고 나머지는 0-9) 정규표현식 객체 생성
	        
	        const bool = regExp_hp2.test($(e.target).val());   
	        
	        if(!bool) { // 연락처 국번이 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true);  
	            $(e.target).prop("disabled", false); 
	            $(e.target).parent().siblings("span.error").show();
	            $(e.target).val("").focus(); 
	        }
	        else { 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().siblings("span.error").hide();
	        }
	        
	    });
		
		///////////////////////////////////////////////////////////////
		
		$("input#hp3").blur( (e) => {
    
	        const regExp_hp3 = new RegExp(/^\d{4}$/);  
	        // 숫자 4자리만 들어오도록 검사해주는 정규표현식 객체 생성
	        
	        const bool = regExp_hp3.test($(e.target).val());   
	        
	        if(!bool) { // 마지막 전화번호 4자리가 정규표현식에 위배된 경우
	            $("div#empRegister :input").prop("disabled", true);  
	            $(e.target).prop("disabled", false); 
	            $(e.target).parent().siblings("span.error").show();
	            $(e.target).val("").focus(); 
	        }
	        else { 
	            $("div#empRegister :input").prop("disabled", false);
	            $(e.target).parent().siblings("span.error").hide();
	        }
	        
	    });
		
		///////////////////////////////////////////////////////////////

		$("input#postcode").attr("readonly", true);
	    $("input#address").attr("readonly", true);
	    $("input#extraAddress").attr("readonly", true);
		
	    $("button#zipcodeSearch").click(function(){ // "우편번호찾기" 를 클릭했을 때 이벤트 처리
	        
	        b_zipcodeSearch_click = true;
	    
	        new daum.Postcode({
	            oncomplete: function(data) {
	                let addr = ''; // 주소 변수
	                let extraAddr = ''; // 참고항목 변수
	            
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    addr = data.roadAddress;
	                } 
	                else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    addr = data.jibunAddress;
	                }

	                if(data.userSelectedType === 'R'){
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    document.getElementById("extraAddress").value = extraAddr;
	                } 
	                else {
	                    document.getElementById("extraAddress").value = '';
	                }

	                document.getElementById('postcode').value = data.zonecode;
	                document.getElementById("address").value = addr;
	                
	                document.getElementById("detailAddress").focus();
	            }
	        }).open();

	        $("input#postcode").attr("readonly", true);
	        $("input#address").attr("readonly", true);
	        $("input#extraAddress").attr("readonly", true);

	    }); // end of $("img#zipcodeSearch").click() ----------
	    
		//////////////////////////////////////////////////////////////
	    
	 	// === jQuery UI 의 datepicker === //
	    $('input#datepicker').datepicker({
	        dateFormat: 'yy-mm-dd'    // Input Display Format 변경
	        ,showOtherMonths: true    // 빈 공간에 현재월의 앞뒤월의 날짜를 표시
	        ,showMonthAfterYear: true // 년도 먼저 나오고, 뒤에 월 표시
	        ,changeYear: true         // 콤보박스에서 년 선택 가능
	        ,changeMonth: true        // 콤보박스에서 월 선택 가능                             
	        ,yearSuffix: "년"          // 달력의 년도 부분 뒤에 붙는 텍스트
	        ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] // 달력의 월 부분 텍스트
	        ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 달력의 월 부분 Tooltip 텍스트
	        ,dayNamesMin: ['일','월','화','수','목','금','토'] // 달력의 요일 부분 텍스트
	        ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] // 달력의 요일 부분 Tooltip 텍스트             
	    });
	    
		//////////////////////////////////////////////////////////////
	    
	    $("button#idcheck").click(function(){ // "아이디중복확인" 을 클릭했을 때 이벤트 처리
	        b_idcheck_click = true;
	      
	        $.ajax({
	            url: "<%= ctxPath%>/admin/idDuplicateCheck.kedai", 
	            data: {"empid":$("input#empid").val()}, 
	            type: "post", 
	            async: true, 
	            dataType: "json", 
	            success: function(json){ 
	            //	console.log(JSON.stringify(json));
	            	
	            	if(json.isExists){ 
	                    $("span#idCheckResult").html("&nbsp;&nbsp;이미 사용 중인 아이디입니다.").css({"color":"#e68c0e"});
	                    $("input#empid").val(""); 
	                }
	                else{ 
	                    $("span#idCheckResult").html("&nbsp;&nbsp;사용 가능한 아이디입니다.").css({"color":"#2c4459"});
	                }
	            },
	            error: function(request, status, error){
	                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
	        });
	    });
		
		//////////////////////////////////////////////////////////////
		
		$("button#emailcheck").click(function(){ // "이메일중복확인" 을 클릭했을 때 이벤트 처리
	        b_emailcheck_click = true;
	
	        $.ajax({
	            url: "<%= ctxPath%>/admin/emailDuplicateCheck.kedai", 
	            data: {"email":$("input#email").val()}, 
	            type: "post", 
	            async: true,  
	            dataType: "json", 
	            success: function(json){ 
	            //	console.log(JSON.stringify(json));
	            	
	            	if(json.isExists){ 
	                    $("span#emailCheckResult").html("&nbsp;&nbsp;이미 사용 중인 이메일입니다.").css({"color":"#e68c0e"});
	                    $("input#email").val(""); 
	                }
	                else{ 
	                    $("span#emailCheckResult").html("&nbsp;&nbsp;사용 가능한 이메일입니다.").css({"color":"#2c4459"});
	                }
	            },
	            error: function(request, status, error){
	                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	            }
	        });
	    });
		
		//////////////////////////////////////////////////////////////

	    // 아이디값이 변경되면 등록하기 버튼을 클릭 시 
	    // "아이디중복확인" 을 클릭했는지 클릭안했는지를 알아보기 위한 용도 초기화 시키기 
	    $("input#empid").bind("change", function(){
	        b_idcheck_click = false;
	    });
	  
	    // 이메일값이 변경되면 등록하기 버튼을 클릭 시 
	    // "이메일중복확인" 을 클릭했는지 클릭안했는지를 알아보기 위한 용도 초기화 시키기 
	    $("input#email").bind("change", function(){
	        b_emailcheck_click = false;
	    });
		
	}); // end of $(document).ready(function(){}) ----------
	
	// Function Declaration
	function goRegister(){
		
		let b_requiredInfo = true;
		
		const requiredInfo_list = document.querySelectorAll("input.requiredInfo");
	    for(let i=0; i<requiredInfo_list.length; i++){
	        const val = requiredInfo_list[i].value.trim();

	        if(val == ""){
	            alert("* 표시된 필수입력사항은 모두 입력하셔야 합니다.");
	            b_requiredInfo = false;
	            break; 
	        }

	    } // end of for ----------
	    
	    if(!b_requiredInfo){
	        return;
	    }
		
	    if(!b_idcheck_click){ // "아이디중복확인" 을 클릭하지 않았을 경우
	        alert("아이디 중복확인을 클릭하셔야 합니다.");
	        return; 
	    }
	    
	    if(!b_emailcheck_click){ // "이메일중복확인" 을 클릭하지 않았을 경우
	        alert("이메일 중복확인을 클릭하셔야 합니다.");
	        return; 
	    }
	    
	    if(!b_zipcodeSearch_click){ // "우편번호찾기" 를 클릭하지 않았을 경우
	        alert("우편번호찾기를 클릭하셔서 우편번호를 입력하셔야 합니다.");
	        return;
	    }
	    
	    const postcode = $("input#postcode").val().trim();
	    const address = $("input#address").val().trim();
	    const detailAddress = $("input#detailAddress").val().trim();
	   
	    if(postcode == "" || address == "" || detailAddress == "") { 
	        alert("우편번호 및 주소를 입력하셔야 합니다.");
	        return; 
	    }
	    
	    const frm = document.registerFrm;
     	frm.action = "<%= ctxPath%>/admin/empRegister.kedai";
     	frm.method = "post";
    	frm.submit();
     	
	} // end of function goRegister() ----------
	
	// Function Declaration
	function goReset(){

	    $("span#idcheckResult").empty();
	    $("span#emailCheckResult").empty();

	} // end of function goReset() ----------
</script>

<%-- content start --%>	
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;사원정보 등록하기<span style="font-size: 12pt; color: #e68c0e;">&nbsp;&nbsp;* 표시는 필수입력 사항입니다.</span></h3>
	
	<form name="registerFrm" enctype="multipart/form-data" class="row mt-5" style="border: 0px solid green;">
		<div class="col-2" style="border: 0px solid blue;">
			<h6>사진등록&nbsp;<span class="star">*</span></h6>
			<div style="width: 200px; height: 230px; overflow: hidden; border: 1px solid #ddd;">
				<img id="previewImg" style="width: 100%; height: 100%;" />
			</div>
			<br>
	   		<input type="file" name="attach" class="infoData img_file" accept='image/*' />
		</div>
		
		<div class="col-10 row" id="empRegister">
			<div class="col-6 register" style="border: 0px solid blue;">
				<div style="position: relative;">
					<h6>사원아이디&nbsp;<span class="star">*</span></h6>
					<input type="text" name="empid" id="empid" maxlength="30" class="requiredInfo" placeholder="AAAABBB-CCC" />
					<button type="button" id="idcheck" style="position: absolute; bottom: 28px; left: 230px;">아이디 중복확인</button>
	                <span id="idCheckResult"></span>
	                <br>
	                <span style="font-size: 10pt; font-weight: bold; color: #bbb;">AAAA : 입사연도, BBB : 부서코드, CCC : 입사순서</span>
				</div>
				<div class="mt-3">
					<h6>비밀번호&nbsp;<span class="star">*</span></h6>
					<input type="password" name="pwd" id="pwd" maxlength="15" class="requiredInfo" placeholder="영문자,숫자,특수기호가 혼합된 8~15 글자" />
	            	<span class="error">&nbsp;&nbsp;비밀번호 형식에 맞지 않습니다.</span>
	            </div>
	            <div class="mt-3">
					<h6>비밀번호확인&nbsp;<span class="star">*</span></h6>
					<input type="password" id="pwdcheck" maxlength="15" class="requiredInfo" placeholder="비밀번호확인" />
					<span class="error">&nbsp;&nbsp;비밀번호가 일치하지 않습니다.</span>
	            </div>
				<div class="mt-3">
					<h6>성명&nbsp;<span class="star">*</span></h6>
					<input type="text" name="name" id="name" maxlength="30" class="requiredInfo" placeholder="성명" />
				</div>
				<div class="mt-3">
					<h6>닉네임&nbsp;</h6>
					<input type="text" name="nickname" id="nickname" maxlength="30" placeholder="닉네임" />
				</div>
				<div class="mt-3">
					<h6>주민등록번호&nbsp;<span class="star">*</span></h6>
					<div style="display: flex;">
						<div>
	                         <input type="text" name="jubun1" id="jubun1" size="6" maxlength="6" class="requiredInfo" style="width: 155px;">
	                         &nbsp;&nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;&nbsp;
                     	</div>
                     	<div>
	                         <input type="text" name="jubun2" id="jubun2" size="7" maxlength="7" class="requiredInfo" style="width: 155px;">
                     	</div>
						<span class="error" style="display: block; align-content: end;">&nbsp;&nbsp;주민등록번호 형식에 맞지 않습니다.</span>
					</div>
				</div>
	            <div class="mt-3" style="position: relative;">
					<h6>이메일&nbsp;<span class="star">*</span></h6>
					<input type="text" name="email" id="email" maxlength="60" class="requiredInfo" placeholder="이메일 주소" />
	                <button type="button" id="emailcheck" style="position: absolute; bottom: 5px; left: 230px;">이메일 중복확인</button>
	                <span class="error">&nbsp;&nbsp;이메일 형식에 맞지 않습니다.</span>
	                <span id="emailCheckResult"></span>
	            </div>
	            <div class="mt-3">
					<h6>연락처&nbsp;<span class="star">*</span></h6>
					<div style="display: flex;">
	                     <div>
	                         <input type="text" name="hp1" id="hp1" size="6" maxlength="3" value="010" style="width: 93px;" readonly>
	                         &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
	                     </div>
	                     <div>
	                         <input type="text" name="hp2" id="hp2" class="requiredInfo" size="6" maxlength="4" placeholder="1234" style="width: 93px; text-align: center;">
	                         &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
	                     </div>
	                     <div>
	                         <input type="text" name="hp3" id="hp3" class="requiredInfo" size="6" maxlength="4" placeholder="5678" style="width: 93px; text-align: center;">
	                     </div>
	                     <span class="error" style="display: block; align-content: end;">&nbsp;&nbsp;휴대폰 형식에 맞지 않습니다.</span>
	                 </div>
				</div>
			</div>
			
			<div class="col-6 register" style="border: 0px solid blue; position: relative;">
				<div style="position: relative;">
					<h6>우편번호&nbsp;<span class="star">*</span></h6>
					<input type="text" name="postcode" id="postcode" size="6" maxlength="5" class="requiredInfo" placeholder="우편번호" />
					<button type="button" id="zipcodeSearch" style="position: absolute; bottom: 5px; left: 230px;">우편번호 찾기</button><br>
				</div>
				<div class="mt-3">
					<h6>주소&nbsp;<span class="star">*</span></h6>
					<input type="text" name="address" id="address" size="40" maxlength="200" class="requiredInfo" placeholder="주소" /><br>
	                <input type="text" name="detailaddress" id="detailAddress" size="40" maxlength="200" class="requiredInfo" placeholder="상세주소" />&nbsp;
	                <input type="text" name="extraaddress" id="extraAddress" size="40" maxlength="200" placeholder="참고항목" />            
	            </div>
				<div class="mt-3">
					<h6>입사일자&nbsp;<span class="star">*</span></h6>
					<input type="text" name="hire_date" id="datepicker" maxlength="10" class="requiredInfo" placeholder="입사일자는 마우스로만 클릭하세요." />
				</div>
				<div class="mt-3" style="position: relative;">
					<h6>급여&nbsp;<span class="star">*</span></h6>
					<input type="text" name="salary" id="salary" maxlength="10" class="requiredInfo" />
					<span style="position: absolute; bottom: 5px; left: 340px;">원</span>
				</div>
				<div class="mt-3" style="display: flex;">
					<div>
						<h6>부서</h6>
						<select name="dept_name" class="infoData" style="width: 170px;">
							<option value="">부서</option>
							<c:forEach var="dvo" items="${requestScope.deptList}">
		                  		<option value="${dvo.dept_name}">${dvo.dept_name}</option>
                  			</c:forEach>
						</select>
					</div>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<div>
						<h6>직급</h6>
						<select name="job_name" class="infoData" style="width: 170px;">
							<option value="">직급</option>
							<c:forEach var="jvo" items="${requestScope.jobList}">
		                  		<option value="${jvo.job_name}">${jvo.job_name}</option>
                  			</c:forEach>
						</select>
					</div>
				</div>
				
				<div class="btnRegister" style="position: absolute; bottom: 0;">
			        <button type="button" onclick="goRegister()">등록하기</button>
			        <button type="reset" onclick="goReset()">취소하기</button>
			    </div>
			</div>
		</div>
	</form>
</div>
<%-- content end --%>