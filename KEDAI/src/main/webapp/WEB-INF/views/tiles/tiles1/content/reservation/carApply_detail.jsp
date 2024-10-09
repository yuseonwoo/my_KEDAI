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
/* /* 360px 이하 */  /* 일반적으로 휴대폰 세로 */
@media screen and (max-width: 360px){
   div#search {
      padding-left: 0 !important;
   }
   
   div#nav button {
      width: 100%;
   }   
}

/* 361px ~ 767px 이하 */  /* 일반적으로 휴대폰 가로 */
@media screen and (min-width: 361px) and (max-width: 767px){
   div#search {
      padding-left: 0 !important;
   }
   
   div#nav button {
      width: 100%;
   }
} */

#container{
    background-color: white;
    color: #2c4459;
    font-size: 15pt;
    font-weight: 300;
    position: relative;
}
#in-container {
    background-color: white;
    color: black;
    width: 25%;
    height: 830px;
    position: absolute; /* 절대 위치 지정 */
    top: 0; /* 부모 요소의 위쪽에 위치 */
    left: 0; /* 부모 요소의 왼쪽에 위치 */
    z-index: 10; /* 다른 요소들보다 앞에 오도록 z-index 설정 */
    overflow: hidden;
}

 #bus_no,
 #bus_no_route{
   margin:3%;
 } 
.busStyle {font-weight: bold;
           color: #2c4459;
           cursor: pointer;
           height:60px;
           width: 100%;
           background-color: white;
           border: none;}
.busStyle:hover
{background-color: #2c4459;
 color: white;}
 
 #showMap:hover{
    font-weight: bold;
    cursor: pointer;
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
	
  /* 달력 시작 */
  body {
      font-family: Arial, sans-serif;
  }
  .container {
      width: 80%;
      margin: 0 auto;
  }
  #calendar {
      max-width: 500px;
      margin: 0 auto;
  }    
.fc .fc-daygrid-day-number, .fc .fc-col-header-cell-cushion {
    color: #2c4459; /* 기본 날짜 및 요일 색상을 검정색으로 설정 */
}
.fc .fc-daygrid-day-frame {
    height: 40px !important; /* 원하는 높이로 조절 */
}
.fc .fc-daygrid-day-top {
    height: 15px !important; /* 날짜 숫자 부분의 높이 조절 */
}
.fc .fc-daygrid-day-events {
    height: 35px !important; /* 이벤트 부분의 높이 조절 */
}
.fc .fc-daygrid-day:hover .fc-daygrid-day-number, .fc .fc-col-header-cell-cushion:hover {
    font-weight: bold; /* hover 시 날짜 및 요일을 더 굵게 */
    color: #e68c0e; /* hover 시 날짜 및 요일 색상을 오렌지색으로 변경 */
} 
 .selected-date {
    background-color: lightgray; !important; 
}  
/*  .selected-date {
     background-color: gray !important;
 }
 .fc-day-disabled {
     background-color: lightgray !important;
 } */
  /* 달력 끝*/
  
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

/* Modal styles */
   .modal {
       display: none; /* Hidden by default */
       position: fixed; /* Stay in place */
       z-index: 1000; /* Sit on top */
       left: 0;
       top: 0;
       width: 100%; /* Full width */
       height: 100%; /* Full height */
       overflow: auto; /* Enable scroll if needed */
       background-color: rgb(0,0,0); /* Fallback color */
       background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
       padding-top: 60px;
   }
   .modal-content {
       background-color: #fefefe;
       margin: 5% auto; /* 15% from the top and centered */
       padding: 20px;
       border: 1px solid #888;
       width: 80%; /* Could be more or less, depending on screen size */
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
	
	/* 날짜 바꾸기 시작 */
	
        function convertDateFormat(start_date) {
            // 입력된 날짜 문자열을 확인하고 출력
//          console.log("Input Date: ", inputDate);

            // 날짜 문자열을 분리 (2024-07-17 00:00:00)
            const dateTimeParts = start_date.split(' ');
            const dateParts = dateTimeParts[0].split('-');
            const timeParts = dateTimeParts[1].split(':');

            // 연도, 월, 일, 시간, 분, 초 추출
            const year = dateParts[0];
            const month = dateParts[1] - 1; // 월은 0부터 시작
            const day = dateParts[2];
            const hours = timeParts[0];
            const minutes = timeParts[1];
            const seconds = timeParts[2];

            // Date 객체 생성 (년, 월, 일, 시, 분, 초)
            const date = new Date(year, month, day, hours, minutes, seconds);
//          console.log("Date Object: ", date);
//			Date Object:  Wed Jul 17 2024 00:00:00 GMT+0900 (한국 표준시)
            // 날짜 포맷 변경
            const formattedDate = date.toString();

            return date;
        }
	
        function parseDate(str, add) {
            var datePart = str.substring(0, 10);
            // 분리된 날짜에서 하이픈을 제거 (2024-01-01 -> 20240101)
            var formattedDate = datePart.replace(/-/g, '');

            var year = parseInt(formattedDate.substring(0, 4), 10);
            var month = parseInt(formattedDate.substring(4, 6), 10) - 1; // 월은 0부터 시작
            var day = parseInt(formattedDate.substring(6, 8), 10) + add;
            return new Date(year, month, day);
        }
        
     var start_date = $("input:hidden[name='start_date']").val();
     var convertedstart_date = parseDate(start_date, 0);
     var last_date = $("input:hidden[name='last_date']").val();
     var convertedlast_date = parseDate(last_date, 1);
  // console.log(convertedDate); // "Mon Jul 01 2024 00:00:00 GMT+0900 (한국 표준시)"
     //Wed Jul 17 2024 00:00:00 GMT+0900 (한국 표준시)
     
    /* 날짜 바꾸기 끝 */
	/* 달력 시작 */
	
    var calendarEl = document.getElementById('calendar');
    var today = new Date();
    today.setHours(0, 0, 0, 0); // 오늘 날짜의 시간 부분을 0으로 설정
    var year = today.getFullYear();
    var month = today.getMonth();
//  console.log("~~~확인용 start: " + new Date(year, month, 1));
//  ~~~확인용 start: Mon Jul 01 2024 00:00:00 GMT+0900 (한국 표준시)
    var startDate = convertedstart_date;
    var endDate = convertedlast_date;
//  console.log("~~~ 확인용  startDate ; " + startDate);
//  console.log("~~~ 확인용  endDate ; " + endDate);
    var calendarOptions = {
        initialView: 'dayGridMonth',  // 월간 달력으로 표시
        
        dateClick: function(info) {
 //         alert('Date: ' + info.dateStr);
 //			Date: 2024-08-23
 			
 			var selectDate = new Date(info.dateStr);
 			$("input[name='share_date']").val(info.dateStr);	
 			
            $('.fc-daygrid-day').removeClass('selected-date');

            // 선택된 날짜의 배경색을 회색으로 설정
            $(info.dayEl).addClass('selected-date'); 

            // 선택한 날짜가 블록된 날짜인지 확인
            if (selectDate <= today && selectDate >= startDate) {
                alert('이전 날짜에는 예약할 수 없습니다.');
                $(info.dayEl).removeClass('selected-date');
            }
        },
        validRange: {
            start: startDate, // 가져온 start_date
            end: endDate // 가져온 last_date
        },
        height: 'auto', // 달력 높이를 자동으로 조절
        contentHeight: 'auto', // 달력 내용의 높이
        aspectRatio: 1.5 // 달력의 가로 세로 비율

    };
	 // 오늘 날짜가 범위 내에 포함되어 있는지 확인
	    if (today >= startDate && today <= endDate) {
	        // datesSet 콜백을 사용하여 달력이 렌더링될 때 오늘 이전의 날짜를 블록 처리
	        calendarOptions.datesSet = function(info) {
	            $('.fc-daygrid-day').each(function() {
	                var dateStr = $(this).data('date');
	                var dateObj = new Date(dateStr);
	                dateObj.setHours(0, 0, 0, 0); // 날짜의 시간 부분을 0으로 설정
	
	                // 오늘 이전의 날짜를 파란색으로 블록 처리
	                if (dateObj < today) {
	                    $(this).css('background-color', '#a6a6a6');
	                }
	            });
	        };
	    }
	 
	var calendar = new FullCalendar.Calendar(calendarEl, calendarOptions);
    calendar.render();
	/* 달력 끝*/
	
	/* 스타일링 추가 */
	document.head.insertAdjacentHTML('beforeend', `
	<style>
	    .fc-daygrid-day.selected-date {
	        background-color: gray !important; /* 선택된 날짜의 배경색을 회색으로 설정 */
	    }
	</style>
	`);
	
	/* 모달 지도 시작 */
	var modal = document.getElementById("mapModal");
	var btn;
    var span = document.getElementsByClassName("close")[0];
    var searchButton = document.getElementById('searchButton');
    var selectedPlace = null;

    // 모달 display 속성 변경 추적
    Object.defineProperty(modal.style, 'display', {
        set: function(value) {
            console.log('Modal display changed to:', value);
            this.setProperty('display', value);
        }
    });
    var index;
    $("input.rname").click(function(){
    	index = this.getAttribute("data-index");
//    	console.log(index);
    	// 모달 열기
        modal.style.display = "block";
        initializeMap();
        
	    if(index == 0){
	       
	        function showPlaceInfo(place) {
	            console.log("place" + place);
	            var place_name = place.place_name;
	            var road_address_name = place.road_address_name;
	    		var dp_lat = place.x;
	    		var dp_lng = place.y;

	            //document.getElementById("departure_name").value = place_name;
	            //document.getElementById("departure_address").value = address_name;
	            // alert(document.getElementById("departure_name").value); -- 문제: refresh가 되서 초기화됨.  clickEvent.preventDefault(); 이부분 추가.
	            // 또는
	            $("input[name='rdp_name']").val(place_name);		
	            $("input[name='rdp_add']").val(road_address_name);
	       		$("input[name='rdp_lat']").val(dp_lat);	
	       		$("input[name='rdp_lng']").val(dp_lng);	
	            
	       		modal.style.display = "none";
	
	
	        }
	    }
	    if(index == 1){
	        // 모달 열기

	        function showPlaceInfo(place) {
	            console.log("place" + place);
	            var place_name = place.place_name;
	            var road_address_name = place.road_address_name;
	    		var ds_lat = place.x;
	    		var ds_lng = place.y;
	            //document.getElementById("departure_name").value = place_name;
	            //document.getElementById("departure_address").value = address_name;
	            // alert(document.getElementById("departure_name").value); -- 문제: refresh가 되서 초기화됨.  clickEvent.preventDefault(); 이부분 추가.
	            // 또는
	            $("input[name='rds_name']").val(place_name);		
	       		
	            $("input[name='rds_add']").val(road_address_name);
	       		$("input[name='rds_lat']").val(ds_lat);	
	       		$("input[name='rds_lng']").val(ds_lng);	
	            
	       		modal.style.display = "none";
	
	
	        }
	    }
    
	
	    // 모달 닫기
	    span.onclick = function() {
	        modal.style.display = "none";
	    }
	
	    // 모달 외부 클릭 시 닫기
	    window.onclick = function(event) {
	        if (event.target == modal) {
	            modal.style.display = "none";
	        }
	    }
	
	
	    if (typeof kakao === 'undefined' || !kakao.maps) {
	//      console.error('Failed to load Kakao Maps API');
	        return;
	    }
	
	
	    var map;
	    var ps;
	    var markers = [];
	    
	    function initializeMap() {
	        var mapContainer = document.getElementById('map'); 
	        var mapOption = { 
	            center: new kakao.maps.LatLng(37.566535, 126.97796919999996), 
	            level: 3 
	        }; 
	
	        map = new kakao.maps.Map(mapContainer, mapOption); 
	
	        if (!kakao.maps.services) {
	            console.error('Kakao Maps services library not loaded');
	            return;
	        }
	
	        ps = new kakao.maps.services.Places(); 
	        
	    }
	
	    // 검색 버튼 클릭 이벤트 핸들러
	    searchButton.onclick = function(clickEvent) {
	        var buildingName = document.getElementById('buildingName').value;
	//      console.log('Searching for:', buildingName);
	        ps.keywordSearch(buildingName, placesSearchCB);
	        clickEvent.preventDefault();      
	        clickEvent.stopPropagation();
	    };
	
	
	    function placesSearchCB(data, status, pagination) {
	        if (status === kakao.maps.services.Status.OK) {
	            console.log('Search successful:', data);
	            var resultsList = document.getElementById('results');
	            resultsList.innerHTML = '';
	            var bounds = new kakao.maps.LatLngBounds();
	            
	         // Clear existing markers
	            clearMarkers();
	         
	            data.forEach(function(place) {
	                var li = document.createElement('li');
	//              console.log('li successful:', li);
	                li.textContent = place.place_name;
	                var selectButton = document.createElement('button');
	                selectButton.textContent = '선택';
	                selectButton.className = 'selectButton';
	                selectButton.onclick = function(clickEvent) {
	                	clickEvent.preventDefault(); // 기본 동작 막기
	//                  alert('Selected: ' + place.place_name + place.road_address_name);
	                    showPlaceInfo(place);
		          	  	// 모달 초기화
	                    const modal_frmArr = document.querySelectorAll("div.modal-content");
						$('#buildingName').val("");
						$('#results').empty();
						
	                };
	
	                li.appendChild(selectButton);
	                li.onclick = function() {
	                    map.setCenter(new kakao.maps.LatLng(place.y, place.x));
	                    clearMarkers();
	                    displayMarker(place);
	                    document.querySelectorAll('.selectButton').forEach(function(button) {
	                        button.style.display = 'none';
	                    });
	                    selectButton.style.display = 'inline';
	                };
	                resultsList.appendChild(li);
	                
	                // Display marker for each place
	                var marker = displayMarker(place);
	                markers.push(marker);
	                bounds.extend(new kakao.maps.LatLng(place.y, place.x));
	            });
	            // Adjust map bounds to show all markers
	            map.setBounds(bounds);
	            
	        } else {
	            console.error('Failed to find the location:', status);
	        }
	    }
	    function displayMarker(place) {
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: new kakao.maps.LatLng(place.y, place.x)
	        });
	
	        kakao.maps.event.addListener(marker, 'click', function() {
	            var infowindow = new kakao.maps.InfoWindow({
	                content: '<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>'
	            });
	            infowindow.open(map, marker);
	        });
	        return marker;
	    }
	    function clearMarkers() {
	        markers.forEach(function(marker) {
	            marker.setMap(null);
	        });
	        markers = [];
	    }

    })//end of $("button.icon").click(function(){}-----------------------------------------------------------------------------
    		
    /* 모달 지도 끝 */
    
    
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

   var startCoords = new kakao.maps.LatLng(${requestScope.day_shareInfo.dp_lng}, ${requestScope.day_shareInfo.dp_lat});
   
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
          mapobj.setCenter(startCoords);
         
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
   
    
   var startCoords = new kakao.maps.LatLng(${requestScope.day_shareInfo.dp_lng}, ${requestScope.day_shareInfo.dp_lat});
   
   // 출발지와 도착지에 마커를 표시합니다.
   var startMarker = new kakao.maps.Marker({
       map: mapobj,
       position: startCoords,
       title: '출발지'
   });

   var startInfoWindow = new kakao.maps.InfoWindow({
       content: '<div style="padding:5px;">출발지</div>'
   });
   startInfoWindow.open(mapobj, startMarker);
   
   var endCoords = new kakao.maps.LatLng(${requestScope.day_shareInfo.ds_lng}, ${requestScope.day_shareInfo.ds_lat});

   var endMarker = new kakao.maps.Marker({
       map: mapobj,
       position: endCoords,
       title: '도착지'
   });

   var endInfoWindow = new kakao.maps.InfoWindow({
       content: '<div style="padding:5px;">도착지</div>'
   });
   endInfoWindow.open(mapobj, endMarker);
   
   mapobj.setCenter(startCoords); 
   // 지도의 경계에 맞게 이동
   var bounds = new kakao.maps.LatLngBounds();
   bounds.extend(startCoords);
   bounds.extend(endCoords);
   mapobj.setBounds(bounds);
   
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
   
    // === 시간 세팅  === //
   var start_time = $("input:hidden[name='start_time']").val();
   $('#startTime').timepicker({
           minTime: start_time,
           maxTime: '11:30pm',
           defaultTime: start_time,
           startTime: start_time,
           dynamic: false,
           dropdown: true,
           scrollbar: true
   });
    
   // 해당 테그에 키보드로 입력 못하도록
   // 키보드로 값을 입력했을 때 즉시 지우는 이벤트 핸들러
   $('#startTime').on('input', function() {
       $(this).val('');
   });
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
  
   function goRegister(){
	   // 검사하기 날짜 선택했는지, 출발지 도착지 칸이 채워져 있는지, 출발시간 칸이 채워져 있는지
	   let b_requiredInfo = true;
	   
	   // 출발시간
	   var share_may_time = document.getElementById('startTime').value.trim();
	   var rdp_name = document.getElementById('rdp_name').value.trim();
	   var rds_name = document.getElementById('rds_name').value.trim();
	   var share_date = document.getElementById('share_date').value.trim();
	   if(share_may_time == "" || rdp_name == "" || rds_name == "" || share_date == ""){
		   alert("모든 항목은 필수 항목입니다. \\n 전부 입력해주세요.");
		   return;
	   }
	   else{
		 const frm = document.day_shareInfoFrm;
		 frm.action = "<%= ctxPath%>/carApply_detailEnd.kedai";
		 frm.method = "post";
		 frm.submit();
	   }
   }
   function goBack() {
	   location.href="javascript:history.back();"
   }
    
</script>

<div id="container">
    <div id="dmap" style="margin-left:25%; width:75%; height:900px;"></div>
		<form name="day_shareInfoFrm" enctype="multipart/form-data"> 
			<input type="hidden" name="pf_res_num" value="${requestScope.day_shareInfo.res_num}"/>
			<input type="hidden" name="start_date" value="${requestScope.day_shareInfo.start_date}"/>
			<input type="hidden" name="last_date" value="${requestScope.day_shareInfo.last_date}"/>
			<input type="hidden" name="start_time" value="${requestScope.day_shareInfo.start_time}"/>
			<!-- 지도에서 보여줄 출발지 도착지의 위치 표시 용도  -->
			<input type="hidden" name="dp_lat" value="${requestScope.day_shareInfo.dp_lat}"/>
			<input type="hidden" name="dp_lng" value="${requestScope.day_shareInfo.dp_lng}"/>
			<input type="hidden" name="ds_lat" value="${requestScope.day_shareInfo.ds_lat}"/>
			<input type="hidden" name="ds_lng" value="${requestScope.day_shareInfo.ds_lng}"/>
			<!-- 작성한 정보를 넘겨줄 값 -->
			<input type="hidden" name="share_date" id="share_date" value=""/>
			<input type="hidden" name="rdp_add" value=""/>
			<input type="hidden" name="rdp_lat" value=""/>
			<input type="hidden" name="rdp_lng" value=""/>
			<input type="hidden" name="rds_add" value=""/>
			<input type="hidden" name="rds_lat" value=""/>
			<input type="hidden" name="rds_lng" value=""/>
			
    <div id="in-container">
        <div id="place" style="background-color:white; border: solid 0px red; margin: 3%;">
         <h2 style="font-weight: 300; text-align:center;">날짜 선택<br><span style="font-size:8pt; text-align: center;">차주가 지정한 기간중에 날짜를 선택해주세요.</span></h2>
         <div id="calendar"></div>	
         <br>
         <h3 style="font-weight: 300; text-align:center; margin-top:4%;">탑승 정보</h3>
  		 <div class="mt-3">
			 <h6>출발지&nbsp;<span class="star">*</span></h6>
			 <input type="text" name="rdp_name" class="rname requiredInfo" id="rdp_name" size="6" maxlength="20" data-index="0" readonly placeholder="경로에 많이 벗어날수록 거부 확률이 높아집니다." />	
	     	 <!-- 출발지 이름에서 주소를 가지고 온 값을 넣어주고 수정 불가능하다. -->
                <!-- The Modal start -->
                <div id="mapModal" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <input type="text" id="buildingName" placeholder="Enter building name">
                        <button id="searchButton">Search</button>
                        <div id="map"></div>
                        <ul id="results"></ul>
                    </div>
                </div>
                <!-- The Modal end -->
	     </div>
         <div class="mt-3">
			 <h6>도착지&nbsp;<span class="star">*</span></h6>
			 <input type="text" name="rds_name" class="rname requiredInfo" id="rds_name" size="6" maxlength="20" data-index="1" readonly placeholder="경로에 많이 벗어날수록 거부 확률이 높아집니다." />	
			 <!-- 도착지 이름에서 주소를 가지고 온 값을 넣어주고 수정 불가능하다. -->
			    <!-- The Modal start -->
                <div id="mapModal" class="modal">
                    <!-- Modal content -->
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <input type="text" id="buildingName" placeholder="Enter building name">
                        <button id="searchButton">Search</button>
                        <div id="map"></div>
                        <ul id="results"></ul>
                    </div>
                </div>
                <!-- The Modal end -->
	     </div>
		 <div class="mt-3">
			 <h6>출발시간&nbsp;<span class="star">* <span style="font-size:8pt;">수기로 값을 입력하지 마세요</span></span></h6>
			 <input type="text" name="share_may_time" id="startTime" size="6" maxlength="20" class="requiredInfo" placeholder="출발시간" value=""/>	
	     </div>      
       </div>
       <div class="mt-3" style="position: relative; left: 90px">
			<div class="btnRegister">
		        <button type="button" onclick="goRegister()">신청하기</button>
		        <button type="reset" onclick="goBack()">뒤로가기</button>
	    	</div>
	   </div>
    </div>
    </form>
</div>
<!--  오늘 이후 날짜도 block -->