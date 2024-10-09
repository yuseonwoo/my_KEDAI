
package com.spring.app.reservation.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.RoomMainVO;
import com.spring.app.domain.RoomSubVO;
import com.spring.app.domain.RoomVO;

public interface RoomDAO {

	List<RoomMainVO> roomMainView();

	List<RoomSubVO> getRoomMainBySeq(Integer roomMainSeq);

	List<RoomSubVO> getRoomroomall();

	//	예약 건 DB에 입력
	int insertreserve(RoomVO roomVO);

	List<RoomSubVO> getRoomData(String subroom);

	List<RoomVO> getAllReservations();

	RoomVO getReservationById(int reservationId);


}