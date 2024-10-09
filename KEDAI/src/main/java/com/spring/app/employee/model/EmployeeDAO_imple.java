package com.spring.app.employee.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.spring.app.company.service.CompanyService;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

@Repository
public class EmployeeDAO_imple implements EmployeeDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	// 직원정보 가져오기
	@Override
	public List<MemberVO> employee_list() {
		List<MemberVO> employeeList = sqlsession.selectList("employee.employee_list");
		return employeeList;
	}	

	
	
	
	
	// 직원정보 가져오기
	//@Override
	/*
	 public List<Map<String, String>> employeeList(Map<String, String> paraMap) {
	 
		
		List<Map<String, String>> employeeList = sqlsession.selectList("employee.employeeList", paraMap);
		// System.out.println("111employeeList : " + employeeList);
		return employeeList;
	}
	*/
	
	/*
	@Override 
	public Long employeeListTotal(Map<String, String> paraMap) { 
		Long employeeListTotal = sqlsession.selectOne("employee.employeeListTotal" , paraMap); 
		// System.out.println("111employeeList : " + employeeList); 
		
		return employeeListTotal;
	 
	}
	*/
	
	// 직원정보 상세보기 팝업 어떤것 클릭했는지 알아오기(직원 아이디로 가져오기)
	@Override
	public List<Map<String, String>> empDetailList (Map<String, String> paraMap) {
		List<Map<String, String>> empDetailList = sqlsession.selectList("employee.empDetailList", paraMap);
		
		return empDetailList;
	}

	// 검색어 입력 시 자동글 완성하기 
	@Override
	public List<String> wordSearchShowJSON(Map<String, String> paraMap) {
		
		List<String> wordList = sqlsession.selectList("employee.wordSearchShowJSON", paraMap);
		
		return wordList;
	}

	// 총 직원명수  구하기 
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int totalCount = sqlsession.selectOne("employee.getTotalCount", paraMap);
		return totalCount;
	}
	
	
	
	// 직원목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	@Override
	public List<MemberVO> employeeListSearch_withPaging(Map<String, String> paraMap) {
		List<MemberVO> employeeList = sqlsession.selectList("employee.employeeListSearch_withPaging", paraMap);
		return employeeList;
	
	}

	

	
	
	
}
