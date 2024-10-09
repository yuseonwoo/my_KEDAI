package com.spring.app.domain;

public class CommunityFileVO {

	public String file_seq;          
	public String fk_community_seq;      
	public String orgfilename;      
	public String filename;         
	public String filesize;
	
	// getters & setters
	public String getFile_seq() {
		return file_seq;
	}
	
	public void setFile_seq(String file_seq) {
		this.file_seq = file_seq;
	}
	
	public String getFk_community_seq() {
		return fk_community_seq;
	}
	
	public void setFk_community_seq(String fk_community_seq) {
		this.fk_community_seq = fk_community_seq;
	}
	
	public String getOrgfilename() {
		return orgfilename;
	}
	
	public void setOrgfilename(String orgfilename) {
		this.orgfilename = orgfilename;
	}
	
	public String getFilename() {
		return filename;
	}
	
	public void setFilename(String filename) {
		this.filename = filename;
	}
	
	public String getFilesize() {
		return filesize;
	}
	
	public void setFilesize(String filesize) {
		this.filesize = filesize;
	}
	
}
