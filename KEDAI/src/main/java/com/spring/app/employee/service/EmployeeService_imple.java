package com.spring.app.employee.service;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.apache.commons.collections4.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.spring.app.common.AES256;
import com.spring.app.domain.MemberVO;
import com.spring.app.employee.model.EmployeeDAO;
@Service
public class EmployeeService_imple implements EmployeeService{
	
	@Autowired
	private EmployeeDAO dao;
	
	@Autowired
    private AES256 aES256;
	
	
	
	
	// 직원정보 가져오기
	@Override
	public List<MemberVO> employee_list() {
		List<MemberVO> employeeList = dao.employee_list();
		// 각 직원의 이메일과 모바일 번호 복호화
	    employeeList.forEach(member -> {
	        try {
	            // 암호화된 이메일과 모바일 번호를 복호화
	            String decryptedEmail = aES256.decrypt(member.getEmail());
	            String decryptedMobile = aES256.decrypt(member.getMobile());
	            member.setEmail(decryptedEmail);   // 복호화된 이메일 설정
	            member.setMobile(decryptedMobile); // 복호화된 모바일 번호 설정
	        } catch (UnsupportedEncodingException | GeneralSecurityException e) {
	            e.printStackTrace();
	            // 복호화 실패 시 적절한 처리 (예: 기본값 설정 등)
	            member.setEmail("복호화 오류");
	            member.setMobile("복호화 오류");
	        }
	    });

	    return employeeList;
	}
	
	
	
	
	// 직원정보 가져오기
	/*@Override
	public Page<Map<String,String>> employeeList(String searchType, String searchWord, Pageable pageable) {
		Map<String, String> paraMap = new HashedMap<String, String>();
		if (StringUtils.hasText(searchWord)) {
			paraMap.put("searchType", searchType);
			if ("personal-tel".equals(searchType)) {
				try {
					paraMap.put("searchWord", aES256.encrypt(searchWord.replaceAll("-", "")));
				} catch (UnsupportedEncodingException | GeneralSecurityException e) {
					e.printStackTrace();
				}
			} else {
				paraMap.put("searchWord", searchWord);				
			}
		}
			
		 if (Objects.nonNull(pageable)) { 
		 		paraMap.put("page",
		 		String.valueOf(pageable.getPageNumber() + 1)); 
		 		paraMap.put("size",
		 		String.valueOf(pageable.getPageSize()));
		 }
	
		List<Map<String, String>> employeeList = dao.employeeList(paraMap);
		employeeList.forEach( map -> {
			
			try {			
				map.put("email",(aES256.decrypt(map.get("email"))));   // 복호화되어진 email 을 넣어준다.
				map.put("mobile",(aES256.decrypt(map.get("mobile")))); // 복호화되어진 mobile 을 넣어준다.
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} 
		});

		Long total = dao.employeeListTotal(paraMap);
		Page<Map<String,String>> page = new PageImpl<Map<String,String>>(employeeList, pageable, total);
										
		return page;
	}
	*/
	
	// 총 게시물 건수 구하기 
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		
		int totalCount = dao.getTotalCount(paraMap);
		
		return totalCount;
	}

	// 직원목록 가져오기(페이징처리를 했으며, 검색어가 있는 것 또는 검색어가 없는 것 모두 포함한 것)
	@Override
	public List<MemberVO> employeeListSearch_withPaging(Map<String, String> paraMap) {
		String mobile = null;
		if ("mobile".equals(paraMap.get("searchType"))) {
			mobile = paraMap.get("searchWord");
			try {
				paraMap.put("searchWord", aES256.encrypt(paraMap.get("searchWord").replaceAll("-", "")));
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
		}
		
		List<MemberVO> employeeList = dao.employeeListSearch_withPaging(paraMap);
		
		for(MemberVO map : employeeList) {
			try {
				map.setEmail(aES256.decrypt(map.getEmail()));
				map.setMobile(aES256.decrypt(map.getMobile()));

				
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} 
		}
		
		if ("mobile".equals(paraMap.get("searchType"))) {
			paraMap.put("searchWord", mobile);
		}

		return employeeList;
	}
	
	
	

	
	
	// 직원정보 상세보기 팝업 어떤것 클릭했는지 알아오기(직원 아이디로 가져오기)
	@Override
	public List<Map<String, String>> empDetailList (Map<String, String> paraMap) {
		
		List<Map<String, String>> empDetailList = dao.empDetailList(paraMap);
		//System.out.println("empDetailList : " + empDetailList);
		empDetailList.forEach( map -> {
			
			try {			
				map.put("email",(aES256.decrypt(map.get("email"))));   // 복호화되어진 email 을 넣어준다.
				map.put("mobile",(aES256.decrypt(map.get("mobile")))); // 복호화되어진 mobile 을 넣어준다.
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			} 
		});
		
		return empDetailList;
	}


	// 검색어 입력 시 자동글 완성하기 
	@Override
	public List<String> wordSearchShowJSON(Map<String, String> paraMap) {
			
		List<String> wordList = dao.wordSearchShowJSON(paraMap);
		return wordList;
	}



	






	
	
}	
	