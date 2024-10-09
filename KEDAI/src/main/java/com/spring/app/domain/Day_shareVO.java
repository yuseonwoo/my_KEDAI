package com.spring.app.domain;

public class Day_shareVO {
	private int res_num;
	private int fk_car_seq;
	private String start_date;
	private String last_date;
	private String start_time;

	private String dp_name;
	private String dp_add;
	private double dp_lat;
	private double dp_lng;
	private String ds_name;
	private String ds_add;
	private double ds_lat;
	private double ds_lng;
	private int want_max;
	private int end_status;
	private int cancel_status;
	private int total_calculate;
	private int total_pay;
	private int total_nonpay;
	
	
	/////////////select 용/////////////
	private String nickname;
	private int readCount;
	
	public int getRes_num() {
		return res_num;
	}
	public void setRes_num(int res_num) {
		this.res_num = res_num;
	}
	public int getFk_car_seq() {
		return fk_car_seq;
	}
	public void setFk_car_seq(int fk_car_seq) {
		this.fk_car_seq = fk_car_seq;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getLast_date() {
		return last_date;
	}
	public void setLast_date(String last_date) {
		this.last_date = last_date;
	}
	public String getDp_name() {
		return dp_name;
	}
	public void setDp_name(String dp_name) {
		this.dp_name = dp_name;
	}
	public String getDp_add() {
		return dp_add;
	}
	public void setDp_add(String dp_add) {
		this.dp_add = dp_add;
	}
	public double getDp_lat() {
		return dp_lat;
	}
	public void setDp_lat(double dp_lat) {
		this.dp_lat = dp_lat;
	}
	public double getDp_lng() {
		return dp_lng;
	}
	public void setDp_lng(double dp_lng) {
		this.dp_lng = dp_lng;
	}
	public String getDs_name() {
		return ds_name;
	}
	public void setDs_name(String ds_name) {
		this.ds_name = ds_name;
	}
	public String getDs_add() {
		return ds_add;
	}
	public void setDs_add(String ds_add) {
		this.ds_add = ds_add;
	}
	public double getDs_lat() {
		return ds_lat;
	}
	public void setDs_lat(double ds_lat) {
		this.ds_lat = ds_lat;
	}
	public double getDs_lng() {
		return ds_lng;
	}
	public void setDs_lng(double ds_lng) {
		this.ds_lng = ds_lng;
	}
	public int getWant_max() {
		return want_max;
	}
	public void setWant_max(int want_max) {
		this.want_max = want_max;
	}
	public int getEnd_status() {
		return end_status;
	}
	public void setEnd_status(int end_status) {
		this.end_status = end_status;
	}
	public int getCancel_status() {
		return cancel_status;
	}
	public void setCancel_status(int cancel_status) {
		this.cancel_status = cancel_status;
	}
	public int getTotal_calculate() {
		return total_calculate;
	}
	public void setTotal_calculate(int total_calculate) {
		this.total_calculate = total_calculate;
	}
	public int getTotal_pay() {
		return total_pay;
	}
	public void setTotal_pay(int total_pay) {
		this.total_pay = total_pay;
	}
	public int getTotal_nonpay() {
		return total_nonpay;
	}
	public void setTotal_nonpay(int total_nonpay) {
		this.total_nonpay = total_nonpay;
	}

	public String getStart_time() {
		return start_time;
	}
	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}
	
	///////////////////////////////////////////////////////////////////
	
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public int getReadCount() {
		return readCount;
	}
	public void setReadCount(int readCount) {
		this.readCount = readCount;
	}
	
	
}
