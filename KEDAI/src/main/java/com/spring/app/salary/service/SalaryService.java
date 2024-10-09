package com.spring.app.salary.service;

import java.util.List;

import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;
import com.spring.app.domain.SalaryVO;

public interface SalaryService {

	//	급여명세서 직원목록 불러오기
	List<MemberVO> memberListView();

	//	급여명세서 계산
	int salaryCal(SalaryVO salaryvo);

	MemberVO getEmployeeById(String employeeId);

	List<SalaryVO> getSalaryDetailsById(String yearMonth);



	List<SalaryVO> getAllSalaryData();

	


}