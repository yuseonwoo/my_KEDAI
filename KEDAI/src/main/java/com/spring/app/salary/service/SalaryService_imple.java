package com.spring.app.salary.service;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;


import com.spring.app.domain.MemberVO;
import com.spring.app.domain.SalaryVO;

import com.spring.app.salary.model.SalaryDAO;
@Service
public class SalaryService_imple implements SalaryService{
	
	@Autowired			
	private SalaryDAO dao;	


//	급여명세서 직원목록 불러오기
	@Override
	public List<MemberVO> memberListView() {
		List<MemberVO> membervoList = dao.memberListView();
		return membervoList;
	}

	//	급여 전체 계산
	@Override
	public int salaryCal(SalaryVO salaryvo) {
		int n = dao.salaryCal(salaryvo);
		return n;
	}

	@Override
	public MemberVO getEmployeeById(String employeeId) {
		MemberVO getEmployeeById = dao.getEmployeeById(employeeId);
		return getEmployeeById;
	}


	@Override
	public List<SalaryVO> getSalaryDetailsById(String yearMonth) {
		List<SalaryVO> getSalaryDetailsById = dao.getSalaryDetailsById(yearMonth);
		return getSalaryDetailsById;
	}

	@Override
	public List<SalaryVO> getAllSalaryData() {
		List<SalaryVO> getAllSalaryData = dao.getAllSalaryData();
		return getAllSalaryData;
	}



	
	
	
}	
	