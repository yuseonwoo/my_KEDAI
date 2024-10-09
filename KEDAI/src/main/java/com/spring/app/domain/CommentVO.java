package com.spring.app.domain;

public class CommentVO {

	public String comment_seq;
	public String fk_community_seq;
	public String fk_empid;          
	public String name;              
	public String content;           
	public String registerday;       
	public String status;
	
	// select 용
	private String nickname;
	
	///////////////////////////////////////////////////////////////	
		
	// getters & setters
	public String getComment_seq() {
		return comment_seq;
	}
	
	public void setComment_seq(String comment_seq) {
		this.comment_seq = comment_seq;
	}
	
	public String getFk_community_seq() {
		return fk_community_seq;
	}
	
	public void setFk_community_seq(String fk_community_seq) {
		this.fk_community_seq = fk_community_seq;
	}
	
	public String getFk_empid() {
		return fk_empid;
	}
	
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getRegisterday() {
		return registerday;
	}
	
	public void setRegisterday(String registerday) {
		this.registerday = registerday;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}  
	
}
