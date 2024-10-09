<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css"
	href="<%=ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script src="<%=ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
<link rel="stylesheet" href="<%=ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css">
<!-- Font Awesome 6 Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<style type="text/css">
a{
	color:#fff;
}

div#title {
	font-size: 27px;
	margin: 3% 0 1% 0;
}

div#title2 {
	font-size: 25px;
	margin: 0 0 1% 0;
}

table.left_table {
	width: 100%;
	border-bottom-width: 0.5px;
	border-bottom-style: solid;
	border-bottom-color: lightgrey;
}

table.left_table th {
	width: 25%;
	background-color: #EBEBEB;
}

table#title_table td {
	width: 25%;
	padding: 0 0 0 3%;
}

table#title_table th, table#newday th, table#newday td {
	padding: 0 0 0 3%;
}

table#approval th, table#approval td {
	padding: 0%;
}

table#approval{
	text-align: center;
}

table.left_table input {
	height: 15pt;
}

.modal-dialog {
	height: 500px;
	max-height: 500px;
}

.modal-body {
	overflow-y: auto;
}

div.openList img {
	width: 11px;
	height: 11px;
	margin-right: 0.5%;
	margin-bottom: 0.5%;
	cursor: pointer;
}

ul.approvalList>li>label:hover {
	background-color: #EBEBEB;
}

ul.approvalList>li>label {
	margin: 0 3%;
	cursor: pointer;
}

.modal-body ul {
	padding-left: 20px; /* 중첩된 목록에 대한 기본 들여쓰기 */
}

.bold_text {
	font-weight: bold;
}

.addApproval {
	text-align: center;
	border-bottom-width: 0.3px;
	border-bottom-style: solid;
	border-bottom-color: lightgrey;
}

.modal_left{
	overflow-y: scroll;
	height: 300px;
}

div.fileDrop{ 
 	display: inline-block; 
    width: 100%; 
    height: 100px;
	overflow: auto; 
    background-color: #fff;
}
div.fileDrop > div.fileList > span.delete{display:inline-block; width: 20px; color: #ff5353; text-align: center;} 
div.fileDrop > div.fileList > span.delete:hover{background-color: #000; color: #fff; cursor: pointer;}
div.fileDrop > div.fileList > span.fileName{padding-left: 10px;}
/* div.fileDrop > div.fileList > span.fileSize{padding-right: 20px; float:right;}  */
span.clear{clear: both;} 
                  
                  
.changeCSSblod {
	font-weight: bold;
}                  

</style>





<script type="text/javascript">
	
	$(document).ready(function(){
		
		$("input:checkbox[class='end_day']").prop("disabled", true);
        
	<%-- === #166.-2 스마트 에디터 구현 시작 === --%>
  //전역변수
		var obj = [];
 
  //스마트에디터 프레임생성
  		nhn.husky.EZCreator.createInIFrame({
    	oAppRef: obj,
    	elPlaceHolder: "doc_content", // id가 content인 textarea에 에디터를 넣어준다.
    	sSkinURI: "<%=ctxPath%>/resources/smarteditor/SmartEditor2Skin.html",
    	htParams : {
	    	// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseToolbar : true,            
	        // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseVerticalResizer : false,    
	        // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseModeChanger : true,
    	}
		});

  		 <%-- === 스마트 에디터 구현 끝 === --%>
  	     
  	     // 글쓰기 버튼
		$("button#btnWrite").click(function(){
  	    	 
  	    	 <%-- === 스마트 에디터 구현 시작 === --%>
  	         // id가 content인 textarea에 에디터에서 대입
  	    	obj.getById["doc_content"].exec("UPDATE_CONTENTS_FIELD", []);
  	        <%-- === 스마트 에디터 구현 끝 === --%>
  	    	 
  	    	 // 글제목 유효성 검사
  	    	const doc_subject = $("input:text[name='doc_subject']").val().trim();
  	    	if(doc_subject == ""){
  	    		 alert("글 제목을 입력하세요!!");
  	    		 $("input:text[name='doc_subject']").val("");
  	    		 return; // 종료
  	    	}
  	    	
  	    	// 연차 신청 유효성 검사
  	    	const annual_leave = $("input:text[name='request_annual_leave']").val().trim();
  	    	if(annual_leave == 0){
 	    		alert("신청 연차를 확인 하세요!!");
 	    		$("#startdate").datepicker('setDate', new Date());
 	           	$("#enddate").datepicker('setDate', new Date());
 	     	
 	           	$("input:checkbox[class='start_day']").prop("checked", true);
 	    		return; // 종료
 	    	}
		
  	    	 
  	    	// 글내용 유효성 검사(스마트 에디터를 사용할 경우) 
  	    	<%-- const doc_content = $("textarea[name='doc_content']").val().trim();
  	    	if(doc_content == ""){
  	    		 alert("글 내용을 입력하세요!!");
  	    		 return; // 종료
  	    	} 
  	    	==> 이렇게 입력했을 경우 html로 변환했을 때 <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</p> 이렇게 나옴. 
  	    	 그래서 공백이라고 인식하지 못함.
  	    	--%>
  	    	let content_val = $("textarea[name='doc_content']").val().trim();
  	   		// alert(content_val); // content에 공백만 여러개를 입력하여 쓰기할 경우 알아보는 것
  	   		// <p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</p>
  			//content_val.replace("&nbsp;", ""); 첫 번째로 발견된 &nbsp; 문자열만을 빈 문자열로 대체. 그러므로 여러 개의 &nbsp;가 존재하는 경우 첫 번째만 대체되고 나머지는 그대로 남게 됨.
  	   		content_val = content_val.replace(/&nbsp;/gi, ""); // 공백(&nbsp;)을 ""으로 변환
  	   		/*    
  	        	대상문자열.replace(/찾을 문자열/gi, "변경할 문자열");
  	      		==> 여기서 꼭 알아야 될 점은 나누기(/)표시안에 넣는 찾을 문자열의 따옴표는 없어야 한다는 점입니다. 
  	                	그리고 뒤의 gi는 다음을 의미합니다.
  	   
  		      g : 전체 모든 문자열을 변경 global
  		      i : 영문 대소문자를 무시, 모두 일치하는 패턴 검색 ignore
  		   */ 
  	      	
  	     	content_val = content_val.substring(content_val.indexOf("<p>")+3);
  	     	content_val = content_val.substring(0,content_val.indexOf("</p>"));
  	     	
  	     	if(content_val.trim().length == 0){
  	     		alert("글 내용을 입력하세요!!");
  	     		return; //종료
  	     	}
  	     	
  	     	
  	  	// 결재라인 유효성 검사
  	  		const second_approval = $("table#approval tr").eq(1).length;
  	    	if(second_approval == 0){
 	    		 alert("결재자를 선택하세요!!");
 	    		 return; // 종료
 	    	}
  	    	
  	    	 /* 
  	         FormData 객체는 ajax 로 폼 전송을 가능하게 해주는 자바스크립트 객체이다.
  	                즉, FormData란 HTML5 의 <form> 태그를 대신 할 수 있는 자바스크립트 객체로서,
  	                자바스크립트 단에서 ajax 를 사용하여 폼 데이터를 다루는 객체라고 보면 된다. 
  	         FormData 객체가 필요하는 경우는 ajax로 파일을 업로드할 때 필요하다.
  	       */ 
  	    
  	       /*
  	          === FormData 의 사용방법 2가지 ===
  	          <form id="myform">
  	             <input type="text" id="title" name="title" />
  	             <input type="file" id="imgFile" name="imgFile" />
  	          </form>
  	               
  	                 첫번째 방법, 폼에 작성된 전체 데이터 보내기   
  	          var formData = new FormData($("form#myform").get(0));  // 폼에 작성된 모든것       
  	                  또는
  	          var formData = new FormData($("form#myform")[0]);  // 폼에 작성된 모든것
  	          // jQuery선택자.get(0) 은 jQuery 선택자인 jQuery Object 를 DOM(Document Object Model) element 로 바꿔주는 것이다. 
  		      // DOM element 로 바꿔주어야 순수한 javascript 문법과 명령어를 사용할 수 있게 된다. 
  	       
  		   // 또는
  	          var formData = new FormData(document.getElementById('myform'));  // 폼에 작성된 모든것
  	        
  	                 두번째 방법, 폼에 작성된 것 중 필요한 것만 선택하여 데이터 보내기 
  	          var formData = new FormData();
  	       // formData.append("key", value값); // "key" 값이 폼태그의 name명에 해당하는 것이 되고, value값이 실제 값이 되는 것이다.  
  	          formData.append("title", $("input#title").val());
  	          formData.append("imgFile", $("input#imgFile")[0].files[0]);
  	      */  
  	    //  var formData = new FormData($("#fileForm")[0]); // $("#fileForm")[0] 폼 에 작성된 모든 데이터 보내기 
  	      //  또는 
  	    	var formData = new FormData($("form[name='newDocFrm']").get(0)); // $("form[name='newDocFrm']").get(0) 폼 에 작성된 모든 데이터 보내기 
  	    	
  	      	if(file_arr.length > 0) { // 파일첨부가 있을 경우   	    	
  	      	// 첨부한 파일의 총합의 크기가 10MB 이상 이라면 메일 전송을 하지 못하게 막는다.
          		let sum_file_size = 0;
  	          	for(let i=0; i<file_arr.length; i++) {
  	            	sum_file_size += file_arr[i].size;
  	          	}// end of for---------------
  	    		
  	          	if( sum_file_size >= 10*1024*1024 ) { // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 
	            	alert("첨부한 파일의 총합의 크기가 10MB 이상이라서 파일을 업로드할 수 없습니다.!!");
	        	  	return; // 종료
	          	}
	          	else { // formData 속에 첨부파일 넣어주기
	        		file_arr.forEach(function(item){
	                	formData.append("file_arr", item);  // 첨부파일 추가하기.  "file_arr" 이 키값이고  item 이 밸류값인데 file_arr 배열속에 저장되어진 배열요소인 파일첨부되어진 파일이 되어진다.    
	                                                      // 같은 key를 가진 값을 여러 개 넣을 수 있다.(덮어씌워지지 않고 추가가 된다.)
	              	});
	          	}
  	      	}
  	      
  	    	
  	    	$.ajax({
            	url : "<%= ctxPath%>/approval/newdoc.kedai",
              	type : "post",
              	data : formData,
              	processData:false,  // 파일 전송시 설정 
              	contentType:false,  // 파일 전송시 설정 
              	dataType:"json",
              	success:function(json){
            	  // console.log("~~~ 확인용 : " + JSON.stringify(json));
                  // ~~~ 확인용 : {"result":1}
                	if(json.result == 1) {
            	    	location.href="<%= ctxPath%>/approval/newDocEnd.kedai"; 
                  	}
                	else {
                        alert("문서 등록에 실패하였습니다.");
                    }
              	},
              	error: function(request, status, error){
  					alert("111111111code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
  		      	}
          	});// end of ajax-------------------
  	      	
		});// end of $("button#btnWrite").click(function()--------------
				
		  /*
        processData 관련하여, 일반적으로 서버에 전달되는 데이터는 query string(쿼리 스트링)이라는 형태로 전달된다. 
        ex) http://localhost:9090/board/list.action?searchType=subject&searchWord=안녕
            ? 다음에 나오는 searchType=subject&searchWord=안녕 이라는 것이 query string(쿼리 스트링) 이다. 

        data 파라미터로 전달된 데이터를 jQuery에서는 내부적으로 query string 으로 만든다. 
                하지만 파일 전송의 경우 내부적으로 query string 으로 만드는 작업을 하지 않아야 한다.
                이와 같이 내부적으로 query string 으로 만드는 작업을 하지 않도록 설정하는 것이 processData: false 이다.
    */
     
    /*
        contentType 은 default 값이 "application/x-www-form-urlencoded; charset=UTF-8" 인데, 
        "multipart/form-data" 로 전송이 되도록 하기 위해서는 false 로 해야 한다. 
                 만약에 false 대신에 "multipart/form-data" 를 넣어보면 제대로 작동하지 않는다.
    */
  	  
    
     // === jQuery UI 의 datepicker === //
	    $("input#startdate").datepicker({
	             dateFormat: 'yy-mm-dd'  //Input Display Format 변경
	            ,showOtherMonths: true   //빈 공간에 현재월의 앞뒤월의 날짜를 표시
	            ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
	            ,changeYear: true        //콤보박스에서 년 선택 가능
	            ,changeMonth: true       //콤보박스에서 월 선택 가능                
	        //   ,showOn: "both"          //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
	        //   ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
	        //   ,buttonImageOnly: true   //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
	        //   ,buttonText: "선택"       //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
	            ,yearSuffix: "년"         //달력의 년도 부분 뒤에 붙는 텍스트
	            ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
	            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
	            ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
	            ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
	        //  ,minDate: "-1M" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
	        //  ,maxDate: "+1M" //최대 선택일자(+1D:하루후, +1M:한달후, +1Y:일년후)                
	    });
	     
	    $("input#enddate").datepicker({
            dateFormat: 'yy-mm-dd'  //Input Display Format 변경
           ,showOtherMonths: true   //빈 공간에 현재월의 앞뒤월의 날짜를 표시
           ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
           ,changeYear: true        //콤보박스에서 년 선택 가능
           ,changeMonth: true       //콤보박스에서 월 선택 가능                
       //   ,showOn: "both"          //button:버튼을 표시하고,버튼을 눌러야만 달력 표시됨. both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시됨.  
       //   ,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
       //   ,buttonImageOnly: true   //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
       //   ,buttonText: "선택"       //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
           ,yearSuffix: "년"         //달력의 년도 부분 뒤에 붙는 텍스트
           ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
           ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
           ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
           ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
       //  ,minDate: "-1M" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
       //  ,maxDate: "+1M" //최대 선택일자(+1D:하루후, +1M:한달후, +1Y:일년후)                
   });
        
	  	
        // input을 datepicker로 선언
        $("input#startdate").datepicker();                    
        $("input#enddate").datepicker();
		
        
        // 초기값을 오늘 날짜로 설정
  	  //   $("input#startdate").datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
  	 //    $("input#enddate").datepicker('setDate', 'today'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, +1M:한달후, +1Y:일년후)
  	
		$("#startdate").datepicker('setDate', new Date());
        $("#enddate").datepicker('setDate', new Date());
  	
		$("input#startdate, input#enddate").keyup(function(e) {
	  		$(e.target).val("");
	  		$(e.target).datepicker('setDate', 'today');
	  		alert("기안일자는 마우스로만 클릭하세요.g");
	  		
	  	}); //  end of $('input#datepicker').keyup((e) => {})--------------------------------------
	  	
<%-- 
	 // 시작일 Datepicker
	    $("#startdate").datepicker({
	        onSelect: function(selectedDate) {
	            // 종료일의 최소 날짜를 선택한 시작일로 설정
	            var minDate = $(this).datepicker('getDate');
	            $("#enddate").datepicker("option", "minDate", minDate);
	        }
	    });
	    
	    // 종료일 Datepicker
        $("#enddate").datepicker({
            onSelect: function(selectedDate) {
                // 시작일의 최대 날짜를 선택한 종료일로 설정
                var maxDate = $(this).datepicker('getDate');
                $("#startdate").datepicker("option", "maxDate", maxDate);
            }
        });
--%>	     
	    
	    
	    // **** !!!! 중요 !!!! **** //
		 /*
		    선택자를 잡을때 선택자가 <body>태그에 직접 기술한 것이라면 선택자를 제대로 잡을수가 있으나
		    스크립트내에서 기술한 것이라면 선택자를 못 잡아올수도 있다.
		    이러한 경우는 아래와 해야만 된다.
		    $(document).on("이벤트종류", "선택자", function(){}); 으로 한다.
		 */
		 
		$(document).on("click", "div.openList > img", function(){
			if($(this).is(".plus")) {
				var $img = $(this); // 현재 클릭된 img 요소를 변수에 저장
				var $ul = $(this).parent();
				
				// img에  plus 클래스가 있는 경우
				$img.removeClass("plus");
				$img.attr("src", "<%=ctxPath%>/resources/images/common/Approval/minus.png");
				var str_dept_code = $(this).next("input#deptCode").val();
				var loginuser_id = "${sessionScope.loginuser.empid}";
				// console.log(str_dept_code);
				var v_html = "";
				$.ajax({
					context: this,
					url:"${pageContext.request.contextPath}/approval/deptEmpListJSON.kedai",
					data:{"dept_code":str_dept_code,
						"loginuser_id":loginuser_id},
					dataType:"json",
					type:"post",
					success:function(json){
						//console.log(JSON.stringify(json));
						//[{"empid":"2010001-001","job_name":"대표이사","name":"관리자","dept_name":" ","fk_dept_code":" ","job_code":"1"}]
						//[{"empid":"2011300-001","job_name":"전무","name":"이주빈","dept_name":"회계부","fk_dept_code":"300","job_code":"2"}]
						v_html = "";
						
						if(json.length >0){
							
							v_html += "<ul class='moreList approvalList'>";
							$.each(json, function(index, item){
								v_html += 	`<li>
								    			<input type='checkbox' id='\${item.empid}' value='\${item.empid}' class='inModalAppList' />
								    			<input type='hidden' id='deptName' value='\${item.dept_name}' />
								    			<input type='hidden' id='jobCode' value='\${item.job_code}'/>
								    			<label for='\${item.empid}' id="labelBold"><span id="emp_name">\${item.name}</span>&nbsp;<span id="emp_jobName">\${item.job_name}</span></label>
											</li>`;
							});
							v_html += "</ul>";
						}
						//console.log(v_html);
						
						$ul.append(v_html);
						//
						//event.target.innerHTML = v_html;
					},
					error: function(request, status, error){
			        	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			        }
				});	
				
			}// end of if-------------
			
		});
		    
		    /*
	         ===== 선택자의 class 명 알아오기 =====
	              선택자.attr('class')  또는  선택자.prop('class')  
	         
	         ===== 선택자의 id 명 알아오기 =====
	              선택자.attr('id')  또는  선택자.prop('id')
	                  
	         ===== 선택자의 name 명 알아오기 =====   
	             선택자.attr('name')  또는  선택자.prop('name')
	         
	                     
	          >>>> .prop() 와 .attr() 의 차이 <<<<            
	         .prop() ==> form 태그내에 사용되어지는 엘리먼트의 disabled, selected, checked 의 속성값 확인 또는 변경하는 경우에 사용함. 
	         .attr() ==> 그 나머지 엘리먼트의 속성값 확인 또는 변경하는 경우에 사용함.

	         */


	    /*   
	       선택자.toggleClass("클래스명1");
	         ==> 이것은 선택자에 "클래스명1" 이 이미 적용되어 있으면 선택자에 "클래스명1" 을 제거해주고, 
	             만약에 선택자에 "클래스명1" 이 적용되어 있지 않으면 선택자에 "클래스명1" 을 추가해주는 것.
	             
	         한마디로 addClass("클래스명1") 와 removeClass("클래스명1") 를 합친것 이라고 보면 된다.     
	     */  

	  //      $(e.target).toggleClass("changeCSSname");

	    // label 태그에 클릭을 했을때에 label 태그에 CSS 클래스 changeCSSname 이 
	       // 적용이 안되어진 상태이라면 label 태그에 CSS 클래스 changeCSSname 을 적용시켜주고,
	       // 이미 적용이 되어진 상태이라면 label 태그에 CSS 클래스 changeCSSname 을 해제시켜준다.

	        /*
            ==== jQuery 에서 라디오 또는 체크박스에 선택을 했는지를 알아오는 2가지 방법 ====
                
             1. $(라디오 또는 체크박스의 선택자).prop("checked") 
                ==> 선택을 했으면 true, 선택을 안했으면 false
                
             2. $(라디오 또는 체크박스의 선택자).is(":checked")   
                ==> 선택을 했으면 true, 선택을 안했으면 false
         */

           // console.log("라디오 선택여부 => ", $(elmt).prop("checked"));
            // 또는
           // console.log("라디오 선택여부 => ", $(elmt).is(":checked"));
            /*
		            라디오 선택여부 =>  false
		            라디오 선택여부 =>  true
		            라디오 선택여부 =>  false
		             라디오 선택여부 =>  false
            */
		       
		$(document).on("click", "ul.approvalList > li > input:checkbox", function(){
			// 체크박스를 클릭하면	    	
			let empId = $(this).val(); // 클릭한 체크박스에 해당하는 직원의 아이디값     
	        
	        // 클릭한 체크박스의 체크유무를 알아온다.
			if($(this).prop("checked")){// 체크 박스가 선택되어 있으면
				
				let $li = $(this).closest("li"); // 체크박스를 포함한 가장 가까운 <li> 요소 선택
				let empName = $li.find("#emp_name").text().trim(); // #emp_name 요소의 텍스트 가져오기
				let empJobName = $li.find("#emp_jobName").text().trim(); // #emp_jobName 요소의 텍스트 가져오기
				let deptName = $li.find("#deptName").val();
				let jobCode = $li.find("#jobCode").val();
				
		        // 선택된 모든 체크박스의 수
				let order = $("ul.approvalList > li input:checkbox:checked").length;
				
				if(order > 3){
					alert("결제자는 3명 이상 선택 불가합니다.");
					$(this).prop("checked", false);
					return;//종료
				}
				
				var htmlRow = `<tr class='oneRow'>
			            	   	 <td><input type='hidden' name='totalListNum' value='\${order}'>\${order}</td>
			                	 <td>\${deptName}</td>
			                     <td>\${empJobName}</td>
			                     <td>\${empName}</td>
			                     <td class ='empId' style='display:none;'><input type='hidden' name='level_no_\${order}' value='\${empId}' />\${empId}</td>
			                     <td class ='jobCode' style='display:none;'>\${jobCode}</td>
			                  </tr>`;

			    $("table.addApproval").append(htmlRow);	
			}
			else{// 체크박스가 선택되어 있지 않으면			
				$("table.addApproval tr.oneRow").each(function(index, item){
					let td_empId = $(item).find("td.empId").text().trim();
					if(td_empId == empId){
						$(item).remove();
					}
				});
				// 남아있는 테이블 행의 순서 재정렬
				$("table.addApproval tr.oneRow").each(function(index, row){
					$(row).find("td:first-child").text(index + 1);
				});
			} 
		});
		     
	    

		
		<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 시작 === --%>
	    let file_arr = []; // 첨부되어진 파일 정보를 담아둘 배열 
			   
		// == 파일 Drag & Drop 만들기 == //
		$("div#fileDrop").on("dragenter", function(e){ /* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */ 
		    e.preventDefault();
			<%-- 
			    브라우저에 어떤 파일을 drop 하면 브라우저 기본 동작이 실행된다. 
			    이미지를 drop 하면 바로 이미지가 보여지게되고, 만약에 pdf 파일을 drop 하게될 경우도 각 브라우저의 pdf viewer 로 브라우저 내에서 pdf 문서를 열어 보여준다. 
			    이것을 방지하기 위해 preventDefault() 를 호출한다. 
			    즉, e.preventDefault(); 는 해당 이벤트 이외에 별도로 브라우저에서 발생하는 행동을 막기 위해 사용하는 것이다.
			--%>
			        
			e.stopPropagation();
			<%--
	            propagation 의 사전적의미는 전파, 확산이다.
	            stopPropagation 은 부모태그로의 이벤트 전파를 stop 중지하라는 의미이다.
	            즉, 이벤트 버블링을 막기위해서 사용하는 것이다. 
	            사용예제 사이트 https://devjhs.tistory.com/142 을 보면 이해가 될 것이다. 
			--%>
		}).on("dragover", function(e){ /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
	    	e.preventDefault();
	        e.stopPropagation();
	        $(this).css("background-color", "#ffd8d8");
		}).on("dragleave", function(e){ /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때  */
	    	e.preventDefault();
	        e.stopPropagation();
	        $(this).css("background-color", "#fff");
		}).on("drop", function(e){      /* "drop" 이벤트는 드롭대상인 박스 안에서 Drag 한것을 Drop(Drag 한 파일(객체)을 놓는것) 했을 때. 필수이벤트이다. */
		    e.preventDefault();
		    $("span#fileInfo").css("display", "none");
		    var files = e.originalEvent.dataTransfer.files;  
			    <%--  
	                jQuery 에서 이벤트를 처리할 때는 W3C 표준에 맞게 정규화한 새로운 객체를 생성하여 전달한다.
	                이 전달된 객체는 jQuery.Event 객체 이다. 이렇게 정규화된 이벤트 객체 덕분에, 
	                웹브라우저별로 차이가 있는 이벤트에 대해 동일한 방법으로 사용할 수 있습니다. (크로스 브라우징 지원)
	                순수한 dom 이벤트 객체는 실제 웹브라우저에서 발생한 이벤트 객체로, 네이티브 객체 또는 브라우저 내장 객체 라고 부른다.
		        --%>
	            /*  Drag & Drop 동작에서 파일 정보는 DataTransfer 라는 객체를 통해 얻어올 수 있다. 
	                jQuery를 이용하는 경우에는 event가 순수한 DOM 이벤트(각기 다른 웹브라우저에서 해당 웹브라우저의 객체에서 발생되는 이벤트)가 아니기 때문에,
	                event.originalEvent를 사용해서 순수한 원래의 DOM 이벤트 객체를 가져온다.
	                Drop 된 파일은 드롭이벤트가 발생한 객체(여기서는 $("div#fileDrop")임)의 dataTransfer 객체에 담겨오고, 
	                담겨진 dataTransfer 객체에서 files 로 접근하면 드롭된 파일의 정보를 가져오는데 그 타입은 FileList 가 되어진다. 
	                그러므로 for문을 사용하든지 또는 [0]을 사용하여 파일의 정보를 알아온다. 
	            */
			//  console.log(typeof files); // object
		    //  console.log(files);
	            <%--
	                FileList {0: File, length: 1}
	                0: File {name: 'berkelekle단가라포인트03.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (한국 표준시), webkitRelativePath: '', size: 57641, …}
	                    length: 1
	                [[Prototype]]: FileList
	                
	                
	                
	                FileList {0: File, 1: File, 2: File, 3: File, length: 4}
	                0: File {name: 'berkelekle덩크04.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (GMT+09:00), webkitRelativePath: '', size: 41931, …}
	                1: File {name: 'berkelekle디스트리뷰트06.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (GMT+09:00), webkitRelativePath: '', size: 48901, …}
	                2: File {name: 'berkelekle심플V넥02.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (GMT+09:00), webkitRelativePath: '', size: 58889, …}
	                3: File {name: 'berkelekle단가라포인트03.jpg', lastModified: 1605506138000, lastModifiedDate: Mon Nov 16 2020 14:55:38 GMT+0900 (GMT+09:00), webkitRelativePath: '', size: 57641, …}
	                    length: 4
	                [[Prototype]]: FileList
	            --%>
						
			if(files != null && files != undefined) {
	                <%-- console.log("files.length 는 => " + files.length);  
	                        // files.length 는 => 1 이 나온다.
	                        // files.length 는 => 4 가 나온다. 
	                --%>    
				        	
	                <%--
	                    for(let i=0; i<files.length; i++){
	                        const f = files[i];
	                        const fileName = f.name;  // 파일명
	                        const fileSize = f.size;  // 파일크기
	                        console.log("파일명 : " + fileName);
	                        console.log("파일크기 : " + fileSize);
	                    } // end of for------------------------
	                --%>
			            
	           	let html = "";
	           	const f = files[0]; // 어차피 files.length 의 값이 1 이므로 위의 for문을 사용하지 않고 files[0] 을 사용하여 1개만 가져오면 된다. 
	           	let fileSize = f.size/1024/1024;  /* 파일의 크기는 MB로 나타내기 위하여 /1024/1024 하였음 */
	            <%--
	            if( !(f.type == 'image/jpeg' || f.type == 'image/png') ) {
	                alert("jpg 또는 png 파일만 가능합니다.");
	                $(this).css("background-color", "#fff");
	                return;
	            }
	            --%>
	            
	           	if(fileSize >= 10) {
	               	alert("10MB 이상인 파일은 업로드할 수 없습니다.!!");
	               	$(this).css("background-color", "#fff");
	               	return;
	           	}
		       	else {
	               	file_arr.push(f); // 드롭대상인 박스 안에 첨부파일을 드롭하면 파일들을 담아둘 배열인 file_arr 에 파일들을 저장시키도록 한다. 
	               	const fileName = f.name; // 파일명	
	           
	               	fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
	                // fileSize 가 1MB 보다 작으면 소수부는 반올림하여 소수점 3자리까지 나타내며, 
	                // fileSize 가 1MB 이상이면 소수부는 반올림하여 소수점 1자리까지 나타낸다. 만약에 소수부가 없으면 소수점은 0 으로 표시한다.
	                /* 
	                        numObj.toFixed([digits]) 의 toFixed() 메서드는 숫자를 고정 소수점 표기법(fixed-point notation)으로 표시하여 나타난 수를 문자열로 반환해준다. 
	                                        파라미터인 digits 는 소수점 뒤에 나타날 자릿수 로써, 0 이상 20 이하의 값을 사용할 수 있으며, 구현체에 따라 더 넓은 범위의 값을 지원할 수도 있다. 
	                        digits 값을 지정하지 않으면 0 을 사용한다.
	                        
	                        var numObj = 12345.6789;

	                        numObj.toFixed();       // 결과값 '12346'   : 반올림하며, 소수 부분을 남기지 않는다.
	                        numObj.toFixed(1);      // 결과값 '12345.7' : 반올림한다.
	                        numObj.toFixed(6);      // 결과값 '12345.678900': 빈 공간을 0 으로 채운다.
	                */
	               	html += 
	                   	"<div class='fileList'>" +
	                       	"<span class='fileName'>"+fileName+"</span>" +
	                       	"<span class='fileSize'>("+fileSize+" MB)</span>" +
	                       	"<span class='delete'><i class='far fa-minus-square'></i></span>" +
	                       	"<span class='clear'></span>" +
	                   	"</div>";
	               	$(this).append(html);
	                    
	                // ===>> 이미지파일 미리보기 시작 <<=== // 
	                // 자바스크립트에서 file 객체의 실제 데이터(내용물)에 접근하기 위해 FileReader 객체를 생성하여 사용한다.
	                // console.log(f);
	            //   const fileReader = new FileReader();
	             //  fileReader.readAsDataURL(f); // FileReader.readAsDataURL() --> 파일을 읽고, result속성에 파일을 나타내는 URL을 저장 시켜준다. 
	                
	               // fileReader.onload = function() { // FileReader.onload --> 파일 읽기 완료 성공시에만 작동하도록 하는 것임. 
	                // console.log(fileReader.result); 
	                    /*
	                    data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAeAB4AAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAg 
	                    이러한 형태로 출력되며, img.src 의 값으로 넣어서 사용한다.
	                    */
	               //     document.getElementById("previewImg").src = fileReader.result;
	               // };
	                // ===>> 이미지파일 미리보기 끝 <<=== //
	           	}
	       	}// end of if(files != null && files != undefined)---------	
	            
	       	$(this).css("background-color", "#fff");
		});
	    
		// == Drop 되어진 파일목록 제거하기 == //
		$(document).on("click", "span.delete", function(e){
			
			let delSpan = $(e.target).closest("span.delete");
			let idx = $("span.delete").index(delSpan);
			//alert("인덱스 : " +idx);
			
			file_arr.splice(idx, 1);// 드롭대상인 박스 안에 첨부파일을 드롭하면 파일들을 담아둘 배열인 file_arr 에서 파일을 제거시키도록 한다. 
		//	console.log(file_arr);
			<%-- 
	           배열명.splice() : 배열의 특정 위치에 배열 요소를 추가하거나 삭제하는데 사용한다. 
	                           삭제할 경우 리턴값은 삭제한 배열 요소이다. 삭제한 요소가 없으면 빈 배열( [] )을 반환한다.
	   
	          배열명.splice(start, 0, element);  // 배열의 특정 위치에 배열 요소를 추가하는 경우 
	                      start   - 수정할 배열 요소의 인덱스
	                         0       - 요소를 추가할 경우
	                         element - 배열에 추가될 요소
	          
	            배열명.splice(start, deleteCount); // 배열의 특정 위치의 배열 요소를 삭제하는 경우    
	                         start   - 수정할 배열 요소의 인덱스
	                         deleteCount - 삭제할 요소 개수
	   		--%>
	    	$(delSpan).closest("div.fileList").remove();
	 //   	console.log("file_arr2"+file_arr);
			if(file_arr.length == 0){
		    	$("span#fileInfo").css("display", "inline");
		    }
		});	    
	    <%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 끝 === --%>
		
	    
	    $("input#startdate, input#enddate").on("change", function() {
			
			var startDate = $("#startdate").val();
	        var endDate = $("#enddate").val();
	        
            if(startDate != null && endDate != null){
           		var start = new Date(startDate);
                var end = new Date(endDate);
                
                if (end < start) {
                	 // endDate가 startDate보다 이전 날짜인 경우
                    alert("종료 날짜는 시작 날짜보다 이후여야 합니다.");
                    // Optional: endDate를 startDate와 동일하게 설정
                    //$("#enddate").val(startDate);
                    $("#startdate").datepicker('setDate', new Date());
                    $("#enddate").datepicker('setDate', new Date());
                    $("input:checkbox[class='end_day']").prop("checked", false);
                    $("input:checkbox[class='end_day']").prop("disabled", true);
                    $("input:checkbox[class='start_day']").prop("checked", false);
                    $("input#request_annual_leave").val(1);
                    return; // 이 시점에서 함수 종료
                }
                
                const diffTime = end.getTime() - start.getTime();// 문자열(날짜형식의 문자열이어야 함)을 날짜로 변경하기 
                // 날짜형식의 문자열은 2023-09-05 또는 2023/09/05 또는 2023.09.05 이다.
                const diffDay = Math.floor(diffTime / (1000 * 3600 * 24));
                var userAnnualLeave = ${sessionScope.loginuser.annual_leave};
                
                if (diffDay === 0) {
                    // diffDay가 0일 때
                    $("input:checkbox[class='end_day']").prop("disabled", true);
                } else if(diffDay > userAnnualLeave) {
                	alert("사용할 수 있는 연차보다 더 많은 날짜가 선택 되었습니다!");
                	$("#startdate").datepicker('setDate', new Date());
                    $("#enddate").datepicker('setDate', new Date());
                    $("input:checkbox[class='end_day']").prop("checked", false);
                    $("input:checkbox[class='end_day']").prop("disabled", true);
                    $("input:checkbox[class='start_day']").prop("checked", false);
                    $("input#request_annual_leave").val(1);
                    
                } else{
                    // diffDay가 0이 아닐 때
                    $("input:checkbox[class='end_day']").prop("disabled", false);
                }
                
                $("input#request_annual_leave").val(diffDay+1);
            	
            }
	    });
	    
	    
	  //시작일 안에 있는 체크박스들을 선택했을 경우 
	    $("input:checkbox[class='start_day']").click( (e) => {
	    	let annual_leave_get = parseFloat($("#request_annual_leave").val());
	        const bool = $(e.target).prop("checked");
	        var checkedCount = $("input:checkbox[class='start_day']:checked").length;
	        
	        //연차를 하루만 쓰는 경우
	        if ($("input:checkbox[class='end_day']").prop("disabled")) {
	        	if(checkedCount == 2 || checkedCount === 0){
	        		$("input:checkbox[class='start_day']").prop("checked", false);
	        		$("#request_annual_leave").val(1);
	        	}
	        	else{
	        		let annual_leave_new = annual_leave_get-0.5;
		            $("#request_annual_leave").val(annual_leave_new);
	        	}
	        }
	        else{// 연차를 연속해서 쓰는 경우 오전 반차만 허용한다.
	        	if(bool){
	        		if ($("input:checkbox[id='start_am_half_day']").prop("checked")) {
	        			let annual_leave_new = annual_leave_get-0.5;
			            $("#request_annual_leave").val(annual_leave_new);
	        		}
	        		else if($("input:checkbox[id='start_pm_half_day']").prop("checked")){
	        			alert("연차를 연속 사용할 경우 시작일은 오전 반차만 가능합니다!");
	        			$(e.target).prop("checked", false);
	        		}
	        	}
	        	else{
	        		let annual_leave_new = annual_leave_get+0.5;
		            $("#request_annual_leave").val(annual_leave_new);
	        	}
	        	
	        }
	        
	        
	        
	       
	    });// end of  $("input:checkbox[class='start_day']").click( (e) => {})----------------------------------
	    
		//종료일 안에 있는 체크박스들을 선택했을 경우 
	    $("input:checkbox[class='end_day']").click( (e) => {
	    	let annual_leave_get = parseFloat($("#request_annual_leave").val());
	        const bool = $(e.target).prop("checked");
	        // 클릭한 체크박스의 체크유무를 알아온다.
	        if(bool){
	        	if ($("input:checkbox[id='end_pm_half_day']").prop("checked")) {
        			let annual_leave_new = annual_leave_get-0.5;
		            $("#request_annual_leave").val(annual_leave_new);
	        	}
	        	else{
        			alert("연차를 연속 사용할 경우 종료일 오후 반차만 가능합니다!");
        			$(e.target).prop("checked", false);
        		}
	        }
	        else{
        		let annual_leave_new = annual_leave_get+0.5;
	            $("#request_annual_leave").val(annual_leave_new);
        	}
	    });// end of  $("input:checkbox[class='start_day']").click( (e) => {})----------------------------------
	    
	    
	    
	    
	    
		
	});// end of $(document).ready(function(){})-----------
	
	function modalSubmit(){

		var login_jobCode = ${sessionScope.loginuser.fk_job_code}; // 로그인한 사람의 직급코드
		var v_html ="";
		
		const isChecked = $("input[class='inModalAppList']:checked").length;
		
		if(isChecked != 0){// 모달 결재라인에 하나라도 선택이 되어 있으면
			$("table#approval").find("tr:not(:first)").remove(); // 회의록에 있는 결제 라인에 제목 부분 빼고 다 지우기
			let approvalArr = [];
			
			let isOk = true;
			$("table.addApproval tr").each(function(index, item) {
				if(index > 0){
					var getjobcode = $(item).find("td:eq(5)").text().trim();
					if(login_jobCode <= getjobcode){
						alert("결재자는 상위 직급만 선택 가능합니다.");
						$("#selectLineModal").modal("hide"); // 모달 닫기
						isOk = false;
						return false; // 함수 종료
					}
					else{
						approvalArr[index] = Number(getjobcode);
						v_html += "<tr>" + $(item).html() +"</tr>";
					}
				}// end of if(index > 0)--------------
			});
			
			for(let i=0; i<approvalArr.length-1; i++){
				if(approvalArr.length > 1){
					if(approvalArr[i] > approvalArr[i+1]){
						alert("결재 순서가 잘못 되었습니다.");
						$("#selectLineModal").modal("hide"); // 모달 닫기
						isOk = false;
						return false; // 함수 종료
					}
				}
			}
			// 모든 조건에 부합했을 때
			if(isOk){
				$("table#approval").append(v_html);
				$("#selectLineModal").modal("hide"); // 모달 닫기
				let lineNumHtml = `<input type="text" name="lineNumber" value="\${isChecked}">`;
				$(".htmlAdd").html(lineNumHtml);
			}		
		}
		else{
			alert("결재자를 최소 1명 이상 선택해주세요!");
			return;
		}
		
		
	}// end of function modalSubmit()------------------
	
	
	
	
	

///////////////////////////////////////////////////////////////////////
</script>

<div id="total_contatiner">
	<form name="newDocFrm" enctype="multipart/form-data" style="display: flex;">
			<%-- 버튼이 form 태그 안에 있으면 무조건 get방식으로 submit되어진다. 유효성 검사를 하고 post방식으로 submit해주고 싶다면 무조건   type="button" 해야 한다. --%>

	<div id="leftside" class="col-md-4" style="width: 90%; padding: 0;">
		<div id="title">연차신청서</div>
		<table class="table left_table" id="title_table">
			<tr>
				<th>문서번호</th>
				<td></td>
				<th>기안일자</th>
				<td><input type="hidden" name="created_date" value="${requestScope.str_now}" />${requestScope.str_now}</td>
			</tr>
			<tr>
				<th>기안자</th>
				<td><input type="hidden" name="fk_empid" value="${sessionScope.loginuser.empid}" />${sessionScope.loginuser.name}</td>
				<th>부서</th>
				<td>${requestScope.dept_name}</td>
			</tr>
		</table>
		<table class="table left_table" id="newday">
			<tr>
				<th>날짜</th>
				<td>
					<input type="text" name="startdate" id="startdate" maxlength="8" size="8" /> ~ <input type="text" name="enddate" id="enddate" maxlength="8" size="8" />
				</td>
			</tr>
			<tr>
				<th>사용 가능 연차</th>
				<td>
					<span>잔여 연차 :</span> <input type="text" style="font-weight:bold; width: 30px; text-align:center;" value="${sessionScope.loginuser.annual_leave}" readonly/>&nbsp; 
					<span>신청 연차 :</span> <input type="text" name="request_annual_leave" id="request_annual_leave" style="font-weight:bold; width: 30px; text-align:center;" value="1" readonly/>
				</td>
			</tr>
		
			<tr>
				<th style = "vertical-align: middle;">반차여부</th>
				<td id = "half_day">
					시작일&nbsp;(&nbsp;
					<input type="checkbox" id="start_am_half_day" name="start_am_half_day" class="start_day" /><label for="start_am_half_day">오전 반차</label>&nbsp;
					<input type="checkbox" id="start_pm_half_day" name="start_pm_half_day" class="start_day"/><label for="start_pm_half_day">오후 반차</label>&nbsp;
					)
					<br>
					종료일&nbsp;(&nbsp;
					<input type="checkbox" id="end_am_half_day" name="end_am_half_day" class="end_day"/><label for="end_am_half_day">오전 반차</label>&nbsp;
					<input type="checkbox" id="end_pm_half_day" name="end_pm_half_day" class="end_day"/><label for="end_pm_half_day">오후 반차</label>&nbsp;
					)
				</td>
			</tr>
		</table>

		<div id="title2">
			결재라인
			<button type="button" class="btn btn-outline-secondary btn-sm"
				data-toggle="modal" style="margin-left: 20%;"
				data-target="#selectLineModal">선택하기</button>
		</div>

		<!-- Modal -->
		<!-- Modal 구성 요소는 현재 페이지 상단에 표시되는 대화 상자/팝업 창입니다. -->
		<div class="modal fade" id="selectLineModal">
			<div class="modal-dialog modal-dialog-centered modal-lg h-75" >
				<!-- .modal-dialog-centered 클래스를 사용하여 페이지 내에서 모달을 세로 및 가로 중앙에 배치합니다. .modal-dialog 클래스를 사용하여 <div> 요소에 크기 클래스를 추가합니다.-->
				<div class="modal-content">
					<!-- Modal header -->
					<div class="modal-header">
						<h5 class="modal-title">결제자 선택</h5>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>

					<!-- Modal body -->
					<div class="modal-body row">
						<div class="modal_left col-md-4">
							<ul>
								<li class="dept"><c:forEach var="deptList"
										items="${requestScope.allDeptList}">
										<c:choose>
											<c:when test="${deptList.dept_name == ' '}">
												<div class="openList">
													<img
														src="<%=ctxPath%>/resources/images/common/Approval/plus.png"
														class="plus" />대표이사 <input type="hidden"
														value="${deptList.dept_code}" id="deptCode" />
												</div>

											</c:when>
											<c:otherwise>
												<div class="openList">
													<img
														src="<%=ctxPath%>/resources/images/common/Approval/plus.png"
														class="plus" />${deptList.dept_name} <input type="hidden"
														value="${deptList.dept_code}" id="deptCode" />
												</div>
											</c:otherwise>
										</c:choose>
									</c:forEach></li>
							</ul>
						</div>
						<div class="modal_right col-md-8">
							<table class="table addApproval" style="width: 100%;">
								<tr>
									<th style="width: 15%;">순서</th>
									<th style="width: 30%;">소속</th>
									<th style="width: 25%;">직급</th>
									<th style="width: 30%;">성명</th>
								</tr>
							</table>
						</div>
					</div>
					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-danger my_close"
							data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary btnSubmit"
							onclick="modalSubmit()" >확인</button>
					</div>
				</div>
			</div>
		</div>




		<table class="table left_table" id="approval">
			<tr style="text-align: center;">
				<th>순서</th>
				<th>소속</th>
				<th>직급</th>
				<th>성명</th>
			</tr>
		</table>
		
		<div class="htmlAdd">
			
		</div>
		
	</div>
	<div class="col-md-6" style="margin: 0; width: 100%">
		
			<table style="margin-left: 5%;" class="table" id="newDoc">
				<tr>
					<th style="width: 12%;">제목</th>
					<td><input type="text" name="doc_subject" size="85"
						maxlength="100" style="height: 23pt;" /></td>
				</tr>

				<tr>
					<td colspan='2'><textarea style="width: 100%; height: 500px;"
							name="doc_content" id="doc_content"></textarea></td>
				</tr>
				<%-- === #170. 파일첨부 타입 추가하기 시작=== --%>
			<%--	<tr>
					<th style="width: 12%;">파일첨부</th>
					<td><input type="file" name="attach" id="multiple" /></td>
				</tr>
				 === #170. 파일첨부 타입 추가하기 끝 === --%>
				
				<%-- ==== 파일을 마우스 드래그앤드롭(DragAndDrop)으로 추가하기 ==== --%>
		    <tr>
		       	<td width="12%" class="prodInputName">파일첨부</td>
		       	<td>
				    <div id="fileDrop" class="fileDrop border border-secondary" style="font-size: 10pt;"><span id="fileInfo">이곳에 파일을 올려주세요.</span></div>
		       	</td>
		    </tr>

			</table>
			<div style="text-align: right; margin: 18px 0 18px 0;">
				<button type="button" class="btn btn btn-dark btn-sm mr-4"
					id="btnWrite">작성완료</button>
				<button type="button" class="btn btn-primary btn-sm"
					onclick="javascript:history.back()">취소</button>
			</div>
			<input type="hidden" name="fk_doctype_code" value="100"/>
		
		</div>
</form>
	</div>



</body>
</html>