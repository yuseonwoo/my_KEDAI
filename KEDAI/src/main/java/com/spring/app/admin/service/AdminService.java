package com.spring.app.admin.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.DeptVO;
import com.spring.app.domain.JobVO;
import com.spring.app.domain.MemberVO;

public interface AdminService {

	// 부서 목록 조회하기
	List<DeptVO> dept_select();

	// 직급 목록 조회하기
	List<JobVO> job_select();

	// 아이디중복확인
	String idDuplicateCheck(String empid);

	// 이메일중복확인
	String emailDuplicateCheck(String email);
	
	// 사원정보 등록하기
	int empRegister(MemberVO mvo);
	
	///////////////////////////////////////////////////////////////
	
	// 부서별 인원통계
	List<Map<String, String>> empCntByDeptname();
	
	// 성별 인원통계
	List<Map<String, String>> empCntByGender();
	
	// 부서별 성별 인원통계
	String genderCntSpecialDeptname(String dept_name);
	
	// 입사년도별 성별 인원통계
	String empCntByGenderHireYear();
		
	// 해당 페이지에 접속한 이후에, 페이지에 접속한 페이지URL, 사용자ID, 접속IP주소, 접속시간을 기록으로 DB에 tbl_empManager_accessTime 테이블에 insert 하기  
	void insert_accessTime(Map<String, String> paraMap);
		
	// 페이지별 사원 접속통계
	String pageurlEmpname();

}
