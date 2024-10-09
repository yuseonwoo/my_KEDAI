package com.spring.app.admin.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.DeptVO;
import com.spring.app.domain.JobVO;
import com.spring.app.domain.MemberVO;

@Repository
public class AdminDAO_imple implements AdminDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	// 부서 목록 조회하기
	@Override
	public List<DeptVO> dept_select() {
		List<DeptVO> deptList = sqlsession.selectList("admin.dept_select");
		return deptList;
	}

	// 직급 목록 조회하기
	@Override
	public List<JobVO> job_select() {
		List<JobVO> jobList = sqlsession.selectList("admin.job_select");
		return jobList;
	}

	// 아이디중복확인
	@Override
	public String idDuplicateCheck(String empid) {
		String searchId = sqlsession.selectOne("admin.idDuplicateCheck", empid);
		return searchId;
	}

	// 이메일중복확인
	@Override
	public String emailDuplicateCheck(String email) {
		String searchEmail = sqlsession.selectOne("admin.emailDuplicateCheck", email);
		return searchEmail;
	}

	// 사원정보 등록하기
	@Override
	public int empRegister(MemberVO mvo) {
		int n = sqlsession.insert("admin.empRegister", mvo);	
		return n;
	}

	///////////////////////////////////////////////////////////////
	
	// 부서별 인원통계
	@Override
	public List<Map<String, String>> empCntByDeptname() {
		List<Map<String, String>> deptnamePercentageList = sqlsession.selectList("admin.empCntByDeptname");
		return deptnamePercentageList;
	}
	
	// 성별 인원통계
	@Override
	public List<Map<String, String>> empCntByGender() {
		List<Map<String, String>> genderPercentageList = sqlsession.selectList("admin.empCntByGender");
		return genderPercentageList;
	}
	
	// 부서별 성별 인원통계
	@Override
	public List<Map<String, String>> genderCntSpecialDeptname(String dept_name) {
		List<Map<String, String>> genderPercentageList = sqlsession.selectList("admin.genderCntSpecialDeptname", dept_name);
		return genderPercentageList;
	}
		
	// 입사년도별 성별 인원통계
	@Override
	public List<Map<String, String>> empCntByGenderHireYear() {
		List<Map<String, String>> genderHireYearList = sqlsession.selectList("admin.empCntByGenderHireYear");
		return genderHireYearList;
	}
		
	// 해당 페이지에 접속한 이후에, 페이지에 접속한 페이지URL, 사용자ID, 접속IP주소, 접속시간을 기록으로 DB에 tbl_empManager_accessTime 테이블에 insert 하기 
	@Override
	public void insert_accessTime(Map<String, String> paraMap) {
		sqlsession.insert("admin.insert_accessTime", paraMap);	
	}
	
	// 페이지별 사원 접속통계
	@Override
	public List<Map<String, String>> pageurlEmpname() {
		List<Map<String, String>> pageurlEmpnameList = sqlsession.selectList("admin.pageurlEmpname");
		return pageurlEmpnameList;
	}

}
