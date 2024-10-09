package com.spring.app.employee.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.WebSocketSession;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.MemberVO;
import com.spring.app.employee.service.EmployeeService;



@Controller
public class EmployeeController {
	
	@Autowired
	private EmployeeService service;
	
	@Autowired
	private ObjectMapper objectMapper;
	

	//////////////////////////////////////////////////////////////////////////
	// 전체 사원들 정보 조회하기
	@RequestMapping(value="/employee.kedai") 

	public ModelAndView employee_list(ModelAndView mav) {
		
		List<MemberVO> employeeList = service.employee_list();
		
		
		mav.addObject("employeeList", employeeList);
		// System.out.println("employeeList : " + employeeList);
		mav.setViewName("tiles1/employee/employee.tiles");
		
		return mav;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////
	
	// 사원리스트  보여주기 ( 여기서 페이징 처리 && 검색 만들기)
	@GetMapping(value="/employee.kedai") 
	public ModelAndView employeelist_select(ModelAndView mav, HttpServletRequest request) {
		
		List<MemberVO> employeeList = null;
		
		// System.out.println("employeeList : " + employeeList);
		// 글조회수(readCount)증가 => 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다. => session 을 사용하여 처리하기
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		// 페이징 처리를 한 검색어가 있는 전체 글목록 보여주기
		String searchType = request.getParameter("searchType");
		// System.out.println(searchType);
		String searchWord = request.getParameter("searchWord");
		// System.out.println(searchWord);
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(searchType == null) {
			searchType = "";
		}
		
		if(searchWord == null) {
			searchWord = "";
		}
		
		if(searchWord != null) {
			searchWord = searchWord.trim();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10; 	   // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정 
		int totalPage = 0; 		   // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		
		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalCount(paraMap);
		// System.out.println("totalCount : " + totalCount);		
		
		totalPage = (int)Math.ceil((double)totalCount/sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13
		
		if(str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (NumberFormatException e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}
		
		
		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
        
        employeeList = service.employeeListSearch_withPaging(paraMap);

        mav.addObject("employeeList", employeeList);
		// System.out.println("");
        // 검색 시 검색조건 및 검색어 값 유지시키기	
		if("dept_name".equals(searchType) ||
		   "job_name".equals(searchType)  ||
		   "name".equals(searchType)	  ||
		   "nickname".equals(searchType)	  ||
		   "mobile".equals(searchType)) {
			mav.addObject("paraMap" , paraMap);
		}
		// System.out.println(" paraMap : " + paraMap);
		
		// 페이지바 만들기
        int blockSize = 3; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
        int loop = 1;      // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
        int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1; 
        // 공식 
        // 첫번째 블럭의 페이지번호 시작값(pageNo)은    1 => ((1-1)/5)*5+1  => 1
        // 두번째 블럭의 페이지번호 시작값(pageNo)은    6 => ((6-1)/5)*5+1  => 6
        // 세번째 블럭의 페이지번호 시작값(pageNo)은  11 => ((11-1)/5)*5+1 => 11
        
        String pageBar = "<ul style='list-style: none;'>";
        String url = "employee.kedai";
		
        // [맨처음][이전] 만들기 
        if(pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
        	pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1' style='color: #2c4459;'>[처음]</a></li>";
        	pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+(pageNo-1)+"' style='color: #2c4459;'>[이전]</a></li>";
        }
        
        while(!(loop > blockSize || pageNo > totalPage)) {
        	
        	if(pageNo == currentShowPageNo) {
        		pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"+pageNo+"</li>";
        	}
        	else {
        		pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>"+pageNo+"</a></li>";
        	}
        	
        	loop++;
        	pageNo++;
        } // end of while() ----------
		
        
        // [다음][마지막] 만들기
        if(pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
        	pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>[다음]</a></li>";
        	pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color: #2c4459;'>[마지막]</a></li>";
        }
        
        pageBar += "</ul>";
        // System.out.println(pageBar);
        mav.addObject("pageBar", pageBar);
        // System.out.println("pageBar : " + pageBar);
        // 특정 글제목을 클릭하여 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 알려주기 위해 현재 페이지 주소를 뷰단으로 넘겨준다.
        String goBackURL = MyUtil.getCurrentURL(request);
        mav.addObject("goBackURL", goBackURL);
        
        // 페이징처리 시 순번을 나타내기 위한 것
        mav.addObject("totalCount", totalCount);
        // System.out.println("1111totalCount : " + totalCount);
        mav.addObject("currentShowPageNo", currentShowPageNo);
        mav.addObject("sizePerPage", sizePerPage);
        
        mav.setViewName("tiles1/employee/employee.tiles");
        
		return mav;
		
	}
        
    /*    
		
		/////////////////////////////////////// 여기는 페이져블 
		// Pageable pageable = PageRequest.of(pageNumber, pageSize); 

		
		// System.out.println("searchType:" + searchType + ", searchWord: " + searchWord +
		//", pageNumber: " + pageNumber + ", pageSize:" + pageSize);
		
		Page<Map<String,String>> pagedResult = service.employeeList(searchType, searchWord, pageable);
		// System.out.println("page : " + page);
		
		//		pagedResult.getTotalPages()
		mav.addObject("pagedResult", pagedResult);
		mav.addObject("employeeList", pagedResult.getContent());
		// mav.addObject("employeeList",employeeList);
		mav.addObject("searchType", searchType);
		mav.addObject("searchWord", searchWord);
		mav.setViewName("tiles1/employee/employee.tiles");
		
		return mav;
	}
	
	*/
	
	
	
	
	
	
	
	@ResponseBody
	@GetMapping(value="/employeeDetail.kedai",produces = "text/plain;charset=UTF-8")
	public String employeeDetailJSON(HttpServletRequest request) {
		
		String empid = request.getParameter("empid");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("empid", empid);
		
		List<Map<String, String>> empDetailList = service.empDetailList(paraMap);
		// System.out.println("empDetailList :" + empDetailList);
		JSONArray jsonArr = new JSONArray();
		if(empDetailList != null) {
			for(Map<String, String> map : empDetailList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("empid", map.get("empid"));
				jsonObj.put("name", map.get("name"));
				jsonObj.put("nickname", map.get("nickname"));
				jsonObj.put("mobile", map.get("mobile"));
				jsonObj.put("email", map.get("email"));
				jsonObj.put("postcode", map.get("postcode"));
				jsonObj.put("address", map.get("address"));
				jsonObj.put("detailaddress", map.get("detailaddress"));
				jsonObj.put("extraaddress", map.get("extraaddress"));
				jsonObj.put("imgfilename", map.get("imgfilename"));
				jsonObj.put("orgimgfilename", map.get("orgimgfilename"));
				jsonObj.put("hire_date", map.get("hire_date"));
				jsonObj.put("salary", map.get("salary"));
				jsonObj.put("point", map.get("point"));
				jsonObj.put("fk_dept_code", map.get("fk_dept_code"));
				jsonObj.put("dept_code", map.get("dept_code"));
				jsonObj.put("dept_name", map.get("dept_name"));
				jsonObj.put("fk_job_code", map.get("fk_job_code"));
				jsonObj.put("job_code", map.get("job_code"));
				jsonObj.put("job_name", map.get("job_name"));
				jsonObj.put("dept_tel", map.get("dept_tel"));
				jsonObj.put("func_gender", map.get("gender"));
				jsonObj.put("func_age", map.get("age"));
				// 디테일 팝업에 gender , age 항목 추가하기
				

				jsonArr.put(jsonObj);
			}// end of for---------------
			
			// System.out.println(jsonArr.toString());
			
		}
		
		return jsonArr.toString();
	}
	
	// 검색어 입력 시 자동글 완성하기
	@ResponseBody
	@GetMapping(value="/employee/wordSearchShowJSON.kedai", produces="text/plain;charset=UTF-8")
	public String wordSearchShowJSON (HttpServletRequest request) {
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		List<String> wordList = service.wordSearchShowJSON(paraMap);
		
		JSONArray jsonArr = new JSONArray(); // []
		
		if(wordList != null) {
			for(String word : wordList) {
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("word", word);
				
				jsonArr.put(jsonObj); // [{}, {}, {}]
			} // end of for ----------
		}
		
		return jsonArr.toString();
	}
	
	// ==== #222. (웹채팅관련4) ==== //
	/*
 	@GetMapping("/chatting/multichat.kedai") 
	public String requiredLogin_multichat(HttpServletRequest request, HttpServletResponse response) {
	
	return "multichat"; 
	 
	}
 	*/
	

	// 접속중인 직원 정보 채팅방에 보여주기 
    @GetMapping("/chatting/multichat.kedai")
    public ModelAndView multichatLogin_EmpList(ModelAndView mav, HttpServletRequest request) {
    	
    	
    /*	
    	HttpSession session = request.getSession();
    	
    	MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
    	
    	List<Map<String,String>> loginEmpInfoList = new ArrayList<>();
    	
    	if(loginuser != null) {
    		Map<String, String> empInfo = new HashMap<>();
        	empInfo.put("name", loginuser.getName());
        	empInfo.put("imgfilename", loginuser.getImgfilename());
        	empInfo.put("dept_name", loginuser.getDept_name());
        	empInfo.put("job_name", loginuser.getJob_name());
        	
        	loginEmpInfoList.add(empInfo);
    	}
    	
    	mav.addObject("loginEmpInfoList" , loginEmpInfoList);
    	System.out.println("loginEmpInfoList : " + loginEmpInfoList);
    	// loginEmpInfoList : [{job_name=전무, imgfilename=20240716235337265539922875800.jpg, name=이주빈, dept_name=회계부}]
    */	
    	mav.setViewName("multichat");
    	
		return mav;
      
   }
	 
}
