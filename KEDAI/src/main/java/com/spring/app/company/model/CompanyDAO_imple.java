package com.spring.app.company.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import com.spring.app.company.service.CompanyService;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

@Repository
public class CompanyDAO_imple implements CompanyDAO{
	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	
	// 거래처 사업자등록번호 이미 있는지 중복확인
	@Override
	public String partnerNoDuplicateCheck(String partner_no) {
		String searchPartnerNo = sqlsession.selectOne("company.partnerNoDuplicateCheck", partner_no);
		
		return searchPartnerNo;
	}
	
	
	// 거래처 정보 등록하기
	@Override
	public int othercomRegister_submit(PartnerVO partvo) {
		int n = sqlsession.insert("company.othercomRegister_submit",partvo);
		return n;
	}
	
	// 거래처 정보 등록하기
	@Override
	public int othercomModify_submit(PartnerVO partvo) {
		int n = sqlsession.update("company.othercomModify_submit",partvo);
		return n;
	}
	
	// 거래처 정보  조회하기
	@Override
	public List<PartnerVO> otherCom_list_select() {
		List<PartnerVO> partnervoList = sqlsession.selectList("company.otherCom_list_select");
		
		return partnervoList;
	}
	
	// 거래처 상세보기 어떤거 선택했는지 알아오기
	@Override
	public PartnerVO otherCom_get_select(String partner_no) {
		PartnerVO partnerVO = sqlsession.selectOne("company.otherCom_get_select", partner_no);
		
		return partnerVO;
	}

	// 거래처 상세보기 어떤거 선택했는지 알아오기
	@Override
	public List<PartnerVO> partnerPopupClick(String partner_name) {
		List<PartnerVO> partnerList = sqlsession.selectList("company.partnerPopupClick", partner_name);
	//	System.out.println("asd" + partnervoList.toString());
		return partnerList;
	}

	// 삭제할 거래처 사업자 번호 알아오기
	@Override
	public int delPartnerNo(String partner_no) {
		
		int n = sqlsession.delete("company.delPartnerNo",partner_no);
		return n;
	}

	// 총 페이지 건수 (TotalCount) 구하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int totalCount = sqlsession.selectOne("company.getTotalCount",paraMap);
		
		return totalCount;
	}

	// 글목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	@Override
	public List<PartnerVO> PartnerListSearch_withPaging(Map<String, String> paraMap) {
		
		List<PartnerVO> partnerList = sqlsession.selectList("company.PartnerListSearch_withPaging", paraMap);
		
		return partnerList;
	}

	// 검색어 입력 시 자동글 완성하기 
	@Override
	public List<String> wordSearchShowJSON(Map<String, String> paraMap) {
		
		List<String> wordList = sqlsession.selectList("company.wordSearchShowJSON", paraMap);
		
		return wordList;
	}


	
	
	
	
	
	
	
	
	
}
