package com.spring.app.reservation.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.MemberVO;
import com.spring.app.domain.RoomMainVO;
import com.spring.app.domain.RoomSubVO;
import com.spring.app.domain.RoomVO;
import com.spring.app.domain.SalaryVO;

public interface RoomService {

	List<RoomMainVO> roomMainListview();

	List<RoomSubVO> getRoomMainBySeq(Integer roomMainSeq);

	List<RoomSubVO> getroomall();

	int insertreserve(RoomVO roomVO);

	List<RoomSubVO> getRoomData(String subroom);

	List<RoomVO> getAllReservations();

	RoomVO getReservationById(int reservationId);

	

}