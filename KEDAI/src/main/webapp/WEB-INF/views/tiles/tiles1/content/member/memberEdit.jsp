<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
	.edit input {
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
	span#emailCheckResult {
		font-size: 12pt;
	}
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
	button#emailcheck:hover,
	button#zipcodeSearch:hover {
		border: none;
		background: #e68c0e;
		color: #fff;
	}
	.btnEdit button {
		border-radius: 25px;
		color: #fff;
		width: 200px;
		height: 50px;
	}
	.btnEdit button:nth-child(1) {
		background: #2c4459;
		margin-right: 10px;
	}
	.btnEdit button:nth-child(2) {
		background: #e68c0e;
	}
</style>

<script type="text/javascript">
	let b_emailcheck_click = true; 
	let b_zipcodeSearch_click = true;
	
	$(document).ready(function(){
		
		$("span.error").hide();
	
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

	    // 이메일값이 변경되면 등록하기 버튼을 클릭 시 
	    // "이메일중복확인" 을 클릭했는지 클릭안했는지를 알아보기 위한 용도 초기화 시키기 
	    $("input#email").bind("change", function(){
	        b_emailcheck_click = false;
	    });
		
	}); // end of $(document).ready(function(){}) ----------
	
	// Function Declaration
	function goEdit(){
		
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
	    
	    const frm = document.editFrm;
     	frm.action = "<%= ctxPath%>/member/memberEditEnd.kedai";
     	frm.method = "post";
    	frm.submit();
     	
	} // end of function goRegister() ----------
	
	// Function Declaration
	function goReset(){

	    $("span#emailCheckResult").empty();

	} // end of function goReset() ----------
</script>

<%-- content start --%>	
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;나의 정보 수정하기<span style="font-size: 12pt; color: #e68c0e;">&nbsp;&nbsp;* 표시는 필수입력 사항입니다.</span></h3>
	
	<form name="editFrm" enctype="multipart/form-data" class="row mt-5" style="border: 0px solid green;">
		<div class="col-2" style="border: 0px solid blue;">

			<div style="width: 200px; height: 230px; overflow: hidden; border: 1px solid #ddd;"> 
				<img id="previewImg" style="width: 100%; height: 100%;" src="<%= ctxPath%>/resources/files/employees/${(sessionScope.loginuser).imgfilename}" />
			</div>
			<br>
	   <%-- <input type="file" name="attach" class="infoData img_file" accept='image/*' /> --%>	
		</div>
		
		<div class="col-10 row" id="memberEdit">
			<div class="col-6 edit" style="border: 0px solid blue;">
				<div style="position: relative;">
					<h6>사원아이디&nbsp;<span class="star">*</span></h6>
					<input type="text" name="empid" id="empid" maxlength="30" class="requiredInfo" value="${sessionScope.loginuser.empid}" readonly />
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
					<input type="text" name="name" id="name" maxlength="30" class="requiredInfo" value="${sessionScope.loginuser.name}" />
				</div>
				<div class="mt-3">
					<h6>닉네임&nbsp;</h6>
					<input type="text" name="nickname" id="nickname" maxlength="30" value="${sessionScope.loginuser.nickname}" />
				</div>
				<div class="mt-3">
					<h6>주민등록번호&nbsp;<span class="star">*</span></h6>
					<div style="display: flex;">
						<div>
	                         <input type="text" name="jubun1" id="jubun1" size="6" maxlength="6" class="requiredInfo" style="width: 155px;" value="${fn:substring(sessionScope.loginuser.jubun, 0, 6)}" readonly>
	                         &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
                     	</div>
                     	<div>
	                         <input type="text" name="jubun2" id="jubun2" size="7" maxlength="7" class="requiredInfo" style="width: 155px;" value="${fn:substring(sessionScope.loginuser.jubun, 6, 13)}" readonly>
                     	</div>
					</div>
				</div>
	            <div class="mt-3" style="position: relative;">
					<h6>이메일&nbsp;<span class="star">*</span></h6>
					<input type="text" name="email" id="email" maxlength="60" class="requiredInfo" value="${sessionScope.loginuser.email}" />
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
	                         <input type="text" name="hp2" id="hp2" class="requiredInfo" size="6" maxlength="4" style="width: 93px; text-align: center;" value="${fn:substring(sessionScope.loginuser.mobile, 3, 7)}">
	                         &nbsp;&nbsp;<i class="fa-solid fa-minus"></i>&nbsp;&nbsp;
	                     </div>
	                     <div>
	                         <input type="text" name="hp3" id="hp3" class="requiredInfo" size="6" maxlength="4" style="width: 93px; text-align: center;" value="${fn:substring(sessionScope.loginuser.mobile, 7, 11)}">
	                     </div>
	                     <span class="error" style="display: block; align-content: end;">&nbsp;&nbsp;휴대폰 형식에 맞지 않습니다.</span>
	                 </div>
				</div>
			</div>
			
			<div class="col-6 edit" style="border: 0px solid blue; position: relative;">
				<div style="position: relative;">
					<h6>우편번호&nbsp;<span class="star">*</span></h6>
					<input type="text" name="postcode" id="postcode" size="6" maxlength="5" class="requiredInfo" value="${sessionScope.loginuser.postcode}" />
					<button type="button" id="zipcodeSearch" style="position: absolute; bottom: 5px; left: 230px;">우편번호 찾기</button><br>
				</div>
				<div class="mt-3">
					<h6>주소&nbsp;<span class="star">*</span></h6>
					<input type="text" name="address" id="address" size="40" maxlength="200" class="requiredInfo" value="${sessionScope.loginuser.address}" /><br>
	                <input type="text" name="detailaddress" id="detailAddress" size="40" maxlength="200" class="requiredInfo" value="${sessionScope.loginuser.detailaddress}" />&nbsp;
	                <input type="text" name="extraaddress" id="extraAddress" size="40" maxlength="200" value="${sessionScope.loginuser.extraaddress}" />            
	            </div>
				<div class="mt-3">
					<h6>입사일자&nbsp;<span class="star">*</span></h6>
					<input type="text" name="hire_date" id="datepicker" maxlength="10" class="requiredInfo" value="${sessionScope.loginuser.hire_date}" readonly />
				</div>
				<div class="mt-3" style="position: relative;">
					<h6>급여&nbsp;<span class="star">*</span></h6>
					<input type="text" name="salary" id="salary" maxlength="10" class="requiredInfo" value="${sessionScope.loginuser.salary}" readonly />
					<span style="position: absolute; bottom: 5px; left: 340px;">원</span>
				</div>
				<div class="mt-3">
					<h6>부서</h6>
					<input type="text" name="dept_name" id="dept_name" value="${sessionScope.loginuser.dept_name}" readonly />
				</div>
				<div class="mt-3">
					<h6>직급</h6>
					<input type="text" name="job_name" id="job_name" value="${sessionScope.loginuser.job_name}" readonly />
				</div>
				<div class="btnEdit" style="position: absolute; bottom: 0;">
			        <button type="button" onclick="goEdit()">수정하기</button>
			        <button type="reset" onclick="goReset()">취소하기</button>
			    </div>
			</div>
		</div>
	</form>
</div>
<%-- content end --%>