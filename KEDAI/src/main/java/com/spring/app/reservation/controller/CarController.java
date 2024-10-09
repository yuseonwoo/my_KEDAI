package com.spring.app.reservation.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.board.service.BoardService;
import com.spring.app.common.AES256;
import com.spring.app.common.FileManager;
import com.spring.app.common.GoogleMail_owner;
import com.spring.app.common.MyUtil;
import com.spring.app.domain.BusVO;
import com.spring.app.domain.CarVO;
import com.spring.app.domain.Day_shareVO;
import com.spring.app.domain.MemberVO;
import com.spring.app.member.service.IndexService;
import com.spring.app.reservation.service.CarService;

@Controller
public class CarController {

	@Autowired
	private CarService service;

	@Autowired
	private AES256 aES256;
	
	@Autowired
	private FileManager fileManager;

    @Autowired
    private BoardService boardService;
    
    @Autowired
    private IndexService indexService;
    
	// sidebar에서 통근버스 클릭시 이동하는 페이지 만들기
	@GetMapping("/bus.kedai")
	public ModelAndView empmanager_bus(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		mav.setViewName("tiles1/reservation/bus.tiles");
		return mav;

	}

	@ResponseBody
	@GetMapping("/bus_select.kedai")
	public String requiredLogin_bus(HttpServletRequest request, HttpServletResponse response) { // http://localhost:9099/final_project/bus.kedai

		String bus_no = request.getParameter("bus_no");
		String pf_station_id = request.getParameter("pf_station_id");

		List<BusVO> stationList = service.getStationList(bus_no);
//			List<BusVO> stationTime = service.getStationTime(pf_station_id);

		JSONArray jsonArr = new JSONArray(); // []

		if (stationList != null) {
			for (BusVO busvo : stationList) {
				JSONObject jsonObj = new JSONObject(); // {}
				jsonObj.put("bus_no", busvo.getBus_no());
				jsonObj.put("pf_station_id", busvo.getPf_station_id());
				jsonObj.put("station_name", busvo.getStation_name());
				jsonObj.put("way", busvo.getWay());
				jsonObj.put("lat", busvo.getLat());
				jsonObj.put("lng", busvo.getLng());
				jsonObj.put("zindex", busvo.getZindex());
				jsonObj.put("minutes_until_next_bus", busvo.getMinutes_until_next_bus());

				jsonArr.put(jsonObj);
			} // end of for-------------------------
		}

		return jsonArr.toString();

	}

	@ResponseBody
	@GetMapping("/station_select.kedai")
	public String requiredLogin_station(HttpServletRequest request, HttpServletResponse response) { // http://localhost:9099/final_project/bus.kedai
		String bus_no = request.getParameter("bus_no");
		String pf_station_id = request.getParameter("pf_station_id");
//			System.out.println("~~~ 확인용 pf_station_id : "+ pf_station_id);
//			System.out.println("~~~ 확인용 bus_no : "+ bus_no );

		List<BusVO> stationTimeList = service.getStationTimeList(bus_no, pf_station_id);

		JSONArray jsonArr = new JSONArray(); // []

		if (stationTimeList != null) {
			for (BusVO busvo : stationTimeList) {
				JSONObject jsonObj = new JSONObject(); // {}
				jsonObj.put("bus_no", busvo.getBus_no());
				jsonObj.put("pf_station_id", busvo.getPf_station_id());
				jsonObj.put("station_name", busvo.getStation_name());
				jsonObj.put("way", busvo.getWay());
				jsonObj.put("lat", busvo.getLat());
				jsonObj.put("lng", busvo.getLng());
				jsonObj.put("zindex", busvo.getZindex());
				jsonObj.put("minutes_until_next_bus", busvo.getMinutes_until_next_bus());

				jsonArr.put(jsonObj);
			} // end of for-------------------------
		}

		return jsonArr.toString();

	}

	// sidebar에서 카쉐어 클릭시 이동하는 페이지 만들기
	@GetMapping("/carShare.kedai")
	public ModelAndView requiredLogin_carShare(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) {

		// car테이블에서 mycar정보 가져오기
		List<Map<String, String>> carShareList = service.carShareList();

		// 글조회수(readCount)증가 => 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다. => session 을 사용하여
		// 처리하기
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");

		// 페이징 처리를 한 검색어가 있는 전체 글목록 보여주기
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String start = request.getParameter("start");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");

		if (carShareList == null) {
			mav.setViewName("tiles1/reservation/carShare.tiles");
		}

		if (searchType == null) {
			searchType = "";
		}

		if (searchWord == null) {
			searchWord = "";
		}

		if (searchWord != null) {
			searchWord = searchWord.trim();
		}
		if (start == null) {
			start = "";
		}

		if (start != null) {
			start = start.trim();
		}

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("start", start);

		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 10; // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)

		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalCount(paraMap);

		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13

		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는
																				// 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (Exception e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}

		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		carShareList = service.carShareListSearch_withPaging(paraMap);

		mav.addObject("carShareList", carShareList);

		// 검색 시 검색조건 및 검색어 값 유지시키기
		if ("dp_name".equals(searchType) || "ds_name".equals(searchType) || "share_date".equals(searchType)) {
			mav.addObject("paraMap", paraMap);
		}

		// 페이지바 만들기
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		// 공식
		// 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 => ((1-1)/5)*5+1 => 1
		// 두번째 블럭의 페이지번호 시작값(pageNo)은 6 => ((6-1)/5)*5+1 => 6
		// 세번째 블럭의 페이지번호 시작값(pageNo)은 11 => ((11-1)/5)*5+1 => 11

		String pageBar = "<ul style='list-style: none;'>";
		String url = "carShare.kedai";

		// [맨처음][이전] 만들기
		if (pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=1'>[처음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"
						+ pageNo + "</li>";
			} else {
				pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='" + url
						+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
						+ "' style='color: #2c4459;'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;
		} // end of while() ----------

		// [다음][마지막] 만들기
		if (pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
					+ "' style='color: #2c4459;'>[다음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + totalPage
					+ "' style='color: #2c4459;'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);

		// 특정 글제목을 클릭하여 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 알려주기 위해 현재 페이지
		// 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);

		// 페이징처리 시 순번을 나타내기 위한 것
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);

		mav.addObject("carShareList", carShareList);

		// sysdate
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String todayStr = sdf.format(today);

		mav.addObject("todayStr", todayStr);
		mav.setViewName("tiles1/reservation/carShare.tiles");
		return mav;

	}

	// 카쉐어에서 검색어 입력 시 자동글 완성하기
	@ResponseBody
	@GetMapping(value = "/carShare/searchShow.kedai", produces = "text/plain;charset=UTF-8")
	public String wordSearchShow(HttpServletRequest request) {

		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		List<String> wordList = service.searchShow(paraMap);

		JSONArray jsonArr = new JSONArray(); // []

		if (wordList != null) {
			for (String word : wordList) {
				JSONObject jsonObj = new JSONObject();

				jsonObj.put("word", word);

				jsonArr.put(jsonObj); // [{}, {}, {}]
			} // end of for ----------
		}

		return jsonArr.toString();
	}

	// 카셰어링현황(차주)에서 검색어 입력 시 자동글 완성하기
	@ResponseBody
	@GetMapping(value = "/carShare/searchShow_owner.kedai", produces = "text/plain;charset=UTF-8")
	public String searchShow_owner(HttpServletRequest request) {

		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);

		List<String> wordList_owner = service.searchShow_owner(paraMap);

		JSONArray jsonArr = new JSONArray(); // []

		if (wordList_owner != null) {
			for (String word : wordList_owner) {
				JSONObject jsonObj = new JSONObject();

				jsonObj.put("word", word);

				jsonArr.put(jsonObj); // [{}, {}, {}]
			} // end of for ----------
		}

		return jsonArr.toString();
	}

	// 카쉐어 페이지에서 등록하기 버튼시 이동하는 페이지 만들기
	@GetMapping("/carRegister.kedai")
	public ModelAndView requiredLogin_carRegister(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String fk_empid = loginuser.getEmpid();

		// car테이블에서 mycar정보 가져오기
		List<Map<String, String>> myCar = service.myCar(fk_empid);

		if (myCar.isEmpty()) {
			String message = "등록되어있는 차량이 없습니다. 차량등록 페이지로 이동합니다.";
			String loc = request.getContextPath() + "/myCarRegister.kedai";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");

		} else {
			mav.setViewName("tiles1/reservation/carRegister.tiles");
		}
		return mav;

	}

	// 카쉐어 페이지에서 등록하기 버튼시 이동하는 페이지 만들기
	@PostMapping("/carRegisterEnd.kedai")
	public ModelAndView carRegisterEnd(ModelAndView mav, MemberVO mvo, CarVO cvo, HttpServletRequest request) {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String fk_empid = loginuser.getEmpid();

		if (fk_empid == null) {
			String message = "로그아웃처리되었습니다. 다시 로그인하세요";
			String loc = request.getContextPath() + "/login.kedai";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");
		} else {
			// car테이블에서 mycar정보 가져오기
			CarVO myCar = service.myCar2(fk_empid);
//		System.out.println("~~~확인용 : " + myCar.getCar_seq());
			int car_seq = myCar.getCar_seq();

			Map<String, Object> paraMap = new HashMap<>();

			String fk_cnum = request.getParameter("fk_cnum");
			String start = request.getParameter("start");
			String last = request.getParameter("last");
			String startTime = request.getParameter("startTime");
			String departure_name = request.getParameter("departure_name");
			String departure_address = request.getParameter("departure_address");
			String arrive_name = request.getParameter("arrive_name");
			String arrive_address = request.getParameter("arrive_address");
			String dp_lat = request.getParameter("dp_lat");
			String dp_lng = request.getParameter("dp_lng");
			String ds_lat = request.getParameter("ds_lat");
			String ds_lng = request.getParameter("ds_lng");
//		System.out.println("~~~확인용 fk_cnum : "+ fk_cnum);
//		System.out.println("~~~확인용 start : "+ start);

			paraMap.put("car_seq", car_seq);
			paraMap.put("fk_cnum", fk_cnum);
			paraMap.put("start", start);
			paraMap.put("last", last);
			paraMap.put("startTime", startTime);
			paraMap.put("departure_name", departure_name);
			paraMap.put("departure_address", departure_address);
			paraMap.put("arrive_name", arrive_name);
			paraMap.put("arrive_address", arrive_address);
			paraMap.put("dp_lat", dp_lat);
			paraMap.put("dp_lng", dp_lng);
			paraMap.put("ds_lat", ds_lat);
			paraMap.put("ds_lng", ds_lng);

			try {

				int n = service.addcarRegister(paraMap);

				if (n == 1) {
					String message = "카셰어링이 정상 등록되었습니다.";
					String loc = request.getContextPath() + "/carShare.kedai";

					mav.addObject("message", message);
					mav.addObject("loc", loc);

					mav.setViewName("msg");
				}

			} catch (Exception e) {
				String message = "카셰어링 등록을 실패했습니다.";
				String loc = "javascript:history.back()";

				mav.addObject("message", message);
				mav.addObject("loc", loc);

				mav.setViewName("msg");
			}
		}
		return mav;

	}

	// 마이페이지에서 나의 차량 정보 등록 클릭시 들어가는 페이지 만들기
	@GetMapping("/myCar.kedai")
	public ModelAndView myCar(ModelAndView mav, HttpServletRequest request) { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		String fk_empid = loginuser.getEmpid();

//		System.out.println("~~~확인용 : "+ empid);
//		~~~확인용 : 2010400-001

		// car테이블에서 mycar정보 가져오기
		List<Map<String, String>> myCar = service.myCar(fk_empid);

		if (myCar == null) {
			mav.setViewName("tiles1/reservation/myCar.tiles");
		}

//		System.out.println("~~~ 확인용 : " + myCar);
		mav.addObject("myCar", myCar);
		mav.setViewName("tiles1/reservation/myCar.tiles");

		return mav;

	}

	// 마이페이지에서 나의 차량 정보 등록 클릭시 들어가는 페이지 만들기
	@PostMapping("/myCarEdit.kedai")
	public ModelAndView myCarEdit(HttpServletRequest request, CarVO cvo, ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String fk_empid = loginuser.getEmpid();

		List<Map<String, String>> myCar = service.myCar(fk_empid);

//		System.out.println("~~~ 확인용 : " + myCar);
		mav.addObject("myCar", myCar);
		mav.setViewName("tiles1/reservation/myCarEdit.tiles");
		return mav;

	}

	// 마이페이지에서 나의 차량 정보 등록 클릭시 들어가는 페이지 만들기(파일이미지떄문에 수정이 안됨)
	@PostMapping("/myCarEditEnd.kedai")
	public ModelAndView myCarEditEnd(MultipartHttpServletRequest mrequest, CarVO cvo, ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		Map<String, Object> paraMap = new HashMap<>();

		HttpSession session = mrequest.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		String fk_empid = loginuser.getEmpid();

		MultipartFile attach = cvo.getAttach();

		if (attach != null) { // 첨부파일이 있는 경우

			// WAS 의 webapp 의 절대경로 알아오기
			String root = session.getServletContext().getRealPath("/");
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\

			String path = root + "resources" + File.separator + "files" + File.separator + "car";
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files\car

			// 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
			String newFileName = ""; // WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null; // 첨부파일의 내용물을 담는 것

			try {
				bytes = attach.getBytes();

				String originalFilename = attach.getOriginalFilename(); // 첨부파일명의 파일명

				newFileName = fileManager.doFileUpload(bytes, originalFilename, path); // 첨부되어진 파일을 업로드

				paraMap.put("car_imgfilename", newFileName);
//				System.out.println("newFileName ~~~ 확인용 : " + newFileName);
				paraMap.put("car_orgimgfilename", originalFilename);
//				System.out.println("originalFilename ~~~ 확인용 : " + originalFilename);

//				newFileName ~~~ 확인용 : 20240720130231737170051538500.jpg
//				originalFilename ~~~ 확인용 : admin차.jpg

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end of if(attach != null) ----------

		String car_type = mrequest.getParameter("car_type");
		String car_num = mrequest.getParameter("car_num");
		int max_num = Integer.parseInt(mrequest.getParameter("max_num"));
		int insurance = Integer.parseInt(mrequest.getParameter("insurance"));
		String license = mrequest.getParameter("license");
		String drive_year = mrequest.getParameter("drive_year");

		System.out.println("~~~ 확인용 : " + fk_empid);
		System.out.println("~~~ 확인용 : " + car_type);
		System.out.println("~~~ 확인용 : " + car_num);
		System.out.println("~~~ 확인용 : " + max_num);
		System.out.println("~~~ 확인용 : " + insurance);
		System.out.println("~~~ 확인용 : " + drive_year);
		System.out.println("~~~ 확인용 : " + license);

		paraMap.put("fk_empid", fk_empid);
		paraMap.put("car_type", car_type);
		paraMap.put("car_num", car_num);
		paraMap.put("max_num", max_num);
		paraMap.put("insurance", insurance);
		paraMap.put("license", license);
		paraMap.put("drive_year", drive_year);

		try {
			int n = service.editMycar(paraMap);

			if (n == 1) {
				String message = "내 차 정보가 정상적으로 수정되었습니다.";
				String loc = mrequest.getContextPath() + "/index.kedai";

				mav.addObject("message", message);
				mav.addObject("loc", loc);

				mav.setViewName("msg");

			}

		} catch (Exception e) {
			String message = "내 차 정보 수정이 실패했습니다. \\n 다시 시도해주세요.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");

		}

		return mav;

	}

	// 마이페이지에서 나의 차량 정보 등록 클릭시 들어가는 페이지 만들기
	@GetMapping("/myCarRegister.kedai")
	public ModelAndView myCarRegister(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		mav.setViewName("tiles1/reservation/myCarRegister.tiles");
		return mav;

	}

	// 마이페이지에서 나의 차량 정보 등록 완료시
	@PostMapping("/myCarRegisterEnd.kedai")
	public ModelAndView myCarRegisterEnd(ModelAndView mav, CarVO cvo, MultipartHttpServletRequest mrequest) { // http://localhost:9099/final_project/bus.kedai

		String userid = mrequest.getParameter("userid");
		HttpSession session = mrequest.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		String fk_empid = loginuser.getEmpid();

		MultipartFile attach = cvo.getAttach();

		if (attach != null) { // 첨부파일이 있는 경우

			// WAS 의 webapp 의 절대경로 알아오기
			String root = session.getServletContext().getRealPath("/");
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\

			String path = root + "resources" + File.separator + "files" + File.separator + "car";
			// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files\car

			// 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
			String newFileName = ""; // WAS(톰캣)의 디스크에 저장될 파일명
			byte[] bytes = null; // 첨부파일의 내용물을 담는 것

			try {
				bytes = attach.getBytes();

				String originalFilename = attach.getOriginalFilename(); // 첨부파일명의 파일명

				newFileName = fileManager.doFileUpload(bytes, originalFilename, path); // 첨부되어진 파일을 업로드

				cvo.setCar_imgfilename(newFileName);
				cvo.setCar_orgimgfilename(originalFilename);

			} catch (Exception e) {
				e.printStackTrace();
			}

		} // end of if(attach != null) ----------

		String car_type = mrequest.getParameter("car_type");
		String car_num = mrequest.getParameter("car_num");
		int max_num = Integer.parseInt(mrequest.getParameter("max_num"));
		int insurance = Integer.parseInt(mrequest.getParameter("insurance"));
		String license = mrequest.getParameter("license");
		String drive_year = mrequest.getParameter("drive_year");

		cvo.setFk_empid(fk_empid);
		cvo.setCar_type(car_type);
		cvo.setCar_num(car_num);
		cvo.setMax_num(max_num);
		cvo.setInsurance(insurance);
		cvo.setDrive_year(drive_year);
		cvo.setLicense(license);

		try {
			int n = service.addMycar(cvo);

			if (n == 1) {
				String message = "내 차 정보가 정상적으로 등록되었습니다.";
				String loc = mrequest.getContextPath() + "/index.kedai";

				mav.addObject("message", message);
				mav.addObject("loc", loc);

				mav.setViewName("msg");

			}
		} catch (Exception e) {
			String message = "내 차 정보 등록이 실패했습니다. \\n 다시 시도해주세요.";
			String loc = "javascript:history.back()";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");

		}
		return mav;

	}

	// 마이페이지에서 나의 카셰어링 예약 및 결제내역 클릭시 들어가는 페이지 만들기 #62.
	@PostMapping("/carApply_detail.kedai")
	public ModelAndView requiredLogin_carApply_detail(HttpServletRequest request, HttpServletResponse response,
			Day_shareVO dsvo, ModelAndView mav) {

		String userid = request.getParameter("userid");
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		String fk_empid = loginuser.getEmpid();

		int res_num = Integer.parseInt(request.getParameter("res_num"));
//		System.out.println("~~~확인용 res_num : "+ res_num);
		Day_shareVO day_shareInfo = service.day_shareInfo(res_num);
//		double dp_lat = day_shareInfo.getDp_lat();
//		double dp_lng = day_shareInfo.getDp_lng();
//		double ds_lat = day_shareInfo.getDs_lat();
//		double ds_lng = day_shareInfo.getDs_lng();
//		String start_time = day_shareInfo.getStart_time();
//		String start_date = day_shareInfo.getStart_date();
//		String last_date = day_shareInfo.getLast_date();

		// res_num 을 가지고 해당 tbl_day_share 가져오기

		// 출발지, 도착지, 출발시간, 지도에 표시해주어야하는 것, 출발지 위도,경도 & 도착지 위도 & 경도

		mav.addObject("day_shareInfo", day_shareInfo);
		mav.setViewName("tiles1/reservation/carApply_detail.tiles");

		return mav;

	}

	// 마이페이지에서 나의 카셰어링 예약 및 결제내역 클릭시 들어가는 페이지 만들기 #62.
	@PostMapping("/carApply_detailEnd.kedai")
	public ModelAndView carApply_detailEnd(HttpServletRequest request, HttpServletResponse response, Day_shareVO dsvo,
			ModelAndView mav) {

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");

		String pf_empid = loginuser.getEmpid();
		int pf_res_num = Integer.parseInt(request.getParameter("pf_res_num"));
//		System.out.println("~~~확인용 pf_res_num : "+ pf_res_num);
//		System.out.println("~~~확인용 pf_empid : "+ pf_empid);

		String share_date = request.getParameter("share_date");
		System.out.println("~~~확인용 share_date : " + share_date);
//		~~~확인용 share_date : 2024-07-24
		String share_may_time = request.getParameter("share_may_time");
		String rdp_name = request.getParameter("rdp_name");
		String rdp_add = request.getParameter("rdp_add");
		String rdp_lat = request.getParameter("rdp_lat");
		String rdp_lng = request.getParameter("rdp_lng");
		String rds_name = request.getParameter("rds_name");
		String rds_add = request.getParameter("rds_add");
		String rds_lat = request.getParameter("rds_lat");
		String rds_lng = request.getParameter("rds_lng");
//		System.out.println("~~~확인용 share_may_time : "+ share_may_time);
//		System.out.println("~~~확인용 rdp_name : "+ rdp_name);
//		System.out.println("~~~확인용 rdp_add : "+ rdp_add);
//		System.out.println("~~~확인용 rdp_lat : "+ rdp_lat);
//		System.out.println("~~~확인용 rdp_lng : "+ rdp_lng);
//		System.out.println("~~~확인용 rds_name : "+ rds_name);
//		System.out.println("~~~확인용 rds_add : "+ rds_add);
//		System.out.println("~~~확인용 rds_lat : "+ rds_lat);
//		System.out.println("~~~확인용 rds_lng : "+ rds_lng);

		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("pf_res_num", pf_res_num);
		paraMap.put("pf_empid", pf_empid);
		paraMap.put("share_date", share_date);
		paraMap.put("share_may_time", share_may_time);
		paraMap.put("rdp_name", rdp_name);
		paraMap.put("rdp_add", rdp_add);
		paraMap.put("rdp_lat", rdp_lat);
		paraMap.put("rdp_lng", rdp_lng);
		paraMap.put("rds_name", rds_name);
		paraMap.put("rds_add", rds_add);
		paraMap.put("rds_lat", rds_lat);
		paraMap.put("rds_lng", rds_lng);

		try {

			int n = service.addcarApply_detail(paraMap);

			if (n == 1) {
				String message = "카셰어링 신청이 정상 등록되었습니다. \\n 마이페이지로 이동하여 신청 정보를 확인합니다.";
				String loc = request.getContextPath() + "/customer_applyStatus.kedai";

				mav.addObject("message", message);
				mav.addObject("loc", loc);

				mav.setViewName("msg");
			}

		} catch (Exception e) {
			String message = "동일한 신청내역이 존재합니다. 카셰어링신청현황에서 확인가능합니다.";
			String loc = request.getContextPath() + "/customer_applyStatus.kedai";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");
		}

		return mav;

	}

	// 마이페이지에서 나의 카셰어링 예약 및 결제내역 클릭시 들어가는 페이지 만들기
	@GetMapping("/myCarReserveAndPay.kedai")
	public ModelAndView requiredLogin_myCarReserveAndPay(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		mav.setViewName("tiles1/reservation/myCarReserveAndPay.tiles");
		return mav;

	}

	// 마이페이지에서 카셰어링현황(차주) 페이지 만들기
	@GetMapping("/owner_Status.kedai")
	public ModelAndView requiredLogin_owner(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String empid = loginuser.getEmpid();

		// car테이블에서 mycar정보 가져오기
		List<Map<String, String>> owner_carShareList = service.owner_carShareList(empid);

		// 페이징 처리를 한 검색어가 있는 전체 글목록 보여주기
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String start = request.getParameter("start");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");

		if (owner_carShareList == null) {
			mav.setViewName("tiles1/reservation/owner_Status.tiles");
		}

		if (searchType == null) {
			searchType = "";
		}

		if (searchWord == null) {
			searchWord = "";
		}

		if (searchWord != null) {
			searchWord = searchWord.trim();
		}
		if (start == null) {
			start = "";
		}

		if (start != null) {
			start = start.trim();
		}

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("empid", empid);
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("start", start);

		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 10; // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 0; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)

		// 총 게시물 건수(totalCount)
		totalCount = service.owner_getTotalCount(paraMap);

		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13

		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는
																				// 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (Exception e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}

		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

		owner_carShareList = service.owner_carShareListSearch_withPaging(paraMap);

		mav.addObject("owner_carShareList", owner_carShareList);

		// 검색 시 검색조건 및 검색어 값 유지시키기
		if ("dp_name".equals(searchType) || "ds_name".equals(searchType) || "share_date".equals(searchType)) {
			mav.addObject("paraMap", paraMap);
		}

		// 페이지바 만들기
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		// 공식
		// 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 => ((1-1)/5)*5+1 => 1
		// 두번째 블럭의 페이지번호 시작값(pageNo)은 6 => ((6-1)/5)*5+1 => 6
		// 세번째 블럭의 페이지번호 시작값(pageNo)은 11 => ((11-1)/5)*5+1 => 11

		String pageBar = "<ul style='list-style: none;'>";
		String url = "owner_Status.kedai";

		// [맨처음][이전] 만들기
		if (pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=1'>[처음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"
						+ pageNo + "</li>";
			} else {
				pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='" + url
						+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
						+ "' style='color: #2c4459;'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;
		} // end of while() ----------

		// [다음][마지막] 만들기
		if (pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + pageNo
					+ "' style='color: #2c4459;'>[다음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?searchType=" + searchType + "&searchWord=" + searchWord + "&currentShowPageNo=" + totalPage
					+ "' style='color: #2c4459;'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);

		// 특정 글제목을 클릭하여 상세내용을 본 이후 사용자가 "검색된결과목록보기" 버튼을 클릭했을 때 돌아갈 페이지를 알려주기 위해 현재 페이지
		// 주소를 뷰단으로 넘겨준다.
		String goBackURL = MyUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);

		// 페이징처리 시 순번을 나타내기 위한 것
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);

		mav.addObject("owner_carShareList", owner_carShareList);

		mav.setViewName("tiles1/reservation/owner_Status.tiles");
		return mav;

	}

	// 마이페이지에서 카셰어링정산(신청자) 페이지 만들기
	@GetMapping("/owner_Status_detail.kedai")
	public ModelAndView owner_Status_detail(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		// 날짜 넘겨주기
		String date = request.getParameter("date");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
//		System.out.println("~~~ 우하하하하하 ######## 확인용 date : " + date);
//		~~~ 확인용 date : 2024-08-08
		mav.addObject("date", date);
		
		// 선택한 날짜에 해당하는 카셰어링 정보를 가져오기
		List<Map<String, Object>> owner_dateInfoList = service.owner_dateInfo(date);
		mav.addObject("owner_dateInfoList", owner_dateInfoList);
		
		int res_num = Integer.parseInt(request.getParameter("res_num"));
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("res_num", res_num);
		paraMap.put("share_date", date);
		
		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 3; // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 1; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)

		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalCount_owner_Status_detail(paraMap);
//		System.out.println("~~~ 확인용 : " + totalCount);
		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13
		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는
																				// 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (Exception e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}

		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

//		System.out.println("~~~ 확인용 res_num : " + res_num);
//		System.out.println("~~~ 확인용  date: " + date);
//		System.out.println("~~~ 확인용 startRno : " + startRno);
//		System.out.println("~~~ 확인용  endRno: " + endRno);
		
		owner_dateInfoList = service.owner_Status_detail_withPaging(paraMap);

		mav.addObject("owner_dateInfoList", owner_dateInfoList);

		// 페이지바 만들기
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		// 공식
		// 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 => ((1-1)/5)*5+1 => 1
		// 두번째 블럭의 페이지번호 시작값(pageNo)은 6 => ((6-1)/5)*5+1 => 6
		// 세번째 블럭의 페이지번호 시작값(pageNo)은 11 => ((11-1)/5)*5+1 => 11

		String pageBar = "<ul style='list-style: none;'>";
		String url = "owner_Status_detail.kedai";

		// [맨처음][이전] 만들기
		if (pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=1&date="+ date + "&res_num=" + res_num+"'>[처음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + (pageNo - 1) + "&date=" + date + "&res_num=" + res_num
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"
						+ pageNo + "</li>";
			} else {
				pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='" + url
						+ "?currentShowPageNo=" + pageNo + "&date=" + date+ "&res_num=" + res_num
						+ "' style='color: #2c4459;'>" + pageNo + "</a></li>";
			}                         

			loop++;
			pageNo++;
		} // end of while() ----------

		// [다음][마지막] 만들기
		if (pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + pageNo + "&date=" + date + "&res_num=" + res_num
					+ "' style='color: #2c4459;'>[다음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + totalPage + "&date=" + date + "&res_num=" + res_num
					+ "' style='color: #2c4459;'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);
		// 페이징처리 시 순번을 나타내기 위한 것
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		mav.setViewName("tiles1/reservation/owner_Status_detail.tiles");
		return mav;

	}

	// 마이페이지에서 카셰어링정산(차주)에서 업데이트 완료하기
	@GetMapping("/owner_Status_detail_update.kedai")
	@ResponseBody
	public ModelAndView owner_Status_detail_update(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String fk_empid = loginuser.getEmpid();
		String owner_nickname = loginuser.getNickname();
		
		if (fk_empid == null) {
			String message = "로그아웃처리되었습니다. 다시 로그인하세요";
			String loc = request.getContextPath() + "/login.kedai";

			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");
		} else {
			// ajax에서 보내준 값을 찍기
            String index = request.getParameter("index");
            String accept_yon = request.getParameter("accept_yon");
           
            String deny_reason = request.getParameter("deny_reason"); // reason 파라미터는 거부일 경우에만 있음
            if(deny_reason == null) {
            	deny_reason = "";
            }
            String pf_res_num = request.getParameter("pf_res_num");
            String pf_empid = request.getParameter("pf_empid");
           
//            System.out.println("Index: " + index + ", accept_yon: " + accept_yon + ", deny_reason: " + deny_reason + ", pf_res_num: " + pf_res_num + ", pf_empid: " + pf_empid);

            Map<String, Object> paraMap = new HashMap<>();
            paraMap.put("pf_res_num", pf_res_num);
            paraMap.put("pf_empid", pf_empid);
           
            paraMap.put("index", index);
            paraMap.put("accept_yon", accept_yon);
            paraMap.put("deny_reason", deny_reason);
			
			try {

				int n = service.updateStatus(paraMap);

				if (n == 1) {
					String message = "업데이트를 성공했습니다.";
					String loc = request.getContextPath() + "/owner_Status_detail.kedai";

					mav.addObject("message", message);
					mav.addObject("loc", loc);

					mav.setViewName("msg");
				}

			} catch (Exception e) {
				String message = "업데이트를 실패했습니다.";
				String loc = "javascript:history.back()";

				mav.addObject("message", message);
				mav.addObject("loc", loc);

				mav.setViewName("msg");
			}
			
			/////// 이메일 발송하기 ////////
			/*
			 * 업데이트된 내역 전달
			 * 승인시 -> '차주(닉네임)' 님이 '신청자(닉네임)'님의 카셰어링 신청을 승인하였습니다.
			 * 거부시 -> '차주(닉네임)' 님이 '신청자(닉네임)'님의 카셰어링 신청을 '거부이유'와 같은 이유로 거절하였습니다. 다른 카셰어링을 이용해주세요 감사합니다.
			 */
			
			String nickname = request.getParameter("nickname");
			String email = request.getParameter("email");
			paraMap.put("nickname", nickname);
			paraMap.put("owner_nickname", owner_nickname);
			String encryptedEmail = "";
			try {
	            encryptedEmail = aES256.decrypt(email);
	            System.out.println("Original email: " + email);
	            System.out.println("Encrypted email: " + encryptedEmail);
	            paraMap.put("email", encryptedEmail);
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			boolean sendMailSuccess = false;
			
			GoogleMail_owner mail = new GoogleMail_owner();
			// 승인인 경우
			if(accept_yon.equals("1")) {
	            try {
		            mail.send_update_accept(nickname, owner_nickname, encryptedEmail);
		            sendMailSuccess = true;
		            
		            
	            } catch(Exception e) {
	                e.printStackTrace();
	                sendMailSuccess = false;
	            }
			}
			// 거부인 경우
			else if(accept_yon.equals("2")) {
	            try {
		            mail.send_update_deny(nickname, owner_nickname, encryptedEmail, deny_reason);
		            sendMailSuccess = true;
		            
		            
	            } catch(Exception e) {
	                e.printStackTrace();
	                sendMailSuccess = false;
	            }
			}

		}
		return mav;
	}
	

	
	// 마이페이지에서 카셰어링정산(차주) 페이지 만들기
	@GetMapping("/owner_Settlement.kedai")
	@ResponseBody
	public ModelAndView owner_Settlement(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) throws ParseException { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String empid = loginuser.getEmpid();
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		System.out.println("~~~ 확인용 str_currentShowPageNo : " + str_currentShowPageNo);
		// car테이블에서 mycar정보 가져오기
		List<Map<String, String>> owner_SettlementList = service.owner_SettlementList(empid);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("empid", empid);
		
		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 10; // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 1; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)

		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalcount_owner_SettlementList(paraMap);
//		System.out.println("~~~ 확인용 : " + totalCount);
		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13
		System.out.println("~~~ 확인용 totalPage : " + totalPage);
		System.out.println("~~~ 확인용 totalCount : " + totalCount);
		
		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);

				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는
																				// 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (Exception e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}

		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		System.out.println("~~~ 확인용 startRno :" + startRno);
		System.out.println("~~~ 확인용 endRno :" + endRno);
		
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

//		System.out.println("~~~ 확인용 res_num : " + res_num);
//		System.out.println("~~~ 확인용  date: " + date);
//		System.out.println("~~~ 확인용 startRno : " + startRno);
//		System.out.println("~~~ 확인용  endRno: " + endRno);
		
		owner_SettlementList = service.owner_SettlementList_withPaging(paraMap);

		mav.addObject("owner_SettlementList", owner_SettlementList);

		// 페이지바 만들기
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		// 공식
		// 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 => ((1-1)/5)*5+1 => 1
		// 두번째 블럭의 페이지번호 시작값(pageNo)은 6 => ((6-1)/5)*5+1 => 6
		// 세번째 블럭의 페이지번호 시작값(pageNo)은 11 => ((11-1)/5)*5+1 => 11

		String pageBar = "<ul style='list-style: none;'>";
		String url = "owner_Settlement.kedai";

		// [맨처음][이전] 만들기
		if (pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=1'>[처음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"
						+ pageNo + "</li>";
			} else {
				pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='" + url
						+ "?currentShowPageNo=" + pageNo
						+ "' style='color: #2c4459;'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;
		} // end of while() ----------

		// [다음][마지막] 만들기
		if (pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + pageNo
					+ "' style='color: #2c4459;'>[다음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + totalPage
					+ "' style='color: #2c4459;'>[마지막]</a></li>";
		}

		pageBar += "</ul>";

		mav.addObject("pageBar", pageBar);
		// 페이징처리 시 순번을 나타내기 위한 것	
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);
		
		
	    
		mav.setViewName("tiles1/reservation/owner_Settlement.tiles");
		return mav;

	}

	// 마이페이지에서 카셰어링정산(차주) 페이지 만들기
	@GetMapping("/request_payment_owner.kedai")
	@ResponseBody
	public ModelAndView request_payment_owner(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) throws ParseException { // http://localhost:9099/final_project/bus.kedai

	
		/////// 이메일 발송하기 ////////
		/*
		 * 미결제금액
		 */
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String owner_nickname = loginuser.getNickname();
		String nickname_applicant = request.getParameter("nickname_applicant");
		String email_applicant = request.getParameter("email_applicant");
		String nonpayment_amount = request.getParameter("nonpayment_amount");
		
		System.out.println("~~~ 확인용 owner_nickname : " + owner_nickname);
		System.out.println("~~~ 확인용 nickname_applicant : " + nickname_applicant);
		System.out.println("~~~ 확인용 email_applicant : " + email_applicant);
		System.out.println("~~~ 확인용 nonpayment_amount : " + nonpayment_amount);
		
		String encryptedEmail = "";
		try {
				encryptedEmail = aES256.decrypt(email_applicant);
				  
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		boolean sendMailSuccess = false;
		
		GoogleMail_owner mail = new GoogleMail_owner();

	    try {
			mail.request_payment(nickname_applicant, owner_nickname, encryptedEmail, nonpayment_amount);
			sendMailSuccess = true;
			String message = "메일을 보냈습니다.";
			String loc = request.getContextPath() + "/request_payment_owner.kedai";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");	          
			
	    } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			sendMailSuccess = false;
		}
	    sendMailSuccess = true;
	    
	    return mav;
   
	}
		
	//시간 계산해주기
	@GetMapping("/calculateUseTime.kedai")
	@ResponseBody
	public Map<String, Object> calculateUseTime(
	    @RequestParam("getin_time") String getinTimeStr,
	    @RequestParam("getout_time") String getoutTimeStr) {
	    
	    Map<String, Object> response = new HashMap<>();
	    
	    try {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        Date getinTime = sdf.parse(getinTimeStr);
	        Date getoutTime = sdf.parse(getoutTimeStr);
	        
	        long diffInMillies = Math.abs(getoutTime.getTime() - getinTime.getTime());
	        long diffInMinutes = diffInMillies / (1000 * 60);

	        long settled_amount = diffInMinutes * 10;
	        
	        response.put("settled_amount", settled_amount);
	        response.put("use_time", diffInMinutes);
	        
	    } catch (ParseException e) {
	        e.printStackTrace();
	        response.put("error", "Invalid date format");
	    }
	    
	    return response;
	}
	
	// 10분당 100point로 계산하여 정산금액 계산하기 
	
    //모바일에서 보여지는 페이지
    @GetMapping("/mobile.kedai")
    public ModelAndView mobile(ModelAndView mav, HttpServletRequest request) {
    	
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String empid = loginuser.getEmpid();
		// car테이블에서 mycar정보 가져오기

		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		System.out.println("~~~ 확인용 str_currentShowPageNo : " + str_currentShowPageNo);
		// sysdate
		Date today = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String todayStr = sdf.format(today);
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("empid", empid);
		paraMap.put("todayStr", todayStr);
		
		List<Map<String, String>> owner_SettlementList_mobile = service.owner_SettlementList_mobile(paraMap);
		
		int totalCount = 0; // 총 게시물 건수
		int sizePerPage = 5; // 한 페이지 당 보여줄 게시물 건수
		int currentShowPageNo = 1; // 현재 보여주는 페이지 번호, 초기값는 1페이지로 설정
		int totalPage = 0; // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)


		// 총 게시물 건수(totalCount)
		totalCount = service.getTotalcount_owner_SettlementList_mobile(paraMap);
//		System.out.println("~~~ 확인용 : " + totalCount);
		totalPage = (int) Math.ceil((double) totalCount / sizePerPage);
		// (double)124/10 => 12.4 ==> Math.ceil(12.4) => 13.0 ==> (int)13.0 ==> 13		
		if (str_currentShowPageNo == null) {
			currentShowPageNo = 1; // 게시판에 보여지는 초기화면
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				System.out.println("~~~ 확인용 currentShowPageNo :" + currentShowPageNo);
				System.out.println("~~~ 확인용 totalPage :" + totalPage);
				
				if (currentShowPageNo < 1 || currentShowPageNo > totalPage) { // "GET" 방식이므로 0 또는 음수나 실제 데이터베이스에 존재하는
																				// 페이지수 보다 더 큰값을 입력하여 장난친 경우
					currentShowPageNo = 1;
				}
			} catch (Exception e) { // "GET" 방식이므로 숫자가 아닌 문자를 입력하여 장난친 경우
				currentShowPageNo = 1;
			}
		}
		
		
		// 가져올 게시글의 범위 => 공식 적용하기
		int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1; // 시작 행번호
		int endRno = startRno + sizePerPage - 1; // 끝 행번호

		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));

//		System.out.println("~~~ 확인용 res_num : " + res_num);
//		System.out.println("~~~ 확인용  date: " + date);
//		System.out.println("~~~ 확인용 startRno : " + startRno);
//		System.out.println("~~~ 확인용  endRno: " + endRno);
		
		owner_SettlementList_mobile = service.owner_SettlementList_withPaging_mobile(paraMap);

		mav.addObject("owner_SettlementList_mobile", owner_SettlementList_mobile);

		// 페이지바 만들기
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[지금은 5개(== blockSize)] 까지만 증가하는 용도
		int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		// 공식
		// 첫번째 블럭의 페이지번호 시작값(pageNo)은 1 => ((1-1)/5)*5+1 => 1
		// 두번째 블럭의 페이지번호 시작값(pageNo)은 6 => ((6-1)/5)*5+1 => 6
		// 세번째 블럭의 페이지번호 시작값(pageNo)은 11 => ((11-1)/5)*5+1 => 11

		String pageBar = "<ul style='list-style: none;'>";
		String url = "mobile.kedai";
		System.out.println("~~~ 확인용 pageno : " + pageNo);
		System.out.println("~~~ 확인용 totalPage : " + totalPage);
		System.out.println("~~~ 확인용 blockSize : " + blockSize);
		System.out.println("~~~ 확인용 currentShowPageNo : " + currentShowPageNo);
		
		
		// [맨처음][이전] 만들기
		if (pageNo != 1) { // 맨처음 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=1'>[처음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + (pageNo - 1)
					+ "'>[이전]</a></li>";
		}

		while (!(loop > blockSize || pageNo > totalPage)) {

			if (pageNo == currentShowPageNo) {
				pageBar += "<li style='display: inline-block; width: 30px; height: 30px; align-content: center; color: #fff; font-size: 12pt; border-radius: 50%; background: #e68c0e'>"
						+ pageNo + "</li>";
			} else {
				pageBar += "<li style='display: inline-block; width: 30px; font-size: 12pt;'><a href='" + url
						+ "?currentShowPageNo=" + pageNo
						+ "' style='color: #2c4459;'>" + pageNo + "</a></li>";
			}

			loop++;
			pageNo++;
		} // end of while() ----------

		// [다음][마지막] 만들기
		if (pageNo <= totalPage) { // 맨마지막 페이지일 때는 보이지 않도록 한다.
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + pageNo
					+ "' style='color: #2c4459;'>[다음]</a></li>";
			pageBar += "<li style='display: inline-block; width: 70px; font-size: 12pt;'><a href='" + url
					+ "?currentShowPageNo=" + totalPage
					+ "' style='color: #2c4459;'>[마지막]</a></li>";
		}

		pageBar += "</ul>";
		System.out.println("~~~ 확인용 pageBar : " + pageBar);
		mav.addObject("pageBar", pageBar);
		// 페이징처리 시 순번을 나타내기 위한 것
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("sizePerPage", sizePerPage);

		mav.addObject("todayStr", todayStr);
		mav.addObject("owner_SettlementList_mobile", owner_SettlementList_mobile);
    	mav.setViewName("tiles1/reservation/mobile.tiles");
    	
        return mav; // 모바일 페이지
    }
    
    @PostMapping("/mobile_time.kedai")
    public ModelAndView mobileTime(@RequestBody Map<String, Object> payload, HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        
        if (payload.containsKey("drive_in_time")) {
            String getin_time = (String) payload.get("drive_in_time");
            int rowId = (Integer) payload.get("row_id");
            String pf_res_num = (String) payload.get("pf_res_num");
            String pf_empid = (String) payload.get("pf_empid");
            System.out.println("Drive-in time: " + getin_time + " for row ID: " + rowId);
            System.out.println("pf_res_num: " + pf_res_num + ", pf_empid: " + pf_empid);
            
            Map<String, String> paraMap = new HashMap<>();
            paraMap.put("pf_res_num", pf_res_num);
            paraMap.put("pf_empid", pf_empid);
            paraMap.put("getin_time", getin_time); // 공백 제거
            
            try {
                int n = service.update_drive_in_time(paraMap);
                if (n == 1) {
                    String message = "업데이트를 성공했습니다.";
                    String loc = request.getContextPath() + "/mobile.kedai";

                    mav.addObject("message", message);
                    mav.addObject("loc", loc);
                    mav.setViewName("msg");
                }
            } catch (Exception e) {
                String message = "업데이트를 실패했습니다.";
                String loc = "javascript:history.back()";

                mav.addObject("message", message);
                mav.addObject("loc", loc);
                mav.setViewName("msg");
            }
        }

        // 하차버튼을 누르자마자 해당 하차 시간이 update되면서 use_time을 계산하여 update하고 settled_amount(point)update하고 해당 값과 똑같이 nonpayment_amount에도 update한다.
        if (payload.containsKey("drive_out_time")) {
        	String getin_time = (String) payload.get("getin_time");
            String driveOutTime = (String) payload.get("drive_out_time");
            int rowId = (Integer) payload.get("row_id");
            String pfResNum = (String) payload.get("pf_res_num");
            String pfEmpid = (String) payload.get("pf_empid");
            System.out.println("Drive-out time: " + driveOutTime + "Drive-in time: " + getin_time + " for row ID: " + rowId);
            System.out.println("pf_res_num: " + pfResNum + ", pf_empid: " + pfEmpid);
            
            Map<String, String> paraMap = new HashMap<>();
            paraMap.put("pf_res_num", pfResNum);
            paraMap.put("pf_empid", pfEmpid);
            paraMap.put("getout_time", driveOutTime);
            paraMap.put("getin_time", getin_time);
            
            System.out.println("~~~getin_time : " + paraMap.get("getin_time"));
            
            try {
                int n = service.update_drive_out_time(paraMap);
                if (n == 1) {
                    String message = "업데이트를 성공했습니다.";
                    String loc = request.getContextPath() + "/mobile.kedai";
                    mav.addObject("message", message);
                    mav.addObject("loc", loc);
                    mav.setViewName("msg");
                }
            } catch (Exception e) {
                String message = "업데이트를 실패했습니다.";
                String loc = "javascript:history.back()";
                mav.addObject("message", message);
                mav.addObject("loc", loc);
                mav.setViewName("msg");
            }
        }

        return mav;
    }

    
    
    
	// 마이페이지에서 카셰어링신청현황(신청자) 페이지 만들기
	@GetMapping("/customer_applyStatus.kedai")
	public ModelAndView customer_applyStatus(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String empid = loginuser.getEmpid();
		
		List<Map<String,String>> customer_applyStatusList = service.getcustomer_applyStatusList(empid);
		
		
		mav.addObject("customer_applyStatusList", customer_applyStatusList);
		mav.setViewName("tiles1/reservation/customer_applyStatus.tiles");
		return mav;

	}

	// 마이페이지에서 카셰어링정산(신청자) 페이지 만들기
	@GetMapping("/customer_Settlement.kedai")
	public ModelAndView customer_Settlement(HttpServletRequest request, HttpServletResponse response,
			ModelAndView mav) { // http://localhost:9099/final_project/bus.kedai

		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		String empid = loginuser.getEmpid();
		
		List<Map<String,String>> customer_SettlementList = service.getcustomer_SettlementList(empid);
		
		
		mav.addObject("customer_SettlementList", customer_SettlementList);
		mav.setViewName("tiles1/reservation/customer_Settlement.tiles");
		return mav;

	}

    @GetMapping("/payment.kedai")
    public ModelAndView point_payment(@RequestParam Map<String, String> paraMap, HttpServletRequest request, ModelAndView mav) {
        
    	int point = Integer.parseInt(request.getParameter("nonpayment_amount"));
        // 포인트 감소에 필요한 파라미터 설정
        Map<String, String> minusParaMap = new HashMap<>(paraMap);
        minusParaMap.put("point", paraMap.get("nonpayment_amount"));
        minusParaMap.put("empid", paraMap.get("pf_empid"));
        
        // 포인트 증가에 필요한 파라미터 설정
        Map<String, String> plusParaMap = new HashMap<>(paraMap);
        plusParaMap.put("point", paraMap.get("nonpayment_amount"));
        plusParaMap.put("empid", paraMap.get("empid_owner"));

		HttpSession session = request.getSession();
		MemberVO pf_empid = (MemberVO)session.getAttribute("loginuser"); 
		
		String message = "";
		if(pf_empid.getPoint() <= point) {
			message = "포인트 잔액이 부족합니다.\n포인트 충전 후 다시 시도해주세요.";
			String loc = request.getContextPath()+"/customer_Settlement.kedai"; 
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);

			mav.setViewName("msg");
			
		}
		else {
	        // 포인트 감소 로직
			int n = service.pointMinus_applicant(minusParaMap);
			
			// tbl_car_share의 nonpayment_amount을 null 처리하고 payment_amount 를 point 로 업데이트 시켜줘야함.
			int n1 = service.payment_settled(minusParaMap);
			
			if(n == 1 && n1 == 1) {
				message = "포인트 결제가 정상적으로 처리되었습니다.";
				pf_empid.setPoint(pf_empid.getPoint());
			}
		}
		
        // 포인트 증가 로직
		service.pointPlus_owner(plusParaMap);
		
		String loc = request.getContextPath()+"/customer_Settlement.kedai"; 
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);

		mav.setViewName("tiles1/reservation/customer_Settlement.tiles");
		
		return mav;
		
    }

}