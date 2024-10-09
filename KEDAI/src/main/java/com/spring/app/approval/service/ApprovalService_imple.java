package com.spring.app.approval.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.approval.model.ApprovalDAO;
import com.spring.app.domain.ApprovalVO;
import com.spring.app.domain.DayoffVO;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.DocVO;
import com.spring.app.domain.DocfileVO;
import com.spring.app.domain.MinutesVO;

@Service
public class ApprovalService_imple implements ApprovalService {
	
	// === #34. 의존객체 주입하기(DI: Dependency Injection) ===
	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private ApprovalDAO dao;
	// Type 에 따라 Spring 컨테이너가 알아서 bean 으로 등록된 com.spring.board.model.BoardDAO_imple 의 bean 을  dao 에 주입시켜준다. 
	// 그러므로 dao 는 null 이 아니다.

	// 새로운 기안 서류 작성 시 작성자의 부서 이름 가져오기
	@Override
	public String getDeptNumber(Map<String, String> paraMap) {
		String deptNumber = dao.getDeptNumber(paraMap);
		return deptNumber;
	}


	// 현재 근무중인 사원이 있는 모든 부서 가져오기
	@Override
	public List<DeptVO> allDeptList() {
		List<DeptVO> allDeptList = dao.allDeptList();
		return allDeptList;
	}
	
	// 해당 부서에 근무중인 사원 정보 가져오기
	@Override
	public List<Map<String, String>> deptEmpList(Map<String, String> paraMap) {
		List<Map<String, String>> deptEmpList = dao.deptEmpList(paraMap);
		return deptEmpList;
	}
	
	// 첨부파일이 없는 게시판 글쓰기
	@Override
	public int noFile_doc(Map<String, Object> paraMap) {
		
		int n1 = dao.noFile_newdoc(paraMap);
		int n2 = 0;
		int n3 = 0;
		
		if("101".equals(paraMap.get("fk_doctype_code"))) {
			n2 = dao.noFile_minutes(paraMap);
		}
		else if("100".equals(paraMap.get("fk_doctype_code"))) {
			n2 = dao.noFile_dayoff(paraMap);
		}
		
		int lineNumber =(Integer) paraMap.get("lineNumber");
		
		for(int i=1; i<lineNumber+1; i++) {
			String level_no_key = "level_no_" + i;
			String level_no_value = (String) paraMap.get(level_no_key);
			
			paraMap.put("level_no", i);
			paraMap.put("empId", level_no_value);			
			
			n3 = dao.noFile_approval(paraMap);
			
			if(n3 != 1) {
				n3=0;
				break;
			}
		}
		
		int result = n1*n2*n3;
		return result;
	}
	
	// 첨부파일이 있을 때 첨부파일 insert하기
	@Override
	public int withFile_doc(Map<String, String> docFileMap) {
		int n = dao.withFile_doc(docFileMap);
		return n;
	}


		
	// doc_no와 approval_noSeq의 시퀀스 채번해오기
	@Override
	public Map<String, String> getDocSeq() {
		String doc_noSeq = dao.getDoc_noSeq();
		String approval_noSeq = dao.getApproval_noSeq();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("doc_noSeq", doc_noSeq);
		paraMap.put("approval_noSeq", approval_noSeq);
		
		return paraMap;
	}

	// 서류 목록 가져오기
/*	@Override
	public List<Map<String, String>> myDocList(String loginEmpId) {
		List<Map<String, String>> myDocList = dao.myDocList(loginEmpId);
		return myDocList;
	}*/
	
	// 메인화면에 보여줄 기안문서 목록 가져오기
	@Override
	public List<DocVO> docListNoSearch(String loginEmpId) {
		List<DocVO> docListNoSearch = dao.docListNoSearch(loginEmpId);
	/*	List<Map<String, String>> myApprovalDoc = dao.myApprovalDoc(loginEmpId);
		
		List<Map<String, String>> resultList = new ArrayList<>();
	    resultList.addAll(myDocList);
	    resultList.addAll(myApprovalDoc);
	  */
		
		return docListNoSearch;
	}

	// 결재 할 문서의 정보 가져오기
	@Override
	public List<Map<String, String>> myapprovalinfo(String loginEmpId) {
		List<Map<String, String>> myapprovalinfo = dao.myapprovalinfo(loginEmpId);
		
		return myapprovalinfo;
	}

	// 나의 기안 문서에서 총 페이지 수 가져오기
	@Override
	public int getTotalMyDocCount(Map<String, String> paraMap) {
		int n = dao.getTotalMyDocCount(paraMap);
		return n;
	}

	// 나의 결재 예정 문서에서 총 페이지수 가져오기
	@Override
	public int getTotalMyNowApprovalCount(Map<String, String> paraMap) {
		int n = dao.getTotalMyNowApprovalCount(paraMap);
		return n;
	}
	
	// 나의 모든 결재 문서 총 페이지수
	@Override
	public int getTotalMyApprovalCount(Map<String, String> paraMap) {
		int n = dao.getTotalMyApprovalCount(paraMap);
		return n;
	}
	
	// 팀 문서 총 페이지수
	@Override
	public int getTotalTeamCount(Map<String, String> paraMap) {
		int n = dao.getTotalTeamCount(paraMap);
		return n;
	}

	// 전체 문서 총 페이지수
	@Override
	public int getTotalAllCount(Map<String, String> paraMap) {
		int n = dao.getTotalAllCount(paraMap);
		return n;
	}
	
	// 나의 모든 기안문서 가져오기
	@Override
	public List<Map<String, String>> myDocListSearch(Map<String, String> paraMap) {
		List<Map<String, String>> myDocListSearch = dao.myDocListSearch(paraMap);
		return myDocListSearch;
	}
	
	// 나의 모든 결재 예정 문서 가져오기
	@Override
	public List<Map<String, String>> myNowApprovalListSearch(Map<String, String> paraMap) {
		List<Map<String, String>> myNowApprovalListSearch = dao.myNowApprovalListSearch(paraMap);
		return myNowApprovalListSearch;
	}
	
	// 나의 모든 결재 문서 가져오기
	@Override
	public List<DocVO> allmyAppListSearch(Map<String, String> paraMap) {
		List<DocVO> allmyAppListSearch = dao.allmyAppListSearch(paraMap);
		return allmyAppListSearch;
	}

	// 모든 팀 문서 가져오기
	@Override
	public List<DocVO> allteamDocListSearch(Map<String, String> paraMap) {
		List<DocVO> allteamDocListSearch = dao.allteamDocListSearch(paraMap);
		return allteamDocListSearch;
	}

	// 관리자가 모든 서류 보기
	@Override
	public List<DocVO> allDocListSearch(Map<String, String> paraMap) {
		List<DocVO> allDocListSearch = dao.allDocListSearch(paraMap);
		return allDocListSearch;
	}

	// 나의 기안 문서에서 문서 한 개 보기(공통부분 + 결재라인 + 문서종류별 내용)
	@Override
	public DocVO getOneDoc(Map<String, String> paraMap) {
		DocVO docvo = dao.getOneDocCommon(paraMap);
		
		if(docvo != null) {
			List<ApprovalVO> approvalvoList = dao.getApprovalList(paraMap);
			if(approvalvoList != null) {
				docvo.setApprovalvoList(approvalvoList);
				if(("fk_doctype_code") != null) {
					// 기안종류코드 100:연차신청서 101:회의록 102:야간근무신청
					if("100".equals(paraMap.get("fk_doctype_code"))) {
						DayoffVO dayoffvo = dao.getOneDayoff(paraMap);
						if(dayoffvo != null) {
							docvo.setDayoffvo(dayoffvo);
						}
					}
					else if("101".equals(paraMap.get("fk_doctype_code"))) {
						MinutesVO minutesvo = dao.getOneMinutes(paraMap);
						if(minutesvo != null) {
							docvo.setMinutesvo(minutesvo);
						}
						
					}
					else if("102".equals(paraMap.get("fk_doctype_code"))) {
						
					}
				}
			}
		}
		return docvo;	
	}

	// 첨부 파일 목록 가져오기
	@Override
	public List<DocfileVO> getDocfiletList(String doc_no) {
		List<DocfileVO> getDocfiletList = dao.getDocfiletList(doc_no);
		return getDocfiletList;
	}

	// 첨부 파일 다운로드
	@Override
	public DocfileVO getDocfileOne(String fileNo) {
		DocfileVO getDocfileOne = dao.getDocfileOne(fileNo);
		return getDocfileOne;
	}

	// 결재하기 눌렀을 떄 결재, doc테이블 업데이트 하기
	@Override
	public void updateDocApprovalOk(Map<String, Object> paraMap) {
		dao.updateApprovalOk(paraMap); // tbl_approval업데이트
		dao.updateDocOk(paraMap); // tbl_doc업데이트
		
		Object annualLeaveUpdate = paraMap.get("annualLeaveUpdate");
		
		if(annualLeaveUpdate.equals("true")) {
			dao.updateAnnualLeave(paraMap); // tbl_employees 업데이트
		}
	}

	// 반려하기 눌렀을 떄 결재, doc테이블 업데이트 하기
	@Override
	public void updateDocApprovalReject(Map<String, String> paraMap) {
		dao.updateApprovalReject(paraMap); // tbl_approval업데이트
		dao.updateDocReject(paraMap); // tbl_doc업데이트
	}

	// 서명 이미지 업데이트
	@Override
	public int updateSignImg(Map<String, String> paraMap) {
		int n = dao.updateSignImg(paraMap); // tbl_employees 서명 이미지 업데이트
		return n;
	}

}