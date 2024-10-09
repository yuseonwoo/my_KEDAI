package com.spring.app.domain;

public class SalaryVO {
	
	private String salary_seq;
	private String fk_empid;
	private String payment_date;
	private int work_day;
	private int work_day_plus;
	private String base_salary;
	private String meal_pay;
	private String annual_pay;
	private String overtime_pay;
	private String income_tax;
	private String local_income_tax;
	private String national_pen;
	private String health_ins;
	private String employment_ins;
	
	
	public String getSalary_seq() {
		return salary_seq;
	}
	public void setSalary_seq(String salary_seq) {
		this.salary_seq = salary_seq;
	}
	public String getFk_empid() {
		return fk_empid;
	}
	public void setFk_empid(String fk_empid) {
		this.fk_empid = fk_empid;
	}
	public String getPayment_date() {
		return payment_date;
	}
	public void setPayment_date(String payment_date) {
		this.payment_date = payment_date;
	}
	public int getWork_day() {
		return work_day;
	}
	public void setWork_day(int work_day) {
		this.work_day = work_day;
	}
	public int getWork_day_plus() {
		return work_day_plus;
	}
	public void setWork_day_plus(int workday) {
		this.work_day_plus = workday;
	}
	public String getBase_salary() {
		return base_salary;
	}
	public void setBase_salary(String base_salary) {
		this.base_salary = base_salary;
	}
	public String getMeal_pay() {
		return meal_pay;
	}
	public void setMeal_pay(String meal_pay) {
		this.meal_pay = meal_pay;
	}
	public String getAnnual_pay() {
		return annual_pay;
	}
	public void setAnnual_pay(String annual_pay) {
		this.annual_pay = annual_pay;
	}
	public String getOvertime_pay() {
		return overtime_pay;
	}
	public void setOvertime_pay(String overtime_pay) {
		this.overtime_pay = overtime_pay;
	}
	public String getIncome_tax() {
		return income_tax;
	}
	public void setIncome_tax(String income_tax) {
		this.income_tax = income_tax;
	}
	public String getLocal_income_tax() {
		return local_income_tax;
	}
	public void setLocal_income_tax(String local_income_tax) {
		this.local_income_tax = local_income_tax;
	}
	public String getNational_pen() {
		return national_pen;
	}
	public void setNational_pen(String national_pen) {
		this.national_pen = national_pen;
	}
	public String getHealth_ins() {
		return health_ins;
	}
	public void setHealth_ins(String health_ins) {
		this.health_ins = health_ins;
	}
	public String getEmployment_ins() {
		return employment_ins;
	}
	public void setEmployment_ins(String employment_ins) {
		this.employment_ins = employment_ins;
	}
}
