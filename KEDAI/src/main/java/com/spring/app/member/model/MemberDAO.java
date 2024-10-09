package com.spring.app.member.model;

import java.util.Map;

import com.spring.app.domain.MemberVO;

public interface MemberDAO {

	// 로그인 처리하기
	MemberVO getLoginMember(Map<String, String> paraMap);

	// tbl_loginhistory 테이블에 로그인 기록 입력하기
	void insert_tbl_loginhistory(Map<String, String> paraMap);

	// 아이디 찾기
	String idFind(Map<String, String> paraMap);

	// 비밀번호 찾기
	String pwdFind(Map<String, String> paraMap);

	// 비밀번호 변경하기
	int pwdUpdateEnd(Map<String, String> paraMap);

	// 나의 정보 수정하기
	int memberEditEnd(Map<String, String> paraMap);
	
	// 포인트 충전하기
	int pointUpdate(Map<String, String> paraMap);

}
