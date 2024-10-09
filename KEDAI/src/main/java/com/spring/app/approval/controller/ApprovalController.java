package com.spring.app.approval.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.app.approval.service.ApprovalService;
import com.spring.app.common.FileManager;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.ApprovalVO;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.DocVO;
import com.spring.app.domain.DocfileVO;
import com.spring.app.domain.MemberVO;


@Controller 
//@RequestMapping(value="/approval/*") // 이렇게 하면 @GetMapping("/approval/newdoc.kedai")에서 /approval를 빼도 됨. /approval 가 붙는 효과가 있음.
public class ApprovalController {
	
	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private ApprovalService service;
	
	@Autowired
	private FileManager fileManager;
	
	@GetMapping(value = "/approval/main.kedai")
	public ModelAndView empmanager_approval(HttpServletRequest request, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String loginEmpId = loginuser.getEmpid();
		
		List<Map<String, String>> myapprovalinfo = service.myapprovalinfo(loginEmpId);
	//	System.out.println("확인용 myapprovalinfo" + myapprovalinfo);
		
		List<Map<String, String>> nowApproval = new ArrayList<>(); // 내가 지금 승인할 문서
		List<Map<String, String>> laterApproval = new ArrayList<>(); // 내가 나중에 승인할 문서
		
		for(Map<String, String> map : myapprovalinfo){
			if("1".equals(map.get("pre_status")) && "1".equals(map.get("doc_status"))) { //이전 레벨의 담당자가 승인하고, 진행중인 기안서만  map에 담기
				nowApproval.add(map);
	        }
			else if((map.get("pre_status") == null) && "0".equals(map.get("doc_status"))) { // 이전 레벨의 승인 담당자가 없고, 서류가 결재중이 아닐때(본인이 첫 결재자일 때)
				nowApproval.add(map);
			}
			
			else if("0".equals(map.get("pre_status")) && !"3".equals(map.get("doc_status")) ) {//이전 레벨의 담당자가 승인하지 않고,반려되지 않은 기안서만  map에 담기(나중에 결재할문서)
				laterApproval.add(map);
			}
	    }
		
	//	System.out.println("확인용 nowApproval" + nowApproval);
		
		List<DocVO> myDocList = null;
		
		myDocList = service.docListNoSearch(loginEmpId);
	//	System.out.println("확인용 myDocList" + myDocList);

//		System.out.println("확인용 laterApproval" + laterApproval);
		
		
		mav.addObject("nowApproval", nowApproval);
		mav.addObject("laterApproval", laterApproval);
		mav.addObject("myDocList", myDocList);

		
		mav.setViewName("tiles1/approval/main.tiles");
		// /WEB-INF/views/tiles/tiles1/content/approval/main.jsp
	//	/WEB-INF/views/tiles/tiles1/content/approval/main.tiles.jsp 페이지를 만들어야 한다.
		
		return mav;
	}
	
	@GetMapping(value = "/approval/newdoc.kedai")
	public ModelAndView newDoc(ModelAndView mav, HttpServletRequest request ) {
		
		String doctype_code = request.getParameter("doctype_code");

		Map<String, String> paraMap = new HashMap<>();
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		paraMap.put("dept_code", loginuser.getFk_dept_code());
		
		Date now = new Date(); // 현재시각
		SimpleDateFormat sdfmt = new SimpleDateFormat("yyyy-MM-dd");
		String str_now = sdfmt.format(now); // "2024-07-04"
		String dept_name = service.getDeptNumber(paraMap); // DB에서 부서번호 구해오기
		mav.addObject("str_now", str_now);
		mav.addObject("dept_name", dept_name);
		
		List<DeptVO> allDeptList = service.allDeptList();
		
		
		
		/*
		 * List<Map<String, String>> numByDept = service.numByDept(); // 각 부서별 당 인원수
		 * 가져오기
		 */		
	//	mav.addObject("allEmployeeList", allEmployeeList);
		mav.addObject("allDeptList", allDeptList);
		
		
		if(doctype_code.equals("100")) {
			mav.setViewName("tiles1/approval/newdayoff.tiles");
		}
		else if(doctype_code.equals("101")){
			
			mav.setViewName("tiles1/approval/newmeeting.tiles");
		}
			
		//	/WEB-INF/views/tiles/tiles1/content/approval/newdoc.jsp 페이지를 만들어야 한다.
		
		return mav;
	}
	
	@ResponseBody
	@PostMapping(value="/approval/newdoc.kedai", produces="text/plain;charset=UTF-8")
	public String newDoc(MultipartHttpServletRequest mtp_request, DocVO docvo) {
		
		List<MultipartFile> fileList = mtp_request.getFiles("file_arr"); // getFile는 단수 개, getFiles는 List로 반환
		// "file_arr" 은 /board/src/main/webapp/WEB-INF/views/tiles1/email/emailWrite.jsp 페이지의 314 라인에 보여지는 formData.append("file_arr", item); 의 값이다.
		// !!주의 !!복수개의 파일은 mtp_request.getFile이 아니라 mtp_request.getFiles이다.
		
		
		// MultipartFile interface는 Spring에서 업로드된 파일을 다룰 때 사용되는 인터페이스로 파일의 이름과 실제 데이터, 파일 크기 등을 구할 수 있다.
	       
	    /*
	         >>>> 첨부파일이 업로드 되어질 특정 경로(폴더)지정해주기
	                    우리는 WAS 의 webapp/resources/doc_attach_file 라는 폴더로 지정해준다.
	    */
	    // WAS 의 webapp 의 절대경로를 알아와야 한다.
		
		HttpSession session = mtp_request.getSession();
	    String root = session.getServletContext().getRealPath("/");
		String path = root+"resources"+File.separator+"files"+File.separator+"doc_attach_file";
		
	    // path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.
	      
	    System.out.println("~~~~ 확인용 업로드 path => " + path);
	    //~~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\board\resources\doc_attach_file
	    // resources에 들어가면 doc_attach_file폴더가 아직 생성되지 않았다. 아래와 같이 생성해준다.
	    
	    File dir = new File(path); // 
	    if(!dir.exists()) {
	    	dir.mkdirs();
	    }
	    
	  //C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\board\resources\doc_attach_file 라는 폴더가 생성 되었는지 확인해준다.
		
		 // >>>> 첨부파일을 위의 path 경로에 올리기 <<<< //
	    String[] arr_attachOrgFilename = null; // 기존 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachNewFilename = null; // 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachFileSize = null;
		
		if(fileList != null && fileList.size() > 0){ // 파일 첨부가 있는 경우라면
			arr_attachOrgFilename = new String[fileList.size()];
			arr_attachNewFilename = new String[fileList.size()];
			arr_attachFileSize = new String[fileList.size()];	
			
		    for(int i=0; i<fileList.size(); i++) {
		    	MultipartFile mtfile = fileList.get(i);
		    	String fileName = mtfile.getOriginalFilename();
		    //	System.out.println("파일명 : " + mtfile.getOriginalFilename() + " / 파일크기 : " + mtfile.getSize());
		    		/*
		    		 파일명 : berkelekle심플라운드01.jpg / 파일크기 : 71317
					파일명 : Electrolux냉장고_사용설명서.pdf / 파일크기 : 791567
					파일명 : 쉐보레전면.jpg / 파일크기 : 131110
					*/
		    	// 서버에 저장할 새로운 파일명을 만든다.
                // 서버에 저장할 새로운 파일명이 동일한 파일명이 되지 않고 고유한 파일명이 되도록 하기 위해
                // 현재의 년월일시분초에다가 현재 나노세컨즈nanoseconds 값을 결합하여 확장자를 붙여서 만든다.
    			String newFilename = fileName.substring(0, fileName.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기
    			
    			newFilename += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance());
    			newFilename += System.nanoTime();
    			newFilename += fileName.substring(fileName.lastIndexOf(".")); // 확장자 붙이기
    			
    			
		    	try {
		    			/*
		                   	File 클래스는 java.io 패키지에 포함되며, 입출력에 필요한 파일이나 디렉터리를 제어하는 데 사용된다.
		                    	파일과 디렉터리의 접근 권한, 생성된 시간, 경로 등의 정보를 얻을 수 있는 메소드가 있으며, 
		                    	새로운 파일 및 디렉터리 생성, 삭제 등 다양한 조작 메서드를 가지고 있다.
		               */		    		
		    		
		    			// === MultipartFile 을 File 로 변환하여 탐색기 저장폴더에 저장하기 시작 ===
		    		File attachFile = new File(path + File.separator + newFilename);
			    	mtfile.transferTo(attachFile); // // !!!!! 이것이 파일을 업로드해주는 것이다. !!!!!!
			    		/*
		                  form 태그로 부터 전송받은 MultipartFile mtfile 파일을 지정된 대상 파일(attachFile)로 전송한다.
		                                           만약에 대상 파일(attachFile)이 이미 존재하는 경우 먼저 삭제된다.
		               */
		               // 탐색기에서 C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\board\resources\doc_attach_file 폴더에 가보면
		               // 첨부한 파일이 생성되어져 있음을 확인할 수 있다.
			    		
			    	arr_attachOrgFilename[i] = mtfile.getOriginalFilename(); // 배열 속에 첨부파일명 들을 기록한다.
			    	arr_attachNewFilename[i] = newFilename; // 배열 속에 첨부파일명 들을 기록한다.
			    	
			    	arr_attachFileSize[i] = Long.toString(mtfile.getSize());
			    		
			    		
			    		// === MultipartFile 을 File 로 변환하여 탐색기 저장폴더에 저장하기 끝 ===
		    	} catch(Exception e) {
		    		e.printStackTrace();
		    	}
		    		
		    }// end of for---------------------
		}
		
		// === 첨부 이미지 파일을 저장했으니 그 다음으로 doc정보들을 테이블에 insert 해주어야 한다.  ===
		Map<String, String> docSeq = new HashMap<>();
		docSeq = service.getDocSeq();// seq들을 채번해 오는 함수
	
		Calendar currentDate = Calendar.getInstance();		// 현재날짜와 시간을 얻어온다.

		int year = currentDate.get(Calendar.YEAR);
		String year_new = String.valueOf(year).substring(2);
		String fk_doctype_code = mtp_request.getParameter("fk_doctype_code");
		String fk_doc_no = "KD" +year_new +"-"+ fk_doctype_code + "-" + docSeq.get("doc_noSeq");
		docvo.setDoc_no(fk_doc_no); 
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("docvo", docvo); 
		//기안 종류 코드, 기안자 사원 아이디, 기안문서 제목, 기안문서내용, 서류 작성일자
		
		int lineNumber = Integer.parseInt(mtp_request.getParameter("lineNumber"));
		
		paraMap.put("fk_doc_no", fk_doc_no);
		paraMap.put("fk_doctype_code", fk_doctype_code);
		paraMap.put("approval_no", docSeq.get("approval_noSeq"));
		paraMap.put("lineNumber", lineNumber);
		
		if("101".equals(fk_doctype_code)) {
			paraMap.put("meeting_date", mtp_request.getParameter("meeting_date"));
			paraMap.put("attendees", mtp_request.getParameter("attendees"));
			paraMap.put("host_dept", mtp_request.getParameter("host_dept"));
		}
		else if("100".equals(fk_doctype_code)) {
			paraMap.put("startdate", mtp_request.getParameter("startdate"));
			paraMap.put("enddate", mtp_request.getParameter("enddate"));
			paraMap.put("request_annual_leave", mtp_request.getParameter("request_annual_leave"));
			
			String start_am_half_day =  mtp_request.getParameter("start_am_half_day");
			String start_pm_half_day = mtp_request.getParameter("start_pm_half_day");
			String end_pm_half_day = mtp_request.getParameter("end_pm_half_day");
			
			String start_half = "0";
			String end_half = "0";
			
			if(start_am_half_day != null ) {
				start_half = "1";
			}
			else if(start_pm_half_day != null) {
				start_half = "2";
			}

			paraMap.put("start_half", start_half);
			
			if(end_pm_half_day != null) {
				end_half = "2";
			}
			
			paraMap.put("end_half", end_half);
		}
		
		int n1 = 0;
		int n2 = 0;
		
		for(int i=1; i<lineNumber+1; i++) {
			String level_no_key = "level_no_" + i; // 예: "level_no_1", "level_no_2", ...
			paraMap.put(level_no_key, mtp_request.getParameter(level_no_key));
		}
		/*
		paraMap.put("empId1", mtp_request.getParameter("level_no_1"));
		paraMap.put("empId2", mtp_request.getParameter("level_no_2"));
		paraMap.put("empId3", mtp_request.getParameter("level_no_3"));
		 	*/	

		n1 = service.noFile_doc(paraMap); // 서류 작성 insert 하기
	/*	
		if(n1>0) {
			System.out.println("Document inserted successfully for empId: " + paraMap.get("empId"));
		}else {
	        // 삽입 실패 처리
	        System.out.println("Failed to insert document for empId: " + paraMap.get("empId"));
	    }
		*/
		

		int cnt = 0;
		if(n1 ==1 && fileList != null && fileList.size() > 0) {
			Map<String, String> docFileMap = new HashMap<>();
			
			docFileMap.put("fk_doc_no", fk_doc_no);
			
			for(int i=0; i<fileList.size(); i++) {
				docFileMap.put("doc_filename", arr_attachNewFilename[i]);
				docFileMap.put("doc_filesize", arr_attachFileSize[i]);
				docFileMap.put("doc_org_filename", arr_attachOrgFilename[i]);
			
				int attach_insert_result = service.withFile_doc(docFileMap);
				
				//System.out.println("~~!확인용 : "+ arr_attachFilename[i].substring(0, arr_attachFilename[i].lastIndexOf("_")));

				if(attach_insert_result == 1) {
        			cnt++;
        		}
			} // end of for----------------
			
			if(cnt == fileList.size()) {
				n2 = 1;
        	}
		}// end of if(n1 ==1 && fileList != null && fileList.size() > 0)-----------------------
		JSONObject jsonObj = new JSONObject();
		
		if(fileList != null && fileList.size() > 0) {
			jsonObj.put("result", n1*n2);
		}
		else {
			jsonObj.put("result", n1);
		}        
        return jsonObj.toString(); 
	}

	
	
	@GetMapping(value="/approval/newDocEnd.kedai")
	public String newDocEnd(ModelAndView mav, HttpServletRequest request ) {
	      
		return "redirect:/approval/main.kedai"; // 메인 화면으로 돌아가기
	    //  /WEB-INF/views/tiles1/email/emailWrite_done.jsp 페이지를 만들어야 한다.
	}	
	
	 /*
    @ResponseBody 란?
	  메소드에 @ResponseBody Annotation이 되어 있으면 return 되는 값은 View 단 페이지를 통해서 출력되는 것이 아니라 
	 return 되어지는 값 그 자체를 웹브라우저에 바로 직접 쓰여지게 하는 것이다. 일반적으로 JSON 값을 Return 할때 많이 사용된다.
	 
	  >>> 스프링에서 json 또는 gson을 사용한 ajax 구현시 데이터를 화면에 출력해 줄때 한글로 된 데이터가 '?'로 출력되어 한글이 깨지는 현상이 있다. 
               이것을 해결하는 방법은 @RequestMapping 어노테이션의 속성 중 produces="text/plain;charset=UTF-8" 를 사용하면 
               응답 페이지에 대한 UTF-8 인코딩이 가능하여 한글 깨짐을 방지 할 수 있다. <<< 
  */ 
	@ResponseBody
	@PostMapping(value="/approval/deptEmpListJSON.kedai",  produces="text/plain;charset=UTF-8")
	public String deptEmpListJSON(HttpServletRequest request ){
				// @RequestParam은 request.getParameter()와 같은 것이다. defaultValue는 파라미터의 초기값을 설정해 줄 수 있는 것을 말한다. 위의 내용은 null대신 ""을 설정한 것이다. 
				//  form태그의 name값을 꼭 String 이름 이런 식으로 넣어주어야 한다.
		
		String dept_code = request.getParameter("dept_code");
		String loginuser_id = request.getParameter("loginuser_id");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("dept_code", dept_code);
		paraMap.put("loginuser_id", loginuser_id);
		
		// 본인을 제외한 모든 사원의 정보 가져오기 - 부서번호가 없는 대표이사가 있기 때문에 dept_code도 같이 paraMap에 담는다.
		List<Map<String,String>> deptEmpList = service.deptEmpList(paraMap);
		
		JSONArray jsonArr = new JSONArray();
		if(deptEmpList != null) {
			for(Map<String,String> map : deptEmpList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("empid", map.get("empid"));
				jsonObj.put("name", map.get("name"));
				jsonObj.put("fk_dept_code", map.get("fk_dept_code"));
				jsonObj.put("dept_name", map.get("dept_name"));
				jsonObj.put("job_code", map.get("job_code"));
				jsonObj.put("job_name", map.get("job_name"));

				jsonArr.put(jsonObj);
			}// end of for---------------
			
		//	System.out.println(jsonArr.toString());
			
		}
		
		return jsonArr.toString();
		
	}
	
	
	@RequestMapping("/approval/nowApprovalList.kedai")
	public ModelAndView nowApprovalList(ModelAndView mav, HttpServletRequest request) {
	
		//System.out.println("확인용 searchWord" + request.getParameter("searchWord"));
		//System.out.println("확인용 searchType" + request.getParameter("searchType"));
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String loginEmpId = loginuser.getEmpid();
		
		List<Map<String, String>> allNowApprovalList = null;
		
		//=== #122.페이징 처리를 한 검색어가 있는 전체 글목록 보여주기 == //
		
		/*  페이징 처리를 통한 글목록 보여주기는 
        
        	예를 들어 3페이지의 내용을 보고자 한다라면 
        	검색을 할 경우는 아래와 같이
 		list.action?searchType=subject&searchWord=안녕&currentShowPageNo=3 와 같이 해주어야 한다.
 
        	또는
 
        	검색이 없는 전체를 볼때는 아래와 같이 
		list.action 또는 
		list.action?searchType=&searchWord=&currentShowPageNo=3 또는 
		list.action?searchType=subject&searchWord=&currentShowPageNo=3 또는
		list.action?searchType=name&searchWord=&currentShowPageNo=3 와 같이 해주어야 한다.
		*/
		String searchType = request.getParameter("searchType"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String searchWord = request.getParameter("searchWord"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
	//	System.out.println("~~ 확인용 str_currentShowPageNo : " + str_currentShowPageNo);
	    // ~~ 확인용 str_currentShowPageNo : null 
	    // ~~ 확인용 str_currentShowPageNo : 3
	    // ~~ 확인용 str_currentShowPageNo : dsfsdfdsfdsfㄴㄹㄴㅇㄹㄴ
	    // ~~ 확인용 str_currentShowPageNo : -3412
	    // ~~ 확인용 str_currentShowPageNo : 0
	    // ~~ 확인용 str_currentShowPageNo : 32546
	    // ~~ 확인용 str_currentShowPageNo : 35325234534623463454354534
		
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
			// "		연습	" ==> "연습"
			// "		 	" ==> ""
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("loginEmpId", loginEmpId);
		
		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을 때로 나뉘어진다.
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		//총 게시물 건수(totalCount)
		totalCount = service.getTotalMyNowApprovalCount(paraMap);
		
	//	System.out.println("~~확인용totalCount "+totalCount);
		//~~확인용totalCount 14
		// 글 제목에 검색어 입력하고 검색 했을 때 
		//~~확인용totalCount 5
		//~~확인용totalCount 2
		//~~확인용totalCount 3
		
		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
        // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);  // 하나를 더블로 바꿔주면 소수점으로 값이 나옴.
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> (int)13.0 ==> 13
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> (int)12.0 ==> 12
		// Math.ceil을 이용해 1을 올려준다. 왜? 12.4가 나오면 13페이지 수가 나와야 하기 때문이다.
		
		
		if(str_currentShowPageNo == null) { // 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					// 다른 사람이 장난 쳐 왔을 때(1보다 작고 토탈 페이지보다 클 때)
					currentShowPageNo = 1; 
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	                // get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				}
			}catch(NumberFormatException e) {
				// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1; 
			}
		}
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
         /*
              currentShowPageNo      startRno     endRno
             --------------------------------------------
                  1 page        ===>    1           10
                  2 page        ===>    11          20
                  3 page        ===>    21          30
                  4 page        ===>    31          40
                  ......                ...         ...
          */
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
				
        allNowApprovalList = service.myNowApprovalListSearch(paraMap);
     // 글 목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.
        
		mav.addObject("loginuser", loginuser); // 모델에 loginuser 객체 추가
		mav.addObject("allNowApprovalList", allNowApprovalList); 
		
		for(Map<String, String> map : allNowApprovalList) {
			System.out.println(map);
		}
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) || "content".equals(searchType) 
				|| "subject_content".equals(searchType) || "name".equals(searchType) ) {  // select 태그 리스트에만 있는 것만 보내준다. 만약 get방식으로 abcd쓰면 select 태그에 빈칸으로 남아있기 때문에.
			mav.addObject("paraMap", paraMap);
		}
		
		// === #129. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
	      /*
	                       1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  21 22 23
	      */
		
		int loop = 1;
     /*   loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.    */
		
		int pageNo =  ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	      // *** !! 공식이다. !! *** //
	      
	//	System.out.println("~~확인용pageNo : " + pageNo);
	   /*
	       1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
	       11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
	       21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
	       
	       currentShowPageNo         pageNo
	      ----------------------------------
	            1                      1 = ((1 - 1)/10) * 10 + 1
	            2                      1 = ((2 - 1)/10) * 10 + 1
	            3                      1 = ((3 - 1)/10) * 10 + 1
	            4                      1
	            5                      1
	            6                      1
	            7                      1 
	            8                      1
	            9                      1
	            10                     1 = ((10 - 1)/10) * 10 + 1
	           
	            11                    11 = ((11 - 1)/10) * 10 + 1
	            12                    11 = ((12 - 1)/10) * 10 + 1
	            13                    11 = ((13 - 1)/10) * 10 + 1
	            14                    11
	            15                    11
	            16                    11
	            17                    11
	            18                    11 
	            19                    11 
	            20                    11 = ((20 - 1)/10) * 10 + 1
	            
	            21                    21 = ((21 - 1)/10) * 10 + 1
	            22                    21 = ((22 - 1)/10) * 10 + 1
	            23                    21 = ((23 - 1)/10) * 10 + 1
	            ..                    ..
	            29                    21
	            30                    21 = ((30 - 1)/10) * 10 + 1
	   */
		
		String pageBar = "<ul style='list-style:none;'>";
		String url="/approval/nowApprovalList.kedai";
		
		// === [맨처음][이전]만들기 ===//
	//	if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'"+pageNo+">[맨처음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo='"+(pageNo-1)+"'>[이전]</a></li>";	
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>"+pageNo+"</a></li>"; 
			}
			loop++;
			pageNo++;	
		}// end of while------------------------
		
		// === [다음][마지막]만들기 ===//
		if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"'>[다음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"'>[마지막]</a></li>";	
		}		
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// === #131. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	      //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	      //           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		//System.out.println(" 확인용(list.action) goBackURL " + goBackURL);
		/*
		  확인용(list.action) goBackURL /list.action
		  확인용(list.action) goBackURL /list.action?searchType=&searchWord=&currentShowPageNo=5
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=java
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=정화&currentShowPageNo=3 
		 */
		
		mav.addObject("goBackURL", goBackURL);
		
		/////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////
		mav.addObject("totalCount", totalCount); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("currentShowPageNo", currentShowPageNo); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("sizePerPage", sizePerPage); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		mav.setViewName("tiles1/approval/nowApprvalList.tiles");
		
		return mav;
	}
	
	@RequestMapping("/approval/showMyDocList.kedai")
	public ModelAndView showMyDocList(ModelAndView mav, HttpServletRequest request) {
		
		
		//System.out.println("확인용 searchWord" + request.getParameter("searchWord"));
		//System.out.println("확인용 searchType" + request.getParameter("searchType"));
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String loginEmpId = loginuser.getEmpid();
		
		List<Map<String, String>> allMyDocList = null;
		
		//=== #122.페이징 처리를 한 검색어가 있는 전체 글목록 보여주기 == //
		
		/*  페이징 처리를 통한 글목록 보여주기는 
        
        	예를 들어 3페이지의 내용을 보고자 한다라면 
        	검색을 할 경우는 아래와 같이
 		list.action?searchType=subject&searchWord=안녕&currentShowPageNo=3 와 같이 해주어야 한다.
 
        	또는
 
        	검색이 없는 전체를 볼때는 아래와 같이 
		list.action 또는 
		list.action?searchType=&searchWord=&currentShowPageNo=3 또는 
		list.action?searchType=subject&searchWord=&currentShowPageNo=3 또는
		list.action?searchType=name&searchWord=&currentShowPageNo=3 와 같이 해주어야 한다.
		*/
		String searchType = request.getParameter("searchType"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String searchWord = request.getParameter("searchWord"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
	//	System.out.println("~~ 확인용 str_currentShowPageNo : " + str_currentShowPageNo);
	    // ~~ 확인용 str_currentShowPageNo : null 
	    // ~~ 확인용 str_currentShowPageNo : 3
	    // ~~ 확인용 str_currentShowPageNo : dsfsdfdsfdsfㄴㄹㄴㅇㄹㄴ
	    // ~~ 확인용 str_currentShowPageNo : -3412
	    // ~~ 확인용 str_currentShowPageNo : 0
	    // ~~ 확인용 str_currentShowPageNo : 32546
	    // ~~ 확인용 str_currentShowPageNo : 35325234534623463454354534
		
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
			// "		연습	" ==> "연습"
			// "		 	" ==> ""
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
        paraMap.put("loginEmpId", loginEmpId);

		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을 때로 나뉘어진다.
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		//총 게시물 건수(totalCount)
		totalCount = service.getTotalMyDocCount(paraMap);
		
		//System.out.println("~~확인용totalCount "+totalCount);
		//~~확인용totalCount 14
		// 글 제목에 검색어 입력하고 검색 했을 때 
		//~~확인용totalCount 5
		//~~확인용totalCount 2
		//~~확인용totalCount 3
		
		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
        // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);  // 하나를 더블로 바꿔주면 소수점으로 값이 나옴.
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> (int)13.0 ==> 13
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> (int)12.0 ==> 12
		// Math.ceil을 이용해 1을 올려준다. 왜? 12.4가 나오면 13페이지 수가 나와야 하기 때문이다.
		
		
		if(str_currentShowPageNo == null) { // 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					// 다른 사람이 장난 쳐 왔을 때(1보다 작고 토탈 페이지보다 클 때)
					currentShowPageNo = 1; 
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	                // get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				}
			}catch(NumberFormatException e) {
				// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1; 
			}
		}
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
         /*
              currentShowPageNo      startRno     endRno
             --------------------------------------------
                  1 page        ===>    1           10
                  2 page        ===>    11          20
                  3 page        ===>    21          30
                  4 page        ===>    31          40
                  ......                ...         ...
          */
		
		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        

        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
				
        allMyDocList = service.myDocListSearch(paraMap);
       // System.out.println("확인용 allMyDocList" + allMyDocList);
     // 글 목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.
		
		mav.addObject("loginuser", loginuser); // 모델에 loginuser 객체 추가
		mav.addObject("allMyDocList", allMyDocList); 
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) || "content".equals(searchType) 
				|| "subject_content".equals(searchType) || "name".equals(searchType) ) {  // select 태그 리스트에만 있는 것만 보내준다. 만약 get방식으로 abcd쓰면 select 태그에 빈칸으로 남아있기 때문에.
			mav.addObject("paraMap", paraMap);
		}
		
		// === #129. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
	      /*
	                       1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  21 22 23
	      */
		
		int loop = 1;
     /*   loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.    */
		
		int pageNo =  ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	      // *** !! 공식이다. !! *** //
	      
	//	System.out.println("~~확인용pageNo : " + pageNo);
	   /*
	       1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
	       11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
	       21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
	       
	       currentShowPageNo         pageNo
	      ----------------------------------
	            1                      1 = ((1 - 1)/10) * 10 + 1
	            2                      1 = ((2 - 1)/10) * 10 + 1
	            3                      1 = ((3 - 1)/10) * 10 + 1
	            4                      1
	            5                      1
	            6                      1
	            7                      1 
	            8                      1
	            9                      1
	            10                     1 = ((10 - 1)/10) * 10 + 1
	           
	            11                    11 = ((11 - 1)/10) * 10 + 1
	            12                    11 = ((12 - 1)/10) * 10 + 1
	            13                    11 = ((13 - 1)/10) * 10 + 1
	            14                    11
	            15                    11
	            16                    11
	            17                    11
	            18                    11 
	            19                    11 
	            20                    11 = ((20 - 1)/10) * 10 + 1
	            
	            21                    21 = ((21 - 1)/10) * 10 + 1
	            22                    21 = ((22 - 1)/10) * 10 + 1
	            23                    21 = ((23 - 1)/10) * 10 + 1
	            ..                    ..
	            29                    21
	            30                    21 = ((30 - 1)/10) * 10 + 1
	   */
		
		String pageBar = "<ul style='list-style:none;'>";
		String url="showMyDocList.kedai";
		
		// === [맨처음][이전]만들기 ===//
	//	if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1' style='color: #2c4459;'>[맨처음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo='"+(pageNo-1)+"' style='color: #2c4459;'>[이전]</a></li>";	
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block;  width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>"+pageNo+"</a></li>"; 
			}
			loop++;
			pageNo++;	
		}// end of while------------------------
		
		// === [다음][마지막]만들기 ===//
		if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;' >[다음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color: #2c4459;' >[마지막]</a></li>";	
		}		
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// === #131. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	      //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	      //           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		//System.out.println(" 확인용(list.action) goBackURL " + goBackURL);
		/*
		  확인용(list.action) goBackURL /list.action
		  확인용(list.action) goBackURL /list.action?searchType=&searchWord=&currentShowPageNo=5
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=java
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=정화&currentShowPageNo=3 
		 */
		
		mav.addObject("goBackURL", goBackURL);
		
		/////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////
		mav.addObject("totalCount", totalCount); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("currentShowPageNo", currentShowPageNo); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("sizePerPage", sizePerPage); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		mav.setViewName("tiles1/approval/myDocList.tiles");
		
		return mav;
	}
	
	@RequestMapping("/approval/viewOneDoc.kedai")
	public ModelAndView viewOneDoc(ModelAndView mav, HttpServletRequest request) {
		//String seq = request.getParameter("seq");
		String doc_no="";
		String fk_doctype_code="";
		String goBackURL = "";
		String searchType = "";
		String searchWord = "";
		
		
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		// redirect 되어서 넘어온 데이터가 있는지 꺼내어 와본다.
		// Map<String, ?>에서 ?은 아무거나. object를 말한다.
		
		if(inputFlashMap != null) { // redirect 되어서 넘어온 데이터가 있다 라면 
			
			@SuppressWarnings("unchecked") // 경고 표시를 하지 말라는 뜻
			Map<String, String> redirect_map = (Map<String, String>) inputFlashMap.get("redirect_map"); 
			// redirect_map이 Map이기 때문에 다시 캐스팅 해줘야 한다.inputFlashMap.get("redirect_map")의 값은 object이다.
			// "redirect_map" 값은  /view_2.action 에서  redirectAttr.addFlashAttribute("키", 밸류값); 을 할때 준 "키" 이다. 
	        // "키" 값을 주어서 redirect 되어서 넘어온 데이터를 꺼내어 온다. 
	        // "키" 값을 주어서 redirect 되어서 넘어온 데이터의 값은 Map<String, String> 이므로 Map<String, String> 으로 casting 해준다.
			

	   //     System.out.println("~~~ 확인용 seq : " + redirect_map.get("seq"));
	     //   seq = redirect_map.get("seq");
			
		}

		/////////////////////////////////////////////////////////////////////////		
		else {// redirect 되어서 넘어온 데이터가 아닌 경우(직접 해 온 경우)
			
			// == 조회하고자 하는 글번호 받아오기 ==
	           
	        // 글목록보기인 /list.action 페이지에서 특정 글제목을 클릭하여 특정글을 조회해온 경우  
	        // 또는 
	        // 글목록보기인 /list.action 페이지에서 특정 글제목을 클릭하여 특정글을 조회한 후 새로고침(F5)을 한 경우는 원본이 form 을 사용해서 POST 방식으로 넘어온 경우이므로 "양식 다시 제출 확인" 이라는 대화상자가 뜨게 되며 "계속" 이라는 버튼을 클릭하면 이전에 입력했던 데이터를 자동적으로 입력해서 POST 방식으로 진행된다. 그래서  request.getParameter("seq"); 은 null 이 아닌 번호를 입력받아온다.     
	        // 그런데 "이전글제목" 또는 "다음글제목" 을 클릭하여 특정글을 조회한 후 새로고침(F5)을 한 경우는 원본이 /view_2.action 을 통해서 redirect 되어진 경우이므로 form 을 사용한 것이 아니라서 "양식 다시 제출 확인" 이라는 alert 대화상자가 뜨지 않는다. 그래서  request.getParameter("seq"); 은 null 이 된다. 
			doc_no= request.getParameter("doc_no");
			fk_doctype_code = request.getParameter("fk_doctype_code");

	        // ~~~~~~ 확인용 seq : 213
	        // ~~~~~~ 확인용 seq : null
			

			// >>> 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물내의 이전글과 다음글이 나오도록 하기 위한 것이다.  시작  // 
			
			searchType = request.getParameter("searchType");
			searchWord = request.getParameter("searchWord");
			
			if(searchType == null) {
				searchType = ""; // Mapper에서 null을 파악하려면 글자 자체가 'null'인지 값이 null인건지 헷갈리기 때문에 컨트롤러에서 해주는 것이 훨씬 낫다!
			}
			
			if(searchWord == null) {
				searchWord = "";
			}
			
			//System.out.println("~~ 확인용(view.action) searchType : "+searchType);
			//~~ 확인용(view.action) searchType : name
			
			//System.out.println("~~ 확인용(view.action) searchWord : "+searchWord);
			//~~ 확인용(view.action) searchWord : 정화
			
			// >>> 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물내의 이전글과 다음글이 나오도록 하기 위한 것이다.  끝  // 
			
			// ===#134. 특정글을 조회한 후 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 만들기 위함.
			goBackURL = request.getParameter("goBackURL");
		//	System.out.println("~~ 확인용(view.action) goBackURL : " + goBackURL);
			//~~ 확인용(view.action) goBackURL : /list.action?searchType=name&searchWord=%EC%A0%95%ED%99%94
		/*
		 	잘못된 것(get방식일 경우)
		 	~~ 확인용(view.action) goBackURL : /list.action?searchType=subject
		 	
		 	올바른 것(post방식일 경우)
		 	~~ 확인용(view.action) goBackURL :/list.action?searchType=subject&searchWord=%EC%A0%95%ED%99%94&currentShowPageNo=4
		*/
			request.setAttribute("goBackURL", goBackURL);
		}
		try {
			//Integer.parseInt(seq);
			 /* 
		     "이전글제목" 또는 "다음글제목" 을 클릭하여 특정글을 조회한 후 새로고침(F5)을 한 경우는   
		         원본이 /view_2.action 을 통해서 redirect 되어진 경우이므로 form 을 사용한 것이 아니라서   
		     "양식 다시 제출 확인" 이라는 alert 대화상자가 뜨지 않는다. 
		         그래서  request.getParameter("seq"); 은 null 이 된다. 
		         즉, 글번호인 seq 가 null 이 되므로 DB 에서 데이터를 조회할 수 없게 된다.     
		         또한 seq 는 null 이므로 Integer.parseInt(seq); 을 하면  NumberFormatException 이 발생하게 된다. 
		  */
			
			
			HttpSession session =  request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String login_userid = null;		
			if(loginuser != null) {
				login_userid = loginuser.getEmpid();
				// login_userid 는 로그인 되어진 사용자의 userid 이다.
			}
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("doc_no", doc_no);
			paraMap.put("fk_doctype_code", fk_doctype_code);
			
			// >>> 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물내의 이전글과 다음글이 나오도록 하기 위한 것이다.  시작  // 
			//paraMap.put("searchType", searchType);
			//paraMap.put("searchWord", searchWord);
			
			// >>> 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물내의 이전글과 다음글이 나오도록 하기 위한 것이다.  끝  // 

			// === #68. !!! 중요 !!! 
            //     글1개를 보여주는 페이지 요청은 select 와 함께 
          //     DML문(지금은 글조회수 증가인 update문)이 포함되어져 있다.
          //     이럴경우 웹브라우저에서 페이지 새로고침(F5)을 했을때 DML문이 실행되어
          //     매번 글조회수 증가가 발생한다.
          //     그래서 우리는 웹브라우저에서 페이지 새로고침(F5)을 했을때는
          //     단순히 select만 해주고 DML문(지금은 글조회수 증가인 update문)은 
          //     실행하지 않도록 해주어야 한다. !!! === //
			
			// 위의 글목록보기 #69. 에서 session.setAttribute("readCountPermission", "yes"); 해두었다.
			
			DocVO docvo = new DocVO();
			docvo = service.getOneDoc(paraMap);
			
			List<ApprovalVO> approvalvoList = docvo.getApprovalvoList();
			
			String level_no_str = null;
			boolean isExist = false;
			boolean isNowApproval = false; 
			for(ApprovalVO avo : approvalvoList) {
			    if(avo.getFk_empid().equals(login_userid) && "0".equals(avo.getStatus())) { 
			    	// 로그인한 사용자가 결재자로 있고, 결재하지 않은 상태일 때  ==> level_no를 level_no_str 변수에 담기
			    	level_no_str = avo.getLevel_no();
			    }
			}
			if(level_no_str != null) {
				String pre_level_no = String.valueOf(Integer.parseInt(level_no_str) + 1); 
				for (ApprovalVO avo : approvalvoList) {
					if(avo.getLevel_no().equals(pre_level_no)) { // 본인 이전 결재 담당자 정보 보기
						isExist = true;// 본인 이전의 담당자가 있는지 없는지 확인용
						if("1".equals(avo.getStatus()) && "1".equals(avo.getDoc_status())) { //이전 레벨의 담당자가 승인하고, 진행중인 기안서
							isNowApproval = true;
						}
					}
				}// end of for-------------
				
				if(isExist == false) {// 본인 이전의 담당자가 없고, 본인이 1순위 결재자일때
					for (ApprovalVO avo : approvalvoList) {
						if("0".equals(avo.getDoc_status())) {
							isNowApproval = true;
							break;
						}
					}
				}	
			}
			
			mav.addObject("isNowApproval",isNowApproval);
			mav.addObject("docvo",docvo);
			mav.addObject("level_no_str", level_no_str);
			mav.setViewName("tiles1/approval/viewOneDoc.tiles");
			
			
		}catch (NumberFormatException e ) {
			mav.setViewName("redirect:/myDocList.kedai");
		}
		return mav;
	}
	
	
	// 하나의 게시글에 있는 첨부파일 목록 불러오기
	@ResponseBody
	@GetMapping(value="/approval/docfileListShow.kedai" , produces="text/plain;charset=UTF-8")
	public String docfileListShow(HttpServletRequest request) {
		
		String doc_no = request.getParameter("doc_no");
		
		List<DocfileVO> docfileList = service.getDocfiletList(doc_no);
		
		JSONArray jsonArr = new JSONArray(); // []
		
		for(DocfileVO dfvo : docfileList) {
			JSONObject jsonObj = new JSONObject(); // {}
			jsonObj.put("file_no", dfvo.getDoc_file_no()); //{"seq":1}
			jsonObj.put("filename", dfvo.getDoc_filename());	// {"seq":1, "fk_userid":"hkim"}
			
			jsonObj.put("filesize", dfvo.getDoc_filesize());// {"seq":1, "fk_userid":"hkim", "name":"ㅎㅎ"}
			jsonObj.put("org_filename", dfvo.getDoc_org_filename());// {"seq":1, "fk_userid":"hkim", "name":"ㅎㅎ", "content":"첫번째 댓글입니다. ㅎㅎㅎ"}
			jsonObj.put("doc_no", dfvo.getFk_doc_no());// {"seq":1, "fk_userid":"hkim", "name":"ㅎㅎ", "content":"첫번째 댓글입니다. ㅎㅎㅎ", "regdate":"2024-06-18 15:36:37"}
			
			jsonArr.put(jsonObj);//[{"seq":1, "fk_userid":"hkim", "name":"ㅎㅎ", "content":"첫번째 댓글입니다. ㅎㅎㅎ", "regdate":"2024-06-18 15:36:37"}]
		}// end of for----------------
	
		
	
		return jsonArr.toString();//[{"seq":1, "fk_userid":"hkim", "name":"ㅎㅎ", "content":"첫번째 댓글입니다. ㅎㅎㅎ", "regdate":"2024-06-18 15:36:37"}],
		  //						{"seq":2, "fk_userid":"hkim", "name":"ㅎㅎ", "content":"두번째로 쓰는 댓글입니다", "regdate":"2024-06-18 16:05:50"}]
								// 또는
								// "[]" 왜? new 해 왔기 때문에
	}
	
	
	@GetMapping("/approval/downloadDocfile.kedai")
	public void requestLogin_download(HttpServletRequest request, HttpServletResponse response) {
		
		 String fileNo = request.getParameter("seq");
		 
		 Map<String, String> paraMap = new HashMap<>();
		 paraMap.put("fileNo", fileNo);
		
		//JSPServletBegin/src/main/java/chap02_package/GetMethod_01.java 참고
	    // *** 웹 브라우저에 출력하기 시작 ***//
	    response.setContentType("text/html; charset=UTF-8");
	    
	    PrintWriter out = null;	// out은 웹 브라우저에 기술하는 대상체라고 생각하자.
	    
	 // HttpServletResponse response 객체는 전송되어져온 데이터를 조작해서 결과물을 나타내고자 할때 쓰인다
	    try {
	    	
	    	Integer.parseInt(fileNo);
	    	DocfileVO docfilevo = service.getDocfileOne(fileNo);
	    	
	    	if(docfilevo == null) {
	    		out = response.getWriter(); // out은 웹 브라우저에 기술하는 대상체라고 생각하자.
	    		
	    		out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
	            return;
	    	}
	    	else {
	    		// 정상적으로 다운로드를 할 경우 
	    		String fileName = docfilevo.getDoc_filename();
	    		//202406280946562702764281800.jpg 이것이 바로 WAS(톰캣) 디스크에 저장된 파일명이다.
	    		
	    		String orgFilename = docfilevo.getDoc_org_filename();
	    		//쉐보레전면.jpg 다운로드시 보여줄 파일명
	    		
	
	    		// 첨부파일이 저장되어 있는 WAS(톰캣) 디스크 경로명을 알아와야만 다운로드를 해줄 수 있다.
	             // 이 경로는 우리가 파일첨부를 위해서 /addEnd.action 에서 설정해두었던 경로와 똑같아야 한다. 
	    		
				// WAS 의 webapp 의 절대경로를 알아와야 한다. 
		         HttpSession session = request.getSession(); 
		         String root = session.getServletContext().getRealPath("/"); 
		         
		         //System.out.println("~~~ 확인용 webapp 의 절대경로 => " + root); 
		         //C:\NCS\workspce_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\
				
		         String path = root+"resources"+File.separator+"files"+File.separator+"doc_attach_file";
		         
					// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files\
					
		         /* File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
			             운영체제가 Windows 이라면 File.separator 는  "\" 이고,
			             운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
			     */
		         
		      // path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
		         System.out.println("~~~ 확인용 path 다운로드 첨부파일 => " + path);
		         //  ~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files
		         //  C:\NCS\workspce_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\files
		           
		           
		      // ***** file 다운로드 하기 ***** //
		         boolean flag = false; // file 다운로드 성공, 실패인지 여부를 알려주는 용도 
		         flag = fileManager.doFileDownload(fileName, orgFilename, path, response); 
		            // file 다운로드 성공시 flag 는 true,
		            // file 다운로드 실패시 flag 는 false 를 가진다.
		            
		         if(!flag) {
		               // 다운로드가 실패한 경우 메시지를 띄워준다. 
		        	 out = response.getWriter();
		                // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
		                
		             out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
		         }
	    	}
		} catch (NumberFormatException | IOException e) {
			try {
				out = response.getWriter();// out은 웹 브라우저에 기술하는 대상체라고 생각하자.
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			
			} catch (IOException e2) {
				e2.printStackTrace();
			} 
		}
	}
	
	//결재 완료를 눌렀을 때
	@PostMapping("/approval/appOk.kedai")
	public String appOk(ModelAndView mav, HttpServletRequest request) {
		
		String fk_doc_no = request.getParameter("doc_no");
		String approval_comment = request.getParameter("approval_comment").trim();
		String level_no_str = request.getParameter("level_no");
		String fk_doctype_code = request.getParameter("fk_doctype_code");
		int offdays = 0;
		boolean annualLeaveUpdate = false;
		Map<String, Object> paraMap = new HashMap<>();
		
		String doc_status;
		if("1".equals(level_no_str)) {
			doc_status = "2"; // 결재완료
			if("100".equals(fk_doctype_code)) {
				annualLeaveUpdate = true;
				offdays = Integer.parseInt(request.getParameter("offdays"));
				paraMap.put("offdays", offdays);
			}
		}
		else {
			doc_status = "1";
		}
		
		Date now = new Date(); // 현재시각 
        SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String approval_date = sdfrmt.format(now);
        
        
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");	
		String loginEmpId = loginuser.getEmpid();
		
        
        paraMap.put("fk_doc_no", fk_doc_no);
        paraMap.put("approval_comment", approval_comment);
        paraMap.put("approval_date", approval_date);
        paraMap.put("loginEmpId", loginEmpId);
        paraMap.put("doc_status", doc_status); // tbl_doc의 status 업데이트
        paraMap.put("annualLeaveUpdate", String.valueOf(annualLeaveUpdate)); // 연차 업데이트가 필요한지 여
        
        service.updateDocApprovalOk(paraMap); // tbl_doc, tbl_approval업데이트
        
		return "redirect:/approval/main.kedai"; // 메인 화면으로 돌아가기
	}
	
 //  	<definition name="*/*/*/*.tiles" extends="layout-tiles">
//  	<put-attribute name="content" value="/WEB-INF/views/tiles/{1}/content/{2}/{3}/{4}.jsp"/>
//	</definition>

//mav.setViewName("tiles1/approval/newDocEnd.tiles");
	//	return mav;
	

	//반려하기를 눌렀을 때
	@PostMapping("/approval/appReject.kedai")
	public String appReject(ModelAndView mav, HttpServletRequest request) {
		
		String fk_doc_no = request.getParameter("doc_no");
		String approval_comment = request.getParameter("approval_comment").trim();
		String doc_status = "3"; // 서류 상태는 반려로 설정
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");	
		String loginEmpId = loginuser.getEmpid();
		
		Date now = new Date(); // 현재시각 
        SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String approval_date = sdfrmt.format(now);
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("fk_doc_no", fk_doc_no);
        paraMap.put("approval_comment", approval_comment);
        paraMap.put("approval_date", approval_date);
        paraMap.put("loginEmpId", loginEmpId);
        paraMap.put("doc_status", doc_status); // tbl_doc의 status 업데이트
        
        service.updateDocApprovalReject(paraMap); // tbl_doc, tbl_approval업데이트
		
		return "redirect:/approval/main.kedai"; // 메인 화면으로 돌아가기
	}
	
			
	@RequestMapping("/approval/showMyApprovalList.kedai")
	public ModelAndView showMyallApprovalList(ModelAndView mav, HttpServletRequest request) {
		
		
		//System.out.println("확인용 searchWord" + request.getParameter("searchWord"));
		//System.out.println("확인용 searchType" + request.getParameter("searchType"));
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String loginEmpId = loginuser.getEmpid();
		
		List<DocVO> myApprovalList = null;
		
		//=== #122.페이징 처리를 한 검색어가 있는 전체 글목록 보여주기 == //
		
		/*  페이징 처리를 통한 글목록 보여주기는 
        
        	예를 들어 3페이지의 내용을 보고자 한다라면 
        	검색을 할 경우는 아래와 같이
 		list.action?searchType=subject&searchWord=안녕&currentShowPageNo=3 와 같이 해주어야 한다.
 
        	또는
 
        	검색이 없는 전체를 볼때는 아래와 같이 
		list.action 또는 
		list.action?searchType=&searchWord=&currentShowPageNo=3 또는 
		list.action?searchType=subject&searchWord=&currentShowPageNo=3 또는
		list.action?searchType=name&searchWord=&currentShowPageNo=3 와 같이 해주어야 한다.
		*/
		String searchType = request.getParameter("searchType"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String searchWord = request.getParameter("searchWord"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
	//	System.out.println("~~ 확인용 str_currentShowPageNo : " + str_currentShowPageNo);
	    // ~~ 확인용 str_currentShowPageNo : null 
	    // ~~ 확인용 str_currentShowPageNo : 3
	    // ~~ 확인용 str_currentShowPageNo : dsfsdfdsfdsfㄴㄹㄴㅇㄹㄴ
	    // ~~ 확인용 str_currentShowPageNo : -3412
	    // ~~ 확인용 str_currentShowPageNo : 0
	    // ~~ 확인용 str_currentShowPageNo : 32546
	    // ~~ 확인용 str_currentShowPageNo : 35325234534623463454354534
		
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
			// "		연습	" ==> "연습"
			// "		 	" ==> ""
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
        paraMap.put("loginEmpId", loginEmpId);

		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을 때로 나뉘어진다.
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		//총 게시물 건수(totalCount)
		totalCount = service.getTotalMyApprovalCount(paraMap);
		
	//	System.out.println("~~확인용totalCount "+totalCount);
		//~~확인용totalCount 14
		// 글 제목에 검색어 입력하고 검색 했을 때 
		//~~확인용totalCount 5
		//~~확인용totalCount 2
		//~~확인용totalCount 3
		
		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
        // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);  // 하나를 더블로 바꿔주면 소수점으로 값이 나옴.
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> (int)13.0 ==> 13
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> (int)12.0 ==> 12
		// Math.ceil을 이용해 1을 올려준다. 왜? 12.4가 나오면 13페이지 수가 나와야 하기 때문이다.
		
		
		if(str_currentShowPageNo == null) { // 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					// 다른 사람이 장난 쳐 왔을 때(1보다 작고 토탈 페이지보다 클 때)
					currentShowPageNo = 1; 
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	                // get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				}
			}catch(NumberFormatException e) {
				// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1; 
			}
		}
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
         /*
              currentShowPageNo      startRno     endRno
             --------------------------------------------
                  1 page        ===>    1           10
                  2 page        ===>    11          20
                  3 page        ===>    21          30
                  4 page        ===>    31          40
                  ......                ...         ...
          */
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
				
        myApprovalList = service.allmyAppListSearch(paraMap);
     // 글 목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.
		
		mav.addObject("loginuser", loginuser); // 모델에 loginuser 객체 추가
		mav.addObject("myApprovalList", myApprovalList); 
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) || "content".equals(searchType) 
				|| "subject_content".equals(searchType) || "name".equals(searchType) ) {  // select 태그 리스트에만 있는 것만 보내준다. 만약 get방식으로 abcd쓰면 select 태그에 빈칸으로 남아있기 때문에.
			mav.addObject("paraMap", paraMap);
		}
		
		// === #129. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
	      /*
	                       1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  21 22 23
	      */
		
		int loop = 1;
     /*   loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.    */
		
		int pageNo =  ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	      // *** !! 공식이다. !! *** //
	      
	//	System.out.println("~~확인용pageNo : " + pageNo);
	   /*
	       1  2  3  4  5  6  7  8  9  10  -- 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 이다.
	       11 12 13 14 15 16 17 18 19 20  -- 두번째 블럭의 페이지번호 시작값(pageNo)은 11 이다.
	       21 22 23 24 25 26 27 28 29 30  -- 세번째 블럭의 페이지번호 시작값(pageNo)은 21 이다.
	       
	       currentShowPageNo         pageNo
	      ----------------------------------
	            1                      1 = ((1 - 1)/10) * 10 + 1
	            2                      1 = ((2 - 1)/10) * 10 + 1
	            3                      1 = ((3 - 1)/10) * 10 + 1
	            4                      1
	            5                      1
	            6                      1
	            7                      1 
	            8                      1
	            9                      1
	            10                     1 = ((10 - 1)/10) * 10 + 1
	           
	            11                    11 = ((11 - 1)/10) * 10 + 1
	            12                    11 = ((12 - 1)/10) * 10 + 1
	            13                    11 = ((13 - 1)/10) * 10 + 1
	            14                    11
	            15                    11
	            16                    11
	            17                    11
	            18                    11 
	            19                    11 
	            20                    11 = ((20 - 1)/10) * 10 + 1
	            
	            21                    21 = ((21 - 1)/10) * 10 + 1
	            22                    21 = ((22 - 1)/10) * 10 + 1
	            23                    21 = ((23 - 1)/10) * 10 + 1
	            ..                    ..
	            29                    21
	            30                    21 = ((30 - 1)/10) * 10 + 1
	   */
		
		String pageBar = "<ul style='list-style:none;'>";
		String url="showMyApprovalList.kedai";
		
		// === [맨처음][이전]만들기 ===//
	//	if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'style='color: #2c4459;' >[맨처음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo='"+(pageNo-1)+"' style='color: #2c4459;'>[이전]</a></li>";	
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e;''>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>"+pageNo+"</a></li>"; 
			}
			loop++;
			pageNo++;	
		}// end of while------------------------
		
		// === [다음][마지막]만들기 ===//
		if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;' >[다음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color: #2c4459;' >[마지막]</a></li>";	
		}		
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// === #131. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	      //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	      //           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		//System.out.println(" 확인용(list.action) goBackURL " + goBackURL);
		/*
		  확인용(list.action) goBackURL /list.action
		  확인용(list.action) goBackURL /list.action?searchType=&searchWord=&currentShowPageNo=5
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=java
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=정화&currentShowPageNo=3 
		 */
		
		mav.addObject("goBackURL", goBackURL);
		
		/////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////
		mav.addObject("totalCount", totalCount); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("currentShowPageNo", currentShowPageNo); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("sizePerPage", sizePerPage); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		mav.setViewName("tiles1/approval/myApprovalList.tiles");
		
		return mav;
	}
	
	
	@RequestMapping("/approval/teamDocList.kedai")
	public ModelAndView teamDocList(ModelAndView mav, HttpServletRequest request) {
		
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		String loginDeptCode = loginuser.getFk_dept_code();
		
		List<DocVO> teamDocList = null;
		
		String searchType = request.getParameter("searchType"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String searchWord = request.getParameter("searchWord"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
			// "		연습	" ==> "연습"
			// "		 	" ==> ""
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
        paraMap.put("loginDeptCode", loginDeptCode);

		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을 때로 나뉘어진다.
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		//총 게시물 건수(totalCount)
		totalCount = service.getTotalTeamCount(paraMap);

		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
        // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);  // 하나를 더블로 바꿔주면 소수점으로 값이 나옴.
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> (int)13.0 ==> 13
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> (int)12.0 ==> 12
		// Math.ceil을 이용해 1을 올려준다. 왜? 12.4가 나오면 13페이지 수가 나와야 하기 때문이다.
		
		
		if(str_currentShowPageNo == null) { // 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					// 다른 사람이 장난 쳐 왔을 때(1보다 작고 토탈 페이지보다 클 때)
					currentShowPageNo = 1; 
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	                // get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				}
			}catch(NumberFormatException e) {
				// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1; 
			}
		}
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
         /*
              currentShowPageNo      startRno     endRno
             --------------------------------------------
                  1 page        ===>    1           10
                  2 page        ===>    11          20
                  3 page        ===>    21          30
                  4 page        ===>    31          40
                  ......                ...         ...
          */
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
				
        teamDocList = service.allteamDocListSearch(paraMap);
     // 글 목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.
		
		mav.addObject("loginuser", loginuser); // 모델에 loginuser 객체 추가
		mav.addObject("teamDocList", teamDocList); 
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) || "content".equals(searchType) 
				|| "subject_content".equals(searchType) || "name".equals(searchType) ) {  // select 태그 리스트에만 있는 것만 보내준다. 만약 get방식으로 abcd쓰면 select 태그에 빈칸으로 남아있기 때문에.
			mav.addObject("paraMap", paraMap);
		}
		
		// === #129. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
	      /*
	                       1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  21 22 23
	      */
		
		int loop = 1;
     /*   loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.    */
		
		int pageNo =  ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	      // *** !! 공식이다. !! *** //
		
		String pageBar = "<ul style='list-style:none;'>";
		String url="teamDocList.kedai";
		
		// === [맨처음][이전]만들기 ===//
	//	if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'style='color: #2c4459;' >[맨처음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo='"+(pageNo-1)+"' style='color: #2c4459;'>[이전]</a></li>";	
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>"+pageNo+"</a></li>"; 
			}
			loop++;
			pageNo++;	
		}// end of while------------------------
		
		// === [다음][마지막]만들기 ===//
		if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;' >[다음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color: #2c4459;' >[마지막]</a></li>";	
		}		
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// === #131. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	      //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	      //           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		//System.out.println(" 확인용(list.action) goBackURL " + goBackURL);
		/*
		  확인용(list.action) goBackURL /list.action
		  확인용(list.action) goBackURL /list.action?searchType=&searchWord=&currentShowPageNo=5
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=java
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=정화&currentShowPageNo=3 
		 */
		
		mav.addObject("goBackURL", goBackURL);
		
		/////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////
		mav.addObject("totalCount", totalCount); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("currentShowPageNo", currentShowPageNo); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("sizePerPage", sizePerPage); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		mav.setViewName("tiles1/approval/teamDocList.tiles");
		
		return mav;
	}
	
	@RequestMapping("/approval/allDocList.kedai")
	public ModelAndView allDocList(ModelAndView mav, HttpServletRequest request) {
		
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		List<DocVO> allDocList = null;
		
		String searchType = request.getParameter("searchType"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String searchWord = request.getParameter("searchWord"); // myDoclist.jsp의 form 태그 내의 name이 searchType가 넘어 온다. 
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(searchType == null) {
			searchType = "";
		}
		if(searchWord == null) {
			searchWord = "";
		}
		if(searchWord != null) {
			searchWord = searchWord.trim();
			// "		연습	" ==> "연습"
			// "		 	" ==> ""
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		// 먼저, 총 게시물 건수(totalCount)를 구해와야 한다.
		// 총 게시물 건수(totalCount)는 검색조건이 있을 때와 없을 때로 나뉘어진다.
		
		int totalCount = 0;        // 총 게시물 건수
		int sizePerPage = 10;      // 한 페이지당 보여줄 게시물 건수 
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함. 
		int totalPage = 0;         // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바) 
		
		//총 게시물 건수(totalCount)
		totalCount = service.getTotalAllCount(paraMap);

		// 만약에 총 게시물 건수(totalCount)가 124 개 이라면 총 페이지수(totalPage)는 13 페이지가 되어야 한다.
        // 만약에 총 게시물 건수(totalCount)가 120 개 이라면 총 페이지수(totalPage)는 12 페이지가 되어야 한다.
		
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);  // 하나를 더블로 바꿔주면 소수점으로 값이 나옴.
		// (double)124/10 ==> 12.4 ==> Math.ceil(12.4) ==> 13.0 ==> (int)13.0 ==> 13
		// (double)120/10 ==> 12.0 ==> Math.ceil(12.0) ==> 12.0 ==> (int)12.0 ==> 12
		// Math.ceil을 이용해 1을 올려준다. 왜? 12.4가 나오면 13페이지 수가 나와야 하기 때문이다.
		
		
		if(str_currentShowPageNo == null) { // 게시판에 보여지는 초기화면
			currentShowPageNo = 1;
		}
		else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) {
					// 다른 사람이 장난 쳐 왔을 때(1보다 작고 토탈 페이지보다 클 때)
					currentShowPageNo = 1; 
					// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
	                // get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				}
			}catch(NumberFormatException e) {
				// get 방식이므로 사용자가 str_currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1; 
			}
		}
		// **** 가져올 게시글의 범위를 구한다.(공식임!!!) **** 
         /*
              currentShowPageNo      startRno     endRno
             --------------------------------------------
                  1 page        ===>    1           10
                  2 page        ===>    11          20
                  3 page        ===>    21          30
                  4 page        ===>    31          40
                  ......                ...         ...
          */
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
        
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
				
        allDocList = service.allDocListSearch(paraMap);
     // 글 목록 가져오기(페이징 처리 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것이다.
		
		mav.addObject("loginuser", loginuser); // 모델에 loginuser 객체 추가
		mav.addObject("allDocList", allDocList); 
		
		// 검색시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) || "content".equals(searchType) 
				|| "subject_content".equals(searchType) || "name".equals(searchType) ) {  // select 태그 리스트에만 있는 것만 보내준다. 만약 get방식으로 abcd쓰면 select 태그에 빈칸으로 남아있기 때문에.
			mav.addObject("paraMap", paraMap);
		}
		
		// === #129. 페이지바 만들기 === //
		int blockSize = 10;
		// blockSize 는 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
	      /*
	                       1  2  3  4  5  6  7  8  9 10 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  11 12 13 14 15 16 17 18 19 20 [다음][마지막]  -- 1개블럭
	         [맨처음][이전]  21 22 23
	      */
		
		int loop = 1;
     /*   loop는 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.    */
		
		int pageNo =  ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
	      // *** !! 공식이다. !! *** //
		
		String pageBar = "<ul style='list-style:none;'>";
		String url="allDocList.kedai";
		
		// === [맨처음][이전]만들기 ===//
	//	if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo=1'style='color: #2c4459;' >[맨처음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo='"+(pageNo-1)+"' style='color: #2c4459;'>[이전]</a></li>";	
		}
		
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"+pageNo+"</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;'>"+pageNo+"</a></li>"; 
			}
			loop++;
			pageNo++;	
		}// end of while------------------------
		
		// === [다음][마지막]만들기 ===//
		if(pageNo <= totalPage) { // 맨 마지막에는 나오지 않도록!
			pageBar += "<li style='display:inline-block; width:50px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+pageNo+"' style='color: #2c4459;' >[다음]</a></li>";	
			pageBar += "<li style='display:inline-block; width:70px; font-size:12pt;'><a href='"+url+"?searchType="+searchType+"&searchWord="+searchWord+"&currentShowPageNo="+totalPage+"' style='color: #2c4459;' >[마지막]</a></li>";	
		}		
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// === #131. 페이징 처리되어진 후 특정 글제목을 클릭하여 상세내용을 본 이후
	      //           사용자가 "검색된결과목록보기" 버튼을 클릭했을때 돌아갈 페이지를 알려주기 위해
	      //           현재 페이지 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		//System.out.println(" 확인용(list.action) goBackURL " + goBackURL);
		/*
		  확인용(list.action) goBackURL /list.action
		  확인용(list.action) goBackURL /list.action?searchType=&searchWord=&currentShowPageNo=5
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=java
		  확인용(list.action) goBackURL /list.action?searchType=subject&searchWord=정화&currentShowPageNo=3 
		 */
		
		mav.addObject("goBackURL", goBackURL);
		
		/////////////////////////////////////////////////////////////// ///////////////////////////////////////////////////
		mav.addObject("totalCount", totalCount); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("currentShowPageNo", currentShowPageNo); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		mav.addObject("sizePerPage", sizePerPage); //  페이징 처리시 보여주는 순번 공식을 위해 값을 넘겨준다.
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		mav.setViewName("tiles1/approval/allDocList.tiles");
		
		return mav;
	}
	
	@ResponseBody
	@PostMapping(value="/approval/singImfRegisterJSON.kedai", produces="text/plain;charset=UTF-8")
	public String singImfRegisterJSON(MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = mrequest.getFile("attach"); // 폼의 'name' 값과 일치해야 함
		int n = 0;
		
		System.out.println("확인용~~" + attach);
		
		if (attach != null && !attach.isEmpty()) { // 첨부파일이 있는 경우
		
			// WAS 의 webapp 의 절대경로 알아오기
			HttpSession session = mrequest.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			String loginId = loginuser.getEmpid();
			String root = session.getServletContext().getRealPath("/"); 
			String path = root+"resources"+File.separator+"files"+File.separator+"doc_attach_file";
			
			File directory = new File(path);
			if (!directory.exists()) {
			    directory.mkdirs(); // 폴더가 없으면 생성
			}
			
			String setSignImgname = loginuser.getName() + loginuser.getJob_name();	
		    // path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.
		      
		    System.out.println("~~~~ 확인용 업로드 path => " + path);
		    //~~~~ 확인용 path => C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\board\resources\doc_attach_file
		    // resources에 들어가면 doc_attach_file폴더가 아직 생성되지 않았다. 아래와 같이 생성해준다.
		    
		 // 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
		 	String newFileName = ""; // WAS(톰캣)의 디스크에 저장될 파일명
		 	byte[] bytes = null;     // 첨부파일의 내용물을 담는 것
		 	
		 	try {
				bytes = attach.getBytes(); 
				
				String originalFilename = attach.getOriginalFilename(); // 첨부파일명의 원래 파일명
		        String extension = originalFilename.substring(originalFilename.lastIndexOf('.')); // 파일 확장자 추출
		        newFileName = setSignImgname + extension; // 새 파일명 생성
				
		        String uploadedFilePath = fileManager.doFileUpload(bytes, newFileName, path); // 첨부되어진 파일을 업로드
		        System.out.println("파일이 업로드되었습니다: " + uploadedFilePath);
		        
		        Map<String, String> paraMap = new HashMap<>();
		        paraMap.put("loginId", loginId);
		        paraMap.put("newFileName", newFileName);
		        
		        n = service.updateSignImg(paraMap);
				
			} catch (Exception e) {
				e.printStackTrace();
				n=0;
			}
		}// end of if (attach != null && !attach.isEmpty())------------------ 
		JSONObject jsonObj = new JSONObject();
		
		jsonObj.put("result", n);
		
        return jsonObj.toString(); 
		
	}
	
	@GetMapping(value="/approval/singImgEnd.kedai")
	public String singImgEnd(ModelAndView mav, HttpServletRequest request ) {
	      
		return "redirect:/approval/main.kedai"; // 메인 화면으로 돌아가기
	    //  /WEB-INF/views/tiles1/email/emailWrite_done.jsp 페이지를 만들어야 한다.
	}	
	
	
	 /*
    @ResponseBody 란?
	  메소드에 @ResponseBody Annotation이 되어 있으면 return 되는 값은 View 단 페이지를 통해서 출력되는 것이 아니라 
	 return 되어지는 값 그 자체를 웹브라우저에 바로 직접 쓰여지게 하는 것이다. 일반적으로 JSON 값을 Return 할때 많이 사용된다.
	 
	  >>> 스프링에서 json 또는 gson을 사용한 ajax 구현시 데이터를 화면에 출력해 줄때 한글로 된 데이터가 '?'로 출력되어 한글이 깨지는 현상이 있다. 
               이것을 해결하는 방법은 @RequestMapping 어노테이션의 속성 중 produces="text/plain;charset=UTF-8" 를 사용하면 
               응답 페이지에 대한 UTF-8 인코딩이 가능하여 한글 깨짐을 방지 할 수 있다. <<< 
  */ 
	
	/*@ResponseBody
	@PostMapping(value="/approval/selectdateJSON.kedai",  produces="text/plain;charset=UTF-8")
	public String selectdateJSON(HttpServletRequest request ){
				// @RequestParam은 request.getParameter()와 같은 것이다. defaultValue는 파라미터의 초기값을 설정해 줄 수 있는 것을 말한다. 위의 내용은 null대신 ""을 설정한 것이다. 
				//  form태그의 name값을 꼭 String 이름 이런 식으로 넣어주어야 한다.
		
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
	

		// 본인을 제외한 모든 사원의 정보 가져오기 - 부서번호가 없는 대표이사가 있기 때문에 dept_code도 같이 paraMap에 담는다.
		List<Map<String,String>> deptEmpList = service.deptEmpList(paraMap);
		
		JSONArray jsonArr = new JSONArray();
		if(deptEmpList != null) {
			for(Map<String,String> map : deptEmpList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("empid", map.get("empid"));
				jsonObj.put("name", map.get("name"));
				jsonObj.put("fk_dept_code", map.get("fk_dept_code"));
				jsonObj.put("dept_name", map.get("dept_name"));
				jsonObj.put("job_code", map.get("job_code"));
				jsonObj.put("job_name", map.get("job_name"));

				jsonArr.put(jsonObj);
			}// end of for---------------
			
		//	System.out.println(jsonArr.toString());
			
		}
		
		return jsonArr.toString();
		
	}*/
	
	
}