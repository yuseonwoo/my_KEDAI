package com.spring.app.company.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.spring.app.company.model.CompanyDAO;
import com.spring.app.domain.MemberVO;
import com.spring.app.domain.PartnerVO;

@Service
public class CompanyService_imple implements CompanyService{
	
	@Autowired
	private CompanyDAO dao;
	
	// 거래처 사업자등록번호 이미 있는지 중복확인
	@Override
	public String partnerNoDuplicateCheck(String partner_no) {
		
		String searchPartnerNo = dao.partnerNoDuplicateCheck(partner_no);
		
		return searchPartnerNo;
	}
	
	// 거래처 정보 등록하기
	@Override
	public int othercomRegister_submit(PartnerVO partvo) {
		int n = dao.othercomRegister_submit(partvo);
		return n;
	}

	// 거래처 정보 수정하기
	@Override
	public int othercomModify_submit(PartnerVO partvo) {
		int n = dao.othercomModify_submit(partvo);
		return n;
	}

	// 거래처 정보 가져오기
	@Override
	public List<PartnerVO> otherCom_list_select() {
		List<PartnerVO> partnervoList = dao.otherCom_list_select();
		return partnervoList;
	}

	// 거래처 상세보기 팝업 어떤것 클릭했는지 알아오기 
	@Override
	public PartnerVO otherCom_get_select(String partner_no) {
		PartnerVO parterVO = dao.otherCom_get_select(partner_no);
		
		return parterVO;
	}
	
	// 거래처 상세보기 팝업 어떤것 클릭했는지 알아오기 
	@Override
	public List<PartnerVO> partnerPopupClick(PartnerVO partvo) {
	//	System.out.println("test " +partvo.getPartner_name());
		List<PartnerVO> partnerList = dao.partnerPopupClick(partvo.getPartner_name());
		return partnerList;
	}
	
	// 거래처 삭제하기 
	@Override
	public int delPartnerNo(String partner_no, String rootPath) {
		PartnerVO partnerVO = dao.otherCom_get_select(partner_no);
		// file delete
		String path = getPartnerImagePath(rootPath);
		new File(path + File.separator + partnerVO.getImgfilename()).delete();

		
		int n = dao.delPartnerNo(partner_no);
		
		return n;
	}

	@Override
	public String getPartnerImagePath(String rootPath) {
		String path = rootPath+"resources"+File.separator+"files"+File.separator+"company";
		// System.out.println(path);
		// C:\NCS\workspace_spring_framework\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\KEDAI\resources\files
					
		return path;
	}

	// 총 페이지 건수 (TotalCount) 구하기
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}
	
	// 글목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	@Override
	public List<PartnerVO> PartnerListSearch_withPaging(Map<String, String> paraMap) {
		List<PartnerVO> partnerList = dao.PartnerListSearch_withPaging(paraMap);
		return partnerList;
	}
	
	// 검색어 입력 시 자동글 완성하기 
	@Override
	public List<String> wordSearchShowJSON(Map<String, String> paraMap) {
		
		List<String> wordList = dao.wordSearchShowJSON(paraMap);
		return wordList;
	}
	


	



	
	
	
}	
	