package com.spring.app.admin.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.app.admin.service.AdminService;
import com.spring.app.common.AES256;
import com.spring.app.common.FileManager;
import com.spring.app.common.Sha256;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.JobVO;
import com.spring.app.domain.MemberVO;

@Controller 
@RequestMapping(value = "/admin/*")
public class AdminController {

	@Autowired
	private AdminService service;
	
	@Autowired
	private AES256 aES256;
	
	@Autowired
	private FileManager fileManager;

	// 부서&직급 목록 조회하기
	@RequestMapping("register.kedai")
	public ModelAndView dept_job_select(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		if(loginuser != null && "Admin".equals(loginuser.getNickname())) {
			List<DeptVO> deptList = service.dept_select();
			List<JobVO> jobList = service.job_select();
			
			mav.addObject("deptList", deptList); 
			mav.addObject("jobList", jobList); 
		
			mav.setViewName("tiles1/admin/register.tiles");
		}
		
		return mav;
	}
	
	// 아이디중복확인
	@ResponseBody
	@PostMapping(value="idDuplicateCheck.kedai", produces="text/plain;charset=UTF-8")
	public String idDuplicateCheck(HttpServletRequest request) {
		
		String empid = request.getParameter("empid");
		
		String searchId = service.idDuplicateCheck(empid);
		
		boolean isExists = false;
		
		if(searchId != null) {
			isExists = true;
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExists", isExists);
		
		return jsonObj.toString();
	}
	
	// 이메일중복확인
	@ResponseBody
	@PostMapping(value="emailDuplicateCheck.kedai", produces="text/plain;charset=UTF-8")
	public String emailDuplicateCheck(HttpServletRequest request) {
		
		String email = request.getParameter("email");
		
		try {
			email = aES256.encrypt(email);
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		String searchEmail = service.emailDuplicateCheck(email);
		
		boolean isExists = false;
		
		if(searchEmail != null) {
			isExists = true;
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExists", isExists);
		
		return jsonObj.toString();
	}
	
	// 사원정보 등록하기
	@PostMapping("empRegister.kedai")
	public ModelAndView empRegister(ModelAndView mav, MemberVO mvo, MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = mvo.getAttach();
		
		if(attach != null) { // 첨부파일이 있는 경우
			
			// WAS 의 webapp 의 절대경로 알아오기
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/"); 
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\
			
			String path = root+"resources"+File.separator+"files"+File.separator+"employees";
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files\employees
			
			// 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
			String newFileName = ""; // WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null;     // 첨부파일의 내용물을 담는 것
			
			try {
				bytes = attach.getBytes(); 
				
				String originalFilename = attach.getOriginalFilename(); // 첨부파일명의 파일명
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path); // 첨부되어진 파일을 업로드
				
				mvo.setImgfilename(newFileName);
				mvo.setOrgimgfilename(originalFilename);
				
			} catch (Exception e) {
				e.printStackTrace(); 
			}
			
		} // end of if(attach != null) ----------
		
		String jubun1 = mrequest.getParameter("jubun1");
		String jubun2 = mrequest.getParameter("jubun2");
		String jubun = jubun1 + jubun2;
		
		String hp1 = mrequest.getParameter("hp1");
		String hp2 = mrequest.getParameter("hp2");
		String hp3 = mrequest.getParameter("hp3");
		String mobile = hp1 + hp2 + hp3;
		
		String dept_name = mrequest.getParameter("dept_name");	
		String dept_tel = "";
		String fk_dept_code = "";

		if(dept_name.equals("인사부")) {
			fk_dept_code = "100";
			dept_tel = "070-1234-100";
		}
		else if(dept_name.equals("영업지원부")) {
			fk_dept_code = "200";
			dept_tel = "070-1234-200";
		}
		else if(dept_name.equals("회계부")) {
			fk_dept_code = "300";
			dept_tel = "070-1234-300";
		}
		else if(dept_name.equals("상품개발부")) {
			fk_dept_code = "400";
			dept_tel = "070-1234-400";
		}
		else if(dept_name.equals("마케팅부")) {
			fk_dept_code = "500";
			dept_tel = "070-1234-500";
		}
		else if(dept_name.equals("해외사업부")) {
			fk_dept_code = "600";
			dept_tel = "070-1234-600";
		}
		else if(dept_name.equals("해외사업부")) {
			fk_dept_code = "700";
			dept_tel = "070-1234-700";
		} 
		else  {
			fk_dept_code = "";
			dept_tel = "";
		}
	
		String job_name = mrequest.getParameter("job_name");
		String fk_job_code = "";
		
		if(job_name.equals("대표이사")) {
			fk_job_code = "1";
		}
		else if(job_name.equals("전무")) {
			fk_job_code = "2";
		}
		else if(job_name.equals("상무")) {
			fk_job_code = "3";
		}
		else if(job_name.equals("부장")) {
			fk_job_code = "4";
		}
		else if(job_name.equals("과장")) {
			fk_job_code = "5";
		}
		else if(job_name.equals("차장")) {
			fk_job_code = "6";
		}
		else if(job_name.equals("대리")) {
			fk_job_code = "7";
		}
		else if(job_name.equals("사원")) {
			fk_job_code = "8";
		}
		else {
			fk_job_code = "";
		}
		
		mvo.setEmpid(mrequest.getParameter("empid"));
		mvo.setPwd(Sha256.encrypt(mrequest.getParameter("pwd")));
		mvo.setName(mrequest.getParameter("name"));
		mvo.setNickname(mrequest.getParameter("nickname"));
		mvo.setJubun(jubun);
		try {
			mvo.setEmail(aES256.encrypt(mrequest.getParameter("email")));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		try {
			mvo.setMobile(aES256.encrypt(mobile));
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		mvo.setPostcode(mrequest.getParameter("postcode"));
		mvo.setAddress(mrequest.getParameter("address"));
		mvo.setDetailaddress(mrequest.getParameter("detailaddress"));
		mvo.setExtraaddress(mrequest.getParameter("extraaddress"));
		mvo.setHire_date(mrequest.getParameter("hire_date"));
		mvo.setSalary(mrequest.getParameter("salary"));
		mvo.setFk_dept_code(fk_dept_code);
		mvo.setFk_job_code(fk_job_code);
		mvo.setDept_tel(dept_tel);
		
		try {
			int n = service.empRegister(mvo);
			
			if(n == 1) {
				String message = "사원정보가 정상적으로 등록되었습니다.";
				String loc = mrequest.getContextPath()+"/index.kedai";
	           
				mav.addObject("message", message);
				mav.addObject("loc", loc);
	           
				mav.setViewName("msg"); 
			}
			
		} catch (Exception e) {
			String message = "사원정보 등록이 실패하였습니다.\\n다시 시도해주세요.";
			String loc = "javascript:history.back()";
           
			mav.addObject("message", message);
			mav.addObject("loc", loc);
           
			mav.setViewName("msg"); 
		}

		return mav;
	}
	
	///////////////////////////////////////////////////////////////
	
	// 통계정보(Chart) 조회하는 페이지 이동
	@GetMapping("chart.kedai")
	public ModelAndView chart(ModelAndView mav) {
		
		mav.setViewName("tiles1/admin/chart.tiles");
		
		return mav;
	}
	
	// 부서별 인원통계
	@ResponseBody
	@GetMapping(value="chart/empCntByDeptname.kedai", produces="text/plain;charset=UTF-8")
	public String empCntByDeptname() {
		
		List<Map<String, String>> deptnamePercentageList = service.empCntByDeptname();
		
		JsonArray jsonArr = new JsonArray(); // [] 
		// JsonArray(소문자) 은 google 에서 제공하고 있는 gjson 이다.
		
		for(Map<String, String> map : deptnamePercentageList) {
			JsonObject jsonObj = new JsonObject(); // {} 
			jsonObj.addProperty("dept_name", map.get("dept_name"));
			jsonObj.addProperty("cnt", map.get("cnt"));
			jsonObj.addProperty("percentage", map.get("percentage"));
			
			jsonArr.add(jsonObj);
		} // end of for ----------
		
		Gson gson = new Gson();
		return gson.toJson(jsonArr);
	}
	
	// 성별 인원통계
	@ResponseBody
	@GetMapping(value="chart/empCntByGender.kedai", produces="text/plain;charset=UTF-8")
	public String empCntByGender() {
		
		List<Map<String, String>> genderPercentageList = service.empCntByGender();
		
		JsonArray jsonArr = new JsonArray(); // [] 
		// JsonArray(소문자) 은 google 에서 제공하고 있는 gjson 이다.
		
		for(Map<String, String> map : genderPercentageList) {
			JsonObject jsonObj = new JsonObject(); // {} 
			jsonObj.addProperty("gender", map.get("gender"));
			jsonObj.addProperty("cnt", map.get("cnt"));
			jsonObj.addProperty("percentage", map.get("percentage"));
			
			jsonArr.add(jsonObj);
		} // end of for ----------
		
		Gson gson = new Gson();
		return gson.toJson(jsonArr);
	}
	
	// 부서별 성별 인원통계
	@ResponseBody
	@GetMapping(value="chart/genderCntSpecialDeptname.kedai", produces="text/plain;charset=UTF-8")
	public String genderCntSpecialDeptname(@RequestParam(defaultValue = "") String dept_name) {
		
		return service.genderCntSpecialDeptname(dept_name);
	}
	
	// 입사년도별 성별 인원통계
	@ResponseBody
	@GetMapping(value="chart/empCntByGenderHireYear.kedai", produces="text/plain;charset=UTF-8")
	public String empCntByGenderHireYear() {
		
		return service.empCntByGenderHireYear();
	}
	
	// 페이지별 사원 접속통계
	@ResponseBody
	@GetMapping(value="chart/pageurlEmpname.kedai", produces="text/plain;charset=UTF-8")
	public String pageurlEmpname() {
		
		return service.pageurlEmpname();
	}
	
}
