package com.spring.app.employee.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

public interface EmployeeDAO {
	
	// 직원 정보 가져오기
	List<MemberVO> employee_list();
	
	
	// 직원 정보 가져오기
	/* List<Map<String, String>> employeeList(Map<String, String> paraMap); */

	/* Long employeeListTotal(Map<String, String> paraMap); */
	
	// 직원정보 상세보기 팝업 어떤것 클릭했는지 알아오기(직원 아이디로 가져오기
	List<Map<String, String>> empDetailList(Map<String, String> paraMap);

	// 검색어 입력 시 자동글 완성하기 
	List<String> wordSearchShowJSON(Map<String, String> paraMap);
	
	// 총 게시물 건수 구하기  
	int getTotalCount(Map<String, String> paraMap);
	
	// 직원목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	List<MemberVO> employeeListSearch_withPaging(Map<String, String> paraMap);

	

	
	

	

}
