package com.spring.app.reservation.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.domain.RoomMainVO;
import com.spring.app.domain.RoomSubVO;
import com.spring.app.domain.RoomVO;
import com.spring.app.reservation.model.RoomDAO;

@Service
public class RoomService_imple implements RoomService {

	@Autowired			
	private RoomDAO dao;			
	
	@Override
	public List<RoomMainVO> roomMainListview() {
		List<RoomMainVO> roomMainList = dao.roomMainView();
		return roomMainList;
	}

	@Override
	public List<RoomSubVO> getRoomMainBySeq(Integer roomMainSeq) {
		List<RoomSubVO> getRoomMainBySeq = dao.getRoomMainBySeq(roomMainSeq);
		return getRoomMainBySeq;
	}

	@Override
	public List<RoomSubVO> getroomall() {
		List<RoomSubVO> roomall = dao.getRoomroomall();
		return roomall;
	}


	@Override
	public int insertreserve(RoomVO roomVO) {
		int n = dao.insertreserve(roomVO);
		System.out.println("n : "+ n);
		return n;
	}

	@Override
	public List<RoomSubVO> getRoomData(String subroom) {
		List<RoomSubVO> getRoomData = dao.getRoomData(subroom);
		return getRoomData;
	}

	@Override
	public List<RoomVO> getAllReservations() {
		List<RoomVO> getAllReservations = dao.getAllReservations();
		return getAllReservations;
	}

	@Override
	public RoomVO getReservationById(int reservationId) {
		RoomVO getReservationById = dao.getReservationById(reservationId);
		return getReservationById;
	}



}