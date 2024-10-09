<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>

<%
   String ctxPath = request.getContextPath();
%>
<!-- <link rel="stylesheet" type="text/css" href="othercom_list.css" /> -->

<style type="text/css">
*{
  margin: 0; padding: 0;
}
div#container{}
div#myHead{
  height: 80px;
  background-color: #999;
}
div#row{
  display: flex !important;
}

div#othercom_list{
	width:100%;
	/* width: calc(100vw - 250px); */
	display: flex;
	justify-content: center;
	align-items: center;
}

/* 여기서부터 시작*/
div#othercom_list .artWrap {
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;  
  gap: 20px;
  border: solid 0px orange;
/*   margin: 2%; */
}

div#cover_all{
  width: 80%;
  border: solid 0px purple;
  margin-left : 5%;

}


div#othercom_list .artWrap article {
	width: 300px;

  background-color: #fff;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.25);
  padding-bottom: 20px;
  border-radius: 10px;
  flex: 1 1 calc(33.33333% - 20px);
}

div#othercom_list .artWrap article:nth-of-type(3) ~ article {
  margin-top: 20px;
}

div#othercom_list .artWrap article .cardHead {

  color: white;
  background-color:#2C4459;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 10px 10px 30px;
  
}

div#othercom_list .artWrap article .cardHead h4 {
  font-size: 18px;
  font-weight: 700;
  line-height: 40px;
  text-indent: 40px;

}
div#othercom_list .artWrap article .cardHead h6 {
	font-size:14px;
	font-weight: 400;
	color: #e68c0e; 
	padding-right:50%;
	font-style: italic;
	
}

div#othercom_list .artWrap article .cardHead button {
  width: 30px;
  height: 30px;
  border-radius: 50px;
}
div#othercom_list .artWrap article .cardHead button img {
  height: 16px;
}
.cardBody {
  list-style-type: none;
  padding: 0;
}
div#othercom_list .artWrap article .cardBody li {
  padding-top:3%;
  padding-left: 5%;
  display: flex;
}
div#othercom_list .artWrap article .cardBody li .listImg {
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}
div#othercom_list .artWrap article .cardBody li .listImg img {
  height: 16px;
}
div#othercom_list .artWrap article .cardBody li .listTxt {
  line-height: 40px;
}

.popupWrap {
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  position: fixed;
  top: 0;
  left: 0;
  display: none;
  justify-content: center;
  align-items: center;
}
.popupWrap .popup {
  width: calc(100% - 800px);
  background-color: #f9f9f9;
  border-radius: 20px;
  overflow: hidden;
}
.popupWrap .popup .popupHead {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #2C4459;
  color: #fff;
  padding-right: 20px;
}
.popupWrap .popup .popupHead h4 {
  font-size: 24px;
  font-weight: 700;
  line-height: 60px;
  text-indent: 40px;
}

.popupWrap .popup .popupHead h4 {

}
.popupWrap .popup .popupHead button.close {
  width: 30px;
  height: 30px;
  border-radius: 50px;
  background-color: white;
  padding-bottom: 3px;
}
.popupWrap .popup .popupHead button.close  > img {
  height: 16px;
}
.popupWrap .popup .popupBody {
  padding: 100px 0;
}
.popupWrap .popup .popupBody .forAlign {
  display: flex;
  justify-content: center;
  
}
.popupWrap .popup .popupBody .popupImg {
  width: 180px;
  height: 180px;
  background-color: #999;
}
.popupWrap .popup .popupBody .popupList {
  margin-left: 50px;
}
.popupWrap .popup .popupBody .popupList li {
  width: 300px;
  display: flex;
  margin-top: 20px;
  font-size: 18px;
  font-weight: 700;
}
.popupWrap .popup .popupBody .popupList li:first-of-type {
  margin-top: 0;
}
.popupWrap .popup .popupBody .popupList li:hover {
  background-color: #eee;
}
.popupWrap .popup .popupBody .popupList li .listImg {
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.popupWrap .popup .popupBody .popupList li .listImg img {
  height: 16px;
}
.popupWrap .popup .popupBody .popupList li .listTxt {
  line-height: 40px;
}

.h5{
  font-weight: 700;
}

.h6{
	font-style:italic;
	color:#e68c0e;
}

.edit{
	border: solid 0px red;
	display: flex;
	padding-top: 15px;

	
}

.othercom-reg {
background-color: #e68c0e;
font-size: 17px;
}

.othercom-reg a {
color: inherit; /* 링크 텍스트 색상을 버튼 색상과 동일하게 /
text-decoration: none; / 링크 밑줄 제거 */
}

.othercom-reg:hover{
	background-color:#2C4459;
	color:#e68c0e;
}
 
.reg{
	border: 0px solid blue;
	width:20%;
	border-radius:3px;
	color:#2C4459;
	font-weight:700;
	float:right;
	
	
}

.reg-search{
	border:0px solid red;
	margin : 20px 10px;
}



.editcom{
	border-radius: 3px;
	width: auto;
	height: 50px;
	background-color: #e68c0e;
	color: 	#2C4459;
	font-weight: 700;
}

.delcom{
	border-radius: 3px;
	width: auto;
	height: 50px;
	background-color: #2C4459;
	color: 	#e68c0e;
	font-weight: 700;
	margin: 0 auto;
}

.othercom_title{
	font-size: 20px;
	border: 0px solid blue;
	font-weight: 700;
	line-height: 40px;
	margin-top: 3%;
}

</style>
<!-- 유선우 제작 페이지 페이징 처리와 검색 기능 Board(list.jsp) 참고함  -->
<script type="text/javascript">
	
	$(document).ready(function(){
		

		$("input:text[name='searchWord']").bind("keydown", function(e){
			if(e.keyCode == 13){
				goSearch();
			}
		});
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}){// paraMap 에 넘겨준 값이 존재하는 경우에만 검색조건 및 검색어 값을 유지한다.
			$("select[name='searchType']").val("${requestScope.paraMap.searchType}");		
			$("input[name='searchWord']").val("${requestScope.paraMap.searchWord}");
		}
		
		// 검색어 입력 시 자동글 완성하기 
		$("div#displayList").hide();
		
		$("input[name='searchWord']").keydown(function(){
			const wordLength = $(this).val().trim().length;
			
			if(wordLength == 0){
				$("div#displayList").hide();
			}
			else{
				if($("select[name='searchType']").val() == "partner_name" ||
				   $("select[name='searchType']").val() == "partner_type" ||
				   $("select[name='searchType']").val() == "part_emp_name"){
					
					$.ajax({
						url: "<%=ctxPath%>/company/wordSearchShowJSON.kedai",
						type: "get",
						data:{"searchType":$("select[name='searchType']").val(),
							  "searchWord":$("input[name='searchWord']").val()},
					    dataType:"json",
					    success: function(json){
					    	console.log(JSON.stringify(json));
					    	
					    	if(json.length > 0){
					    		let v_html = ``;
					    		
					    		$.each(json, function(index, item){
					    			const word = item.word;
					    			const idx = word. toLowerCase().indexOf($("input[name='searchWord']").val().toLowerCase());
					    			const len = $("input[name='searchWord']").val().length;
					   				const result = word.substring(0, idx)+"<span style='color: #2c4459; font-weight: bold;'>"+word.substring(idx, idx+len)+"</span>"+word.substring(idx+len);
					    		
					   				v_html += `<span style='cursor: pointer;' class='result'>\${result}</span><br>`;
					    		}); // end of $.each(json, function(index, item){}-------------------------------------
					    		
					    		// 검색어 input 태그의 width 값 알아오기
								const input_width = $("input[name='searchWord']").css("width");
					    		
								// 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
								$("div#displayList").css({"width":input_width});
								
								$("div#displayList").html(v_html);
								$("div#displayList").show();
					    	}
					    },
					    error: function(request, status, error){
					    	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					    }
					});
				}
			}
		}); // $("input[name='searchWord']").keydown(function(){}
	
		$(document).on("click", "span.result", function(e){
			const word = $(e.target).text();
			
			$("input[name='searchWord']").val(word);// 텍스트박스에 검색된 결과의 문자열을 입력
			$("div#displayList").hide();
			goSearch();
		})
		
	}); // end of $(document).ready(function(){}-----------------------------\
	
			
	function goSearch(){
		
		const frm = document.company_search_frm;
		// console.log(frm);
		frm.method = "get";
		frm.action = "<%= ctxPath%>/othercom_list.kedai";
		frm.submit();
	}// end of function goSearch(){}---------------------
	
	/* 여기 까지 검색기능  */
/////////////////////////////////////////////////////////////////////////////	
	
	
	
	
	$(function(){
	  $('.cardHead button').click(function(e){
		 //  var partner_no = $(this).('article').attr('partner_no');
		 var partner_no = $(e.target).closest('.cardHead').find('input[name="partner_no"]').val();
		 // console.log(partner_no)
		  
		  
	    // 클릭한 거래처 정보 상세보기
	    $.ajax({
	      url: "<%= ctxPath%>/partnerPopupClick.kedai?partner_no=" + partner_no,
	      type: "get",
	      async: true,
/* 	      data: {
	        "partner_name": partner_name
	      },
 */	      dataType: "json",
	      success: function(json){
	    	// console.log(JSON.stringify(json));
	        // 서버에서 거래처이름으로 정보 얻어오기\images\partne
	        if(json.partner_no != null){
	          $("#pop_partnerName").html(json.partner_name);
	          $("#pop_partnerNo").html(json.partner_no);
	          $("#pop_partnerImg").attr("src", "<%= ctxPath%>/resources/files/company/" + json.imgfilename);
	          $("#pop_partnerAddress").html(json.partner_address + " " + json.partner_detailaddress + " " + json.partner_extraaddress);
	          $("#pop_partnerUrl").html(json.partner_url);
	          $("#pop_partEmpTel").html(json.part_emp_tel);
	          $("#pop_partEmpEmail").html(json.part_emp_email);
	          $("#pop_partEmpName").html(json.part_emp_name);
	          $("#pop_partEmpRank").html(json.part_emp_rank);
	      
	         
	          /*
				private String partner_type;
				private String partner_url; 
				private String partner_postcode;
				private String partner_detailaddress;
				private String partner_extraaddress;
				private String imgfilename;
				private String originalfilename;
				private String part_emp_name;
				private String part_emp_tel;
				private String part_emp_email;
				private String part_emp_dept;
				private String part_emp_rank;
	          */
	          
	          
	        } else {
	          $("#partnerNameContainer").html("거래처이름을 불러오지 못했습니다.");
	        }
	      },
	      error: function(request, status, error) {
	        alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	      }
	    });
		  $('.popupWrap').css({display: 'flex'});
	  });
	 
	  
	  
	  	$('.popupHead button').click(function(){
	    	$('.popupWrap').css({display: 'none'});
	  	});
	});
	/* 카드 팝업 열고 닫기 끝 */

	$(".cardHead button").click(function(){
	  // 필요한 추가 작업이 있으면 여기에 작성
	});
	
	function editPopup() {
		var partner_no = $("#pop_partnerNo").html();
		location.assign("othercom_modify.kedai?partner_no=" + partner_no);
	}


	// 거래처 삭제하기
	function delPopup(){
		var partner_no = $("#pop_partnerNo").html();
		
		var bool = confirm("정말 거래처를 삭제하시겠습니까?");
		
		if(bool){
			// console.log("partner_no : " + partner_no)
			$.ajax({
				url: "<%=ctxPath%>/company/delPartner_com.kedai" ,
				type: "post",
				data:{"partner_no" :partner_no},
				dataType:"json",
				success: function(json){
					// console.log("응답 데이터: " + JSON.stringify(json)); 
					if(json.n == 1 ){
						alert("거래처를 삭제하였습니다.");
					//	console.log("json.n : " + json.n);
					}
					else{
						alert("거래처를 삭제하지 못했습니다.");
					}
					location.href="<%=ctxPath%>/othercom_list.kedai";
				},
				error: function(request, status, error){
		            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		        }
			});
		}
	
	}; // end of function delPopup(){}------------------------------------------------------
	

	
	
	
	
</script>


<div id="cover_all">
<div class="othercom_title">
		거래처 목록
</div>
<div class="reg-search row">
	
    <form name="company_search_frm" style="position:relative;" class="col-10">
		<select name ="searchType" style="margin-right:10px;">
			<option value="partner_name">거래처명</option>
			<option value="partner_type">업종</option>
			<option value="part_emp_name">담당자명</option>
		</select>
		<input type="text" name="searchWord" style="margin-right:10px"/>
		<input type="text" style="display: none;"/> 
		<button type="button" onclick="goSearch()" style="border:1px solid #2C4459;">검색</button>
	
		<div id="displayList" style="position: absolute; left: 0; border: solid 0px gray; border-top: 0px; height: 100px; margin-left: 8.1%; background: #fff; overflow: hidden; overflow-y: scroll;">
		
		</div>
	</form>
	
	<c:if test="${(sessionScope.loginuser).fk_job_code eq '1'}">
    	<div class="col-2 d-md-flex justify-content-md-end pl-0 pr-0">
    		<a href="<%= ctxPath%>/othercom_register.kedai" class="othercom-reg">거래처  등록하기</a>
    	</div>
    	
     	<!-- <button type="button" class="othercom-reg" onclick="goToRegisterPage()">거래처 등록하기</button> -->
    </c:if>
</div>  
   
<div id="othercom_list" class="othercom_list">
  <div class="artWrap">
  	<c:if test="${not empty requestScope.partnerList}">
	    <c:forEach var="partvo" items="${requestScope.partnerList}">
	      	<article>
	      	<fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}" />
	        <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}" /> 
	        <%-- fmt:parseNumber 은 문자열을 숫자형식으로 형변환 시키는 것이다. --%>
	      	
	        <div class="cardHead">
	          <div class="h5"><span id="asdasd">${partvo.partner_name}</span>&nbsp;&nbsp;&nbsp;<span class="h6">업종:${partvo.partner_type}</span></div>
	          <button class="detailbtn"><img src="<%= ctxPath%>/resources/images/common/chevron-right.svg" alt="" id="detailbtn"></button>
	          <input type="hidden" name="partner_no" value="${partvo.partner_no}" />
	        </div>
	        <ul class="cardBody">
	          <li>
	            <div class="listImg">
	              <img src="<%= ctxPath%>/resources/images/common/team.svg" alt="">
	            </div>
	            <div class="listTxt">${partvo.part_emp_dept}</div>
	          </li>
	          <li>
	            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/user.svg" alt=""></div>
	            <div class="listTxt">
	              <span>${partvo.part_emp_name}</span>
	              <span>${partvo.part_emp_rank}</span>
	            </div>
	          </li>
	          <li>
	            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/phone.svg" alt=""></div>
	            <div class="listTxt">${partvo.part_emp_tel}</div>
	          </li>
	          <li>
	            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/email.svg" alt=""></div>
	            <div class="listTxt">${partvo.partner_url}</div>
	          </li>
	        </ul>
	      </article>
	    </c:forEach>
    </c:if>
    <c:if test="${empty requestScope.partnerList}">
    	<div>데이터가 존재하지 않습니다.</div>
    </c:if>
  </div>
 
</div>
 	<div align="center" style="border: solid 0px gray; width: 50%; margin: 2% auto;  height: 100px;">
		${requestScope.pageBar}
	</div>

<!-- popup area -->
<div class="popupWrap">
  <div class="popup">
    <div class="popupHead">
      <h4 id="pop_partnerName"></h4>
      <button class="close"><img src="<%= ctxPath%>/resources/images/common/xmark.svg" alt=""></button>
    </div>
    <div class="popupBody">
      <div class="forAlign">
        <div class="popupImg" style="width:200px; border: 0px solid red; height:200px; overflow: hidden;">
          <img id="pop_partnerImg" src="" alt="" style="object-fit: cover; width:100%; height:100%;">
			<!-- 사진들어오는곳  -->
        </div>
        <ul class="popupList">
          <li>
            <div class="listImg">
              <img src="<%= ctxPath%>/resources/images/common/business_num.svg" alt="">
            </div>
            <div id="pop_partnerNo" class="listTxt"></div>
          </li>
          <li>
            <div class="listImg">
              <img src="<%= ctxPath%>/resources/images/common/comp.svg" alt="">
            </div>
            <div id="pop_partnerAddress" class="listTxt"><a href="https://www.eland.co.kr/"></a></div>
          </li>
          <li>
            <div class="listImg">
              <img src="<%= ctxPath%>/resources/images/common/homepage.svg" alt="">
            </div>
            <div id="pop_partnerUrl" class="listTxt"></div>
          </li>
        </ul>
        <ul class="popupList">
          <li>
            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/user.svg" alt=""></div>
            <div class="listTxt">
              <span id="pop_partEmpName"></span>
              <span id="pop_partEmpRank"></span>
            </div>
          </li>
          <li>
            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/phone.svg" alt=""></div>
            <div id="pop_partEmpTel" class="listTxt"></div>
          </li>
          <li>
            <div class="listImg"><img src="<%= ctxPath%>/resources/images/common/email.svg" alt=""></div>
            <div id="pop_partEmpEmail" class="listTxt"></div>
          </li>
        </ul>
      </div>
      <c:if test="${(sessionScope.loginuser).fk_job_code eq '1'}">
        <div class="buttonContainer" style="width: 200px; margin: 1% auto; border:solid 0px blue;">
          <button onclick="editPopup()" class="editcom" style="border: solid 0px red; float: left; margin-right: 10px;">수정하기</button>
          <button onclick="delPopup()" class="delcom" style="border: solid 0px red; float: left;">삭제하기</button>
        </div>
      </c:if>
    </div>
  </div>
</div>
</div>

<%-- 사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해 현재 페이지 주소를 뷰단으로 넘겨준다. --%>
<form name="goViewFrm">
	<input type="hidden" name="board_seq" />
	<input type="hidden" name="goBackURL" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form> 
<%-- content end --%>