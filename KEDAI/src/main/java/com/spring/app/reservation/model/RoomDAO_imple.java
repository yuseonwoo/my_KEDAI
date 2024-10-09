
package com.spring.app.reservation.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.BusVO;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.RoomMainVO;
import com.spring.app.domain.RoomSubVO;
import com.spring.app.domain.RoomVO;
import com.spring.app.domain.SalaryVO;

@Repository
public class RoomDAO_imple implements RoomDAO {

	@Autowired 				
	@Qualifier("sqlsession")		// auto일 경우에는 이와같이 qualifier를 해준다.
	private SqlSessionTemplate sqlsession;				// qualifier안해주면 오류

	@Override
	public List<RoomMainVO> roomMainView() {
		List<RoomMainVO> roomMainList = sqlsession.selectList("Room.roomMainView");
		return roomMainList;
		
	}


	@Override
	public List<RoomSubVO> getRoomMainBySeq(Integer roomMainSeq) {
		List<RoomSubVO> getRoomMainBySeq = sqlsession.selectList("Room.getRoomMainBySeq", roomMainSeq);
		return getRoomMainBySeq;
	}


	@Override
	public List<RoomSubVO> getRoomroomall() {
		List<RoomSubVO> getRoomroomall = sqlsession.selectList("Room.Roomroomall");
		return getRoomroomall;
	}

	@Override
	public int insertreserve(RoomVO roomVO) {
		int insertreserve = sqlsession.insert("Room.insertreserve", roomVO);
		return insertreserve;
	}


	@Override
	public List<RoomSubVO> getRoomData(String subroom) {
		List<RoomSubVO> getRoomData = sqlsession.selectList("Room.getRoomData", subroom);
		return getRoomData;
	}


	@Override
	public List<RoomVO> getAllReservations() {
		List<RoomVO> getAllReservations = sqlsession.selectList("Room.getAllReservations");
		return getAllReservations;
	}


	@Override
	public RoomVO getReservationById(int reservationId) {
		RoomVO reservation = sqlsession.selectOne("Room.getReservationById", reservationId);
	    return reservation;
	}


	

}
