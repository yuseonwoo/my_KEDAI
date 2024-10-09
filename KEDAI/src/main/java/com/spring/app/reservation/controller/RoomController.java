package com.spring.app.reservation.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.spring.app.domain.RoomMainVO;
import com.spring.app.domain.RoomSubVO;
import com.spring.app.domain.RoomVO;
import com.spring.app.reservation.service.RoomService;

@Controller
public class RoomController {

	@Autowired
	private RoomService service;
	
	 @GetMapping(value = "/roommain.kedai", produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public String roommain(@RequestParam(required = false) Integer roomMainSeq ) {
	        JSONArray jsonArr = new JSONArray();

	        if (roomMainSeq == null) {
	            // roomMainSeq가 없을 경우 모든 RoomMain 리스트를 반환
	            List<RoomMainVO> roomMainList = service.roomMainListview();

	            if (roomMainList != null) {
	                for (RoomMainVO vo : roomMainList) {
	                    JSONObject jsonObj = new JSONObject();

	                    jsonObj.put("roomMainSeq", vo.getRoomMainSeq());
	                    jsonObj.put("roomMainName", vo.getRoomMainName());
	                    jsonObj.put("roomMainDetail", vo.getRoomMainDetail());

	                    jsonArr.put(jsonObj);
	                }
	            }
	        } else {
	            // roomMainSeq가 있을 경우 해당하는 RoomSub 리스트를 반환
	            List<RoomSubVO> roomSubList = service.getRoomMainBySeq(roomMainSeq);

	            if (roomSubList != null) {
	                for (RoomSubVO vo : roomSubList) {
	                    JSONObject jsonObj = new JSONObject();
	                    jsonObj.put("roomSubSeq", vo.getRoomSubSeq());
	                    jsonObj.put("roomMainSeq", vo.getRoomMainSeq());
	                    jsonObj.put("roomSubName", vo.getRoomSubName());
	                    jsonObj.put("roomSub_detail", vo.getRoomSub_detail());
	                    jsonObj.put("room_status", vo.getRoom_status());
	                    jsonArr.put(jsonObj);
	                }
	            }
	        }

	        return jsonArr.toString();
	    }
	 
	 @GetMapping(value = "/roomall.kedai", produces = "application/json;charset=UTF-8")
	 @ResponseBody
	 public String roomall() {
		 List<RoomSubVO> roomSubList = service.getroomall();
		 JSONArray jsonArr = new JSONArray();
		 
         if (roomSubList != null) {
             for (RoomSubVO vo : roomSubList) {
                 JSONObject jsonObj = new JSONObject();
                 jsonObj.put("roomSubSeq", vo.getRoomSubSeq());
                 jsonObj.put("roomMainSeq", vo.getRoomMainSeq());
                 jsonObj.put("roomSubName", vo.getRoomSubName());
                 jsonObj.put("roomSub_detail", vo.getRoomSub_detail());
                 jsonObj.put("room_status", vo.getRoom_status());
                 jsonArr.put(jsonObj);
             }
         }
         return jsonArr.toString();
	 }
	 
	 @GetMapping(value = "/roomResercation.kedai")  // http://localhost:8090/board/pay_stub.action
	 public String empmanager_roomResercation(HttpServletRequest request) {
		
		 return "tiles1/reservation/roomReservation.tiles";
	 }
	 
	 @PostMapping("/reserve.kedai")
	    public ResponseEntity<Map<String, Object>> reserveRoom(@RequestBody Map<String, Object> reservationData) {
	        Map<String, Object> response = new HashMap<>();
	        try {
	            RoomVO roomVO = new RoomVO();
	            roomVO.setFk_empid((String) reservationData.get("reserver"));
	            roomVO.setFk_room_name((String) reservationData.get("roomname")); 
	            roomVO.setContent((String) reservationData.get("purpose"));

	            // 입력된 날짜와 시간의 형식
	            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.KOREAN);
	            SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

	            String startDateTime = (String) reservationData.get("startDateTime");
	            String endDateTime = (String) reservationData.get("endDateTime");

	            // 디버깅을 위한 출력
	            System.out.println("Received startDateTime: " + startDateTime);
	            System.out.println("Received endDateTime: " + endDateTime);

	            Date startDate = inputFormat.parse(startDateTime);
	            Date endDate = inputFormat.parse(endDateTime);

	            // 디버깅을 위한 출력
	            System.out.println("Parsed startDate: " + startDate);
	            System.out.println("Parsed endDate: " + endDate);

	            // TO_DATE 형식과 일치하도록 문자열로 포맷
	            String formattedStartTime = dbDateFormat.format(startDate);
	            String formattedEndTime = dbDateFormat.format(endDate);

	         
	            roomVO.setStart_time(formattedStartTime);
	            roomVO.setEnd_time(formattedEndTime);

	            String formattedRegisterDay = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	            roomVO.setRegisterday(formattedRegisterDay);
	            roomVO.setReservation_status(1);

	            // 서비스 호출
	            service.insertreserve(roomVO);

	            response.put("success", true);
	        } catch (ParseException e) {
	            response.put("success", false);
	            response.put("message", "날짜 형식이 잘못되었습니다: " + e.getMessage());
	        } catch (Exception e) {
	            response.put("success", false);
	            response.put("message", e.getMessage());
	        }
	        return ResponseEntity.ok(response);
	    }

	
	 @GetMapping("/getRoomData.kedai")
	 public ResponseEntity<?> getRoomData(@RequestParam(defaultValue = "default_value") String subroom) {
	     try {
	         List<RoomSubVO> roomData = service.getRoomData(subroom);
	         return ResponseEntity.ok(roomData);
	     } catch (Exception e) {
	         return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error fetching room data");
	     }
	 }

	  
	  @GetMapping(value = "/getReservations.kedai", produces = "application/json;charset=UTF-8")
	    @ResponseBody
	    public ResponseEntity<String> getReservations() {
	        if (service == null) {
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Service is not available");
	        }

	        List<RoomVO> reservations = service.getAllReservations();
	        
	        JSONArray jsonArr = new JSONArray();

	        for (RoomVO reservation : reservations) {
	            JSONObject jsonObj = new JSONObject();
	            jsonObj.put("roomName", reservation.getFk_room_name());
	            jsonObj.put("reserver", reservation.getFk_empid());
	            jsonObj.put("startTime", reservation.getStart_time());
	            jsonObj.put("endTime", reservation.getEnd_time());
	            jsonObj.put("purpose", reservation.getContent());
	            jsonObj.put("status", reservation.getReservation_status());
	            jsonArr.put(jsonObj);
	        }

	        return ResponseEntity.ok(jsonArr.toString());
	    }
	  
	  @PostMapping(value = "/reservation_detail.kedai", produces = "application/json;charset=UTF-8")
	    public ResponseEntity<String> getReservationDetail(@RequestParam int reservationId) {
	        RoomVO reservation = service.getReservationById(reservationId);

	        if (reservation != null) {
	            JSONObject jsonObj = new JSONObject();
	            jsonObj.put("roomName", reservation.getFk_room_name());
	            jsonObj.put("reserver", reservation.getFk_empid());
	            jsonObj.put("startTime", reservation.getStart_time());
	            jsonObj.put("endTime", reservation.getEnd_time());
	            jsonObj.put("purpose", reservation.getContent());
	            jsonObj.put("status", reservation.getReservation_status());

	            return ResponseEntity.ok(jsonObj.toString());
	        } else {
	            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Reservation not found");
	        }
	    }
}