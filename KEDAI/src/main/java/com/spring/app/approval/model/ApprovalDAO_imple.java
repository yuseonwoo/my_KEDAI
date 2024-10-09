package com.spring.app.approval.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.ApprovalVO;
import com.spring.app.domain.DayoffVO;
import com.spring.app.domain.DeptVO;
import com.spring.app.domain.DocVO;
import com.spring.app.domain.DocfileVO;
import com.spring.app.domain.MinutesVO;

@Repository 
public class ApprovalDAO_imple implements ApprovalDAO {
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	// /board/src/main/webapp/WEB-INF/spring/root-context.xml 의  bean에서 id가 sqlsession 인 bean을 주입하라는 뜻이다. 
    // 그러므로 sqlsession 는 null 이 아니다.

	// 새로운 기안 서류 작성 시 작성자의 부서 이름 가져오기
	@Override
	public String getDeptNumber(Map<String, String> paraMap) {
		String deptNumber = sqlsession.selectOne("approval.getDeptNumber", paraMap);
		return deptNumber;
	}


	// 결재 라인에서 찾을 모든 사원 목록 보기
	@Override
	public List<Map<String, String>> allEmployeeList(String login_empid) {
		List<Map<String, String>> allEmployeeList = sqlsession.selectList("approval.allEmployeeList", login_empid);
		return allEmployeeList;
	}
	
	// 현재 근무중인 사원이 있는 모든 부서 가져오기
	@Override
	public List<DeptVO> allDeptList() {
		List<DeptVO> allDeptList = sqlsession.selectList("approval.allDeptList");
		return allDeptList;
	}
	
	// 해당 부서에 근무중인 사원 정보 가져오기
	@Override
	public List<Map<String, String>> deptEmpList(Map<String, String> paraMap) {
		List<Map<String, String>> deptEmpList = sqlsession.selectList("approval.deptEmpList", paraMap);		
		return deptEmpList;
	}


	// 첨부파일이 없는 서류 작성하기(tbl_doc)
	@Override
	public int noFile_newdoc(Map<String, Object> paraMap) {
		int n = sqlsession.insert("approval.noFile_newdoc", paraMap);
		return n;
	}

	// 첨부파일이 없는 서류 작성하기(tbl_minutes)
	@Override
	public int noFile_minutes(Map<String, Object> paraMap) {
		int n = sqlsession.insert("approval.noFile_minutes", paraMap);
		return n;
	}

	// 첨부파일이 없는 서류 작성하기(tbl_dayoff)
	@Override
	public int noFile_dayoff(Map<String, Object> paraMap) {
		int n = sqlsession.insert("approval.noFile_dayoff", paraMap);
		return n;
	}

	// 첨부파일이 없는 서류 작성하기(tbl_approval)
	@Override
	public int noFile_approval(Map<String, Object> paraMap) {
		int n = sqlsession.insert("approval.noFile_approval", paraMap);
		return n;
	}
	
	
	// 첨부파일이 있을 때 첨부파일 insert하기
	@Override
	public int withFile_doc(Map<String, String> docFileMap) {
		int n = sqlsession.insert("approval.withFile_doc", docFileMap);
		return n;
	}

	// doc_no의 시퀀스 채번해오기
	@Override
	public String getDoc_noSeq() {
		String doc_noSeq = sqlsession.selectOne("approval.getDoc_noSeq");
		return doc_noSeq;
	}

	// approval_noSeq 시퀀스 채번해오기
	@Override
	public String getApproval_noSeq() {
		String approval_noSeq = sqlsession.selectOne("approval.getApproval_noSeq");
		return approval_noSeq;
	}

	// 메인화면에 보여줄 나의 기안문서 목록 가져오기
	@Override
	public List<DocVO> docListNoSearch(String loginEmpId) {
		List<DocVO> myDocList = sqlsession.selectList("approval.docListNoSearch", loginEmpId);
		return myDocList;
	}

	// 메인화면에 보여줄 나의 결재 문서 목록 가져오기
/*	@Override
	public List<Map<String, String>> myApprovalDoc(String loginEmpId) {
		List<Map<String, String>> myApprovalDoc = sqlsession.selectList("approval.myApprovalDoc", loginEmpId);
		return myApprovalDoc;
	}*/

	// 결재 할 문서의 정보 가져오기
	@Override
	public List<Map<String, String>> myapprovalinfo(String loginEmpId) {
		List<Map<String, String>> myapprovalinfo = sqlsession.selectList("approval.myapprovalinfo", loginEmpId);
		return myapprovalinfo;
	}

	// 나의 기안 문서에서 총 페이지 수 가져오기
	@Override
	public int getTotalMyDocCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("approval.getTotalMyDocCount", paraMap);
		return n;
	}
	
	// 나의 결재 예정 문서에서 총 페이지수 가져오기
	@Override
	public int getTotalMyNowApprovalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("approval.getTotalMyNowApprovalCount", paraMap);
		return n;
	}

	// 나의 결재 문서에서 총 페이지수 가져오기
	@Override
	public int getTotalMyApprovalCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("approval.getTotalMyApprovalCount", paraMap);
		return n;
	}
	
	// 팀 문서 총 페이지수
	@Override
	public int getTotalTeamCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("approval.getTotalTeamCount", paraMap);
		return n;
	}

	// 전체 문서 총 페이지수
	@Override
	public int getTotalAllCount(Map<String, String> paraMap) {
		int n = sqlsession.selectOne("approval.getTotalAllCount", paraMap);
		return n;
	}

	// 나의 모든 기안문서 가져오기
	@Override
	public List<Map<String, String>> myDocListSearch(Map<String, String> paraMap) {
		List<Map<String, String>> myDocListSearch = sqlsession.selectList("approval.myDocListSearch", paraMap);
		return myDocListSearch;
	}
	
	// 나의 모든 결재 대기 문서 가져오기
	@Override
	public List<Map<String, String>> myNowApprovalListSearch(Map<String, String> paraMap) {
		List<Map<String, String>> myApprovalListSearch = sqlsession.selectList("approval.myNowApprovalListSearch", paraMap);
		return myApprovalListSearch;
	}

	// 나의 모든 결재 문서 가져오기
	@Override
	public List<DocVO> allmyAppListSearch(Map<String, String> paraMap) {
		List<DocVO> allmyAppListSearch = sqlsession.selectList("approval.allmyAppListSearch", paraMap);
		return allmyAppListSearch;
	}

	// 모든 팀 문서 가져오기
	@Override
	public List<DocVO> allteamDocListSearch(Map<String, String> paraMap) {
		List<DocVO> allteamDocListSearch = sqlsession.selectList("approval.allteamDocListSearch", paraMap);
		return allteamDocListSearch;
	}
	
	// 관리자가 모든 서류 보기
	@Override
	public List<DocVO> allDocListSearch(Map<String, String> paraMap) {
		List<DocVO> allDocListSearch = sqlsession.selectList("approval.allDocListSearch", paraMap);
		return allDocListSearch;
	}
	
	// 나의 기안 문서에서 문서 한 개 보기
	@Override
	public DocVO getOneDocCommon(Map<String, String> paraMap) {
		DocVO getOneDocCommon = sqlsession.selectOne("approval.getOneDocCommon", paraMap);
		return getOneDocCommon;
	}
	
	// 회의록 서류 정보 가져오기
	@Override
	public MinutesVO getOneMinutes(Map<String, String> paraMap) {
		MinutesVO getOneMinutes = sqlsession.selectOne("approval.getOneMinutes", paraMap);
		return getOneMinutes;
	}
	
	// 연차신청 서류 정보 가져오기
	@Override
	public DayoffVO getOneDayoff(Map<String, String> paraMap) {
		DayoffVO getOneDayoff = sqlsession.selectOne("approval.getOneDayoff", paraMap);
		return getOneDayoff;
	}

	// 결재라인 정보 가져오기
	@Override
	public List<ApprovalVO> getApprovalList(Map<String, String> paraMap) {
		List<ApprovalVO> getApprovalList = sqlsession.selectList("approval.getApprovalList", paraMap);
		return getApprovalList;
	}

	// 첨부 파일 목록 가져오기
	@Override
	public List<DocfileVO> getDocfiletList(String doc_no) {
		List<DocfileVO> getDocfiletList = sqlsession.selectList("approval.getDocfiletList", doc_no);
		return getDocfiletList;
	}

	// 첨부 파일 다운로드
	@Override
	public DocfileVO getDocfileOne(String fileNo) {
		DocfileVO getDocfileOne = sqlsession.selectOne("approval.getDocfileOne", fileNo);
		return getDocfileOne;
	}


	// 결재하기 눌렀을 떄 doc테이블 업데이트 하기
	@Override
	public void updateDocOk(Map<String, Object> paraMap) {
		sqlsession.update("approval.updateDocOk", paraMap);
	}

	// 결재하기 눌렀을 떄 결재 테이블 업데이트 하기
	@Override
	public void updateApprovalOk(Map<String, Object> paraMap) {
		sqlsession.update("approval.updateApprovalOk", paraMap);
	}
	
	// 결재하기 눌렀을 떄 employees 테이블 업데이트 하기
	@Override
	public void updateAnnualLeave(Map<String, Object> paraMap) {
		sqlsession.update("approval.updateAnnualLeave", paraMap);
	}


	// 반려하기 눌렀을 떄 doc테이블 업데이트 하기
	@Override
	public void updateDocReject(Map<String, String> paraMap) {
		sqlsession.update("approval.updateDocReject", paraMap);
	}

	// 반려하기 눌렀을 떄 결재 테이블 업데이트 하기
	@Override
	public void updateApprovalReject(Map<String, String> paraMap) {
		sqlsession.update("approval.updateApprovalReject", paraMap);
	}

	// 서명 이미지 업데이트
	@Override
	public int updateSignImg(Map<String, String> paraMap) {
		int n = sqlsession.update("approval.updateSignImg", paraMap);
		return n;
	}









	// 기안종류코드 100:연차신청서 101:회의록 102:야간근무신청
/*	@Override
	public MinutesVO getOneMinutes(Map<String, String> paraMap) {
		MinutesVO getOneMinutes = sqlsession.selectOne("approval.getOneMinutes", paraMap);
		return getOneMinutes;
	}*/

	// 파일 종류 받아오기
/*	@Override
	public List<DocfileVO> getDocfile(Map<String, String> paraMap) {
		List<DocfileVO> docfileVoList = sqlsession.selectOne("approval.getDocfile", paraMap);
		return docfileVoList;
	}
*/


}