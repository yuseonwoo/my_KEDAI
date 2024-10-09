<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String ctxPath = request.getContextPath();
	//     /KEDAI
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포인트 충전 결제하기</title>
<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" >

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<style type="text/css">
	span {
		margin-right: 10px;
	}
	.stylePoint {
		font-weight: bold;
		color: #e68c0e;
	}
	.purchase_btn {
		border: solid 1px #2c4459;
		color: #2c4459;
		font-size: 12pt;
		width: 120px;
		height: 40px;
	}
	.purchase {
		color: #fff;
		border: none;
		background: #e68c0e;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		
		$("td#error").hide();

		$("input:radio[name='coinmoney']").bind("click", e => {
			
			const index = $("input:radio[name='coinmoney']").index($(e.target));
			
			$("td > span").removeClass("stylePoint");
			$("td > span").eq(index).addClass("stylePoint");
			
			$("label.radio-inline").removeClass("stylePoint");
			$("label.radio-inline").eq(index).addClass("stylePoint");
			
		}); // end of $("input:radio[name='coinmoney']").bind("click", e => {}) ----------
		
		$("td#purchase > button").hover(function(e){ // mouseover
			$(e.target).addClass("purchase");
		}, 
		function(e){  // mouseout
			$(e.target).removeClass("purchase");
		});
		
	}); // end of $(document).ready(function(){}) ----------
	
	function goCoinPayment(ctxPath, empid){
		
		const checked_cnt = $("input:radio[name='coinmoney']:checked").length;
		
		if(checked_cnt == 0){ // 결제금액을 선택하지 않았을 경우
			$("td#error").show();
			return;
		}
		else{ // 결제금액을 선택했을 경우
			$("td#error").hide();
			
			const coinmoney = $("input:radio[name='coinmoney']:checked").val();

			opener.goCoinPurchaseEnd(ctxPath, empid, coinmoney); // 팝업창에서 부모창 함수 호출		
			self.close(); // 팝업창 닫기
		}
		
	} // end of function goCoinPayment(ctxPath, empid){} ----------
</script>
</head>
<body>	
	<%-- content start --%>
	<div class="container-fluid" style="width: 80%; margin: 3% auto; border: 1px solid #ddd; text-align: center;">
	   	<h2 class="my-5"><i class="fa-solid fa-angles-right"></i>&nbsp;&nbsp;포인트충천 결제방식 선택&nbsp;&nbsp;<i class="fa-solid fa-angles-left"></i></h2>
	    
	   	<div class="table-responsive" style="margin-top: 30px;">           
	    	<table class="table table-bordered">
	       		<thead>
	           		<tr>
	           			<th style="width: 50%">금 액</th>
	           			<th style="width: 30%">POINT</th>
	           		</tr>
	       		</thead>
	       		<tbody>
	           		<tr>
	           			<td><label class="radio-inline"><input type="radio" name="coinmoney" value="300000" />&nbsp;&nbsp;300,000원</label></td>
	              		<td><span>3,000</span></td>
		            </tr>
		            <tr>
	              		<td><label class="radio-inline"><input type="radio" name="coinmoney" value="200000" />&nbsp;&nbsp;200,000원</label></td>
		              	<td><span>2,000</span></td>
		            </tr>
	           		<tr>
	           			<td><label class="radio-inline"><input type="radio" name="coinmoney" value="100000" />&nbsp;&nbsp;100,000원</label></td>
	           			<td><span>1,000</span></td>
	           		</tr>
	           		<tr>
	           			<td id="purchase" colspan="3" align="center" style="height: 50px;">
	           				<button class="btn purchase_btn" type="button" onclick="goCoinPayment('<%= ctxPath%>','${(sessionScope.loginuser).empid}')">결제하기</button>  
	           			</td>
	           		</tr>
	           		<tr>
	           			<td id="error" colspan="3" align="center" style="height: 50px; color: #e68c0e; font-weight: bold;">*** 결제종류에 따른 금액을 선택하세요. ***</td>
	           		</tr>
	       		</tbody>
	       	</table>
	   	</div>
	</div>
	<%-- content end --%>
</body>
</html>