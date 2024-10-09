package com.spring.app.domain;

public class BusVO {
	
	private String bus_no;
	private String pf_station_id;
	private String first_time;
	private String last_time;
	private int time_gap;
	
	private String pk_station_id;
	private String station_name;
	private double lat;
	private double lng;
	private String way;
	private int zindex;
	private int minutes_until_next_bus;
	

	public int getZindex() {
		return zindex;
	}
	public void setZindex(int zindex) {
		this.zindex = zindex;
	}
	public String getBus_no() {
		return bus_no;
	}
	public void setBus_no(String bus_no) {
		this.bus_no = bus_no;
	}
	public String getPf_station_id() {
		return pf_station_id;
	}
	public void setPf_station_id(String pf_station_id) {
		this.pf_station_id = pf_station_id;
	}
	public String getFirst_time() {
		return first_time;
	}
	public void setFirst_time(String first_time) {
		this.first_time = first_time;
	}
	public String getLast_time() {
		return last_time;
	}
	public void setLast_time(String last_time) {
		this.last_time = last_time;
	}
	public int getTime_gap() {
		return time_gap;
	}
	public void setTime_gap(int time_gap) {
		this.time_gap = time_gap;
	}
	public String getPk_station_id() {
		return pk_station_id;
	}
	public void setPk_station_id(String pk_station_id) {
		this.pk_station_id = pk_station_id;
	}
	public String getStation_name() {
		return station_name;
	}
	public void setStation_name(String station_name) {
		this.station_name = station_name;
	}
	public double getLat() {
		return lat;
	}
	public void setLat(double lat) {
		this.lat = lat;
	}
	public double getLng() {
		return lng;
	}
	public void setLng(double lng) {
		this.lng = lng;
	}
	public String getWay() {
		return way;
	}
	public void setWay(String way) {
		this.way = way;
	}
	public int getMinutes_until_next_bus() {
		return minutes_until_next_bus;
	}
	public void setMinutes_until_next_bus(int minutes_until_next_bus) {
		this.minutes_until_next_bus = minutes_until_next_bus;
	}
	
	

	
	
}
