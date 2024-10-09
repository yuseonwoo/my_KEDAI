package com.spring.app.company.controller;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.app.common.AES256;
import com.spring.app.common.FileManager;
import com.spring.app.common.MyUtil;
import com.spring.app.company.service.CompanyService;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

import jdk.nashorn.api.scripting.JSObject;

@Controller
public class CompanyController {

	@Autowired
	private CompanyService service;

	@Autowired
	private AES256 aes256;

	@Autowired
	private FileManager fileManager;

	@Autowired
	private ObjectMapper objectMapper;

	// 거래처 사업자등록번호 이미 있는지 중복확인
	@ResponseBody
	@PostMapping(value = "/partnerNoCheck.kedai", produces = "text/plain;charset=UTF-8")
	public String partnerNoDuplicateCheck(HttpServletRequest request) {

		String partner_no = request.getParameter("partner_no");
		// System.out.println("확인용 partner_no : " + partner_no);

		String searchPartnerNo = service.partnerNoDuplicateCheck(partner_no);

		boolean isExists = false;

		if (searchPartnerNo != null) {
			isExists = true;
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isExists", isExists);

		return jsonObj.toString();

	} // end of public String
		// partnerNoDuplicateCheck()--------------------------------------

	// 거래처 정보 등록하기 시작
	@GetMapping(value = "/othercom_register.kedai") // http://localhost:9099/KEDAI/othercom_list.kedai
	public ModelAndView other_comRegister(ModelAndView mav) {

		mav.setViewName("tiles1/company/othercom_register.tiles");

		return mav;
	}

	// 거래처 정보 등록하기 넘겨주기
	@PostMapping("othercom_register.kedai")
	public ModelAndView othercomRegister_submit(PartnerVO partvo, @RequestParam("is_modify") Boolean isModify,
			ModelAndView mav, MultipartHttpServletRequest mrequest) {

		// 이미지파일 업로드
		imageFileUpload(partvo, mrequest);

		try {
			int n = (isModify != true) ? service.othercomRegister_submit(partvo) // 등록 때
					: service.othercomModify_submit(partvo); // 수정
			if (n == 1) {
				setModelView(mav, "거래처가 정상적으로 " + ((isModify != true) ? "등록" : "수정") + "되었습니다!",
						mrequest.getContextPath() + "/othercom_list.kedai");
			}
		} catch (Exception e) {
			setModelView(mav, "거래처 " + ((isModify != true) ? "등록" : "수정") + "을 실패하였습니다.", "javascript:history.back()");
		}

		return mav;
	}

	private void setModelView(ModelAndView mav, String message, String loc) {
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		mav.setViewName("msg");
	}

	private void imageFileUpload(PartnerVO partvo, MultipartHttpServletRequest mrequest) {
		MultipartFile attach = partvo.getAttach();

		String imgfilename = "";
		String originalFilename = "";

		if (attach != null) { // 첨부파일이 있는 경우

			// WAS의 webapp 의 절대 경로 알아오기
			String root = mrequest.getSession().getServletContext().getRealPath("/");
			
			//String path = root+"resources"+File.separator+"files"+File.separator+"company";
			// System.out.println(root);
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\

			String path = service.getPartnerImagePath(root);

			// 파일 첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 업로드
			imgfilename = ""; // WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null; // 첨부파일의 내용물을 담는 것

			try {
				bytes = attach.getBytes(); // 첨부파일의 내용물을 읽어오는 것

				originalFilename = attach.getOriginalFilename(); // 첨부파일명의 파일명
				/* System.out.println("originalFilename"+originalFilename); */
				imgfilename = fileManager.doFileUpload(bytes, originalFilename, path);
				/* System.out.println("imgfilename" +imgfilename); */
				partvo.setImgfilename(imgfilename);
				partvo.setOriginalfilename(originalFilename);
			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end of if(attach != null)
			// {}--------------------------------------------------------------
	}

	// end of public ModelAndView othercomRegister_submit(ModelAndView mav,
	// PartnerVO partvo, MultipartHttpServletRequest mrequest)
	// {}-----------------------------------------------------

	// 거래처 수정하기
	@GetMapping(value = "/othercom_modify.kedai") // http://localhost:9099/KEDAI/othercom_list.kedai
	public ModelAndView other_comModify(@RequestParam("partner_no") String partnerNo, ModelAndView mav) {
		PartnerVO partnerVO = service.otherCom_get_select(partnerNo);

		mav.setViewName("tiles1/company/othercom_register.tiles");
		mav.addObject("partvo", partnerVO);

		return mav;
	}

	// 거래처 정보 조회하기 #######################################################
	@RequestMapping(value = "/othercom_list.kedai")
	public ModelAndView otherCom_list_select(ModelAndView mav, HttpServletRequest request) {

		List<PartnerVO> partnervoList = service.otherCom_list_select();
		// System.out.println("partnervoList : " + partnervoList);
		/*
		 * for(PartnerVO partvo : partnervoList) { System.out.println("partner_No : " +
		 * partvo.getPartner_no()); System.out.println("PARTNER_TYPE : " +
		 * partvo.getPartner_type()); System.out.println("PARTNER_NAME : " +
		 * partvo.getPartner_name()); System.out.println("PARTNER_URL : " +
		 * partvo.getPartner_url()); System.out.println("PARTNER_POSTCODE : " +
		 * partvo.getPartner_postcode()); System.out.println("PARTNER_ADDRESS : " +
		 * partvo.getPartner_address()); System.out.println("PARTNER_DETAILADDRESS : " +
		 * partvo.getPartner_detailaddress());
		 * System.out.println("PARTNER_EXTRAADDRESS : " +
		 * partvo.getPartner_extraaddress()); System.out.println("PART_EMP_NAME : " +
		 * partvo.getPart_emp_name()); System.out.println("PART_EMP_TEL : " +
		 * partvo.getPart_emp_tel()); System.out.println("PART_EMP_EMAIL : " +
		 * partvo.getPart_emp_email()); System.out.println("PART_EMP_DEPT : " +
		 * partvo.getPart_emp_dept()); System.out.println("ORIGINALFILENAME : " +
		 * partvo.getOriginalfilename()); System.out.println("PART_EMP_RANK : " +
		 * partvo.getPart_emp_rank()); }
		 */

		mav.addObject("partnervoList", partnervoList);

		mav.setViewName("tiles1/company/othercom_list.tiles");

		return mav;
	}

	// 거래처 상세보기 팝업 어떤것 클릭했는지 알아오기
	
	@ResponseBody
	@GetMapping(value = "/partnerPopupClick.kedai", produces = "text/plain;charset=UTF-8")
	public String otherCom_get_select(String partner_no) throws JsonProcessingException {

		PartnerVO partnerVO = service.otherCom_get_select(partner_no);

		String jsonString = objectMapper.writeValueAsString(partnerVO); // toObject => PartnerVO partnerVO =
																		// objectMapper.readValue(jsonString,
																		// PartnerVO.class)

		return jsonString;
	} // end of public String partnerPopupClick(HttpServletRequest request) {
	/*
	// 거래처 상세보기 팝업 어떤것 클릭했는지 알아오기
	@ResponseBody
	@GetMapping(value = "/partnerPopupClick.kedai", produces = "text/plain;charset=UTF-8")
	public String partnerPopupClick(PartnerVO partvo) {

		List<PartnerVO> partnerList = service.partnerPopupClick(partvo);

		JSONArray jsonArr = new JSONArray();

		if (partnerList != null) {

			for (PartnerVO pvo : partnerList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("partner_no", pvo.getPartner_no());
				jsonObj.put("partner_name", pvo.getPartner_name());
				jsonObj.put("partner_type", pvo.getPartner_type());
				jsonObj.put("partner_url", pvo.getPartner_url());
				jsonObj.put("partner_postcode", pvo.getPartner_postcode());
				jsonObj.put("partner_address", pvo.getPartner_address());
				jsonObj.put("partner_detailaddress", pvo.getPartner_detailaddress());
				jsonObj.put("partner_extraaddress", pvo.getPartner_extraaddress());
				jsonObj.put("imgfilename", pvo.getImgfilename());
				jsonObj.put("originalfilename", pvo.getOriginalfilename());
				jsonObj.put("part_emp_name", pvo.getPart_emp_name());
				jsonObj.put("part_emp_tel", pvo.getPart_emp_tel());
				jsonObj.put("part_emp_email", pvo.getPart_emp_email());
				jsonObj.put("part_emp_dept", pvo.getPart_emp_dept());
				jsonObj.put("part_emp_rank", pvo.getPart_emp_rank());

				jsonArr.put(jsonObj);
			} // end of for()------------------------------------------------

		}

		String jsonString = jsonArr.toString();

		return jsonString;

	} // end of public String partnerPopupClick(HttpServletRequest request) {
*/
	// 거래처 삭제하기 //
	@ResponseBody
	@PostMapping(value = "/company/delPartner_com.kedai", produces = "text/plain;charset=UTF-8")
	public String delPartner_com(HttpServletRequest request) throws Throwable {

		// WAS의 webapp 의 절대 경로 알아오기
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		// System.out.println(root);
		// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\

		String partner_no = request.getParameter("partner_no");
		// System.out.println("partner_no : " + partner_no);
		int n = service.delPartnerNo(partner_no, rootPath);
		// System.out.println("n : " + n );
		JSONObject jsObj = new JSONObject();

		jsObj.put("n", n);

		return jsObj.toString();

	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	// 거래처 목록 보여주기 (여기서 페이징 처리 && 검색
	@GetMapping("/othercom_list.kedai")
	public ModelAndView empmanager_partnerComList(HttpServletRequest request, ModelAndView mav) {
		
		List<PartnerVO> partnerList = null;
		
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
		int sizePerPage = 6; 	   // 한 페이지 당 보여줄 게시물 건수
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
        
        partnerList = service.PartnerListSearch_withPaging(paraMap);
		
		
        mav.addObject("partnerList", partnerList);
		// System.out.println("");
        // 검색 시 검색조건 및 검색어 값 유지시키기	
		if("partner_name".equals(searchType) ||
		   "partner_type".equals(searchType) ||
		   "part_emp_name".equals(searchType)) {
			mav.addObject("paraMap" , paraMap);
		}
		
		// 페이지바 만들기
        int blockSize = 3; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
        int loop = 1;      // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
        int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1; 
        // 공식 
        // 첫번째 블럭의 페이지번호 시작값(pageNo)은    1 => ((1-1)/5)*5+1  => 1
        // 두번째 블럭의 페이지번호 시작값(pageNo)은    6 => ((6-1)/5)*5+1  => 6
        // 세번째 블럭의 페이지번호 시작값(pageNo)은  11 => ((11-1)/5)*5+1 => 11
        
        String pageBar = "<ul style='list-style: none;'>";
        String url = "othercom_list.kedai";
        
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
        
        // 특정 글제목을 클릭하여 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 알려주기 위해 현재 페이지 주소를 뷰단으로 넘겨준다.
        String goBackURL = MyUtil.getCurrentURL(request);
        mav.addObject("goBackURL", goBackURL);
        
        // 페이징처리 시 순번을 나타내기 위한 것
        mav.addObject("totalCount", totalCount);
        // System.out.println("1111totalCount : " + totalCount);
        mav.addObject("currentShowPageNo", currentShowPageNo);
        mav.addObject("sizePerPage", sizePerPage);
        
        mav.setViewName("tiles1/company/othercom_list.tiles");
        
		return mav;
		
	}
	
	// 검색어 입력 시 자동글 완성하기
	@ResponseBody
	@GetMapping(value="/company/wordSearchShowJSON.kedai", produces="text/plain;charset=UTF-8")
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
	
	
	
}
