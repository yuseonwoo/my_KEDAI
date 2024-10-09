	package com.spring.app.domain;

public class Car_shareVO {
	private int pf_res_num;
	private String pf_empid;
	private String share_date;
	private String share_may_time;
	private int accept_yon;
	private String reason_nonaccept;
	private String rdp_name;
	private String rdp_add;
	private double rdp_lat;
	private double rdp_lng;
	private String rds_name;
	private String rds_add;
	private double rds_lat;
	private double rds_lng;
	private String getin_time;
	private String getout_time;
	private String use_time;
	private double settled_amount;
	private double payment_amount;
	private double nonpayment_amount;
	
	///// == select용 == /////
	private String nickname;
	private int rno;
	private String email;
	private String nickname_owner;
	private String nickname_applicant;
	private String email_applicant;
	private String empid_owner;
	
	public String getEmpid_owner() {
		return empid_owner;
	}
	public void setEmpid_owner(String empid_owner) {
		this.empid_owner = empid_owner;
	}
	public String getEmail_applicant() {
		return email_applicant;
	}
	public void setEmail_applicant(String email_applicant) {
		this.email_applicant = email_applicant;
	}
	public String getNickname_owner() {
		return nickname_owner;
	}
	public void setNickname_owner(String nickname_owner) {
		this.nickname_owner = nickname_owner;
	}
	public String getNickname_applicant() {
		return nickname_applicant;
	}
	public void setNickname_applicant(String nickname_applicant) {
		this.nickname_applicant = nickname_applicant;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getRno() {
		return rno;
	}
	public void setRno(int rno) {
		this.rno = rno;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public int getPf_res_num() {
		return pf_res_num;
	}
	public void setPf_res_num(int pf_res_num) {
		this.pf_res_num = pf_res_num;
	}
	public String getPf_empid() {
		return pf_empid;
	}
	public void setPf_empid(String pf_empid) {
		this.pf_empid = pf_empid;
	}
	public String getShare_date() {
		return share_date;
	}
	public void setShare_date(String share_date) {
		this.share_date = share_date;
	}
	public String getShare_may_time() {
		return share_may_time;
	}
	public void setShare_may_time(String share_may_time) {
		this.share_may_time = share_may_time;
	}
	public int getAccept_yon() {
		return accept_yon;
	}
	public void setAccept_yon(int accept_yon) {
		this.accept_yon = accept_yon;
	}
	public String getReason_nonaccept() {
		return reason_nonaccept;
	}
	public void setReason_nonaccept(String reason_nonaccept) {
		this.reason_nonaccept = reason_nonaccept;
	}
	public String getRdp_name() {
		return rdp_name;
	}
	public void setRdp_name(String rdp_name) {
		this.rdp_name = rdp_name;
	}
	public String getRdp_add() {
		return rdp_add;
	}
	public void setRdp_add(String rdp_add) {
		this.rdp_add = rdp_add;
	}
	public double getRdp_lat() {
		return rdp_lat;
	}
	public void setRdp_lat(double rdp_lat) {
		this.rdp_lat = rdp_lat;
	}
	public double getRdp_lng() {
		return rdp_lng;
	}
	public void setRdp_lng(double rdp_lng) {
		this.rdp_lng = rdp_lng;
	}
	public String getRds_name() {
		return rds_name;
	}
	public void setRds_name(String rds_name) {
		this.rds_name = rds_name;
	}
	public String getRds_add() {
		return rds_add;
	}
	public void setRds_add(String rds_add) {
		this.rds_add = rds_add;
	}
	public double getRds_lat() {
		return rds_lat;
	}
	public void setRds_lat(double rds_lat) {
		this.rds_lat = rds_lat;
	}
	public double getRds_lng() {
		return rds_lng;
	}
	public void setRds_lng(double rds_lng) {
		this.rds_lng = rds_lng;
	}
	public String getGetin_time() {
		return getin_time;
	}
	public void setGetin_time(String getin_time) {
		this.getin_time = getin_time;
	}
	public String getGetout_time() {
		return getout_time;
	}
	public void setGetout_time(String getout_time) {
		this.getout_time = getout_time;
	}
	public String getUse_time() {
		return use_time;
	}
	public void setUse_time(String use_time) {
		this.use_time = use_time;
	}
	public double getSettled_amount() {
		return settled_amount;
	}
	public void setSettled_amount(double settled_amount) {
		this.settled_amount = settled_amount;
	}
	public double getPayment_amount() {
		return payment_amount;
	}
	public void setPayment_amount(double payment_amount) {
		this.payment_amount = payment_amount;
	}
	public double getNonpayment_amount() {
		return nonpayment_amount;
	}
	public void setNonpayment_amount(double nonpayment_amount) {
		this.nonpayment_amount = nonpayment_amount;
	}
	
	

}
