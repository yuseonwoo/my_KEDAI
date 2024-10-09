package com.spring.app.salary.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import com.spring.app.company.service.CompanyService;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;
import com.spring.app.domain.SalaryVO;

@Repository
public class SalaryDAO_imple implements SalaryDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
//	급여명세서 직원목록 불러오기
	@Override
	public List<MemberVO> memberListView() {
		List<MemberVO> membervoList = sqlsession.selectList("salary.memberListView");
		return membervoList;
	}

    
	//	급여 전체 계산
	@Override
	public int salaryCal(SalaryVO salaryvo) {
		int n = sqlsession.insert("salary.salaryCal", salaryvo);
		return n;
	}


	@Override
	public MemberVO getEmployeeById(String employeeId) {
		MemberVO getEmployeeById = sqlsession.selectOne("salary.getEmployeeById", employeeId);
		return getEmployeeById;
	}


	@Override
	public List<SalaryVO> getSalaryDetailsById(String yearMonth) {
	  Map<String, Object> params = new HashMap<>();
	    params.put("yearMonth", yearMonth);
	    
		return sqlsession.selectList("salary.getSalaryDetailsById", params);
	}


	@Override
	public List<SalaryVO> getAllSalaryData() {
		List<SalaryVO> getAllSalaryData = sqlsession.selectList("salary.getAllSalaryData");
		return getAllSalaryData;
	}

	
	
	
	
	
	
	
}