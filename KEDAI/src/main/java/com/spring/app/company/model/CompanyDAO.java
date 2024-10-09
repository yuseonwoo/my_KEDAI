package com.spring.app.company.model;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

public interface CompanyDAO {
	
	// 거래처 사업자등록번호 이미 있는지 중복확인
	String partnerNoDuplicateCheck(String partner_no);

	// 거래처 정보 등록하기
	int othercomRegister_submit(PartnerVO partvo);
	
	// 거래처 정보 수정하기
	int othercomModify_submit(PartnerVO partvo);
	
	// 거래처 정보 가져오기
	List<PartnerVO> otherCom_list_select();
	
	PartnerVO otherCom_get_select(String partner_no);

	// 거래처 상세보기 어떤거 선택했는지 알아오기
	List<PartnerVO> partnerPopupClick(String partner_no);
	
	// 거래처 삭제하기(삭제할 거래처 사업자 번호 가져오기)
	int delPartnerNo(String partner_no);

	// 총 페이지 건수 (TotalCount) 구하기
	int getTotalCount(Map<String, String> paraMap);
	
	// 글목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	List<PartnerVO> PartnerListSearch_withPaging(Map<String, String> paraMap);
	
	// 검색어 입력 시 자동글 완성하기 
	List<String> wordSearchShowJSON(Map<String, String> paraMap);


	
	
	
	

}
