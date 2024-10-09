package com.spring.app.schedule.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.CalendarScheduleVO;
import com.spring.app.domain.CalendarSmallCategoryVO;
import com.spring.app.domain.MemberVO;

public interface ScheduleService {
	
	// 사내 캘린더에서 사내캘린더 소분류  보여주기 
	List<CalendarSmallCategoryVO> showCompanySmallCalendar();
	
	// 내 캘린더에서 내캘린더 소분류  보여주기
	List<CalendarSmallCategoryVO> showMySmallCalendar(String fk_empid);
	
	// 등록된 일정 가져오기
	List<CalendarScheduleVO> allSchedule(String empid);
	
	// 일정 상세 보기 
	Map<String, String> detailSchedule(String scheduleno);
	
	// 사내 캘린더에 일정 추가하기
	int addComCalendar(Map<String, String> paraMap) throws Throwable;
	
	// (사내캘린더 또는 내캘린더)속의 소분류 카테고리인 서브캘린더 수정하기 
	int editCalendar(Map<String, String> paraMap);
	
	// 내 캘린더에 일정 추가하기
	int addMyCalendar(Map<String, String> paraMap)  throws Throwable;
	
	// (사내캘린더 또는 내캘린더)속의  소분류 카테고리인 서브캘린더 삭제하기 
	int deleteSubCalendar(String smcatgono) throws Throwable;

	// 총 일정 검색 건수(totalCount)
	int getTotalCount(Map<String, String> paraMap);

	// 페이징 처리한 캘린더 가져오기(검색어가 없다라도 날짜범위 검색은 항시 포함된 것임)
	List<Map<String, String>> scheduleListSearchWithPaging(Map<String, String> paraMap);

	// 일정 등록시 내캘린더,사내캘린더 선택에 따른 서브캘린더 종류를 알아오기 
	List<CalendarSmallCategoryVO> selectSmallCategory(Map<String, String> paraMap);

	// 공유자를 찾기 위한 특정글자가 들어간 회원명단 불러오기 
	List<MemberVO> searchJoinUserList(String joinUserName);

	// 일정 등록하기
	int registerSchedule_end(Map<String, String> paraMap) throws Throwable;

	// 일정삭제하기 
	int deleteSchedule(String scheduleno) throws Throwable;

	// 일정수정하기 
	int editSchedule_end(CalendarScheduleVO svo) throws Throwable;






}
