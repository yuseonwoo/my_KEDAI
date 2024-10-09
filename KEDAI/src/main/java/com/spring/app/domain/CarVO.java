package com.spring.app.domain;

import org.springframework.web.multipart.MultipartFile;

public class CarVO {
	private int car_seq;
	private String fk_empid;
	private String car_num;
	private String car_type;
	private int max_num;
	private int insurance;
	private String drive_year;
	private String license;


	private String car_imgfilename;
	private String car_orgimgfilename;
	
	// form 태그에서 type="file" 인 파일을 받아서 저장되는 필드
	private MultipartFile attach; 
	
	public int getCar_seq() {
		return car_seq;
	}



	public void setCar_seq(int car_seq) {
		this.car_seq = car_seq;
	}
	public String getFk_empid() {
		return fk_empid;
	}
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}
	public String getCar_num() {
		return car_num;
	}
	public void setCar_num(String car_num) {
		this.car_num = car_num;
	}
	public String getCar_type() {
		return car_type;
	}
	public void setCar_type(String car_type) {
		this.car_type = car_type;
	}
	public int getMax_num() {
		return max_num;
	}
	public void setMax_num(int max_num) {
		this.max_num = max_num;
	}
	public int getInsurance() {
		return insurance;
	}
	public void setInsurance(int insurance) {
		this.insurance = insurance;
	}
	public String getDrive_year() {
		return drive_year;
	}
	public void setDrive_year(String drive_year) {
		this.drive_year = drive_year;
	}
	public MultipartFile getAttach() {
		return attach;
	}
	public void setAttach(MultipartFile attach) {
		this.attach = attach;
	}
	
	public String getCar_imgfilename() {
		return car_imgfilename;
	}

	public void setCar_imgfilename(String car_imgfilename) {
		this.car_imgfilename = car_imgfilename;
	}

	public String getCar_orgimgfilename() {
		return car_orgimgfilename;
	}

	public void setCar_orgimgfilename(String car_orgimgfilename) {
		this.car_orgimgfilename = car_orgimgfilename;
	}
	public String getLicense() {
		return license;
	}



	public void setLicense(String license) {
		this.license = license;
	}
}
