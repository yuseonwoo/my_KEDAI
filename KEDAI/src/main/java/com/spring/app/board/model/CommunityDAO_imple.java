package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.domain.CommentVO;
import com.spring.app.domain.CommunityCategoryVO;
import com.spring.app.domain.CommunityFileVO;
import com.spring.app.domain.CommunityVO;

@Repository
public class CommunityDAO_imple implements CommunityDAO {

	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;

	@Override
	public List<CommunityCategoryVO> category_select() {
		List<CommunityCategoryVO> categoryList = sqlsession.selectList("community.category_select");
		return categoryList;
	}

	@Override
	public int getCseqOfCommunity() {
		int community_seq = sqlsession.selectOne("community.getCseqOfCommunity");
		return community_seq;
	}

	@Override
	public int add(CommunityVO cvo) {
		int n = sqlsession.insert("community.add", cvo);
		return n;
	}

	@Override
	public int community_attachfile_insert(Map<String, Object> paraMap) {
		int attach_insert_result = sqlsession.insert("community.community_attachfile_insert", paraMap);
		return attach_insert_result;
	}

	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = sqlsession.selectOne("community.getTotalCount", paraMap);
		return totalCount;
	}

	@Override
	public List<CommunityVO> communityListSearch_withPaging(Map<String, String> paraMap) {
		List<CommunityVO> communityList = sqlsession.selectList("community.communityListSearch_withPaging", paraMap);
		return communityList;
	}

	@Override
	public List<String> wordSearchShow(Map<String, String> paraMap) {
		List<String> wordList = sqlsession.selectList("community.wordSearchShow", paraMap);
		return wordList;
	}

	@Override
	public CommunityVO getView(Map<String, String> paraMap) {
		CommunityVO cvo = sqlsession.selectOne("community.getView", paraMap);
		return cvo;
	}

	@Override
	public int increase_readCount(String community_seq) {
		int n = sqlsession.update("community.increase_readCount", community_seq);
		return n;
	}

	@Override
	public List<CommunityFileVO> getAttachFileList(String fk_community_seq) {
		List<CommunityFileVO> attachFileList = sqlsession.selectList("community.getAttachFileList", fk_community_seq);
		return attachFileList;
	}
	
	@Override
	public CommunityFileVO getFilename(Map<String, String> paraMap) {
		CommunityFileVO cfvo = sqlsession.selectOne("community.getFilename", paraMap);
		return cfvo;
	}
	
	@Override
	public int community_attachfile_delete(String community_seq) {
		int attach_delete_result = sqlsession.delete("community.community_attachfile_delete", community_seq);
		return attach_delete_result;
	}
	
	@Override
	public int edit(CommunityVO cvo) {
		int n = sqlsession.update("community.edit", cvo);
		return n;
	}
	
	@Override
	public int del(String fk_community_seq) {
		int  n = sqlsession.delete("community.del", fk_community_seq);
		return n;
	}
	
	@Override
	public int addComment(CommentVO commentvo) {
		int n = sqlsession.insert("community.addComment", commentvo);
		return n;
	}

	@Override
	public int updateCommentCount(String fk_community_seq) {
		int n = sqlsession.update("community.updateCommentCount", fk_community_seq);
		return n;
	}

	@Override
	public int updateMemberPoint(Map<String, String> paraMap) {
		int result = sqlsession.update("community.updateMemberPoint", paraMap);
		return result;
	}

	@Override
	public List<CommentVO> getCommentList_Paging(Map<String, String> paraMap) {
		List<CommentVO> commentList = sqlsession.selectList("community.getCommentList_Paging", paraMap);
		return commentList;
	}

	@Override
	public int getCommentTotalCount(String fk_community_seq) {
		int totalCount = sqlsession.selectOne("community.getCommentTotalCount", fk_community_seq);
		return totalCount;
	}

	@Override
	public int updateComment(Map<String, String> paraMap) {
		int n = sqlsession.update("community.updateComment", paraMap);
		return n;
	}

	@Override
	public int deleteComment(String comment_seq) {
		int n = sqlsession.delete("community.deleteComment", comment_seq);
		return n;
	}

	@Override
	public int updateCommentCount_decrease(String fk_community_seq) {
		int m = sqlsession.update("community.updateCommentCount_decrease", fk_community_seq);
		return m;
	}

	@Override
	public int likeAdd(Map<String, String> paraMap) {
		int n = 0;
		
		try {
			 n = sqlsession.insert("community.likeAdd", paraMap);
		} catch(Exception e) {}
		
		return n;
	}

	@Override
	public int likeMinus(Map<String, String> paraMap) {
		int n = sqlsession.delete("community.likeMinus", paraMap);
		return n;
	}

}
