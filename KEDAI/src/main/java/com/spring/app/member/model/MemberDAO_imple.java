package com.spring.app.member.model;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.MemberVO;

@Repository
public class MemberDAO_imple implements MemberDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	@Override
	public MemberVO getLoginMember(Map<String, String> paraMap) {
		MemberVO loginuser = sqlsession.selectOne("member.getLoginMember", paraMap);
		return loginuser;
	}

	@Override
	public void insert_tbl_loginhistory(Map<String, String> paraMap) {
		sqlsession.insert("member.insert_tbl_loginhistory", paraMap);	
	}

	@Override
	public String idFind(Map<String, String> paraMap) {
		String empId = sqlsession.selectOne("member.idFind", paraMap);
		return empId;
	}

	@Override
	public String pwdFind(Map<String, String> paraMap) {
		String empPwd = sqlsession.selectOne("member.pwdFind", paraMap);
		return empPwd;
	}

	@Override
	public int pwdUpdateEnd(Map<String, String> paraMap) {
		int n = sqlsession.update("member.pwdUpdateEnd", paraMap);
		return n;
	}

	@Override
	public int memberEditEnd(Map<String, String> paraMap) {
		int n = sqlsession.update("member.memberEditEnd", paraMap);
		return n;
	}
	
	@Override
	public int pointUpdate(Map<String, String> paraMap) {
		int n = sqlsession.update("member.pointUpdate", paraMap);
		return n;
	} 
	
}
