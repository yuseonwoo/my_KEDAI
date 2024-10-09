<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
    //    /MyMVC
%>
<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Kakao Maps -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f8cd36a9ca80015c17a395ab719b2d8d&libraries=services,places"></script>
<!-- FullCalendar CSS -->
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
<!-- FullCalendar JS -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>

<link href="<%= ctxPath %>/resources/css/jquery.timepicker.min.css" rel="stylesheet" />
<script src="<%= ctxPath %>/resources/js/jquery.timepicker.min.js"></script>

<style type="text/css">
   
@charset "UTF-8";
.nav-tabs .nav-link.active {
    background-color: #2c4459; /* 활성화된 탭의 배경색 변경 */
    color: white; /* 활성화된 탭의 글자색 변경 */
    border-bottom-color: transparent; /* 활성화된 탭의 하단 선 제거 */
}
.nav-tabs .nav-item {
    flex: 1; /* 각 탭을 균등하게 분배 */
    text-align: center;
}
#container{
    background-color: white;
    color: #2c4459;
    font-weight: 300;

}
#in-container {
    background-color: white;
    color: black;
    z-index: 10; /* 다른 요소들보다 앞에 오도록 z-index 설정 */
    overflow: hidden;
}
/* 지도 시작 */
   
div#title {
    font-size: 20pt;
 /* border: solid 1px red; */
    padding: 12px 0;
}

div.mycontent {
      width: 300px;
      padding: 5px 3px;
  }
  
  div.mycontent>.title {
      font-size: 12pt;
      font-weight: bold;
      background-color: #d95050;
      color: #fff;
  }
  
  div.mycontent>.title>a {
      text-decoration: none;
      color: #fff;
  }
        
  div.mycontent>.desc {
   /* border: solid 1px red; */
      padding: 10px 0 0 0;
      color: #000;
      font-weight: normal;
      font-size: 9pt;
  }
  
  div.mycontent>.desc>img {
      width: 50px;
      height: 50px;
  }
  

  /* 지도 끝 */
	
.requiredInfo {
    width: 360px;
    border: none;
    border-bottom: 1px solid #2c4459;
    margin-top: 8px;
}
.btnRegister button {
	border-radius: 25px;
	color: #fff;
	width: 100px;
	height: 50px;
}
.btnRegister button:nth-child(1) {
	background: #2c4459;
	margin-right: 10px;
}
.btnRegister button:nth-child(2) {
	background: #e68c0e;
}

   #map {
       width: 100%;
       height: 400px;
       margin-top: 10px;
   }
   #results {
       list-style: none;
       padding: 0;
       max-height: 200px;
       overflow-y: auto;
       margin-top: 10px;
   }
   #results li {
       padding: 10px;
       border-bottom: 1px solid #ddd;
       cursor: pointer;
   }
   #results li:hover {
       background-color: #f0f0f0;
   }
   .selectButton {
    display: none;
    margin-left: 10px;
    padding: 5px;
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
   }
</style>
<script type="text/javascript">

$(document).ready(function(){ 
  
    // 지도를 담을 영역의 DOM 레퍼런스
   var mapContainer = document.getElementById("dmap");
   
   // 지도를 생성할때 필요한 기본 옵션
   var options = {
           center: new kakao.maps.LatLng(37.556513150417395, 126.91951995383943), // 지도의 중심좌표. 반드시 존재해야함.
           <%--
               center 에 할당할 값은 kakao.maps.LatLng 클래스를 사용하여 생성한다.
               kakao.maps.LatLng 클래스의 2개 인자값은 첫번째 파라미터는 위도(latitude)이고, 두번째 파라미터는 경도(longitude)이다.
           --%>
           level: 4  // 지도의 레벨(확대, 축소 정도). 숫자가 클수록 축소된다. 4가 적당함.
     };
   
   // 지도 생성 및 생성된 지도객체 리턴
   var mapobj = new kakao.maps.Map(mapContainer, options);
   
   // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함.    
   var mapTypeControl = new kakao.maps.MapTypeControl();
   
   // 지도 타입 컨트롤을 지도에 표시함.
   // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미함.   
   mapobj.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT); 
   
   // 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함.   
   var zoomControl = new kakao.maps.ZoomControl();
   
   // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 지도에 표시함.
   // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 RIGHT는 오른쪽을 의미함.    
   mapobj.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
   
   if(navigator.geolocation) {
      // HTML5의 geolocation으로 사용할 수 있는지 확인한다 
      
      // GeoLocation을 이용해서 웹페이지에 접속한 사용자의 현재 위치를 확인하여 그 위치(위도,경도)를 지도의 중앙에 오도록 한다.
      navigator.geolocation.getCurrentPosition(function(position) {
         var latitude = position.coords.latitude;   // 현위치의 위도
         var longitude = position.coords.longitude; // 현위치의 경도
      //   console.log("현위치의 위도: "+latitude+", 현위치의 경도: "+longitude);
         // 현위치의 위도: 37.5499076, 현위치의 경도: 126.9218479
         
         // 마커가 표시될 위치를 geolocation으로 얻어온 현위치의 위.경도 좌표로 한다   
         var locPosition = new kakao.maps.LatLng(latitude, longitude);
           
          // 마커이미지의 옵션. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정한다. 
          var imageOption = {offset: new kakao.maps.Point(15, 39)};

          // 마커의 이미지정보를 가지고 있는 마커이미지를 생성한다. 
          var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

          // == 마커 생성하기 == //
         var marker = new kakao.maps.Marker({ 
            map: mapobj, 
              position: locPosition // locPosition 좌표에 마커를 생성 
         }); 
          
         marker.setMap(mapobj); // 지도에 마커를 표시한다
        
         
         // === 인포윈도우(텍스트를 올릴 수 있는 말풍선 모양의 이미지) 생성하기 === //
         
         // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능함.
         var iwContent = "<div style='padding:5px; font-size:13pt; color:black;'>현재 위치</div>";
         
         // 인포윈도우 표시 위치
          var iwPosition = locPosition;
         
       // removeable 속성을 true 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됨
          var iwRemoveable = true; 

          // == 인포윈도우를 생성하기 == 
         var infowindow = new kakao.maps.InfoWindow({
             position : iwPosition, 
             content : iwContent,
             removable : iwRemoveable
         });

         // == 마커 위에 인포윈도우를 표시하기 == //
         infowindow.open(mapobj, marker);

         // == 지도의 센터위치를 locPosition로 변경한다.(사이트에 접속한 클라이언트 컴퓨터의 현재의 위.경도로 변경한다.)
          mapobj.setCenter(locPosition);
         
       });
   }
   else {
      // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정한다.
      var locPosition = new kakao.maps.LatLng(37.556513150417395, 126.91951995383943);     
        
      // 위의 
      // 마커이미지를 기본이미지를 사용하지 않고 다른 이미지로 사용할 경우의 이미지 주소 
      // 부터
      // 마커 위에 인포윈도우를 표시하기 
      // 까지 동일함.
      
     // 지도의 센터위치를 위에서 정적으로 입력한 위.경도로 변경한다.
       mapobj.setCenter(locPosition);
      
   }// end of if~else------------------------------------------
   
   
   // ============ 지도에 매장위치 마커 보여주기 시작 ============ //
   // 매장 마커를 표시할 위치와 내용을 가지고 있는 객체 배열
   var positionArr = [];
   
   
   
   // infowindowArr 은 인포윈도우를 가지고 있는 객체 배열의 용도이다. 
   var infowindowArr = new Array();
   
   // === 객체 배열 만큼 마커 및 인포윈도우를 생성하여 지도위에 표시한다. === //
   for(var i=0; i<positionArr.length; i++){
      
      // == 마커 생성하기 == //
      var marker = new kakao.maps.Marker({ 
         map: mapobj, 
           position: positionArr[i].latlng   
      }); 
      
      // 지도에 마커를 표시한다.
      marker.setMap(mapobj);
      
      // == 인포윈도우를 생성하기 == 
      var infowindow = new kakao.maps.InfoWindow({
         content: positionArr[i].content,
         removable: true,
         zIndex : i+1
      });
      
      // 인포윈도우를 가지고 있는 객체배열에 넣기 
      infowindowArr.push(infowindow);
      
      // == 마커 위에 인포윈도우를 표시하기 == //
      // infowindow.open(mapobj, marker);
      
      // == 마커 위에 인포윈도우를 표시하기 == //
      // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
       // 이벤트 리스너로는 클로저(closure => 함수 내에서 함수를 정의하고 사용하도록 만든것)를 만들어 등록합니다 
       // for문에서 클로저(closure => 함수 내에서 함수를 정의하고 사용하도록 만든것)를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
       kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(mapobj, marker, infowindow, infowindowArr)); 
      
   }// end of for----------------
   // ============ 지도에 매장위치 마커 보여주기 끝 ============ //
   
   
   // ================== 지도에 클릭 이벤트를 등록하기 시작 ======================= //
   // 지도를 클릭하면 클릭한 위치에 마커를 표시하면서 위,경도를 보여주도록 한다.
   
   // == 마커 생성하기 == //
   // 1. 마커이미지 변경
   var imageSrc = 'http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png';       
        
   // 2. 마커이미지의 크기 
    var imageSize = new kakao.maps.Size(34, 39);   
            
    // 3. 마커이미지의 옵션. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정한다. 
    var imageOption = {offset: new kakao.maps.Point(15, 39)};   
      
    // 4. 이미지정보를 가지고 있는 마커이미지를 생성한다. 
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
          
    var movingMarker = new kakao.maps.Marker({ 
      map: mapobj
   });
    
    // === 인포윈도우(텍스트를 올릴 수 있는 말풍선 모양의 이미지) 생성하기 === //
   var movingInfowindow = new kakao.maps.InfoWindow({
       removable : false
     //removable : true   // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됨
   });
   
    
   kakao.maps.event.addListener(mapobj, 'click', function(mouseEvent) {         
          
       // 클릭한 위도, 경도 정보를 가져옵니다 
       var latlng = mouseEvent.latLng;
       
       // 마커 위치를 클릭한 위치로 옮긴다.
       movingMarker.setPosition(latlng);
       
       // 인포윈도우의 내용물 변경하기 
       movingInfowindow.setContent("<div style='padding:5px; font-size:9pt;'>여기가 어디에요?<br/><a href='https://map.kakao.com/link/map/여기,"+latlng.getLat()+","+latlng.getLng()+"' style='color:blue;' target='_blank'>큰지도</a> <a href='https://map.kakao.com/link/to/여기,"+latlng.getLat()+","+latlng.getLng()+"' style='color:blue' target='_blank'>길찾기</a></div>");  
       
       // == 마커 위에 인포윈도우를 표시하기 == //
       movingInfowindow.open(mapobj, movingMarker);
       
       var htmlMessage = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, '; 
           htmlMessage += '경도는 ' + latlng.getLng() + ' 입니다';
          
       var resultDiv = document.getElementById("latlngResult"); 
       resultDiv.innerHTML = htmlMessage;
   });
    // ================== 지도에 클릭 이벤트를 등록하기 끝 ======================= //
}); // end of $(document).ready(function(){})----------------------------------------------------

//!! 인포윈도우를 표시하는 클로저(closure => 함수 내에서 함수를 정의하고 사용하도록 만든것)를 만드는 함수(카카오에서 제공해준것임)입니다 !! // 
   function makeOverListener(mapobj, marker, infowindow, infowindowArr) {
       return function() {
          // alert("infowindow.getZIndex()-1:"+ (infowindow.getZIndex()-1));
             
          for(var i=0; i<infowindowArr.length; i++) {
             if(i == infowindow.getZIndex()-1) {
                   infowindowArr[i].open(mapobj, marker);
             }
             else{
                infowindowArr[i].close();
             }
          }
       };
       
   }// end of function makeOverListener(mapobj, marker, infowindow, infowindowArr)--------
   
   function updateAcceptYon(index, pf_empid, pf_res_num, nickname, email) {
	    // 선택된 라디오 버튼의 값을 가져옴
	    var acceptYonElements = document.getElementsByName('accept_yon_' + index);
	    var denyReasonElement = document.querySelector('input[name="deny_reason_' + index + '"]');

	    console.log("~~~ 확인용 : " + pf_empid);
	    var acceptYonValue = null;
	    for (var i = 0; i < acceptYonElements.length; i++) {
	        if (acceptYonElements[i].checked) {
	            acceptYonValue = acceptYonElements[i].value;
	            break;
	        }
	    }

	    if (acceptYonValue === null) {
	        alert("라디오 버튼을 선택하세요.");
	        return;
	    }

	    var denyReason = denyReasonElement ? denyReasonElement.value : '';

	    // 필요한 로직 수행 (예: Ajax 호출로 서버에 데이터 전송)
	    console.log("Index: " + index + ", Accept Yon Value: " + acceptYonValue + ", Deny Reason: " + denyReason + ", pf_empid: " + pf_empid);

	    if (acceptYonValue === "0") {
	        // 미승인일 경우 업데이트 안함.
	        alert("미승인 상태입니다. 업데이트하지 않습니다.");
	    } else if (acceptYonValue === "1") {
	        // 승인일 경우 업데이트를 하고 신청자에게 메일을 보낸다.
	        alert("승인 상태입니다. 업데이트하고 신청자에게 메일을 보냅니다.");
	        
	        // 컨트롤러에 변경된 값을 넘겨주기 (Ajax 사용)
	        $.ajax({
	            type: 'GET',
	            url:"<%=ctxPath%>/owner_Status_detail_update.kedai",
	            async: true,
	            data: {
	                index: index,
	                accept_yon: 1,
	                pf_empid: pf_empid,
	                pf_res_num: pf_res_num,
	                nickname: nickname,
	                email: email
	            },
	            success: function(response) {
	                console.log('Update success:', response);
	                // 성공 후 추가로 수행할 작업이 있으면 여기에 작성
	            },
	            error: function(xhr, status, error) {
	                console.error('Update failed:', error);
	                // 실패 시 수행할 작업이 있으면 여기에 작성
	            }
	        });
	    } else if (acceptYonValue === "2") {
	        // 거부인 경우 업데이트를 하고 신청자에게 거부사유와 함께 메일을 보낸다.
	        if (denyReason.trim() === "") {
	            alert("거부 사유를 입력하세요.");
	            return;
	        }
	        alert("거부 상태입니다. 업데이트하고 신청자에게 거부 사유와 함께 메일을 보냅니다.");

	        // 컨트롤러에 변경된 값을 넘겨주기 (Ajax 사용)
	        $.ajax({
	            type: 'GET',
	            url:"<%=ctxPath%>/owner_Status_detail_update.kedai",
	            data: {
	                index: index,
	                accept_yon: 2,
	                deny_reason: denyReason,
	                pf_empid: pf_empid,
	                pf_res_num: pf_res_num,
	                nickname: nickname,
	                email: email
	            },
	            success: function(response) {
	                console.log('Update success:', response);
	                // 성공 후 추가로 수행할 작업이 있으면 여기에 작성
	            },
	            error: function(xhr, status, error) {
	                console.error('Update failed:', error);
	                // 실패 시 수행할 작업이 있으면 여기에 작성
	            }
	        });
	    } else {
	        alert("라디오버튼을 선택해주세요.");
	    }
	    
		
	}// end of function updateAcceptYon(index, pf_empid, pf_res_num) {})----------------------------------






</script>
<div style="border: 0px solid red; padding: 2% 0; width: 90%;">
	<!-- Navigation Tabs -->
	<ul class="nav nav-tabs" style="margin-bottom:0.5%;">
	    <li class="nav-item">
	        <a class="nav-link" style="color: black; font-size:12pt;" href="<%= ctxPath %>/myCar.kedai">차량정보</a>
	    </li>
	    <li class="nav-item">
	        <a class="nav-link active" style="color: white; font-size:12pt;" href="<%= ctxPath %>/owner_Status.kedai">카셰어링현황(차주)</a>
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
	<div id="container">
		<h2 style="margin: auto; padding-bottom: 0.5%;">${requestScope.date}</h2>
	    <div id="dmap" style="height:400px; margin-bottom:0.5%;"></div>	
	    <div id="in-container" style="border: 0px solid red;">
		<table style="margin: auto;" class="table table-bordered">
            <thead>
            	<tr>
                    <th style="width: 20px; text-align: center;">no</th>
                    <th style="width: 50px; text-align: center;">닉네임</th>
                    <th style="width: 175px; text-align: center; border: none;">출발지</th>
					<th style="width: 10px; text-align: center; border: none;"><i class="fa-solid fa-arrow-right"></i></th>
					<th style="width: 175px; text-align: center; border: none;">도착지</th>
					<th style="width: 100px; text-align: center;">출발시간</th>
                    <th style="width: 20px; text-align: center;">승인</th>
                    <th style="width: 205px; text-align: center;">거부(사유)</th>
                    <th style="width: 50px; text-align: center;">미승인</th>
                    <th style="width: 50px; text-align: center;">알림보내기</th>
                </tr>
            </thead>
            <tbody>
 				<c:if test="${not empty requestScope.owner_dateInfoList}">
                        <c:forEach var="owner_dateInfoList" items="${requestScope.owner_dateInfoList}" varStatus="status">
                            <tr>
                            	<td align="center">${(requestScope.totalCount)-(requestScope.currentShowPageNo-1)*(requestScope.sizePerPage)-(status.index)}</td>
                                <td align="center">${owner_dateInfoList.nickname}</td>
                                <td align="center"
									style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${owner_dateInfoList.rdp_name}</td>
								<td align="center"
									style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;"><i
									class="fa-solid fa-arrow-right"></i></td>
								<td align="center"
									style="border-left: none; border-right: none; border-top: 1px solid #dee2e6; border-bottom: 1px solid #dee2e6;">${owner_dateInfoList.rds_name}</td>
								<td align="center">${owner_dateInfoList.share_may_time}</td>
                                <td align="center">
                                    <input type="radio" name="accept_yon_${status.index}" value="1" <c:if test="${owner_dateInfoList.accept_yon == 1}">checked</c:if>>
                                </td>
                                <td>
                                    <input type="radio" name="accept_yon_${status.index}" value="2" <c:if test="${owner_dateInfoList.accept_yon == 2}">checked</c:if>>
                                    <c:if test="${not empty owner_dateInfoList.reason_nonaccept}"><input type="text" name="deny_reason_${status.index}" style="border-bottom:1px solid gray; border-left: none; border-right:none; border-top:none; width: 90%; font-size: 10pt;" value="${owner_dateInfoList.reason_nonaccept}"/></c:if>
                                    <c:if test="${empty owner_dateInfoList.reason_nonaccept}"><input type="text" name="deny_reason_${status.index}" style="border-bottom:1px solid gray; border-left: none; border-right:none; border-top:none; width: 90%; font-size: 10pt;" placeholder="거부사유를 입력하세요(20자 내외)" value=""/></c:if>
                                </td>
                                <td align="center">
                                    <input type="radio" name="accept_yon_${status.index}" value="0" <c:if test="${owner_dateInfoList.accept_yon == 0}">checked</c:if>>
                                </td>
                                <td align="center">
                                    <input type="button" value="UPDATE" style="background-color: #2c4459; border-radius: 25px; color:white;" onclick="updateAcceptYon(${status.index}, '${owner_dateInfoList.pf_empid}','${owner_dateInfoList.pf_res_num}', '${owner_dateInfoList.nickname}', '${owner_dateInfoList.email}' )"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                <c:if test="${empty requestScope.owner_dateInfoList}">
                    <tr>
                        <td colspan="5" style="text-align: center;">데이터가 존재하지 않습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        <div id="pageBar" align="center" style="border: solid 0px gray; width: 50%; margin: 3% auto;">
                ${requestScope.pageBar}
        </div>
        </div>
	    </div>
	</div>
</div>
