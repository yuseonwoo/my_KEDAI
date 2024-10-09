package com.spring.app.domain;

public class DocfileVO {
	
	private String doc_file_no;    			//결재번호 
	private String fk_doc_no;    			//기안문서번호 
	private String doc_org_filename;    	
	private String doc_filename;    			
	private String doc_filesize;    
	

	public String getDoc_file_no() {
		return doc_file_no;
	}
	public void setDoc_file_no(String doc_file_no) {
		this.doc_file_no = doc_file_no;
	}
	
	public String getFk_doc_no() {
		return fk_doc_no;
	}
	public void setFk_doc_no(String fk_doc_no) {
		this.fk_doc_no = fk_doc_no;
	}
	
	public String getDoc_org_filename() {
		return doc_org_filename;
	}
	public void setDoc_org_filename(String doc_org_filename) {
		this.doc_org_filename = doc_org_filename;
	}
	
	public String getDoc_filename() {
		return doc_filename;
	}
	public void setDoc_filename(String doc_filename) {
		this.doc_filename = doc_filename;
	}
	
	public String getDoc_filesize() {
		return doc_filesize;
	}
	public void setDoc_filesize(String doc_filesize) {
		this.doc_filesize = doc_filesize;
	}

}
