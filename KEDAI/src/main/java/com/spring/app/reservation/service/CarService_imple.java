package com.spring.app.reservation.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.AES256;
import com.spring.app.domain.BoardVO;
import com.spring.app.domain.BusVO;
import com.spring.app.domain.CarVO;
import com.spring.app.domain.Car_shareVO;
import com.spring.app.domain.Day_shareVO;
import com.spring.app.reservation.model.CarDAO;

@Service
public class CarService_imple implements CarService {

	@Autowired			
	private CarDAO dao;			

    @Autowired
    private AES256 aES256;

	@Override
	public List<BusVO> getStationList(String bus_no) {
		List<BusVO> stationList = dao.getStationList(bus_no);
		return stationList;
	}

	@Override
	public List<BusVO> getStationTimeList(String pf_station_id, String bus_no) {
		List<BusVO> stationTimeList = dao.getStationTimeList(bus_no,pf_station_id);
		return stationTimeList;
	}

	@Override
	public List<Map<String, String>> myCar(String fk_empid) {
		List<Map<String, String>> myCar = dao.getmyCar(fk_empid);
		return myCar;
	}

	@Override
	public CarVO myCar2(String fk_empid) {
		CarVO myCar = dao.getmyCar2(fk_empid);
		return myCar;
	}

	// 파일첨부가 없는 차량등록
	@Override
	public int addMycar(CarVO cvo) {
		int n = dao.addMycar(cvo);
		return n;
	}

	@Override
	public int editMycar(Map<String, Object> paraMap) {
		int n = dao.editMycar(paraMap);
		return n;
	}

	@Override
	public int addcarRegister(Map<String, Object> paraMap) {
		int n = dao.addcarRegister(paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> carShareList() {
		List<Map<String, String>> carShareList = dao.getcarShareList();
		return carShareList;
	}

	@Override
	public Day_shareVO day_shareInfo(int res_num) {
		Day_shareVO day_shareInfo = dao.getday_shareInfo(res_num);
		return day_shareInfo;
	}

	@Override
	public int addcarApply_detail(Map<String, Object> paraMap) {
		int n = dao.addcarApply_detail(paraMap);
		return n;
	}

	// 총 게시물 건수(totalCount) 구하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}

	@Override
	public List<Map<String, String>> carShareListSearch_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> carShareList = dao.carShareListSearch_withPaging(paraMap);
		return carShareList;
	}

	@Override
	public List<String> searchShow(Map<String, String> paraMap) {
		List<String> wordList = dao.searchShow(paraMap);
		return wordList;
	}

	@Override
	public List<String> searchShow_owner(Map<String, String> paraMap) {
		List<String> wordList_owner = dao.searchShow_owner(paraMap);
		return wordList_owner;
	}
	
	@Override
	public List<Map<String, String>> owner_carShareList(String empid) {
		List<Map<String, String>> owner_carShareList = dao.getowner_carShareList(empid);
		return owner_carShareList;
	}

	@Override
	public List<Map<String, String>> owner_carShareListSearch_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> owner_carShareList = dao.owner_carShareListSearch_withPaging(paraMap);
		return owner_carShareList;
	}

	@Override
	public int owner_getTotalCount(Map<String, String> paraMap) {
		int owner_totalCount = dao.owner_getTotalCount(paraMap);
		return owner_totalCount;
	}

	// 선택한 날짜에 해당하는 카셰어링 정보를 가져오기
	@Override
	public List<Map<String, Object>> owner_dateInfo(String date) {
		List<Map<String, Object>> owner_dateInfo = dao.getowner_dateInfo(date);
		return owner_dateInfo;
	}

	@Override
	public int getTotalCount_owner_Status_detail(Map<String, Object> paraMap) {
		int totalCount_owner_Status_detail = dao.getTotalCount_owner_Status_detail(paraMap);
		return totalCount_owner_Status_detail;
	}

	@Override
	public List<Map<String, Object>> owner_Status_detail_withPaging(Map<String, Object> paraMap) {
		List<Map<String, Object>> owner_carShareList_detail = dao.owner_Status_detail_withPaging(paraMap);
		return owner_carShareList_detail;
	}

	@Override
	public int updateStatus(Map<String, Object> paraMap) {
		int n = dao.updateStatus(paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> owner_SettlementList(String empid) {
		List<Map<String, String>> owner_SettlementList = dao.getowner_SettlementList(empid);
		return owner_SettlementList;
	}

	@Override
	public int getTotalcount_owner_SettlementList(Map<String, String> paraMap) {
		int totalCount_owner_SettlementList = dao.getTotalcount_owner_SettlementList(paraMap);
		return totalCount_owner_SettlementList;
	}

	@Override
	public List<Map<String, String>> owner_SettlementList_withPaging(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_withPaging = dao.owner_SettlementList_withPaging(paraMap);
		return owner_SettlementList_withPaging;
	}

	@Override
	public List<Map<String, String>> owner_SettlementList_mobile(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_mobile = dao.getowner_SettlementList_mobile(paraMap);
		return owner_SettlementList_mobile;
	}

	@Override
	public int getTotalcount_owner_SettlementList_mobile(Map<String, String> paraMap) {
		int totalCount_owner_SettlementList_mobile = dao.getTotalcount_owner_SettlementList_mobile(paraMap);
		return totalCount_owner_SettlementList_mobile;
	}

	@Override
	public List<Map<String, String>> owner_SettlementList_withPaging_mobile(Map<String, String> paraMap) {
		List<Map<String, String>> owner_SettlementList_withPaging_mobile = dao.getowner_SettlementList_withPaging_mobile(paraMap);
		return owner_SettlementList_withPaging_mobile;
	}

	@Override
	public int update_drive_in_time(Map<String, String> paraMap) {
		int n = dao.update_drive_in_time(paraMap);
		return n;
	}

	@Override
	public int update_drive_out_time(Map<String, String> paraMap) {
		int n = dao.update_drive_out_time(paraMap);
		return n;
	}

	@Override
	public List<Map<String, String>> getcustomer_applyStatusList(String empid) {
		List<Map<String, String>> customer_applyStatusList = dao.getcustomer_applyStatusList(empid);
		return customer_applyStatusList;
	}

	@Override
	public List<Map<String, String>> getcustomer_SettlementList(String empid) {
		List<Map<String, String>> customer_SettlementList = dao.getcustomer_SettlementList(empid);
		return customer_SettlementList;
	}

	@Override
	public int pointMinus_applicant(Map<String, String> minusParaMap) {
		int n = dao.pointMinus_applicant(minusParaMap);
		return n;
	}

	@Override
	public void pointPlus_owner(Map<String, String> plusParaMap) {
		dao.pointPlus_owner(plusParaMap);
		
	}

	@Override
	public int payment_settled(Map<String, String> minusParaMap) {
		int n1 = dao.payment_settled(minusParaMap);
		return n1;
	}




}
