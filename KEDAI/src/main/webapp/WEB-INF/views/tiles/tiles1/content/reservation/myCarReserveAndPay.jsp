<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctxPath = request.getContextPath();
    //    /MyMVC
%>
<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Kakao Maps -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f8cd36a9ca80015c17a395ab719b2d8d"></script>
    
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

               
</style>
<script type="text/javascript">

$(document).ready(function(){ 
   
   $("input:button[name='bus_no']").click(function(e){
      var bus_no = $(e.target).val();
//      alert("~~~ 확인용 bus_no : " + bus_no);
      choiceBus(bus_no);
      
   });//end of $("input:button[name='bus_no']").click(function(){})---------------------
   
   // 지도를 담을 영역의 DOM 레퍼런스
   var mapContainer = document.getElementById("map");
   
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
   
});

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
   
    function choiceBus(bus_no){
      // 버스 번호 선택시 나오는 테이블 ajax + 지도에 정류장 마커 띄워주기 시작 // 
      
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    	   // 지도를 담을 영역의 DOM 레퍼런스
    	   var mapContainer = document.getElementById("map");
    	   
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
      
      
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      $.ajax({
         url : "<%=ctxPath%>/bus_select.kedai",
         data:{"bus_no":bus_no},
         dataType:"json",
         success:function(json){
            console.log(JSON.stringify(json));
//          [{"station_name":"수원월드컵경기장.아름학교","lng":127.0402587819467,"pf_station_id":"03122","time_gap":10,"way":"경기도경제과학진흥원 방면","lat":37.28674706537582},{"station_name":"경기도경제과학진흥원","lng":127.04547963591234,"pf_station_id":"04021","time_gap":10,"way":"광교중앙.경기도청.아주대역환승센터 방면","lat":37.29079534179728},{"station_name":"광교중앙.경기도청.아주대역환승센터","lng":127.05138185376052,"pf_station_id":"04397","time_gap":10,"way":"종점","lat":37.288454732776685},{"station_name":"광교중앙.경기도청.아주대역환승센터","lng":127.05177379426947,"pf_station_id":"04396","time_gap":10,"way":"경기도경제과학진흥원 방면","lat":37.288537908037156},{"station_name":"경기도경제과학진흥원","lng":127.04516688665875,"pf_station_id":"04019","time_gap":10,"way":"수원월드컵경기장.아름학교 방면","lat":37.291135603390984},{"station_name":"수원월드컵경기장.아름학교","lng":127.0400587889236,"pf_station_id":"03123","time_gap":10,"way":"종점","lat":37.28707375972554}]
            let html = `<table id="bus_no_route">`;
            let no = 1;
		    var locPosition = new kakao.maps.LatLng(json[0].lat, json[0].lng);     
	        
	        mapobj.setCenter(locPosition);
            $.each(json, function(index, busStop) {
                var markerPosition  = new kakao.maps.LatLng(busStop.lat, busStop.lng);

                var marker = new kakao.maps.Marker({
                    position: markerPosition
                });

                marker.setMap(mapobj);

                // 마커에 클릭 이벤트 추가
                kakao.maps.event.addListener(marker, 'click', function() {
                    alert(busStop.station_name);
                });
            });
            
            $.each(json,function(index,item){
            	
               html += `<tr>`;
               html += `<td rowspan='2' width="10%;"><img src='<%=ctxPath%>/resources/images/common/bus/bus\${no}.png' style="width:100%;"/></td>`;
               html += `<td width="90%;" id="showMap"  onclick="showStation(event, '\${item.pf_station_id}', '\${bus_no}')">\${item.station_name}<span style="font-size: 10pt;">(</span><span style="font-size: 10pt;">\${item.pf_station_id}</span><span style="font-size: 10pt;">)</span></td>`;
//               html += `<td width="90%;" id="showMap" onclick="showStation(\${item.pf_station_id})">\${item.station_name}<span style="font-size: 10pt;">(</span><span style="font-size: 10pt;">\${item.pf_station_id}</span><span style="font-size: 10pt;">)</span></td>`;
               html += `</tr>`;
               html += `<tr>`;
               html += `<td width="90%;" style="color: #666666;">\${item.way}<span style="display: block; border: solid 1px #2c4459;"></span></td>`;
               html += `</tr>`;

               no = no+1;
               
            })
            
            html += `</table>`;
              $("div#bus-route").html(html);
            
  	        // == 지도를 담을 영역의 DOM 만들기 시작 == //
  	        json.forEach( (item, index) => {
  	     	    html += `<div class="map" id="map\${index}"></div>`;
  	        });                
  	        
  	        $("div#map_container").html(html);
  	        // == 지도를 담을 영역의 DOM 만들기 끝 == //
  	        
  	        
  	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 시작 == //
  	        const arr_mapContainer = [];
  	        for(let i=0; i<json.length; i++){
  	        	let mapContainer = document.getElementById("map"+i);
  	        	arr_mapContainer.push(mapContainer);
  	        }// end of for---------------------------
  	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 끝 == //
  	        
            // == 지도를 생성할때 필요한 기본 옵션 만들기 시작 == //
 	        const arr_options = [];
 	        
 	        json.forEach( item => {
 	     	    let options = {center: new kakao.maps.LatLng(item.lat, item.lng), // 지도의 중심좌표. 반드시 존재해야함.
 	            	 	       /*
 	            		  	     center 에 할당할 값은 kakao.maps.LatLng 클래스를 사용하여 생성한다.
 	            		  	     kakao.maps.LatLng 클래스의 2개 인자값은 첫번째 파라미터는 위도(latitude)이고, 두번째 파라미터는 경도(longitude)이다.
 	            		       */
 	            	 	       level: 4  // 지도의 레벨(확대, 축소 정도). 숫자가 클수록 축소된다. 4가 적당함.
 	             };
 	     	    
 	     	    arr_options.push(options);
 	        });
 	        // == 지도를 생성할때 필요한 기본 옵션 만들기 끝 == //
  	        
           // == 지도 생성 및 생성된 지도객체 리턴 시작 == // 
  	        const arr_mapobj = [];
  	        
  	        arr_options.forEach( (item, index) => {
  	     	    
  	        	let mapobj = new kakao.maps.Map(arr_mapContainer[index], arr_options[index]);
  	        	
  	        	arr_mapobj.push(mapobj);
  	        });
  	        // == 지도 생성 및 생성된 지도객체 리턴 끝 == //
  	        
  	        
  	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 시작 ==
  	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 시작 ==	
  	        arr_mapobj.forEach( item => {
  	        	
  	        	// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함. 	
      	        let mapTypeControl = new kakao.maps.MapTypeControl();
      	
      	        // 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함.	
      	        let zoomControl = new kakao.maps.ZoomControl();
  	        	
  	        	// 지도 타입 컨트롤을 지도에 표시함.
      	        // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미함.
  	        	item.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);        	
  	        	
  	        	// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 지도에 표시함.
      	    	// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 RIGHT는 오른쪽을 의미함.	 
      	    	item.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);   	
  	        });
  	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 끝 ==
  	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 끝 ==	
  	        
  	        // == 마커 생성하기 시작 == //
  	        const arr_marker = [];
  	        
  	        arr_mapobj.forEach( (item, index) => {
  	        	
  	        	let latitude = json[index].lat;
  	        	let longitude = json[index].lng;
  	        	
  	        	let locPosition = new kakao.maps.LatLng(latitude, longitude);
  	        	
  	        	let marker = new kakao.maps.Marker({ map: arr_mapobj[index], 
	    		                                         position: locPosition // locPosition 좌표에 마커를 생성 
	    			                                   });
  	        	
  	        	arr_marker.push(marker);
  	        });
  	        // == 마커 생성하기 끝 == //
         },
           error: function(request, status, error){
               alert("code11111: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
           }
      });
      
   }// end of function choiceBus() -----------------------------------------------------------------------   
   
   
   function showStation(event, pf_station_id, bus_no) {
	   var mapContainer = document.getElementById("map");
	   
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
	   // === 인포윈도우(텍스트를 올릴 수 있는 말풍선 모양의 이미지) 생성하기 === //
	     
	   // == 마커 위에 인포윈도우를 표시하기 == //
	   // 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
	   // 이벤트 리스너로는 클로저(closure => 함수 내에서 함수를 정의하고 사용하도록 만든것)를 만들어 등록합니다 
	   // for문에서 클로저(closure => 함수 내에서 함수를 정의하고 사용하도록 만든것)를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
	   //kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(mapobj, marker, infowindow)); 
   
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

	   //console.log("pf_station_id : " + pf_station_id);

      // 버스 정류장 선택시 해당위치의 인포윈도우 보여주기 ajax 시작 // 
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	  
		$.ajax({
		         url : "<%=ctxPath%>/station_select.kedai",
		         data:{"pf_station_id":pf_station_id,"bus_no":bus_no},
		         dataType:"json",
		         success:function(json){
		            console.log(JSON.stringify(json));
					
				    var locPosition = new kakao.maps.LatLng(json[0].lat, json[0].lng);     
			        
			        mapobj.setCenter(locPosition);
	                var markerPosition  = new kakao.maps.LatLng(json[0].lat, json[0].lng);
	
	                var marker = new kakao.maps.Marker({
	                    position: markerPosition
	                });
	
	                marker.setMap(mapobj);
	
    	    		// == 인포윈도우에 넣을 내용물 생성하기 == 
    	    		let html_content = "<div class='mycontent' style='text-align:center;'>"+ 
    					       		   "  <div class='title'>"+ 
    						           "    <span>"+json[0].station_name+"&nbsp;&nbsp;&nbsp;</span>"+  
    						           "  </div>"+
    						           "  <div class='desc'>"+ 
    						           "    <span class='address'> "+ json[0].bus_no+ "</span><br>"+
    						           "	<span class='address'> "+json[0].minutes_until_next_bus + "분뒤에도착</span>"	
    						           "  </div>"+ 
    						           "</div>";	
    						           
	         	   var infowindow = new kakao.maps.InfoWindow({
	         		  content: html_content, 
	         		  removable: true,
	        	      zIndex : 1
	        	    });
	        	      
	        	    
	        	   // == 마커 위에 인포윈도우를 표시하기 == //
	        	   infowindow.open(mapobj, marker);
	                // 마커에 클릭 이벤트 추가
	                kakao.maps.event.addListener(marker, 'click', function() {
	                    alert(json[0].station_name);
	                });

	                let html =	``;
		        	// == 지도를 담을 영역의 DOM 만들기 시작 == //
		   	        json.forEach( (item, index) => {
		   	     	    html += `<div class="map" id="map\${index}"></div>`;
		   	        });                
		   	        
		   	        $("div#map_container").html(html);
		   	        // == 지도를 담을 영역의 DOM 만들기 끝 == //
		   	        
		   	        
		   	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 시작 == //
		   	        const arr_mapContainer = [];
		   	        for(let i=0; i<json.length; i++){
		   	        	let mapContainer = document.getElementById("map"+i);
		   	        	arr_mapContainer.push(mapContainer);
		   	        }// end of for---------------------------
		   	        // == 지도를 담을 영역의 DOM 레퍼런스 만들기 끝 == //
		   	        
		             // == 지도를 생성할때 필요한 기본 옵션 만들기 시작 == //
		  	        const arr_options = [];
		  	        
		  	        json.forEach( item => {
		  	     	    let options = {center: new kakao.maps.LatLng(item.lat, item.lng), // 지도의 중심좌표. 반드시 존재해야함.
		  	            	 	       /*
		  	            		  	     center 에 할당할 값은 kakao.maps.LatLng 클래스를 사용하여 생성한다.
		  	            		  	     kakao.maps.LatLng 클래스의 2개 인자값은 첫번째 파라미터는 위도(latitude)이고, 두번째 파라미터는 경도(longitude)이다.
		  	            		       */
		  	            	 	       level: 4  // 지도의 레벨(확대, 축소 정도). 숫자가 클수록 축소된다. 4가 적당함.
		  	             };
		  	     	    
		  	     	    arr_options.push(options);
		  	        });
		  	        // == 지도를 생성할때 필요한 기본 옵션 만들기 끝 == //
		   	        
		            // == 지도 생성 및 생성된 지도객체 리턴 시작 == // 
		   	        const arr_mapobj = [];
		   	        
		   	        arr_options.forEach( (item, index) => {
		   	     	    
		   	        	let mapobj = new kakao.maps.Map(arr_mapContainer[index], arr_options[index]);
		   	        	
		   	        	arr_mapobj.push(mapobj);
		   	        });
		   	        // == 지도 생성 및 생성된 지도객체 리턴 끝 == //
		   	        
		   	        
		   	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 시작 ==
		   	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 시작 ==	
		   	        arr_mapobj.forEach( item => {
		   	        	
		   	        	// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함. 	
		       	        let mapTypeControl = new kakao.maps.MapTypeControl();
		       	
		       	        // 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함.	
		       	        let zoomControl = new kakao.maps.ZoomControl();
		   	        	
		   	        	// 지도 타입 컨트롤을 지도에 표시함.
		       	        // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미함.
		   	        	item.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);        	
		   	        	
		   	        	// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 지도에 표시함.
		       	    	// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 RIGHT는 오른쪽을 의미함.	 
		       	    	item.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);   	
		   	        });
		   	        // == 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함 끝 ==
		   	        // == 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함 끝 ==	
		   	        
		   	        // == 마커 생성하기 시작 == //
		   	        const arr_marker = [];
		   	        
		   	        arr_mapobj.forEach( (item, index) => {
		   	        	
		   	        	let latitude = json[index].lat;
		   	        	let longitude = json[index].lng;
		   	        	
		   	        	let locPosition = new kakao.maps.LatLng(latitude, longitude);
		   	        	
		   	        	let marker = new kakao.maps.Marker({ map: arr_mapobj[index], 
		 	    		                                         position: locPosition // locPosition 좌표에 마커를 생성 
		 	    			                                   });
		   	        	
		   	        	arr_marker.push(marker);
		   	        });
		   	        // == 마커 생성하기 끝 == //
		      
		         },
		           error: function(request, status, error){
		               alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		           }
		      });
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
   }//end of function showStation(${item.station_name}){
</script>

<div id="container">
    <div id="map" style="margin-left:25%; width:75%; height:900px;"></div>
    <%-- 
    <div id="latlngResult" style="display: none;"></div>
    --%>
 
    <div id="in-container">
        <div id="place" style="background-color:white; border: solid 0px red; margin: 3%;">
         <h2 style="font-weight: 300; text-align:center;">COMMUTER BUS<br><span style="font-size:8pt; text-align: center;">버스 번호를 누르시면 경로가 표시됩니다.</span></h2>
         
         <div id="bus_no" class="row">
            <input type="button" class="busStyle col-4" name="bus_no" value="101번">
            <input type="button" class="busStyle col-4" name="bus_no" value="102번">
            <input type="button" class="busStyle col-4" name="bus_no" value="103번">
         </div>

              <h3 style="font-weight: 300; text-align:center;">COMMUTER BUS ROUTE</h3>
              <div id="bus-route">
                 
                    
                 
              </div> 
       </div>
    </div>
</div>