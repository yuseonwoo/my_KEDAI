<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
   String ctxPath = request.getContextPath();
%>


<style type="text/css">
	#myContent > div{
		width: 80%;
		margin-top: 2%;
	}

    table {
        width: 80%;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid black;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #f2f2f2;
    }
    button {
        padding: 1px 20px;
        margin: 0 1px;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }
    .header h1 {
        margin: 0;
    }
    .search {
        fliat: right;
        align-items: center;
        width:30%;
    }
    .search input {
         margin-right: 5px;
         padding: 5px;
         width: 200px;
    }
    
   .modal-dialog {
            max-width: 50%;
        }
        
   .modal-body {
            max-height: 500px; /* 모달의 최대 높이 설정 */
            overflow-y: auto; /* 모달 내용의 세로 스크롤 설정 */
        }
        
	#modal3 > div > div > div.modal-body > table{
		font-size: 10pt;
		margin: 0 auto;
		width: 100%;
	}

   .bold-line {
          background-color: yellow;
    }
	
</style>

<script type="text/javascript">
	$(document).ready(function(){
		loadInitialData();
		const modalClose = document.querySelector('.close_btn');
		
		$("#workdaySmt").click(function(e){	
			if (confirm("저장하시겠습니까?")) {
				salary_submit();
				$('#modal1').modal("hide");
			}
			else{
				 e.preventDefault();
			}
		});
		

		
		$('#close').click(function(e){
			modal.style.display = "none"
		});
		
		// 모두선택박스 반응
		 $(document).on('change', ".checkbox-member", function() {
	        var allChecked = true;
	        $(".checkbox-member").each(function() {
	            if (!$(this).prop("checked")) {
	                allChecked = false;
	                return false;
	            }
	        });
	
	        if (allChecked) {
	            $("#allCheckbox").prop("checked", true);
	        } else {
	            $("#allCheckbox").prop("checked", false);
	        }
    	});
		
		//	모두선택박스 컨트롤
		$('#allCheckbox').click(function(e) {
	        if($("#allCheckbox").is(':checked')) {
	    		$("input[name=checkbox-member]").prop("checked", true);
	    	} else {
	    		$("input[name=checkbox-member]").prop("checked", false);
	    	}
	    
	    });
				
		 // 모달1과 모달2의 상태를 확인하기 위한 변수
		  var isModal2Open = false;

		  // 모달2가 열릴 때 isModal2Open를 true로 설정
		  $('#modal2').on('show.bs.modal', function () {
		    isModal2Open = true;
		  });

		  // 모달2가 닫힐 때 isModal2Open를 false로 설정
		  $('#modal2').on('hidden.bs.modal', function () {
		    isModal2Open = false;
		  });

		  // 모달1이 닫히려고 할 때, 모달2가 열려 있는 경우 닫히지 않도록 방지
		  $('#modal1').on('hide.bs.modal', function (e) {
			if (isModal2Open) {
		    	alert("열려있는 창이 있습니다.");
		     	e.preventDefault();
		    }
		  });

		  // 모달2가 닫히지 않도록 설정
		  $('#modal2').modal({
		    backdrop: 'static',
		    keyboard: false,
		    show: false
		  });
		
	
	    //	
	    
	    $('#btnClose').click(function(e){
	    	$('#start-date').datepicker('setDate', "");
		    $('#end-date').datepicker('setDate', "");
		    $('#weekdayCount').val("");
		    $('#start-date').datepicker('destroy'); 
		    initializeDatepickers();
	    });
	    

	// 삭제 버튼 클릭 시 체크된 행 삭제
	    $("#deleteRows").click(function() {
	        // 체크된 체크박스가 있는지 확인
	        if ($(".checkbox-member:checked").length == 0) {
	            alert("선택한 사원이 없습니다.");
	            return;
	        }

	        // 확인 메시지 표시
	        if (confirm("선택한 행을 삭제하시겠습니까?")) {
	            // 체크된 행을 순회하며 삭제
	            $(".checkbox-member:checked").each(function() {
	                $(this).closest('tr').remove();
	            });
	        }
	    });
	});	//	end of $(document).ready(function(){--------
		
	
		
	//	근무기록 확정 시 회원목록 조회하기
	function Memberview(){
		var tbody = $('#modal1table');
		
		 $.ajax({
	    	 url:"<%= ctxPath%>/memberView.kedai",
	    	 type:"get",
	    	 dataType:"json",
	    	 success:function(json){
	    		 $.each(json, function(index, item) {
	    			if("100" === item.fk_dept_code){
	    				item.fk_dept_code = "인사부"; 
	    			}
	    			else if("200" === item.fk_dept_code){
	    				item.fk_dept_code = "영업지원부";
	    			}
	    			else if("300" === item.fk_dept_code){
	    				item.fk_dept_code = "회계부";
	    			}
	    			else if("400" === item.fk_dept_code){
	    				item.fk_dept_code = "상품개발부";
	    			}
	    			else if("500" === item.fk_dept_code){
	    				item.fk_dept_code = "마케팅부";
	    			}
	    			else if("600" === item.fk_dept_code){
	    				item.fk_dept_code = "해외사업부";
	    			}
	    			else if("700" === item.fk_dept_code){
	    				item.fk_dept_code = "온라인사업부";
	    			}
	    			else{
	    				item.fk_dept_code = "";
	    			
	    			}
	    		 
	    		        var newRow = '<tr>';
	    		        newRow += '<td><input type="checkbox" class="checkbox-member" id="checkbox-' + index + '" name="checkbox-member"></td>';
	    		        newRow += '<td class="empid">' + item.empid + '</td>'; // 사원번호
	    		        newRow += '<td>' + item.name + '</td>'; // 사원명
	    		        newRow += '<td>' + item.fk_dept_code + '</td>'; // 부서명
	    		        newRow += '<td><input type="text" class="form-control" id="weekdayCountfi" /></td>'; // 근무일수
	    		        newRow += '<td><input type="text" class="form-control" /><input type="hidden" id="memberSalary" value="' + item.salary + '"/></td>'; // 추가근무일수 (데이터가 없어서 비워둠)
	    		        newRow += '</tr>';
	    		        
	    		        // 새로운 행을 tbody에 추가
	    		        tbody.append(newRow);
	    
	    		    });
	    		 
	    		 $('#workhis').click(function(e){
	    			 if ($(".checkbox-member:checked").length == 0) {
	                     alert("선택한 사원이 없습니다.");
	                     return;
	                 } else {
	                     var selectedEmpIds = [];
	                     $(".checkbox-member:checked").each(function() {
	                         var empid = $(this).closest('tr').find('.empid').text();
	                         selectedEmpIds.push(empid);
	                     });
	                     //	alert("선택한 사원의 번호: " + selectedEmpIds.join(", "));
	                  
    					$('#modal2').modal("show");
    					initializeDatepickers();
	    				 
	    			 }
	    		});
	    		 
	    		 $('#dateSave').click(function(e){
	    		    	if($("#weekdayCount").val() == ""){
    		    		alert("날짜를 지정하여 주시기 바랍니다.");
    		    		return;
    		    	}
    		    	else{
    		    		 var weekdayCountValue = $("#weekdayCount").val();

    		    	        // Find all checked checkboxes
    		    	        $(".checkbox-member:checked").each(function() {
    		    	            // Find the closest tr and then find the #weekdayCountfi input inside it
    		    	            $(this).closest('tr').find('#weekdayCountfi').val(weekdayCountValue);
    		    	        });

    		    		$('#modal2').modal("hide")
    		    		$('#start-date').datepicker('destroy'); 
    		    	}
    		    	
    		    });
	    	  	
	    	 },
	    	 error: function(request, status, error){
			    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			 }
	     });
	}
		
	// 날짜 가져오기 함수
	function getDate(dateString) {
	    var date;
	    try {
	        date = $.datepicker.parseDate("yy-mm-dd", dateString);
	    } catch (error) {
	        date = null; // 날짜 형식 오류 처리
	    }
	    return date;
	}
	
	function initializeDatepickers() {
	    var currentYear = new Date().getFullYear(); 
	    var dateFormat = "yy-mm-dd";

	    $("#start-date").datepicker({
	        changeMonth: true,
	        changeYear: true,
	        dateFormat: dateFormat,
	        yearRange: (currentYear - 5) + ":" + (currentYear + 5),
	        onClose: function(selectedDate) {
	            $("#end-date").datepicker("option", "minDate", selectedDate ? selectedDate : null);
	            calculateWeekdays();
	        }
	    });

	    $("#end-date").datepicker({
	        changeMonth: true,
	        changeYear: true,
	        dateFormat: dateFormat,
	        yearRange: (currentYear - 5) + ":" + (currentYear + 5),
	        onClose: function(selectedDate) {
	            $("#start-date").datepicker("option", "maxDate", selectedDate ? selectedDate : null);
	            calculateWeekdays();
	        }
	    });
	}

	// 평일 수 계산 함수
	function calculateWeekdays() {
		 var startDate = getDate($("#start-date").val());
	    var endDate = getDate($("#end-date").val());

	    console.log("startDate:", startDate);
	    console.log("endDate:", endDate);
	    
	    if (startDate && endDate) {
	        console.log("start", startDate); // startDate 로그 확인
	        var weekdays = countWeekdays(startDate, endDate); // 평일 수 계산
	        $("#weekdayCount").val(weekdays); // 계산된 평일 수를 #weekdayCount 입력 필드에 설정
	    }
	}

	
		
    function countWeekdays(startDate, endDate) {
        var weekdays = 0;
        var currentDate = new Date(startDate);

        while (currentDate <= endDate) {
            var dayOfWeek = currentDate.getDay();
            if (dayOfWeek !== 0 && dayOfWeek !== 6) { // Sunday (0) and Saturday (6)
                weekdays++;
            }
            currentDate.setDate(currentDate.getDate() + 1);
        }

        return weekdays;
    }
	 
	
    function addNewRow() {
        const table = document.querySelector('tbody');
        const newRow = table.insertRow();

        // Create select elements for year and month
        const yearSelect = document.createElement('select');
        yearSelect.classList.add('yearSelect');
        const monthSelect = document.createElement('select');
        monthSelect.classList.add('monthSelect');

        const currentYear = new Date().getFullYear();
        const currentMonth = new Date().getMonth() + 1; // Month is zero-indexed in JavaScript

        // Populate year select with the past 5 years
        for (let i = 0; i < 5; i++) {
            const yearOption = document.createElement('option');
            yearOption.value = currentYear - i;
            yearOption.textContent = (currentYear - i).toString();
            yearSelect.appendChild(yearOption);
        }

        // Populate month select with 1 to 12
        for (let i = 1; i <= 12; i++) {
            const monthOption = document.createElement('option');
            monthOption.value = i < 10 ? '0' + i : i.toString();
            monthOption.textContent = i < 10 ? '0' + i : i.toString();
            monthSelect.appendChild(monthOption);
        }

        // Set the initial values for the select elements to the current year and month
        yearSelect.value = currentYear.toString();
        monthSelect.value = currentMonth < 10 ? '0' + currentMonth : currentMonth.toString();

        const cellsContent = [
            '급여',
            '', // This will be replaced with the select elements for year and month
            '<button id="workListcom_btn">근무기록확정</button>',
            '<button id="total_bth">전체계산</button>',
            '<button id="dwd">다운로드</button>',
            '지급총액'
        ];

        // Append cells to the new row
        for (let i = 0; i < cellsContent.length; i++) {
            const newCell = newRow.insertCell(i);
            if (i === 1) {
                newCell.appendChild(yearSelect);
                newCell.appendChild(document.createTextNode('년 '));
                newCell.appendChild(monthSelect);
                newCell.appendChild(document.createTextNode('월 급여'));
            } else {
                newCell.innerHTML = cellsContent[i];
            }
        }

        // 전체계산 버튼 클릭 이벤트 바인딩
     
    }

	
    function salary_submit() {
        var workdayval = $("#weekdayCount").val();
        var empidval = [];
        var memberSalary = [];
        var payment_date = $(".yearSelect").val() + $(".monthSelect").val()+"07";
        console.log(payment_date)
        
        $(".checkbox-member:checked").each(function() {
            var empid = $(this).closest('tr').find('.empid').text();
            var memSal = $(this).closest('tr').find('#memberSalary').val();
            empidval.push(empid.trim());
            memberSalary.push(memSal.trim());
        });

        // 유효성 검사: workdayval이 유효한지 확인
        if (workdayval <= 0 || isNaN(workdayval)) {
            alert("근로 일자를 올바르게 입력해 주세요.");
            return;
        }

        // 유효성 검사: empidval 및 memberSalary 배열 확인
        if (empidval.length === 0 || memberSalary.length === 0) {
            alert("선택된 직원이 없습니다.");
            return;
        }


        $.ajax({
            url: "<%= ctxPath%>/salaryCal.kedai",
            type: "post",
            data: {
                workday: workdayval,
                "empid": empidval,
                memberSalary: memberSalary,
                payment_date: payment_date
            },
            traditional: true,
            dataType: 'json',
            success: function(response) {
                console.log(response);
                if (Array.isArray(response)) {
                    response.forEach(function(item) {
                        console.log("사원번호: " + item.empid);
                        console.log("기본급: " + item.base_salary);
                        console.log("근로일: " + item.work_day);
                    });
                } else {
                    console.error("서버로부터 예상치 못한 데이터를 수신했습니다.");
                }
            },
            error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
        });
    }
    
    

    function loadSalaryData() {
        var yearMonth_not = document.getElementById('yearMonth').value;
        var year = yearMonth_not.substring(0, 4); // "2024"
        var month = yearMonth_not.substring(4, 6); // "08"
        
        // 변환된 날짜 문자열 생성 (YYYY-MM 형식)
        var yearMonth = year + "-" + month; // "2024-08"

        $.ajax({
            url: "<%= ctxPath %>/salaryData.kedai", // 서버의 데이터 URL
            type: "GET",
            data: {
                yearMonth: yearMonth // 요청 파라미터
            },
            dataType: "json", // 데이터 형식
            success: function(response) {
                
                console.log($('#yearMonth').val());

                var tbody = $('#modal3 table tbody');
                tbody.empty(); // 테이블 내용 초기화

                // 서버에서 반환된 데이터가 배열인지 확인
                if (Array.isArray(response)) {
                    $.each(response, function(index, salary) {
                        // 데이터에서 error 키가 있는지 확인
                        if (salary.error) {
                            alert(salary.error);
                            return false; // 배열 탐색 중지
                        }

                        var newRow = '<tr>';
                        newRow += '<td>' + (salary.namd || '') + '</td>';
                        newRow += '<td>' + (salary.base_salary || '') + '</td>';
                        newRow += '<td>' + (salary.meal_allowance || '') + '</td>';
                        newRow += '<td>' + (salary.annual_allowance || '') + '</td>';
                        newRow += '<td>' + (salary.overtime_allowance || '') + '</td>';
                        newRow += '<td>' + (salary.total_income || '') + '</td>';
                        newRow += '<td>' + (salary.income_tax || '') + '</td>';
                        newRow += '<td>' + (salary.local_income_tax || '') + '</td>';
                        newRow += '<td>' + (salary.pension || '') + '</td>';
                        newRow += '<td>' + (salary.health_insurance || '') + '</td>';
                        newRow += '<td>' + (salary.employment_insurance || '') + '</td>';
                        newRow += '<td>' + (salary.total_deduction || '') + '</td>';
                        newRow += '<td>' + (salary.net_pay || '') + '</td>';
                        newRow += '</tr>';
                        
                        tbody.append(newRow); // 테이블에 새로운 행 추가
                    });
                } else {
                    alert("서버에서 반환된 데이터 형식이 올바르지 않습니다.");
                }
            },
            error: function(xhr, status, error) {
                console.error("데이터를 불러오지 못했습니다:", status, error);
                alert("데이터를 불러오지 못했습니다.");
            }
        });
    }



    function loadInitialData() {
        $.ajax({
            url: "<%= ctxPath %>/initialData.kedai", // 실제 데이터 조회 URL로 변경
            type: "GET",
            dataType: "json",
            success: function(response) {
            	// 각 테이블에 대한 식별자를 확인하고 적절한 테이블을 선택합니다
                // 이 예제에서는 단일 테이블에 삽입하지만, 조건에 따라 여러 테이블에 삽입할 수 있습니다.
                var targetTableId = 'salaryTable'; // 여기에 삽입할 테이블의 ID를 설정

                // 테이블 식별자로 tbody 선택
                var tbody = $('#' + targetTableId + ' tbody');
                tbody.empty(); // 기존 데이터를 비움

                // 서버에서 반환된 JSON 데이터가 배열 형태인지 확인
                if (Array.isArray(response)) {
                    $.each(response, function(index, item) {
                        // 데이터로 새 행 생성
                        var newRow = '<tr>';
                        newRow += '<td>급여</td>'; // '급여구분' 고정값
                        newRow += '<td id="date">' + item.period + '</td>'; // '대장명칭'에 기간을 삽입
                        newRow += '<td><button id="workListcom_btn">근무기록확정</button></td>'; // '사전작업' 버튼
                        newRow += '<td><button id="total_bth">전체계산</button></td>'; // '급여계산' 버튼
                        newRow += '<td><button id="dwd">다운로드</button></td>'; // '명세서' 버튼
                        newRow += '<td>' + formatCurrency(item.total_amount) + '</td>'; // '지급총액' 포맷
                        newRow += '</tr>';

                        tbody.append(newRow);
                    });
                } else {
                    alert("서버에서 반환된 데이터 형식이 올바르지 않습니다.");
                }
            },
            error: function(xhr, status, error) {
                console.error("데이터를 불러오지 못했습니다:", status, error);
                alert("데이터를 불러오지 못했습니다.");
            }
        });
    }


    // 숫자를 포맷하여 통화 형식으로 변환하는 함수
    function formatCurrency(amount) {
        // Check if amount is a number before formatting
        if (typeof amount === 'number') {
            return amount.toLocaleString('ko-KR', { style: 'currency', currency: 'KRW' });
        }
        return amount; // If not a number, return it as is
    }


    $(document).on('click', '#workListcom_btn', function(e) {
		 $('#modal1').modal("show");
		 Memberview();
	});
    
    $(document).on('click', '#total_bth', function(e) {
    	// 클릭된 버튼
        var button = $(this);

        // 클릭된 버튼의 부모 행을 찾기
        var row = button.closest('tr');

        // 행에서 id가 'date'인 <td> 요소의 값을 가져오기
        var date = row.find('td#date').text();

        console.log(date);
        // 또는 클릭된 버튼의 부모 행에서 특정 열의 값을 가져오는 방법
        // var date = row.find('td').eq(0).text(); // 예를 들어 첫 번째 열에서 가져오기

        // yearSelect와 monthSelect 값 가져오기
        var yearSelect = document.getElementById('yearSelect');
        var monthSelect = document.getElementById('monthSelect');

        var yearMonth;

        if (yearSelect && monthSelect) {
            if (!yearSelect.value || !monthSelect.value) {
                yearMonth = formatYearMonth(date); // 버튼에서 가져온 date를 포맷팅
            } else {
                yearMonth = yearSelect.value + monthSelect.value; // 선택된 연도와 월을 조합
            }
        } else {
            yearMonth = formatYearMonth(date); // 버튼에서 가져온 date를 포맷팅
        }

         $('#yearMonth').val(yearMonth); // 설정된 값을 hidden input에 저장
         $('#empid').val(""); // 필요시 empid 값을 설정할 수 있음
         loadSalaryData(); // 급여 데이터 로드
         $('#modal3').modal("show");
     });
		
    
    function formatYearMonth(input) {
        // 입력 문자열을 "년", "월"로 분리
        var parts = input.split('년');
        if (parts.length < 2) {
            console.error("입력 문자열 형식이 올바르지 않습니다.");
            return null;
        }

        var year = parts[0].trim(); // 연도 추출
        var monthPart = parts[1].split('월')[0].trim(); // 월 추출

        // 연도와 월이 올바른 형식인지 확인
        if (!year || !monthPart) {
            console.error("연도 또는 월 정보가 누락되었습니다.");
            return null;
        }

        // 월을 두 자리로 포맷
        var formattedMonth = monthPart.padStart(2, '0');

        // YYYY-MM 형식으로 반환
        return year + formattedMonth;
    }
		
    
    $(document).on('click', '#dwd', function(e) {
    	
    	console.log("?????????????????????????")
    	const downloadButton = document.querySelector('#dwd');
    	if (downloadButton) {
    	    downloadButton.addEventListener('click', makeFile);
    	} else {
    	    console.error('Download button with ID "dwd" not found.');
    	}

        
        async function makeFile(e) {
            e.preventDefault(); // 기본 동작 방지 (폼 제출 등)

            const selectedValue = document.getElementById('yearMonth').value;
            console.log(selectedValue)
            const response = await fetch(`/salaryData.kedai?yearMonth=${selectedValue}`);
            const data = await response.json();

            if (Array.isArray(data) && data.length > 0) {
                const workbook = new ExcelJS.Workbook();

                // 스타일 설정
                const headerStyle = {
                    font: { bold: true, size: 16, color: { argb: 'FFFFFF' } },
                    alignment: { horizontal: 'center', vertical: 'middle' },
                    fill: { type: 'pattern', pattern: 'solid', fgColor: { argb: '4472C4' } }
                };

                const subHeaderStyle = {
                    font: { bold: true, size: 12, color: { argb: 'FFFFFF' } },
                    alignment: { horizontal: 'center', vertical: 'middle' },
                    fill: { type: 'pattern', pattern: 'solid', fgColor: { argb: '5B9BD5' } }
                };

                const normalStyle = {
                    alignment: { horizontal: 'center', vertical: 'middle' },
                    border: {
                        top: { style: 'thin' },
                        left: { style: 'thin' },
                        bottom: { style: 'thin' },
                        right: { style: 'thin' }
                    }
                };

                const warningStyle = {
                    font: { color: { argb: 'FF0000' } }
                };

                data.forEach(employeeData => {
                    const sheet = workbook.addWorksheet(employeeData.namd);

                    // 데이터 삽입
                    sheet.mergeCells('A1:D1');
                    const titleCell = sheet.getCell('A1');
                    titleCell.value = '급여명세서';
                    titleCell.style = headerStyle;

                    // 선택된 연도와 월 가져오기
                    sheet.mergeCells('A2:D2');
                    const dateCell = sheet.getCell('A2');
                    dateCell.value = '급여지급일 : ' + selectedValue + ' 10일';
                    dateCell.style = normalStyle;

                    // 개인 정보
                    sheet.addRow(['이름', employeeData.namd, '부서', employeeData.department || '']);
                    sheet.addRow(['직위', employeeData.position || '', '입사일자', employeeData.hireDate || '']);
                    sheet.getRow(3).eachCell(cell => { cell.style = normalStyle; });
                    sheet.getRow(4).eachCell(cell => { cell.style = normalStyle; });

                    // 세부 내역 헤더
                    sheet.addRow([]);
                    sheet.addRow(['', '', '세부 내역', '']);
                    sheet.mergeCells('C5:D5');
                    const detailHeaderCell = sheet.getCell('C5');
                    detailHeaderCell.value = '세부 내역';
                    detailHeaderCell.style = subHeaderStyle;

                    // 세부 내역 데이터 삽입
                    const details = [
                        ['기본급', employeeData.base_salary],
                        ['식대', employeeData.meal_allowance],
                        ['연차수당', employeeData.annual_allowance],
                        ['초과근무수당', employeeData.overtime_allowance],
                        ['소득세', employeeData.income_tax],
                        ['지방소득세', employeeData.local_income_tax],
                        ['연금', employeeData.pension],
                        ['건강보험', employeeData.health_insurance],
                        ['고용보험', employeeData.employment_insurance],
                        ['총소득', employeeData.total_income],
                        ['총공제', employeeData.total_deduction],
                        ['실지급액', employeeData.net_pay]
                    ];

                    details.forEach(detail => {
                        const newRow = sheet.addRow(['', '', detail[0], detail[1]]);
                        newRow.eachCell((cell, colNumber) => {
                            cell.style = normalStyle;
                            if (colNumber === 2 && cell.value === '실지급액') {
                                cell.style = warningStyle;
                            }
                        });
                    });
                });

                // 엑셀 파일 다운로드
                await download(workbook, selectedValue + ' 급여명세서');
            } else {
                alert("서버에서 반환된 데이터가 올바르지 않습니다.");
            }
        }

        const download = async (workbook, fileName) => {
            const buffer = await workbook.xlsx.writeBuffer();
            const blob = new Blob([buffer], {
                type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            });
            const url = window.URL.createObjectURL(blob);
            const anchor = document.createElement('a');
            anchor.href = url;
            anchor.download = fileName + '.xlsx';
            document.body.appendChild(anchor); // for Firefox
            anchor.click();
            document.body.removeChild(anchor); // cleanup
            window.URL.revokeObjectURL(url);
        };
    });
    
</script>
<script src="salary_excelExport.js"></script>

<div class="header">
        <h1>급여명세서</h1>
        <div class="search-bar">
            <button onclick="searchTable()">검색</button>
        </div>
    </div>

    <table id="salaryTable">
        <thead>
            <tr>
            	<th>급여구분</th> 
            	<th>대장명칭</th>
                <th>사전작업</th>
                <th>급여계산</th>
                <th>명세서</th>
                <th>지급총액</th>
            </tr>
        </thead>
        <tbody>
           
        </tbody>
    </table>
    <br>
    <button onclick="addNewRow()">신규</button>
    <input type="hidden" id="yearMonth" name="yearMonth">
	
	<!-- 모달1 -->
<div id="modal1" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="exampleModalLabel">근무기록확정</h3>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="container mt-3">
                    <!-- 상단 근태 버튼과 일괄적용 체크박스 -->
                    <div class="d-flex justify-content-start mb-2">
                        <button class="btn btn-primary btn-sm" id="workhis">근태</button>
                        <div class="form-check ml-2">
                            <input type="checkbox" class="form-check-input" id="batchApply">
                            <label class="form-check-label" for="batchApply">일괄적용</label>
                        </div>
                    </div>

                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th><input type="checkbox" id="allCheckbox"></th>
                                <th>사원번호</th>
                                <th>사원명</th>
                                <th>부서명</th>
                                <th>근무일수</th>
                                <th>추가근무일수</th>
                            </tr>
                        </thead>
                        <tbody id="modal1table">
                          
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <div class="d-flex justify-content-end mt-3">
                <button id="workdaySmt">저장</button>
                    <button data-dismiss="modal">닫기</button>
                    <button id="deleteRows">삭제</button>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- 모달2 -->
<div class="modal fade" id="modal2" tabindex="-1" role="dialog" style="width: 30%">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">근무일수</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <p>날짜 선택</p>
                    <label for="start-date">시작 날짜:</label>
				    <input type="text" id="start-date">
				    <label for="end-date">마지막 날짜:</label>
				    <input type="text" id="end-date">
                </div>
                <div class="form-group">
				 	<input type="hidden" id="weekdayCount" />
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn mr-2" id="dateSave">저장</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal" id="btnClose">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 모달 3: 총급여 계산 -->
<div id="modal3" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">총급여 계산</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <table>
                    <thead>
                        <tr>
                        	<th>사원명</th>
                            <th>기본급</th>
                            <th>식대 보조금</th>
                            <th>연차 수당</th>
                            <th>초과근무 수당</th>
                            <th>총 수익</th>
                            <th>소득세</th>
                            <th>지방 소득세</th>
                            <th>국민연금</th>
                            <th>건강보험</th>
                            <th>고용보험</th>
                            <th>총 공제액</th>
                            <th>실 지급액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- 계산된 급여 정보가 여기에 추가됩니다 -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

	   
</html>