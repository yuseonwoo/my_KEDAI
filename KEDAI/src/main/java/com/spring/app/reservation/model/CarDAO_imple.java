package com.spring.app.reservation.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.BoardVO;
import com.spring.app.domain.BusVO;
import com.spring.app.domain.CarVO;
import com.spring.app.domain.Car_shareVO;
import com.spring.app.domain.Day_shareVO;

@Repository
public class CarDAO_imple implements CarDAO {

	@Autowired 				
	@Qualifier("sqlsession")		// auto일 경우에는 이와같이 qualifier를 해준다.
	private SqlSessionTemplate sqlsession;				// qualifier안해주면 오류

	@Override
	public List<BusVO> getStationList(String bus_no) {
		List<BusVO> stationList = sqlsession.selectList("reservation.getStationList", bus_no);
		return stationList;
	}

	@Override
	public List<BusVO> getStationTimeList(String pf_station_id, String bus_no) {
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("bus_no", bus_no);
		paraMap.put("pf_station_id", pf_station_id);
		
		List<BusVO> stationTimeList = sqlsession.selectList("reservation.getStationTimeList", paraMap);
		return stationTimeList;
	}

	@Override
	public List<Map<String, String>> getmyCar(String fk_empid) {

		List<Map<String, String>> myCar = sqlsession.selectList("reservation.getmyCar", fk_empid);
		return myCar;
	}
	
	@Override
	public CarVO getmyCar2(String fk_empid) {
		CarVO myCar2 = sqlsession.selectOne("reservation.getmyCar2", fk_empid);
		return myCar2;
	}
	// 내 차 정보 등록하기
	@Override
	public int addMycar(CarVO cvo) {
		int n = sqlsession.insert("reservation.addMyCar", cvo);
		return n;
	}

	@Override
	public int editMycar(Map<String, Object> paraMap) {
		int n = sqlsession.update("reservation.editMycar", paraMap);
		return n;
	}

	
	@Override
	public int addcarRegister(Map<String, Object> paraMap) {
		int n = sqlsession.insert("reservation.addcarRegister", paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> getcarShareList() {

		List<Map<String, String>> carShareList = sqlsession.selectList("reservation.getcarShareList");
		return carShareList;
	}

	@Override
	public Day_shareVO getday_shareInfo(int res_num) {
		Day_shareVO day_shareInfo = sqlsession.selectOne("reservation.getday_shareInfo", res_num);
		return day_shareInfo;
	}

	@Override
	public int addcarApply_detail(Map<String, Object> paraMap) {
		int n = sqlsession.insert("reservation.addcarApply_detail", paraMap);
		return n;
	}

	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = sqlsession.selectOne("reservation.getTotalCount", paraMap);
		return totalCount;
	}

	@Override
	public List<Map<String, String>> carShareListSearch_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> carShareList = sqlsession.selectList("reservation.carShareListSearch_withPaging", paraMap);
		return carShareList;
	}

	@Override
	public List<String> searchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("reservation.searchShow", paraMap);
		return wordList;
	}

	@Override
	public List<String> searchShow_owner(Map<String, String> paraMap) {
		List<String> wordList_owner = sqlsession.selectList("reservation.searchShow_owner", paraMap);
		return wordList_owner;
	}

	
	@Override
	public List<Map<String, String>> getowner_carShareList(String empid) {
		List<Map<String, String>> owner_carShareList = sqlsession.selectList("reservation.getowner_carShareList", empid);
		return owner_carShareList;
	}

	@Override
	public List<Map<String, String>> owner_carShareListSearch_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> owner_carShareList = sqlsession.selectList("reservation.owner_carShareListSearch_withPaging", paraMap);
		return owner_carShareList;
	}

	@Override
	public int owner_getTotalCount(Map<String, String> paraMap) {
		int owner_totalCount = sqlsession.selectOne("reservation.owner_getTotalCount", paraMap);
		return owner_totalCount;
	}

	@Override
	public List<Map<String, Object>> getowner_dateInfo(String date) {
		List<Map<String, Object>> owner_dateInfo = sqlsession.selectList("reservation.getowner_dateInfo", date);
		System.out.println("~~~~~~ 도현아~!! 울지마라 ㅎㅎㅎ  " + date);
		return owner_dateInfo;
	}

	@Override
	public int getTotalCount_owner_Status_detail(Map<String, Object> paraMap) {
		int totalCount_owner_Status_detail = sqlsession.selectOne("reservation.getTotalCount_owner_Status_detail", paraMap);
		return totalCount_owner_Status_detail;
	}

	@Override
	public List<Map<String, Object>> owner_Status_detail_withPaging(Map<String, Object> paraMap) {
		List<Map<String, Object>> owner_carShareList_detail = sqlsession.selectList("reservation.owner_Status_detail_withPaging", paraMap);
		return owner_carShareList_detail;
	}

	@Override
	public int updateStatus(Map<String, Object> paraMap) {
		int n = sqlsession.update("reservation.updateStatus", paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> getowner_SettlementList(String empid) {
		List<Map<String, String>> owner_SettlementList = sqlsession.selectList("reservation.getowner_SettlementList", empid);
		return owner_SettlementList;
	}

	@Override
	public int getTotalcount_owner_SettlementList(Map<String, String> paraMap) {
		int totalCount_owner_SettlementList = sqlsession.selectOne("reservation.getTotalcount_owner_SettlementList", paraMap);
		return totalCount_owner_SettlementList;
	}

	@Override
	public List<Map<String, String>> owner_SettlementList_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_withPaging = sqlsession.selectList("reservation.owner_SettlementList_withPaging", paraMap);
		return owner_SettlementList_withPaging;
	}

	@Override
	public List<Map<String, String>> getowner_SettlementList_mobile(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_mobile = sqlsession.selectList("reservation.getowner_SettlementList_mobile", paraMap);
		return owner_SettlementList_mobile;
	}

	@Override
	public int getTotalcount_owner_SettlementList_mobile(Map<String, String> paraMap) {
		int totalCount_owner_SettlementList_mobile = sqlsession.selectOne("reservation.getTotalcount_owner_SettlementList_mobile", paraMap);
		return totalCount_owner_SettlementList_mobile;
	}

	@Override
	public List<Map<String, String>> getowner_SettlementList_withPaging_mobile(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_withPaging_mobile = sqlsession.selectList("reservation.getowner_SettlementList_withPaging_mobile", paraMap);
		return owner_SettlementList_withPaging_mobile;
	}

	@Override
	public int update_drive_in_time(Map<String, String> paraMap) {
		int n = sqlsession.update("reservation.update_drive_in_time", paraMap);
		return n;
	}

	@Override
	public int update_drive_out_time(Map<String, String> paraMap) {
		int n = sqlsession.update("reservation.update_drive_out_time", paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> getcustomer_applyStatusList(String empid) {
		List<Map<String, String>> customer_applyStatusList = sqlsession.selectList("reservation.getcustomer_applyStatusList", empid);
		return customer_applyStatusList;
	}

	@Override
	public List<Map<String, String>> getcustomer_SettlementList(String empid) {
		List<Map<String, String>> customer_SettlementList = sqlsession.selectList("reservation.getcustomer_SettlementList", empid);
		return customer_SettlementList;
	}

	@Override
	public int pointMinus_applicant(Map<String, String> minusParaMap) {
		int n = sqlsession.update("reservation.pointMinus_applicant", minusParaMap);
		return n;
	}

	@Override
	public void pointPlus_owner(Map<String, String> plusParaMap) {
		sqlsession.update("reservation.pointPlus_owner", plusParaMap);
		
	}

	@Override
	public int payment_settled(Map<String, String> minusParaMap) {
		int n1 = sqlsession.update("reservation.payment_settled", minusParaMap);
		return n1;
	}












}
