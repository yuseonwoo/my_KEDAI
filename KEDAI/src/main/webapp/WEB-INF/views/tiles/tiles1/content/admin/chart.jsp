<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<style type="text/css">
	.highcharts-figure,
	.highcharts-data-table table {
	    min-width: 320px;
	    max-width: 800px;
	    margin: 1em auto;
	}
	.highcharts-data-table table {
	    font-family: Verdana, sans-serif;
	    border-collapse: collapse;
	    border: 1px solid #ebebeb;
	    margin: 10px auto;
	    text-align: center;
	    width: 100%;
	    max-width: 500px;
	}
	.highcharts-data-table caption {
	    padding: 1em 0;
	    font-size: 1.2em;
	    color: #555;
	}
	.highcharts-data-table th {
	    font-weight: 600;
	    padding: 0.5em;
	}
	.highcharts-data-table td,
	.highcharts-data-table th,
	.highcharts-data-table caption {
	    padding: 0.5em;
	}	
	.highcharts-data-table thead tr,
	.highcharts-data-table tr:nth-child(even) {
	    background: #f8f8f8;
	}	
	.highcharts-data-table tr:hover {
	    background: #f1f7ff;
	}
	input[type="number"] {
	    min-width: 50px;
	}
	div#chart_container {height: 600px;}
	div#table_container table {width: 100%;}
	div#table_container th, div#table_container td {text-align: center;} 
	div#table_container th {background: #e68c0e; color: #fff;}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("select#searchType").change(function(e){
		   func_choice($(this).val());
	   });
		
		$("select#searchType").val("deptname").trigger("change"); 
		
	}); // end of $(document).ready(function(){}) ----------
	
	function func_choice(searchTypeVal) {
		
		switch(searchTypeVal) {
			case "":
				$("div#chart_container").empty();
				$("div#table_container").empty();
				$("div#highcharts-data-table").empty();
				
				break;
				
			case "deptname": // 부서별 인원통계
				$.ajax({
					url:"<%= ctxPath%>/admin/chart/empCntByDeptname.kedai",
			    	dataType:"json",
			    	success:function(json){
			    	// 	console.log(JSON.stringify(json)); 
			    	 	/*
			    	 		[{"dept_name":"마케팅부","cnt":"10","percentage":"30.3"},
		    	 			{"dept_name":"영업지원부","cnt":"7","percentage":"21.21"},
		    	 			{"dept_name":"인사부","cnt":"7","percentage":"21.21"},
		    	 			{"dept_name":"상품개발부","cnt":"6","percentage":"18.18"},
		    	 			{"dept_name":"회계부","cnt":"2","percentage":"6.06"},
		    	 			{"dept_name":"부서없음","cnt":"1","percentage":"3.03"}]
			    	 	*/
			    	 	
						let resultArr = [];
						
			    	 	for(let i=0; i<json.length; i++){
			    	 		let obj;
			    	 		
			    	 		if(i == 0){
			    	 			obj = {
			    	 					name: json[i].dept_name,
							            y: Number(json[i].percentage),
							            sliced: true,
							            selected: true
		    	 					  }
			    	 		}
			    	 		else{
			    	 			obj = {
			    	 					name: json[i].dept_name,
							            y: Number(json[i].percentage)
		    	 					  }
			    	 		}
			    	 		
			    	 		resultArr.push(obj);
			    	 	} // end of for ----------
			    	 	
			    	 	$("div#chart_container").empty();
						$("div#table_container").empty();
						$("div#highcharts-data-table").empty();
			    	 	
						//////////////////////////////////////////////////////////////

						Highcharts.chart('chart_container', {
						    chart: {
						        plotBackgroundColor: null,
						        plotBorderWidth: null,
						        plotShadow: false,
						        type: 'pie'
						    },
						    title: {
						        text: '<span style="font-size: 18pt; font-weight: bold; color: #e68c0e;">《&nbsp;KEDAI 부서별 인원통계&nbsp;》</span>'
						    },
						    tooltip: {
						        pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>'
						    },
						    accessibility: {
						        point: {
						            valueSuffix: '%'
						        }
						    },
						    plotOptions: {
						        pie: {
						            allowPointSelect: true,
						            cursor: 'pointer',
						            dataLabels: {
						                enabled: true,
						                format: '<b>{point.name}</b>: {point.percentage:.2f} %'
						            }
						        }
						    },
						    series: [{
						        name: '인원비율',
						        colorByPoint: true,
						        data: resultArr
						    }]    
						});
						
						//////////////////////////////////////////////////////////////

						let v_html = "<table class='table table-bordered'>";
						
						v_html += "<tr>"+
								  "<th style='width: 40%;'>부서명</th>"+
								  "<th style='width: 30%;'>인원수(명)</th>"+
								  "<th style='width: 30%;'>퍼센티지(%)</th>"+
								  "</tr>";
						
					  	let totalCount = 0;
					  	let totalPercentage = 0;
					  	
					 	$.each(json, function(index, item){
					 		v_html += "<tr>"+
					 		          "<td>"+item.dept_name+"</td>"+
					 		          "<td>"+item.cnt+"</td>"+
					 		          "<td>"+item.percentage+"</td>"+
					 		          "</tr>";
					 		          
					 		totalCount += Number(item.cnt);
					 		totalPercentage += parseFloat(item.percentage);
					 	});
					 	
					 	totalPercentage = isNaN(totalPercentage)?'Invalid':totalPercentage.toFixed(1);
					 	
					 	v_html += "<tr style='font-weight: bold;'>"+
					 			  "<td>합계</td>"+
					 			  "<td>"+totalCount+"</td>"+
					 			  "<td>"+totalPercentage+"</td>"+
					 	          "</tr>";
					 	
					 	v_html += "</table>";
					 	
					 	$("div#table_container").html(v_html);
		    		},
			    	error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			
				break;
			
			case "gender": // 성별 인원통계
				$.ajax({
					url:"<%= ctxPath%>/admin/chart/empCntByGender.kedai",
			    	dataType:"json",
			    	success:function(json){
			    	// 	console.log(JSON.stringify(json)); 
			    	 	/*
			    	 		[{"gender":"여","cnt":"14","percentage":"42.4"},
			    	 		{"gender":"남","cnt":"19","percentage":"57.6"}]
			    	 	*/
			    	 	
						let resultArr = [];
						
			    	 	for(let i=0; i<json.length; i++){
			    	 		let obj;
			    	 		
			    	 		if(i == 0){
			    	 			obj = {
			    	 					name: json[i].gender,
							            y: Number(json[i].percentage),
							            sliced: true,
							            selected: true
		    	 					  }
			    	 		}
			    	 		else{
			    	 			obj = {
			    	 					name: json[i].gender,
							            y: Number(json[i].percentage)
		    	 					  }
			    	 		}
			    	 		
			    	 		resultArr.push(obj);
			    	 	} // end of for ----------
			    	 	
			    	 	$("div#chart_container").empty();
						$("div#table_container").empty();
						$("div#highcharts-data-table").empty();
						
						//////////////////////////////////////////////////////////////

						Highcharts.chart('chart_container', {
						    chart: {
						        plotBackgroundColor: null,
						        plotBorderWidth: null,
						        plotShadow: false,
						        type: 'pie'
						    },
						    title: {
						        text: '<span style="font-size: 18pt; font-weight: bold; color: #e68c0e;">《&nbsp;KEDAI 성별 인원통계&nbsp;》</span>'
						    },
						    tooltip: {
						        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
						    },
						    accessibility: {
						        point: {
						            valueSuffix: '%'
						        }
						    },
						    plotOptions: {
						        pie: {
						            allowPointSelect: true,
						            cursor: 'pointer',
						            dataLabels: {
						                enabled: true,
						                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
						            }
						        }
						    },
						    series: [{
						        name: '인원비율',
						        colorByPoint: true,
						        data: resultArr
						    }]    
						});
						
						//////////////////////////////////////////////////////////////
			    	 	
						let v_html = "<table class='table table-bordered'>";
						
						v_html += "<tr>"+
								  "<th style='width: 40%;'>성별</th>"+
								  "<th style='width: 30%;'>인원수(명)</th>"+
								  "<th style='width: 30%;'>퍼센티지(%)</th>"+
								  "</tr>";
						
					  	let totalCount = 0;
					  	let totalPercentage = 0;
					  	
					 	$.each(json, function(index, item){
					 		v_html += "<tr>"+
					 		          "<td>"+item.gender+"</td>"+
					 		          "<td>"+item.cnt+"</td>"+
					 		          "<td>"+item.percentage+"</td>"+
					 		          "</tr>";
					 		          
					 		totalCount += Number(item.cnt);
					 		totalPercentage += parseFloat(item.percentage);
					 	});
					 	
					 	totalPercentage = isNaN(totalPercentage)?'Invalid':totalPercentage.toFixed(1);
					 	
					 	v_html += "<tr style='font-weight: bold;'>"+
					 			  "<td>합계</td>"+
					 			  "<td>"+totalCount+"</td>"+
					 			  "<td>"+totalPercentage+"</td>"+
					 	          "</tr>";
					 	
					 	v_html += "</table>";
					 	
					 	$("div#table_container").html(v_html);
		    		},
			    	error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			
				break;
			
			case "deptnameGender": // 부서별 성별 인원통계
				$.ajax({
					url:"<%= ctxPath%>/admin/chart/empCntByDeptname.kedai",
			    	dataType:"json",
			    	success:function(json){
			    	// 	console.log(JSON.stringify(json)); 
			    	 	/*
			    	 		[{"dept_name":"마케팅부","cnt":"10","percentage":"30.3"},
		    	 			{"dept_name":"영업지원부","cnt":"7","percentage":"21.21"},
		    	 			{"dept_name":"인사부","cnt":"7","percentage":"21.21"},
		    	 			{"dept_name":"상품개발부","cnt":"6","percentage":"18.18"},
		    	 			{"dept_name":"회계부","cnt":"2","percentage":"6.06"},
		    	 			{"dept_name":"부서없음","cnt":"1","percentage":"3.03"}]
			    	 	*/
			    	 	
			    	 	let deptnameArr = []; // 부서명별 인원수 퍼센티지 객체 배열
			    	 	
			    	 	$.each(json, function(index, item){
			    	 		deptnameArr.push(item.dept_name);
			    	 	}); 
			    	 	
			    	 	let malePercentageArr = [];   // 남자 퍼센티지
	    				let femalePercentageArr = []; // 여자 퍼센티지 
			    	 	
			    	 	$.each(json, function(index, item){
			    	 		$.ajax({
			    	 			url:"<%= ctxPath%>/admin/chart/genderCntSpecialDeptname.kedai",
				    			data:{"dept_name":item.dept_name},
				    			dataType:"json",
				    			success:function(json2){
				    			//	console.log(JSON.stringify(json2));
				    				/*
				    					[{"gender":"남","cnt":"5","percentage":"15.15"},{"gender":"여","cnt":"5","percentage":"15.15"}]
				    				    [{"gender":"남","cnt":"1","percentage":"3.03"}]
										[{"gender":"남","cnt":"1","percentage":"3.03"},{"gender":"여","cnt":"1","percentage":"3.03"}]
										[{"gender":"남","cnt":"5","percentage":"15.15"},{"gender":"여","cnt":"2","percentage":"6.06"}]
										[{"gender":"남","cnt":"3","percentage":"9.09"},{"gender":"여","cnt":"4","percentage":"12.12"}]
										[{"gender":"남","cnt":"4","percentage":"12.12"},{"gender":"여","cnt":"2","percentage":"6.06"}]
				    				*/
				    				
				    				for(let i=0; i<json2.length; i++){
				    					if( json2[i].gender == "남" ) {
				    						malePercentageArr.push(Number(json2[i].percentage));
				    					}
				    					else {
				    						femalePercentageArr.push(Number(json2[i].percentage));
				    					}
				    				} // end of for ----------
				    			},
				    			error: function(request, status, error){
								   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
								}
			    	 		});
			    	 	}); // end of $.each(json, function(index, item) ----------
			    	 /*	
			    	 	let gender_Arr = []; // 특정 부서명에 근무하는 직원들의 성별 인원수 퍼센티지 객체 배열		
			    	 	
			    	 	gender_Arr.push({name: '남', data: malePercentageArr});
			    	 	gender_Arr.push({name: '여', data: femalePercentageArr});
			    	 */	
			    	 	$("div#chart_container").empty();
						$("div#table_container").empty();
						$("div#highcharts-data-table").empty();
						
						//////////////////////////////////////////////////////////////
						
						Highcharts.chart('chart_container', {
						    chart: {
						        type: 'bar'
						    },
						    title: {
						        text: '<span style="font-size: 18pt; font-weight: bold; color: #e68c0e;">《&nbsp;KEDAI 부서별 성별 인원통계&nbsp;》</span>'
						    },
						    subtitle: {
						        text: ''
						    },
						    xAxis: {
						        categories: deptnameArr,
						        title: {
						            text: null
						        }
						    },
						    yAxis: {
						        min: 0,
						        title: {
						            text: '성별 (%)',
						            align: 'high'
						        },
						        labels: {
						            overflow: 'justify'
						        }
						    },
						    tooltip: {
						        valueSuffix: ' %'
						    },
						    plotOptions: {
						        bar: {
						            dataLabels: {
						                enabled: true
						            }
						        }
						    },
						    legend: {
						        layout: 'vertical',
						        align: 'right',
						        verticalAlign: 'top',
						        x: -40,
						        y: 80,
						        floating: true,
						        borderWidth: 1,
						        backgroundColor:
						            Highcharts.defaultOptions.legend.backgroundColor || '#FFFFFF',
						        shadow: true
						    },
						    credits: {
						        enabled: false
						    },
						//  series: gender_Arr
						    series: [{name: '남', data: [15.15, 15.15, 9.09, 12.12, 3.03, 3.03]}, {name: '여', data: [15.15, 6.06, 12.12, 6.06, 3.03]}]  
						});
						
						//////////////////////////////////////////////////////////////
			    	 	
						let v_html = "<table class='table table-bordered'>";
						
						v_html += "<tr>"+
								  "<th style='width: 30%; vertical-align: middle;' rowspan='2'>부서명</th>"+
								  "<th style='width: 50%;' colspan='2'>성별</th>"+
								  "<th style='width: 20%; vertical-align: middle;' rowspan='2'>합계</th>"+
								  "</tr>";
								  
						v_html += "<tr>"+
								  "<th>남자</th>"+
				 		          "<th>여자</th>"+
								  "</tr>";
					  
						malePercentageArr = [15.15, 15.15, 9.09, 12.12, 3.03, 3.03];   // 남자 퍼센티지
				    	femalePercentageArr = [15.15, 6.06, 12.12, 6.06, 3.03]; // 여자 퍼센티지  		  
	                    let totalPercentage = 0; // 총 퍼센트 변수 초기화

	                    $.each(json, function(index2, item2) {
	                        const malePercentage = malePercentageArr[index2] !== undefined ? malePercentageArr[index2] : '';
	                        const femalePercentage = femalePercentageArr[index2] !== undefined ? femalePercentageArr[index2] : '';

	                        v_html += "<tr>"+
	                                  "<td>"+item2.dept_name+"</td>"+
	                                  "<td>"+malePercentage+"</td>"+
	                                  "<td>"+femalePercentage+"</td>"+
	                                  "<td>"+item2.percentage+"</td>"+
	                                  "</tr>";
	                        
	                        totalPercentage += parseFloat(item2.percentage);
	                    });
					 	
					 	totalPercentage = isNaN(totalPercentage)?'Invalid':totalPercentage.toFixed(1);
					 	
					 	v_html += "<tr style='font-weight: bold;'>"+
					 			  "<td colspan='3'>합계</td>"+
					 			  "<td>"+totalPercentage+"</td>"+
					 	          "</tr>";
					 	
					 	v_html += "</table>";
					 	
					 	$("div#table_container").html(v_html);
		    		},
			    	error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			
				break;
				
			case "genderHireYear": // 입사년도별 성별 인원통계
				$.ajax({
					url:"<%= ctxPath%>/admin/chart/empCntByGenderHireYear.kedai",
			    	dataType:"json",
			    	success:function(json){
			    	// 	console.log(JSON.stringify(json)); 
			    	 	/*
			    	 		[{"gender":"남","Y2010":"1","Y2011":"1","Y2012":"1","Y2013":"4","Y2014":"1","Y2015":"2","Y2016":"1","Y2017":"2","Y2018":"2","Y2019":"1","Y2020":"0","Y2021":"1","Y2022":"1","Y2023":"0","Y2024":"1","totalCount":"19"},
			    	 		{"gender":"여","Y2010":"1","Y2011":"1","Y2012":"1","Y2013":"0","Y2014":"1","Y2015":"0","Y2016":"2","Y2017":"0","Y2018":"1","Y2019":"2","Y2020":"2","Y2021":"0","Y2022":"0","Y2023":"1","Y2024":"2","totalCount":"14"}]
			    	 	*/
			    	 	
			    	 	let resultArr = [];
			    	 	
			    	 	for(let i=0; i<json.length; i++){
			    	 		let hireYear_Arr = [];
			    	 		hireYear_Arr.push(Number(json[i].Y2010));
			    	 		hireYear_Arr.push(Number(json[i].Y2011));
			    	 		hireYear_Arr.push(Number(json[i].Y2012));
			    	 		hireYear_Arr.push(Number(json[i].Y2013));
			    	 		hireYear_Arr.push(Number(json[i].Y2014));
			    	 		hireYear_Arr.push(Number(json[i].Y2015));
			    	 		hireYear_Arr.push(Number(json[i].Y2016));
			    	 		hireYear_Arr.push(Number(json[i].Y2017));
			    	 		hireYear_Arr.push(Number(json[i].Y2018));
			    	 		hireYear_Arr.push(Number(json[i].Y2019));
			    	 		hireYear_Arr.push(Number(json[i].Y2020));
			    	 		hireYear_Arr.push(Number(json[i].Y2021));
			    	 		hireYear_Arr.push(Number(json[i].Y2022));
			    	 		hireYear_Arr.push(Number(json[i].Y2023));
			    	 		hireYear_Arr.push(Number(json[i].Y2024));
			    	 		
			    	 		let obj = {name: json[i].gender,
			    	 		           data: hireYear_Arr};
			    	 		
			    	 		resultArr.push(obj); 
			    	 	}  // end of for ----------
			    	 	
			    	 	$("div#chart_container").empty();
						$("div#table_container").empty();
						$("div#highcharts-data-table").empty();
						
						//////////////////////////////////////////////////////////////
						
						Highcharts.chart('chart_container', {
						    title: {
						        text: '<span style="font-size: 18pt; font-weight: bold; color: #e68c0e;">《&nbsp;입사년도별 성별 인원통계, 2010년 ~ 2024년 &nbsp;》</span>'
						    },
						    subtitle: {
						        text: ''
						    },
						    yAxis: {
						        title: {
						            text: '사원수'
						        }
						    },
						    xAxis: {
						        accessibility: {
						            rangeDescription: 'Range: 2010 to 2024'
						        }
						    },
						    legend: {
						        layout: 'vertical',
						        align: 'right',
						        verticalAlign: 'middle'
						    },
						    plotOptions: {
						        series: {
						            label: {
						                connectorAllowed: false
						            },
						            pointStart: 2010
						        }
						    },
						    series: resultArr,
						    responsive: {
						        rules: [{
						            condition: {
						                maxWidth: 500
						            },
						            chartOptions: {
						                legend: {
						                    layout: 'horizontal',
						                    align: 'center',
						                    verticalAlign: 'bottom'
						                }
						            }
						        }]
						    }
						});
						
						//////////////////////////////////////////////////////////////
						
						let v_html = "<table class='table table-bordered'>";
						
						v_html += "<tr>"+
								  "<th>성별</th>"+
								  "<th>2010년</th>"+
								  "<th>2011년</th>"+
								  "<th>2012년</th>"+
								  "<th>2013년</th>"+
								  "<th>2014년</th>"+
								  "<th>2015년</th>"+
								  "<th>2016년</th>"+
								  "<th>2017년</th>"+
								  "</tr>";
								  
						$.each(json, function(index, item){
							v_html += "<tr>"+
									  "<td>"+item.gender+"</td>"+
									  "<td>"+item.Y2010+"</td>"+
									  "<td>"+item.Y2011+"</td>"+
									  "<td>"+item.Y2012+"</td>"+
									  "<td>"+item.Y2013+"</td>"+
									  "<td>"+item.Y2014+"</td>"+
									  "<td>"+item.Y2015+"</td>"+
									  "<td>"+item.Y2016+"</td>"+
									  "<td>"+item.Y2017+"</td>"+
									  "</tr>";
						});
						
						v_html += "<tr>"+
								  "<th>성별</th>"+
								  "<th>2018년</th>"+
								  "<th>2019년</th>"+
								  "<th>2020년</th>"+
								  "<th>2021년</th>"+
								  "<th>2022년</th>"+
								  "<th>2023년</th>"+
								  "<th>2024년</th>"+
								  "<th>합계</th>"+
								  "</tr>";
						  
						$.each(json, function(index, item){
							v_html += "<tr>"+
									  "<td>"+item.gender+"</td>"+
									  "<td>"+item.Y2018+"</td>"+
									  "<td>"+item.Y2019+"</td>"+
									  "<td>"+item.Y2020+"</td>"+
									  "<td>"+item.Y2021+"</td>"+
									  "<td>"+item.Y2022+"</td>"+
									  "<td>"+item.Y2023+"</td>"+
									  "<td>"+item.Y2024+"</td>"+
									  "<td>"+item.totalCount+"</td>"+
									  "</tr>";
						});
								  
						v_html += "</table>";
					    
				    	$("div#table_container").html(v_html);
		    		},
			    	error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			
				break; 
				
			case "pageurlEmpname": // 페이지별 사원 접속통계
				$.ajax({
					url:"<%= ctxPath%>/admin/chart/pageurlEmpname.kedai",
			    	dataType:"json",
			    	success:function(json){
			    		let str_json = JSON.stringify(json);
					//	console.log(str_json);
						/*	
							{"categories":"[\"거래처정보\",\"게시판\",\"급여명세서\",\"사내연락망\",\"전자결재\",\"카쉐어\",\"커뮤니티\",\"통근버스\",\"회의실예약\"]",
							 "series":"[{\"name\":\"정예린\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"2\\\"]\"},{\"name\":\"정예린\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"4\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"1\\\"]\"},{\"name\":\"관리자\",\"data\":\"[\\\"1\\\"]\"}]"}
						*/
			    		str_json = str_json.replace(/\\/gi, "");
			    	//	console.log(str_json);
				    	/*	
				    		{"categories":"["거래처정보","게시판","급여명세서","사내연락망","전자결재","카쉐어","커뮤니티","통근버스","회의실예약"]",
				    		 "series":"[{"name":"정예린","data":"["1"]"},{"name":"관리자","data":"["2"]"},{"name":"정예린","data":"["1"]"},{"name":"관리자","data":"["1"]"},{"name":"관리자","data":"["4"]"},{"name":"관리자","data":"["1"]"},{"name":"관리자","data":"["1"]"},{"name":"관리자","data":"["1"]"},{"name":"관리자","data":"["1"]"}]"}
				    	*/	
			    		str_json = str_json.replace(/\"\[/gi, "[");
		    		    str_json = str_json.replace(/\]\"/gi, "]");
	    		    //	console.log(str_json);
			    		/*    
		    		    	{"categories":["거래처정보","게시판","급여명세서","사내연락망","전자결재","카쉐어","커뮤니티","통근버스","회의실예약"],
		    		    	 "series":[{"name":"정예린","data":["1"]},{"name":"관리자","data":["2"]},{"name":"정예린","data":["1"]},{"name":"관리자","data":["1"]},{"name":"관리자","data":["4"]},{"name":"관리자","data":["1"]},{"name":"관리자","data":["1"]},{"name":"관리자","data":["1"]},{"name":"관리자","data":["1"]}]}
				    	*/
			    	
		    		    const obj_str_json = JSON.parse(str_json);
		    		//  console.log(obj_str_json.categories);
		    		    // ['거래처정보', '게시판', '급여명세서', '사내연락망', '전자결재', '카쉐어', '커뮤니티', '통근버스', '회의실예약']
		    		//  console.log(obj_str_json.series);
						/*
			    		    {name: '정예린', data: ['1']}
			    		    {name: '관리자', data: ['2']}
			    		    {name: '정예린', data: ['1']}
			    		    {name: '관리자', data: ['1']}
			    		    {name: '관리자', data: ['4']}
			    		    {name: '관리자', data: ['1']}
			    		    {name: '관리자', data: ['1']}
			    		    {name: '관리자', data: ['1']}
			    		    {name: '관리자', data: ['1']}
						*/
						const arr_series = [];
			    		
		    		    for(let i=0; i<obj_str_json.series.length; i++) {
		    		    	 if(i == 0) {
		    		    	    const obj_series = {};
		    		    	    obj_series.name = obj_str_json.series[i].name;
		    		    	
		    		    	    const arr_data = [];
		    		    	    arr_data.push(Number(obj_str_json.series[i].data));
		    		    	    obj_series.data = arr_data;
		    		    	   
		    		    	    arr_series.push(obj_series);
		    		    	 }
		    		    	 else {
		    		    		 let flag = false;
		    		    		 
		    		    		 for(let k=0; k<arr_series.length; k++) {
		    		    		     if(arr_series[k].name == obj_str_json.series[i].name) {
		    		    			    arr_series[k].data.push(Number(obj_str_json.series[i].data));
		    		    			    flag = true;
		    		    		     }
		    		    		 } // end of for ----------
		    		    		 
		    		    		 if(!flag) {
		    		    			 const obj_series = {};
				    		    	 obj_series.name = obj_str_json.series[i].name;
				    		    	
				    		    	 const arr_data = [];
				    		    	 arr_data.push(Number(obj_str_json.series[i].data));
				    		    	 obj_series.data = arr_data;
				    		    	   
				    		    	 arr_series.push(obj_series); 
		    		    		 }
		    		    	}
		    		    } // end of for ----------
						
					//	console.log(arr_series);
						/*	
							0:{name: '정예린', data: [1, 1]}
							1:{name: '관리자', data: [2, 1, 4, 1, 1, 1, 1]}
						*/	
						$("div#chart_container").empty();
						$("div#table_container").empty();
						$("div#highcharts-data-table").empty();

						//////////////////////////////////////////////////////////////
						
						Highcharts.chart('chart_container', {
						    chart: {
						        type: 'column'
						    },
						    title: {
						        text: '<span style="font-size: 18pt; font-weight: bold; color: #e68c0e;">《&nbsp;페이지별 사원 접속 통계&nbsp;》</span>'
						    },
						    subtitle: {
						        text: ''
						    },
						    xAxis: {
						        categories: obj_str_json.categories,
						        crosshair: true
						    },
						    yAxis: {
						        title: {
						            useHTML: true,
						            text: '접속회수 (번)'
						        }
						    },
						    tooltip: {
						        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
						        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
						            		 '<td style="padding:0"><b>{point.y:.0f}</b>번 접속</td></tr>',
						        footerFormat: '</table>',
						        shared: true,
						        useHTML: true
						    },
						    plotOptions: {
						        column: {
						            pointPadding: 0.2,
						            borderWidth: 0
						        }
						    },
						    series: arr_series
						});
						
		    		},
			    	error: function(request, status, error){
					   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
			
				break;
		
		} // end of switch (searchTypeVal) ----------
		
	} // end of function func_choice(searchTypeVal) ----------
</script>
	
<%-- content start --%>	
<div style="border: 0px solid red; padding: 2% 3% 0 0;">
	<h3><span class="icon"><i class="fa-solid fa-seedling"></i></span>&nbsp;&nbsp;통계정보 조회하기</h3>
	<br>
	<form name="searchFrm">
		<select name="searchType" id="searchType" style="height: 30px; padding-left: 0.5%;">
			<option value="deptname">부서별 인원통계</option>
			<option value="gender">성별 인원통계</option>
			<option value="deptnameGender">부서별 성별 인원통계</option>
			<option value="genderHireYear">입사년도별 성별 인원통계</option>
			<option value="pageurlEmpname">페이지별 사원 접속통계</option>
		</select>
	</form>
	<br><br>
	<section class="row" style="height: 600px;">
		<div class="col-6" style="border: 0px solid blue;">
			<div id="chart_container"></div>
		</div>
		<div class="col-6" style="border: 0px solid red;">
			<div id="table_container"></div>
		</div>
	</section>
</div>
<%-- content end --%>