<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
%>

<style type="text/css">
     a{
        	color: #fff !important;
        }
        
      table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid black;
            vertical-align: middle; /* 수직 정렬을 중앙으로 */
        }
        
        .header {
            font-size: 24px;
            font-weight: bold;
        }
        
        .full-width {
            width: 100%;
            padding: 10px;
            border-top: 1px solid black;
        }
        
        .outer-border {
            border: 3px solid black;
        }
        
        #yearMonth {
            margin-bottom: 1%;
        }
        
        .no-data {
            text-align: center;
            font-style: italic;
            color: red;
        }
        
        /* 열 크기 고정 */
        #salaryDetails td {
            min-width: 150px; /* 열의 최소 너비 설정 */
        }
        
        #salaryDetails tr.total-row td {
            min-width: 150px; /* 총액 및 실지급액을 강조하기 위해 설정 */
        }

        /* 입력 필드를 td처럼 보이게 디자인 */
        .input-field {
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            padding: 0;
            margin: 0;
            font-size: 1em; /* 필요에 따라 조정 */
        }
        
        .input-field:focus {
            outline: none;
        }
        
   
     
</style>

<script type="text/javascript">
    $(document).ready(function(){
        var yearMonth = document.getElementById('yearMonth');
        var selectDateSpan = document.getElementById('selectedDate');
        var empid = $('#empid').val(); // 직원 ID

        // 연도와 월 범위 설정
        var currentYear = new Date().getFullYear();
        var startYear = currentYear - 5;
        var endYear = currentYear + 5;

        // 연도와 월 옵션 생성
        for (var i = startYear; i <= endYear; i++) {
            for (var j = 1; j <= 12; j++) {
                var month = j < 10 ? '0' + j : j;
                var option = document.createElement('option');
                option.value = i + '-' + month; // YYYY-MM 형식
                option.textContent = i + '년 ' + month + '월'; // YYYY년 MM월 형식
                yearMonth.appendChild(option);
            }
        }

        // 페이지 로딩 시 데이터 로드 및 초기 선택값 업데이트
        function loadData() {
            var selectedDate = yearMonth.value; // YYYY-MM 형식

            $.ajax({
                url: '<%= ctxPath %>/getEmployee.kedai',
                type: 'POST',
                data: { empid: empid },
                dataType: 'json',
                success: function(data) {
                    $('#employeeName').text(data.name || '');
                    $('#employeePosition').text(data.job_name || '');
                    $('#employeeDepartment').text(data.department_name || '');
                    $('#employeeHireDate').text(data.hire_date || '');
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching employee data:', error);
                }
            });

            $.ajax({
                url: '<%= ctxPath %>/getSalaryDetails.kedai',
                type: 'POST',
                data: { yearMonth: selectedDate, empid: empid },
                dataType: 'json',
                success: function(data) { 
                	//	console.log(data)
                	
                	var base_salary = data.base_salary;
                	var annual_allowance = data.annual_allowance;
                	var employment_insurance = data.employment_insurance;
                	var health_insurance = data.health_insurance;
                	var income_tax = data.income_tax;
                	var local_income_tax = data.local_income_tax;
                	var meal_allowance = data.meal_allowance;
                	var net_pay = data.net_pay;
                	var overtime_allowance = data.overtime_allowance;
                	var pension = data.pension;
                	var total_deduction = data.total_deduction;
                	var total_income = data.total_income;
                	
                	 if (!data || !data.base_salary) {
                         htmlContent = `<tr><td colspan="4" class="no-data">해당 사항이 없습니다</td></tr>`;
                     }
                	 else{
                		 var htmlContent = `
                			    <tr>
                			        <td>기본급</td>
                			        <td><input type="text" class="input-field" id="base_salary" value="" readonly/></td>
                			        <td>소득세</td>
                			        <td><input type="text" class="input-field" id="income_tax" value="" readonly/></td>
                			    </tr>
                			    <tr>
                			        <td>식대</td>
                			        <td><input type="text" class="input-field" id="meal_allowance" value="" readonly/></td>
                			        <td>지방소득세</td>
                			        <td><input type="text" class="input-field" id="local_income_tax" value="" readonly/></td>
                			    </tr>
                			    <tr>
                			        <td>연차수당</td>
                			        <td><input type="text" class="input-field" id="annual_allowance" value="" readonly/></td>
                			        <td>국민연금</td>
                			        <td><input type="text" class="input-field" id="pension" value="" readonly/></td>
                			    </tr>
                			    <tr>
                			        <td>초과근무수당</td>
                			        <td><input type="text" class="input-field" id="overtime_allowance" value="" readonly/></td>
                			        <td>건강보험</td>
                			        <td><input type="text" class="input-field" id="health_insurance" value="" readonly/></td>
                			    </tr>
                			    <tr>
                			        <td></td>
                			        <td></td>
                			        <td>고용보험</td>
                			        <td><input type="text" class="input-field" id="employment_insurance" value="" readonly/></td>
                			    </tr>
                			    <tr class="total-row">
                			        <td>지급총액</td>
                			        <td><input type="text" class="input-field" id="total_income" value="" readonly/></td>
                			        <td>공제총액</td>
                			        <td><input type="text" class="input-field" id="total_deduction" value="" readonly/></td>
                			    </tr>
                			    <tr class="total-row">
                			        <td colspan="2"></td>
                			        <td>실지급액</td>
                			        <td><input type="text" class="input-field" id="net_pay" value="" readonly/></td>
                			    </tr>
                			`;
	                	
                	 }
                	                	 
                     // HTML 업데이트
                     $('#salaryDetails').html(htmlContent);                	

                     if(base_salary != null){
                     	document.getElementById("base_salary").value = base_salary;
                     	document.getElementById("income_tax").value = income_tax;
                     	document.getElementById("meal_allowance").value = meal_allowance;
                     	document.getElementById("local_income_tax").value = local_income_tax;
                     	document.getElementById("annual_allowance").value = annual_allowance;
                     	document.getElementById("pension").value = pension;
                     	document.getElementById("overtime_allowance").value = overtime_allowance;
                     	document.getElementById("health_insurance").value = health_insurance;
                     	document.getElementById("employment_insurance").value = employment_insurance;
                     	document.getElementById("total_income").value = total_income;
                     	document.getElementById("total_deduction").value = total_deduction;
                     	document.getElementById("net_pay").value = net_pay;
                     }
                     
                },
                error: function(xhr, status, error) {
                    console.error('Error fetching salary details:', error);
                }
            });
        }


        // 페이지 로딩 시 데이터 로드 및 초기 선택값 업데이트
        loadData();

        // 날짜 선택 시 데이터 로드
        yearMonth.addEventListener('change', function() {
            loadData();
        });
        

    });
</script>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">


<div class="container" style="padding: 3%;">
      <button id="downloadExcel" class="btn btn-primary mt-3" style="float: right; margin: 1%;">엑셀 다운로드</button>
      <script src="<%= ctxPath%>/resources/js/salary_excelExport.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/exceljs@4.3.0/dist/exceljs.min.js"></script>
      
    <table class="outer-border">
        <thead>
            <tr>
                <td colspan="3" class="header" style="height:100px;">급여명세서</td>
                <td class="date" style="font-size: 16px; height:100px;">급여지급일 : <span id="dateDetail"><select id="yearMonth"></select> 10일</span></td>
            </tr>
        </thead>
        <tbody style="border: solid 1px black;">
            <tr>
                <td colspan="4" class="full-width" style="background-color: grey;">■ 개인 정보</td>
            </tr>
            <tr>
                <td>이름<input type="hidden" id="empid" value="${sessionScope.loginuser.empid}"></td>
                <td id="employeeName"></td>
                <td>부서</td>
                <td id="employeeDepartment"></td>
            </tr>
            <tr>
                <td>직위</td>
                <td id="employeePosition"></td>
                <td>입사일자</td>
                <td id="employeeHireDate"></td>
            </tr>
            
            <tr>
                <td colspan="4" class="full-width" style="background-color: grey;">■ 세부 내역</td>
            </tr>
            <tbody id="salaryDetails">
                <!-- 초기 데이터 없음 상태 -->
            </tbody>
        </tbody> 
    </table>
</div>

</body>
</html>