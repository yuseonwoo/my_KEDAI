package com.spring.app.approval.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.ApprovalVO;
import com.spring.app.domain.DayoffVO;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.DocVO;
import com.spring.app.domain.DocfileVO;
import com.spring.app.domain.MinutesVO;

public interface ApprovalDAO {

	// 새로운 기안 서류 작성 시 작성자의 부서 이름 가져오기
	String getDeptNumber(Map<String, String> paraMap);
	
	// 현재 근무중인 사원이 있는 모든 부서 가져오기
	List<DeptVO> allDeptList();

	// 결재 라인에서 찾을 모든 사원 목록 보기
	List<Map<String, String>> allEmployeeList(String login_empid);

	// 해당 부서에 근무중인 사원 정보 가져오기
	List<Map<String, String>> deptEmpList(Map<String, String> paraMap);

	// doc_no의 시퀀스 채번해오기
	String getDoc_noSeq();

	// approval_noSeq 시퀀스 채번해오기
	String getApproval_noSeq();
	
	// 첨부파일이 없는 서류 작성하기(tbl_doc)
	int noFile_newdoc(Map<String, Object> paraMap);

	// 첨부파일이 없는 서류 작성하기(tbl_minutes)
	int noFile_minutes(Map<String, Object> paraMap);
	
	// 첨부파일이 없는 서류 작성하기(tbl_dayoff)
	int noFile_dayoff(Map<String, Object> paraMap);

	// 첨부파일이 없는 서류 작성하기(tbl_approval)
	int noFile_approval(Map<String, Object> paraMap);

	// 첨부파일이 있을 때 첨부파일 insert하기
	int withFile_doc(Map<String, String> docFileMap);

	// 메인화면에 보여줄 내가 작성한 기안문서 목록 가져오기
	List<DocVO> docListNoSearch(String loginEmpId);

	// 메인화면에 보여줄 
//	List<Map<String, String>> myApprovalDoc(String loginEmpId);

	// 결재 할 문서의 정보 가져오기
	List<Map<String, String>> myapprovalinfo(String loginEmpId);

	// 나의 기안 문서에서 총 페이지 수 가져오기
	int getTotalMyDocCount(Map<String, String> paraMap);
	
	// 나의 결재 예정 문서에서 총 페이지수 가져오기
	int getTotalMyNowApprovalCount(Map<String, String> paraMap);
	
	// 나의 모든 결재 문서 총 페이지수
	int getTotalMyApprovalCount(Map<String, String> paraMap);
	
	// 팀 문서 총 페이지수
	int getTotalTeamCount(Map<String, String> paraMap);
	
	// 전체 문서 총 페이지수
	int getTotalAllCount(Map<String, String> paraMap);
	
	// 나의 모든 기안문서 가져오기
	List<Map<String, String>> myDocListSearch(Map<String, String> paraMap);
	
	// 나의 모든 결재 대기 문서 가져오기
	List<Map<String, String>> myNowApprovalListSearch(Map<String, String> paraMap);
	
	// 나의 모든 결재 문서 가져오기
	List<DocVO> allmyAppListSearch(Map<String, String> paraMap);
	
	// 모든 팀 문서 가져오기
	List<DocVO> allteamDocListSearch(Map<String, String> paraMap);
	
	// 관리자가 모든 서류 보기
	List<DocVO> allDocListSearch(Map<String, String> paraMap);
	
	// 나의 기안 문서에서 문서 한 개 보기
	DocVO getOneDocCommon(Map<String, String> paraMap);

	// 회의록 문서 한 개 보기
	MinutesVO getOneMinutes(Map<String, String> paraMap);
	
	// 연차신청서 문서 한 개 보기
	DayoffVO getOneDayoff(Map<String, String> paraMap);
	
	// 결재라인 정보 가져오기
	List<ApprovalVO> getApprovalList(Map<String, String> paraMap);

	// 첨부 파일 목록 가져오기
	List<DocfileVO> getDocfiletList(String doc_no);

	// 첨부 파일 다운로드
	DocfileVO getDocfileOne(String fileNo);

	// 결재하기 눌렀을 떄 doc테이블 업데이트 하기
	void updateDocOk(Map<String, Object> paraMap);
	
	// 결재하기 눌렀을 떄 결재 테이블 업데이트 하기
	void updateApprovalOk(Map<String, Object> paraMap);

	// 결재하기 눌렀을 떄 employees 테이블 업데이트 하기
	void updateAnnualLeave(Map<String, Object> paraMap);
	
	// 반려하기 눌렀을 떄 doc테이블 업데이트 하기
	void updateDocReject(Map<String, String> paraMap);

	// 반려하기 눌렀을 떄 결재 테이블 업데이트 하기
	void updateApprovalReject(Map<String, String> paraMap);

	// 서명 이미지 업데이트
	int updateSignImg(Map<String, String> paraMap);
















	
}