package com.spring.app.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.admin.model.AdminDAO;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.JobVO;
import com.spring.app.domain.MemberVO;

@Service
public class AdminService_imple implements AdminService {

	@Autowired
	private AdminDAO dao;

	// 부서 목록 조회하기
	@Override
	public List<DeptVO> dept_select() {
		List<DeptVO> deptList = dao.dept_select();
		return deptList;
	}

	// 직급 목록 조회하기
	@Override
	public List<JobVO> job_select() {
		List<JobVO> jobList = dao.job_select();
		return jobList;
	}

	// 아이디중복확인
	@Override
	public String idDuplicateCheck(String empid) {
		String searchId = dao.idDuplicateCheck(empid);
		return searchId;
	}

	// 이메일중복확인
	@Override
	public String emailDuplicateCheck(String email) {
		String searchEmail = dao.emailDuplicateCheck(email);
		return searchEmail;
	}

	// 사원정보 등록하기
	@Override
	public int empRegister(MemberVO mvo) {		
		int n = dao.empRegister(mvo);
		return n;
	}

	///////////////////////////////////////////////////////////////
	
	// 부서별 인원통계
	@Override
	public List<Map<String, String>> empCntByDeptname() {
		List<Map<String, String>> deptnamePercentageList = dao.empCntByDeptname();
		return deptnamePercentageList;
	}
	
	// 성별 인원통계
	@Override
	public List<Map<String, String>> empCntByGender() {
		List<Map<String, String>> genderPercentageList = dao.empCntByGender();
		return genderPercentageList;
	}
	
	// 부서별 성별 인원통계
	@Override
	public String genderCntSpecialDeptname(String dept_name) {
		List<Map<String, String>> genderPercentageList = dao.genderCntSpecialDeptname(dept_name);
		
		JsonArray jsonArr = new JsonArray(); // []
		
		if(genderPercentageList != null && genderPercentageList.size() > 0) {
			for(Map<String, String> map : genderPercentageList) {
				JsonObject jsonObj = new JsonObject(); // {}
				jsonObj.addProperty("gender", map.get("gender"));
				jsonObj.addProperty("cnt", map.get("cnt"));
				jsonObj.addProperty("percentage", map.get("percentage"));
			
				jsonArr.add(jsonObj); 
			}  // end of for ----------
		}
		
		Gson gson = new Gson();
		return gson.toJson(jsonArr);
	}
	
	// 입사년도별 성별 인원통계
	@Override
	public String empCntByGenderHireYear() {
		List<Map<String, String>> genderHireYearList = dao.empCntByGenderHireYear();
		
		JsonArray jsonArr = new JsonArray(); // []
		
		for(Map<String, String> map : genderHireYearList) {
			JsonObject jsonObj = new JsonObject(); // {}
			
			jsonObj.addProperty("gender", map.get("gender"));
			jsonObj.addProperty("Y2010", map.get("Y2010"));
			jsonObj.addProperty("Y2011", map.get("Y2011"));
			jsonObj.addProperty("Y2012", map.get("Y2012"));
			jsonObj.addProperty("Y2013", map.get("Y2013"));
			jsonObj.addProperty("Y2014", map.get("Y2014"));
			jsonObj.addProperty("Y2015", map.get("Y2015"));
			jsonObj.addProperty("Y2016", map.get("Y2016"));
			jsonObj.addProperty("Y2017", map.get("Y2017"));
			jsonObj.addProperty("Y2018", map.get("Y2018"));
			jsonObj.addProperty("Y2019", map.get("Y2019"));
			jsonObj.addProperty("Y2020", map.get("Y2020"));
			jsonObj.addProperty("Y2021", map.get("Y2021"));
			jsonObj.addProperty("Y2022", map.get("Y2022"));
			jsonObj.addProperty("Y2023", map.get("Y2023"));
			jsonObj.addProperty("Y2024", map.get("Y2024"));
			jsonObj.addProperty("totalCount", map.get("totalCount"));
			
			jsonArr.add(jsonObj); 
		} // end of for ----------
		
		Gson gson = new Gson();
		return gson.toJson(jsonArr);
	}
		
	// 해당 페이지에 접속한 이후에, 페이지에 접속한 페이지URL, 사용자ID, 접속IP주소, 접속시간을 기록으로 DB에 tbl_empManager_accessTime 테이블에 insert 하기  
	@Override
	public void insert_accessTime(Map<String, String> paraMap) {
		dao.insert_accessTime(paraMap);
	}
	
	// 페이지별 사원 접속통계
	@Override
	public String pageurlEmpname() {
		List<Map<String, String>> pageurlEmpnameList = dao.pageurlEmpname();
		
		JsonObject jsonObj = new JsonObject(); // {}
		
		JsonArray categories = new JsonArray(); // [] 
		JsonArray series     = new JsonArray(); // []
		
		Gson gson = new Gson();
		
		for(int i=0; i<pageurlEmpnameList.size(); i++) {
			if(i == 0) {
				categories.add(pageurlEmpnameList.get(i).get("pagename"));
			}
			
			if(i > 0 && !pageurlEmpnameList.get(i-1).get("pagename").equals(pageurlEmpnameList.get(i).get("pagename"))) {
				categories.add(pageurlEmpnameList.get(i).get("pagename"));
			}
			
			JsonObject sub_jsonObj = new JsonObject(); // {}
			sub_jsonObj.addProperty("name", pageurlEmpnameList.get(i).get("name"));
	         
			JsonArray data_jsonArr = new JsonArray(); // []
			data_jsonArr.add(pageurlEmpnameList.get(i).get("cnt"));
			sub_jsonObj.addProperty("data", gson.toJson(data_jsonArr));
	         
			series.add(sub_jsonObj);  
			
		} // end of for ----------
		
		jsonObj.addProperty("categories", gson.toJson(categories));
		jsonObj.addProperty("series", gson.toJson(series));
		
		return gson.toJson(jsonObj);
	}
	
}
