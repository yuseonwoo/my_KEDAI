package com.spring.app.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.Calendar;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.app.board.service.CommunityService;
import com.spring.app.common.FileManager;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.BoardVO;
import com.spring.app.domain.CategoryVO;
import com.spring.app.domain.CommentVO;
import com.spring.app.domain.CommunityCategoryVO;
import com.spring.app.domain.CommunityFileVO;
import com.spring.app.domain.CommunityVO;
import com.spring.app.domain.MemberVO;

@Controller
public class CommunityController {

	@Autowired
	private CommunityService service;
	
	@Autowired
	private FileManager fileManager;
	
	// 커뮤니티 글 등록하는 페이지 이동
	@GetMapping("/community/add.kedai")
	public ModelAndView add(ModelAndView mav) {
		
		List<CommunityCategoryVO> categoryList = service.category_select();
	
		mav.addObject("categoryList", categoryList);
		
		mav.setViewName("tiles1/community/add.tiles");	
		
		return mav;
	}
	
	// 커뮤니티 글 등록하기
	@ResponseBody
	@PostMapping(value="/community/add.kedai", produces="text/plain;charset=UTF-8")
	public String add(MultipartHttpServletRequest mrequest, CommunityVO cvo) {
		
		List<MultipartFile> fileList = mrequest.getFiles("file_arr");
		
		// WAS 의 webapp 의 절대경로 알아오기
		HttpSession session = mrequest.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root+"resources"+File.separator+"files"+File.separator+"community_attach_file";
		
		File dir = new File(path);
		if(!dir.exists()) { // community_attach_file 이라는 폴더가 없다면 생성하기
			dir.mkdirs();
		}
		
		String[] arr_attachOrgFilename = null; // 기존 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachNewFilename = null; // 새로운 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachFilesize = null;    // 첨부파일명들의 크기를 기록하기 위한 용도
		
		if(fileList != null && fileList.size() > 0) {
			arr_attachOrgFilename = new String[fileList.size()];
			arr_attachNewFilename = new String[fileList.size()];
			arr_attachFilesize = new String[fileList.size()];
			
			for(int i=0; i<fileList.size(); i++) {
				MultipartFile mtfile = fileList.get(i);
			//	System.out.println("파일명 : " + mtfile.getOriginalFilename() + " / 파일크기 : " + mtfile.getSize());
				/*
					파일명 : berkelekle단가라포인트03.jpg / 파일크기 : 57641
					파일명 : berkelekle덩크04.jpg / 파일크기 : 41931
					파일명 : berkelekle트랜디05.jpg / 파일크기 : 44338
				*/
				
				String orgFilename = mtfile.getOriginalFilename();
				
				String newFilename = orgFilename.substring(0, orgFilename.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기
				newFilename += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); // 년월일시분초
    			newFilename += System.nanoTime(); // 나노세컨즈(nanoseconds)
    			newFilename += orgFilename.substring(orgFilename.lastIndexOf(".")); // 확장자 붙이기
				
    			try {
    				File attachFile = new File(path+File.separator+newFilename);
					mtfile.transferTo(attachFile); // 파일을 업로드해주는 것이다.
					
					arr_attachOrgFilename[i] = mtfile.getOriginalFilename(); // 배열 속에 첨부파일명들을 기록한다.
					arr_attachNewFilename[i] = newFilename;
					arr_attachFilesize[i] = Long.toString(mtfile.getSize());
    				
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			} // end of for ----------
			
		} // end of if ----------
		
		// 글번호 채번해오기
		int community_seq = service.getCseqOfCommunity();
		
		String category_name = mrequest.getParameter("category_name");
		String fk_category_code = "";
		
		if(category_name.equals("동호회")) {
			fk_category_code = "1";
		}
		else if(category_name.equals("건의함")) {
			fk_category_code = "2";
		}
		else if(category_name.equals("사내소식")) {
			fk_category_code = "3";
		}
		
		cvo.setCommunity_seq(String.valueOf(community_seq));
		cvo.setFk_category_code(fk_category_code);
		
		int result = 0;
		int n = service.add(cvo);
		
		if(n == 1) {
			result = 1;
		}
		
		if(n == 1 && fileList != null && fileList.size() > 0) {
			int cnt = 0;
			
			for(int i=0; i<fileList.size(); i++) {
				Map<String, Object> paraMap = new HashMap<>();
				
				paraMap.put("fk_community_seq", community_seq); 
				paraMap.put("orgfilename", arr_attachOrgFilename[i]); 
				paraMap.put("filename", arr_attachNewFilename[i]); 
				paraMap.put("filesize", arr_attachFilesize[i]); 
				
				int attach_insert_result = service.community_attachfile_insert(paraMap);
				
				if(attach_insert_result == 1) {
        			cnt++;
        		}
				
			} // end of for ----------
			
			if(cnt == fileList.size()) { // insert 가 성공되어지면 cnt 와 추가 이미지 파일의 갯수가 같아진다.
        		result = 1;
        	}
			
		} // end of if ----------
		
		JSONObject jsonObj = new JSONObject();
	
		try {
			jsonObj.put("result", result); // 성공된 경우
			jsonObj.put("fk_empid", cvo.getFk_empid());
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("result", result); // 실패된 경우
		}
		
		if(arr_attachOrgFilename != null) {
			for(String attachFilename : arr_attachOrgFilename) {
				try {
					fileManager.doFileDelete(attachFilename, path);
	            } catch (Exception e) {
	            	e.printStackTrace();
	            }
			} // end of for ----------
		}
	
		return jsonObj.toString();
	}
	
	// 커뮤니티 글 등록 후 포인트 증가시키기
	@GetMapping("/community/addEnd.kedai")
	public ModelAndView pointPlus_addEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {
		
		String fk_empid = request.getParameter("fk_empid");
		
		paraMap.put("empid", fk_empid);
		paraMap.put("point", "100");
		
		mav.setViewName("redirect:/community/list.kedai");
		
		return mav;
	}
	
	// 게시판 목록 보여주기
	@RequestMapping("/community/list.kedai")
	public ModelAndView empmanager_list(HttpServletRequest request, ModelAndView mav) {
		
		List<CommunityVO> communityList = null;
		
		// 글조회수(readCount)증가 => 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다. => session 을 사용하여 처리하기
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		// 페이징 처리를 한 검색어가 있는 전체 글목록 보여주기
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
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
		
		int totalCount = 0; 	   // 총 게시물 건수
		int sizePerPage = 5; 	   // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정 
		int totalPage = 0; 		   // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		
		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalCount(paraMap);
		
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
		
		communityList = service.communityListSearch_withPaging(paraMap);
		
		mav.addObject("communityList", communityList);
		
		// 검색 시 검색조건 및 검색어 값 유지시키기
		if("subject".equals(searchType) ||
		   "content".equals(searchType)	||
		   "subject_content".equals(searchType) ||
		   "name".equals(searchType)) {
			mav.addObject("paraMap", paraMap);
		}
		
		// 페이지바 만들기
		int blockSize = 5; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1;      // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1; 
        // 공식 
        // 첫번째 블럭의 페이지번호 시작값(pageNo)은    1 => ((1-1)/5)*5+1  => 1
        // 두번째 블럭의 페이지번호 시작값(pageNo)은    6 => ((6-1)/5)*5+1  => 6
        // 세번째 블럭의 페이지번호 시작값(pageNo)은  11 => ((11-1)/5)*5+1 => 11
		
		String pageBar = "<ul style='list-style: none;'>";
        String url = "list.kedai";
		
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
        
        mav.addObject("pageBar", pageBar);
        
        // 특정 글제목을 클릭하여 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 알려주기 위해 현재 페이지 주소를 뷰단으로 넘겨준다.
        String goBackURL = MyUtil.getCurrentURL(request);
        mav.addObject("goBackURL", goBackURL);
        
        // 페이징처리 시 순번을 나타내기 위한 것
        mav.addObject("totalCount", totalCount);
        mav.addObject("currentShowPageNo", currentShowPageNo);
        mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("tiles1/community/list.tiles");
		
		return mav;
	}
	
	// 검색어 입력 시 자동글 완성하기
	@ResponseBody
	@GetMapping(value="/community/wordSearchShow.kedai", produces="text/plain;charset=UTF-8")
	public String wordSearchShow(HttpServletRequest request) {
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		
		List<String> wordList = service.wordSearchShow(paraMap);
		
		JSONArray jsonArr = new JSONArray(); // []
		
		if(wordList != null) {
			for(String word : wordList) {
				JSONObject jsonObj = new JSONObject(); // {}
				
				jsonObj.put("word", word);
			
				jsonArr.put(jsonObj); // [{}, {}, {}]
			} // end of for ----------
		}
		
		return jsonArr.toString();
	}
	
	// 글 1개를 보여주는 페이지 요청
	@RequestMapping("/community/view.kedai")
	public ModelAndView view(ModelAndView mav, HttpServletRequest request) {
		
		String community_seq = "";
		String goBackURL = "";
		String searchType = "";
		String searchWord = "";
		
		// redirect 되어서 넘어온 데이터가 있는지 꺼내어 와본다. => /community/view_2.kedai 에서 보내주었다.
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		
		if(inputFlashMap != null) {  // redirect 되어서 넘어온 데이터가 있는 경우
			@SuppressWarnings("unchecked")
			Map<String, String> redirect_map = (Map<String, String>)inputFlashMap.get("redirect_map");
			// "redirect_map" 값은  /community/view_2.kedai 에서  redirectAttr.addFlashAttribute("키", 밸류값); 을 할 때 준 "키" 이다. 
		
			community_seq = redirect_map.get("community_seq");
			
			// 이전글제목, 다음글제목 보기
			searchType = redirect_map.get("searchType");
			try { 
				// sendredirect 되어서 넘어온 데이터를 한글로 복구한 후 mapper 로 넘겨줘야 한다.
				searchWord = URLDecoder.decode(redirect_map.get("searchWord"), "UTF-8");
				goBackURL = URLDecoder.decode(redirect_map.get("goBackURL"), "UTF-8");
						
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		else { // redirect 되어서 넘어온 데이터가 아닌 경우 => sendRedirect 하지않고 직접 넘어온 경우
			community_seq = request.getParameter("community_seq"); // 조회하고자 하는 글번호 받아오기
			goBackURL = request.getParameter("goBackURL");         // 특정글을 조회한 후 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 만들기 위한 것
			
			// 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물 내의 이전글과 다음글이 나오도록 하기 위한 것
			searchType = request.getParameter("searchType");
			searchWord = request.getParameter("searchWord");
			
			if(searchType == null) { // 검색조건이 없는 경우 원복한다.
				searchType = "";
			}
			
			if(searchWord == null) { // 검색어가 없는 경우 원복한다.
				searchWord = "";
			}
		}
		
		mav.addObject("goBackURL", goBackURL);
		
		try {
			Integer.parseInt(community_seq);
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			String login_empid = "";
			if(loginuser != null) {
				login_empid = loginuser.getEmpid();
			}
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("community_seq", community_seq);
			paraMap.put("login_empid", login_empid);
			
			// 글목록에서 검색되어진 글내용일 경우 이전글제목, 다음글제목은 검색되어진 결과물 내의 이전글과 다음글이 나오도록 하기 위한 것
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);
			
			// 웹브라우저에서 페이지 새로고침(F5)을 했을 때 select(글 1개 조회)만 해주고 DML문(글 조회수 증가인 update문)은 실행되지 않도록 하기
			CommunityVO cvo = null;
			
			if("yes".equals((String)session.getAttribute("readCountPermission"))) { // 글목록보기인 /community/list.kedai 페이지를 클릭한 다음에 특정글을 조회해온 경우
				cvo = service.getView(paraMap); // 글 조회수 증가와 함께 글 1개를 조회해오는 것
				
				session.removeAttribute("readCountPermission"); // session 에 저장된 readCountPermission 을 삭제
			}
			else { // 글목록에서 특정 글제목을 클릭하여 본 상태에서 웹브라우저에서 새로고침(F5)을 클릭한 경우
				cvo = service.getView_noIncrease_readCount(paraMap); // 글 조회수 증가는 없고 단순히  글 1개만 조회해오는 것
				
				if(cvo == null) {
					mav.setViewName("redirect:/community/list.kedai");
					return mav;
				}
			}
			
			mav.addObject("cvo", cvo);
			mav.addObject("paraMap", paraMap); // 이전글제목, 다음글제목 보기
			
			mav.setViewName("tiles1/community/view.tiles");
			
		} catch (NumberFormatException e) {
			mav.setViewName("redirect:/community/list.kedai");
		}
		
		return mav;
	}
	
	// view.jsp 에서  "POST" 방식으로 보내준 것
	@PostMapping("/community/view_2.kedai")
	public ModelAndView view_2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {
		
		// 조회하고자하는 글번호
		String community_seq = request.getParameter("community_seq");
		
		// 이전글제목, 다음글제목 보기
		String goBackURL = request.getParameter("goBackURL");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		// 보내야할 데이터에 한글이 포함되는 경우
		try {
			searchWord = URLEncoder.encode(searchWord, "UTF-8");
			goBackURL = URLEncoder.encode(goBackURL, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		// redirect(GET 방식) 시
		// 데이터를 넘길때 GET 방식이 아닌 POST 방식'처럼'(POST 방식이 아닌) 데이터를 넘기려면 RedirectAttributes 를 사용
		Map<String, String> redirect_map = new HashMap<>();
		redirect_map.put("community_seq", community_seq);
		redirect_map.put("goBackURL", goBackURL);
		redirect_map.put("searchType", searchType);
		redirect_map.put("searchWord", searchWord);
		
		redirectAttr.addFlashAttribute("redirect_map", redirect_map);
		// .addFlashAttribute() 는 오로지 1개의 데이터만 담을 수 있으므로 여러개의 데이터를 담으려면 Map 사용
		// 키값을 "redirect_map" 으로 담아서 "redirect:/community/view.kedai" 으로 보내는 것
		
		mav.setViewName("redirect:/community/view.kedai");
		
		return mav;
	}
	
	// 첨부파일명 조회하기
	@ResponseBody
	@GetMapping(value="/community/getOrgFilenameJSON.kedai", produces="text/plain;charset=UTF-8")
	public String getOrgFilenameJSON(HttpServletRequest request) {
		
		String fk_community_seq = request.getParameter("fk_community_seq");
		
		List<CommunityFileVO> attachFileList = service.getAttachFileList(fk_community_seq);
		
		JSONArray jsonArr = new JSONArray(); // []
		
		if(attachFileList != null) {
			for(CommunityFileVO attachFile : attachFileList) {
				JSONObject jsonObj = new JSONObject(); // {}
				
				jsonObj.put("orgfileName", attachFile.getOrgfilename());
		
				jsonArr.put(jsonObj); // [{}, {}, {}]	
			} // end of for ----------
			
		} // end of if ----------
		
		return jsonArr.toString();
	}
	
	// 첨부파일 다운로드 받기
	@GetMapping("/community/download.kedai")
	public void requiredLogin_download(HttpServletRequest request, HttpServletResponse response) {
		
		// 첨부파일이 있는 글번호
		String fk_community_seq = request.getParameter("fk_community_seq");
		String orgfilename = request.getParameter("orgfilename");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_community_seq", fk_community_seq);
		paraMap.put("orgfilename", orgfilename);
		
		// html 이 출력될 때 한글이 깨지지 않고 제대로 나올 수 있도록 설정하기
		response.setContentType("text/html; charset=UTF-8");
		
		PrintWriter out = null; // out 은 웹브라우저에 기술하는 대상체
		
		try {
			Integer.parseInt(fk_community_seq);
			CommunityFileVO cfvo = service.getFilename(paraMap);
			
			if(cfvo == null || (cfvo != null && cfvo.getOrgfilename() == null)) { // DB 에서 파일을 삭제한 경우
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일이 없으므로 파일다운로드가 불가합니다.'); history.back();</script>");
				return;
			}
			else { // 정상적으로 파일을 다운로드를 할 경우
				String fileName = cfvo.getFilename();
				String orgFilename = cfvo.getOrgfilename();
				
				// WAS 의 webapp 의 절대경로 알아오기
				HttpSession session = request.getSession();
				String root = session.getServletContext().getRealPath("/"); 
				// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\
				
				String path = root+"resources"+File.separator+"files"+File.separator+"community_attach_file";
				// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files\community_attach_file
				
				boolean flag = false;
				flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				// file 다운로드 성공시 flag 는 true, 실패시 flag 는 false
				
				if(!flag) {
					out = response.getWriter();
					out.println("<script type='text/javascript'>alert('파일다운로드가 실패하였습니다.'); history.back();</script>");
				}
				
			}
			
		} catch (NumberFormatException | IOException e) { // 숫자가 아닌 경우 => "GET" 방식으로 조작한 경우
			try {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e2) {
				e.printStackTrace();
			}
		}
		
	}
	
	// 커뮤니티 글 수정하는 페이지 이동
	@GetMapping("/community/edit.kedai")
	public ModelAndView requiredLogin_edit(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 수정하고자하는 글번호
		String community_seq = request.getParameter("community_seq");
		String message = "";
		
		try {
			Integer.parseInt(community_seq);
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("community_seq", community_seq);
			
			CommunityVO cvo = service.getView_noIncrease_readCount(paraMap); // 글 조회수 증가는 없고 단순히  글 1개만 조회해오는 것
			
			if(cvo == null) {
				message = "글 수정이 불가합니다.";
			}
			else {
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
				
				if(!loginuser.getEmpid().equals(cvo.getFk_empid())){ // 로그인한 사용자와 작성자가 다른 경우(다른 사람의 글을 수정하려고 하는 경우)
					message = "다른 사용자의 글은 수정이 불가합니다.";
				}
				else { // 자신의 글을 수정하려고 하는 경우
					List<CommunityCategoryVO> categoryList = service.category_select();
					
					mav.addObject("categoryList", categoryList);
					mav.addObject("cvo", cvo);
					
					mav.setViewName("tiles1/community/edit.tiles"); 
					
					return mav;
				}
			}
			
		} catch (NumberFormatException e) { // "GET" 방식으로 문자를 입력한 경우
			message = "글 수정이 불가합니다.";
		}
		
		String loc = "javascript:history.back()"; // 이전 페이지로 이동
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg"); 
		
		return mav;
	}
	
	// 커뮤니티 글 수정하기
	@ResponseBody
	@PostMapping(value="/community/editEnd.kedai", produces="text/plain;charset=UTF-8")
	public String editEnd(MultipartHttpServletRequest mrequest, CommunityVO cvo) {
		
		List<MultipartFile> fileList = mrequest.getFiles("file_arr");
		
		// WAS 의 webapp 의 절대경로 알아오기
		HttpSession session = mrequest.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root+"resources"+File.separator+"files"+File.separator+"community_attach_file";				
		
		String[] arr_attachOrgFilename = null; // 기존 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachNewFilename = null; // 새로운 첨부파일명들을 기록하기 위한 용도
		String[] arr_attachFilesize = null;    // 첨부파일명들의 크기를 기록하기 위한 용도
		
		// 기존 첨부파일 삭제 후 등록하기 
		if(fileList != null && fileList.size() > 0) { // 첨부파일이 존재하는 경우 
			String fk_community_seq = mrequest.getParameter("community_seq");
			
			List<CommunityFileVO> attachFileList = service.getAttachFileList(fk_community_seq);
			
			if(attachFileList != null) {
				for(CommunityFileVO attachFile : attachFileList) {
					String filename = attachFile.getFilename();
				
					try {
						fileManager.doFileDelete(filename, path); // 운영경로에 저장되어 있는 기존 첨부파일 삭제하기
		            } catch (Exception e) {
		            	e.printStackTrace();
		            }
					
				} // end of for ----------
				
				// 커뮤니티 첨부파일 삭제하기
				int attach_delete_result = service.community_attachfile_delete(fk_community_seq);
				
			} // end of if ----------
			
			arr_attachOrgFilename = new String[fileList.size()];
			arr_attachNewFilename = new String[fileList.size()];
			arr_attachFilesize = new String[fileList.size()];
			
			for(int i=0; i<fileList.size(); i++) {
				MultipartFile mtfile = fileList.get(i);
			//	System.out.println("파일명 : " + mtfile.getOriginalFilename() + " / 파일크기 : " + mtfile.getSize());
				/*
					파일명 : refrigerator_lg_normal_1.png / 파일크기 : 58141
					파일명 : refrigerator_lg_normal_2.png / 파일크기 : 342639
				*/
			
				String orgFilename = mtfile.getOriginalFilename();
				
				String newFilename = orgFilename.substring(0, orgFilename.lastIndexOf(".")); // 확장자를 뺀 파일명 알아오기
				newFilename += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); // 년월일시분초
    			newFilename += System.nanoTime(); // 나노세컨즈(nanoseconds)
    			newFilename += orgFilename.substring(orgFilename.lastIndexOf(".")); // 확장자 붙이기
				
    			try {
    				File attachFile = new File(path+File.separator+newFilename);
					mtfile.transferTo(attachFile); // 파일을 업로드해주는 것이다.
					
					arr_attachOrgFilename[i] = mtfile.getOriginalFilename(); // 배열 속에 첨부파일명들을 기록한다.
					arr_attachNewFilename[i] = newFilename;
					arr_attachFilesize[i] = Long.toString(mtfile.getSize());
    				
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			} // end of for ----------
			
		} //  end of if(fileList != null && fileList.size() > 0)
		
		String category_name = mrequest.getParameter("category_name");
		String fk_category_code = "";
		
		if(category_name.equals("동호회")) {
			fk_category_code = "1";
		}
		else if(category_name.equals("건의함")) {
			fk_category_code = "2";
		}
		else if(category_name.equals("사내소식")) {
			fk_category_code = "3";
		}
		
		cvo.setFk_category_code(fk_category_code);
		
		int result = 0;
		int n = service.edit(cvo);
		
		if(n == 1) {
			result = 1;
		}
	
		if(n == 1 && fileList != null && fileList.size() > 0) {
			int cnt = 0;
			
			for(int i=0; i<fileList.size(); i++) {
				Map<String, Object> paraMap = new HashMap<>();
				
				paraMap.put("fk_community_seq", cvo.getCommunity_seq()); 
				paraMap.put("orgfilename", arr_attachOrgFilename[i]); 
				paraMap.put("filename", arr_attachNewFilename[i]); 
				paraMap.put("filesize", arr_attachFilesize[i]); 
				
				int attach_update_result = service.community_attachfile_insert(paraMap);
				
				if(attach_update_result == 1) {
        			cnt++;
        		}
				
			} // end of for ----------
			
			if(cnt == fileList.size()) { // insert 가 성공되어지면 cnt 와 추가 이미지 파일의 갯수가 같아진다.
        		result = 1;
        	}
			
		} // end of if ----------

		JSONObject jsonObj = new JSONObject();
	
		try {
			jsonObj.put("result", result); // 성공된 경우
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put("result", result); // 실패된 경우
		}
		
		return jsonObj.toString();
	}
	
	// 커뮤니티  글 삭제하는 페이지 이동
	@GetMapping("/community/del.kedai")
	public ModelAndView requiredLogin_del(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		// 삭제하고자하는 글번호
		String community_seq = request.getParameter("community_seq");
		String message = "";
		
		try {
			Integer.parseInt(community_seq);
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("community_seq", community_seq);
			
			CommunityVO cvo = service.getView_noIncrease_readCount(paraMap); // 글 조회수 증가는 없고 단순히  글 1개만 조회해오는 것
			
			if(cvo == null) {
				message = "글 삭제가 불가합니다.";
			}
			else {
				HttpSession session = request.getSession();
				MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
				if(!loginuser.getEmpid().equals(cvo.getFk_empid())) {
					message = "다른 사용자의 글은 삭제가 불가합니다.";
				}
				else { // 자신의 글을 삭제하려고 하는 경우
					mav.addObject("cvo", cvo);
					
					mav.setViewName("tiles1/community/del.tiles");
					
					return mav;
				}
			}
			
		} catch (NumberFormatException e) {
			message = "글 삭제가 불가합니다.";
		}
		
		String loc = "javascript:history.back()"; // 이전 페이지로 이동
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}
	
	// 커뮤니티 글 삭제하기
	@PostMapping("/community/delEnd.kedai")
	public ModelAndView delEnd(ModelAndView mav, HttpServletRequest request) {
		
		// 삭제하고자하는 글번호
		String fk_community_seq = request.getParameter("community_seq");
		
		List<CommunityFileVO> attachFileList = service.getAttachFileList(fk_community_seq);
		
		// WAS 의 webapp 의 절대경로 알아오기
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root+"resources"+File.separator+"files"+File.separator+"community_attach_file";
		
		if(attachFileList != null) {
			for(CommunityFileVO attachFile : attachFileList) {
				String filename = attachFile.getFilename();
			
				try {
					fileManager.doFileDelete(filename, path); // 운영경로에 저장되어 있는 기존 첨부파일 삭제하기
	            } catch (Exception e) {
	            	e.printStackTrace();
	            }
				
			} // end of for ----------
			
		} // end of if ----------
		
		int n = service.del(fk_community_seq);
		
		if(n == 1) {
			mav.addObject("message", "글 삭제가 성공되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/community/list.kedai"); 
			
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	// 댓글쓰기(Ajax 로 처리)
	@ResponseBody
	@PostMapping(value="/community/addComment.kedai", produces="text/plain;charset=UTF-8")
	public String addComment(CommentVO commentvo) {
		
		int n = 0;
		try {
			n = service.addComment(commentvo);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		jsonObj.put("name", commentvo.getName());
		
		return jsonObj.toString();
	}
	
	// 댓글 내용들을 페이징 처리하기
	@ResponseBody
	@GetMapping(value="/community/commentList.kedai", produces="text/plain;charset=UTF-8")
	public String commentList(HttpServletRequest request) {
		
		String fk_community_seq = request.getParameter("fk_community_seq");
		String currentShowPageNo = request.getParameter("currentShowPageNo");
		
		if(currentShowPageNo == null) {
			currentShowPageNo = "1"; // default 로 1 페이지를 보여준다.
		}
		
		int sizePerPage = 5; // 한 페이지당 5개의 댓글을 보여준다.
		
		int startRno = ((Integer.parseInt(currentShowPageNo) - 1) * sizePerPage) + 1; // 시작 행번호 
        int endRno = startRno + sizePerPage - 1; // 끝 행번호
		
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("fk_community_seq", fk_community_seq);
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));
        
		List<CommentVO> commentList = service.getCommentList_Paging(paraMap);
		int totalCount = service.getCommentTotalCount(fk_community_seq); // 페이징처리 시 보여주는 순번을 나타내기 위한 것
		
		JSONArray jsonArr = new JSONArray(); // []
		
		if(commentList != null) {
			for(CommentVO commentvo : commentList) {
				JSONObject jsonObj = new JSONObject(); // {}
				
				jsonObj.put("comment_seq", commentvo.getComment_seq());
				jsonObj.put("fk_empid", commentvo.getFk_empid());
				
				jsonObj.put("name", commentvo.getName());
				jsonObj.put("nickname", commentvo.getNickname());
				jsonObj.put("content", commentvo.getContent());
				jsonObj.put("registerday", commentvo.getRegisterday());
				
				jsonObj.put("totalCount", totalCount);
				jsonObj.put("sizePerPage", sizePerPage);
				
				jsonArr.put(jsonObj);
			} // end of for ----------
		}
		
		return jsonArr.toString();
	}
	
	// 댓글 수정하기(Ajax 로 처리)
	@ResponseBody
	@PostMapping(value="/community/updateComment.kedai", produces="text/plain;charset=UTF-8")
	public String updateComment(HttpServletRequest request) {
		
		String comment_seq = request.getParameter("comment_seq");
		String content = request.getParameter("content");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("comment_seq", comment_seq);
		paraMap.put("content", content);
		
		int n = service.updateComment(paraMap);
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	// 댓글 삭제하기(Ajax 로 처리)
	@ResponseBody
	@PostMapping(value="/community/deleteComment.kedai", produces="text/plain;charset=UTF-8")
	public String deleteComment(HttpServletRequest request) {
		
		String comment_seq = request.getParameter("comment_seq");
		String fk_community_seq = request.getParameter("fk_community_seq");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("comment_seq", comment_seq);
		paraMap.put("fk_community_seq", fk_community_seq);
		
		int n = 0;
		try {
			n = service.deleteComment(paraMap);
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	// 좋아요 누르기
	@ResponseBody
	@GetMapping(value="/community/likeAdd.kedai", produces="text/plain;charset=UTF-8")
	public String likeAdd(HttpServletRequest request) {
		
		String fk_community_seq = request.getParameter("fk_community_seq");
		String fk_empid = request.getParameter("fk_empid");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_community_seq", fk_community_seq);
		paraMap.put("fk_empid", fk_empid);
		
		int n = service.likeAdd(paraMap);
		 
		// n => 1 이라면 정상투표, n => 0 이라면 중복투표
		// fk_empid 와 fk_community_seq 는 복합 primary key 이기 때문에 중복투표를 하게 된다면 insert 시 SQLException 이 발생 => SQLException 이 발생한 경우 n 은 0 이 되도록 한다.
		
		String msg = "";
		if(n == 1) {
			msg = fk_community_seq + "번 글에 좋아요를 누르셨습니다.";
			
		}
		else { 
			msg = "이미 좋아요를 클릭하셨기 때문에 두번 이상 좋아요는\n불가능합니다.";
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		jsonObj.put("msg", msg);
				
		return jsonObj.toString();
	}
	
	// 좋아요 취소하기
	@ResponseBody
	@GetMapping(value="/community/likeMinus.kedai", produces="text/plain;charset=UTF-8")
	public String likeMinus(HttpServletRequest request) {
		
		String fk_community_seq = request.getParameter("fk_community_seq");
		String fk_empid = request.getParameter("fk_empid");
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("fk_community_seq", fk_community_seq);
		paraMap.put("fk_empid", fk_empid);
		
		int n = service.likeMinus(paraMap);
		
		String msg = "";
		if(n == 1) {
			msg = fk_community_seq + "번 글에 좋아요를 취소하였습니다.";
		}
		
		JSONObject jsonObj = new JSONObject(); // {}
		jsonObj.put("n", n);
		jsonObj.put("msg", msg);
				
		return jsonObj.toString();
	}
	
}
