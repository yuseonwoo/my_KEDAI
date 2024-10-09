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
<title>LOGIN</title>
<%-- Required meta tags --%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<%-- Bootstrap CSS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/resources/bootstrap-4.6.2-dist/css/bootstrap.min.css" >

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%= ctxPath%>/resources/js/jquery-3.7.1.min.js"></script>
<style type="text/css">
   .form-group input {
      width: 400px;
      height: 60px;
      padding: 0 10px;
      outline: none;
      border: 1px solid #2c4459;
      box-sizing: border-box;
      color: #363636;
   }
   .login_btn {
      width: 100%;
      height: 60px;
      font-size: 18px;
      border: none;
      background: #2c4459;
      color: #fff;
      cursor: pointer;
   }
   .login_btn:hover {
      background: #e68c0e;
      color: #fff;
   }
   a{
      text-decoration: none;
      color: #363636;
   }
   a:hover {
      color: #e68c0e;
   }
   /* text-animation */
   .name {
      font-size: 2.9rem;
      font-weight: bold;
       display: flex;
       position: relative;
   }
   .name::before {
       content: '';
       width: 100%;
       background: #2c4459;
       bottom: 0;
       height: 2px;
       left: 0;
       position: absolute;
   }
   .letter {
        opacity: 0;
        transform: scale(0.8);
        transition: opacity 0.5s ease, transform 0.5s ease;
    }
</style>

<script type="text/javascript">
   $(document).ready(function(){
      
      $("input:text[name='empid']").focus();
        
      $("button#btnSubmit").click(function(){
          goLogin();
       }); 
      
      $("input:password[id='pwd']").keydown(function(e){
           if(e.keyCode == 13) { 
              goLogin(); 
           }
        });
      
      if(${empty sessionScope.loginuser}){
         const loginid = localStorage.getItem('idSave');
           
           if(loginid != null){
              $("input#empid").val(loginid);
              $("input:checkbox[id='idSave']").prop("checked", true);
              $("input:password[name='pwd']").focus();
           }
      }
      
      /* text-animation */
      var delay = 80;

        $('.letter').each(function(index) {
            var $this = $(this);
            
            // Set initial opacity and scale
            $this.css({
                opacity: 0,
                transform: 'scale(0.8)'
            });

            // Animate to final state with delay
            setTimeout(function() {
                $this.animate({
                    opacity: 1
                }, 300); // Duration of opacity change
                
                $this.css({
                    transform: 'scale(1)'
                });
            }, index * delay);
        });
      
        // Repeat animation loop
        setInterval(function() {
            $('.letter').each(function(index) {
                var $this = $(this);
                
                // Animate to initial state
                $this.animate({
                    opacity: 0
                }, 300); // Duration of opacity change
                
                $this.css({
                    transform: 'scale(0.8)'
                });

                // Animate back to final state with delay
                setTimeout(function() {
                    $this.animate({
                        opacity: 1
                    }, 300); // Duration of opacity change
                    
                    $this.css({
                        transform: 'scale(1)'
                    });
                }, index * delay);
            });
        }, $('.letter').length * delay * 2 + 1000); // Adjust interval as needed
      
   }); // end of $(document).ready(function(){}) ----------
   
   // 로그인 시 기기 정보 확인하기 시작 //
    function detectDevice() {
        const userAgent = navigator.userAgent || navigator.vendor || window.opera;

        if (/android/i.test(userAgent)) {
            return "Android";
        }

        if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
            return "iOS";
        }

        if (/Windows|Macintosh|Linux/.test(userAgent)) {
            return "PC";
        }

        return "Unknown";
    }
   
   function goLogin(){
      
      if($("input#empid").val().trim() == ""){
           alert("아이디를 입력하세요.");
           $("input#empid").val("").focus();
           return; 
       }

       if($("input#pwd").val().trim() == ""){
           alert("비밀번호를 입력하세요.");
           $("input#pwd").val("").focus();
           return; 
       }
       
      if($("input:checkbox[id='idSave']").prop("checked")){ 
           localStorage.setItem('idSave', $("input#empid").val());
       }
       else{
           localStorage.removeItem('idSave');
       }
      
      const deviceType = detectDevice();
        console.log("Detected device:", deviceType); // 콘솔에 기기 정보 출력
      
        const form = document.getElementById('loginForm');
      const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'deviceType';
        hiddenInput.value = deviceType;
        form.appendChild(hiddenInput);
        
        form.action = "<%= ctxPath%>/loginEnd.kedai";
        form.method = "post";
        form.submit();
   }
</script>   
</head>
<body>
   <div style="width: 400px; margin: 4% auto; text-align: center;">
      <div style="width: 400px; margin: 0 auto; margin-bottom: 3%;">
         <img alt="logo" src="<%= ctxPath%>/resources/images/common/logo_ver1.png" width="60%" class="img-fluid" />
      </div>
      <br>
      <form name="loginFrm" id="loginForm" style="width: 400px; margin: 0 auto;">
           <div class="form-row mx-0">    
               <div class="form-group" style="margin-bottom: 3%;">
                     <input type="text" class="form-control" name="empid" id="empid" value="" placeholder="사원아이디" />
                  </div>
   
               <div class="form-group" style="margin-bottom: 3%;">
                     <input type="password" class="form-control" name="pwd" id="pwd" value="" placeholder="비밀번호" /> 
               </div>
            </div>
          </form>
        <div style="width: 400px; margin: 0 auto;">
             <button type="button" class="btn login_btn" id="btnSubmit">로그인</button>
            <br><br>
            <div style="text-align: left;">
               <input type="checkbox" id="idSave" />&nbsp;<label for="idSave">아이디 저장하기</label>
               <div style="border: 0px solid red; float: right;">
                  <span><a href="<%= ctxPath%>/login/idPwdFind.kedai">[ 사원아이디 &amp; 비밀번호 찾기 ]</a></span>
               </div>
            </div>
        </div>        
        <br>
          <div class="name">
           <div class="letter" style="color: #2c4459;">W</div>
           <div class="letter" style="color: #2c4459;">e</div>
           <div class="letter" style="color: #2c4459;">l</div>
           <div class="letter" style="color: #2c4459;">c</div>
           <div class="letter" style="color: #2c4459;">o</div>
           <div class="letter" style="color: #2c4459;">m</div>
           <div class="letter" style="color: #2c4459;">e</div>
           <div class="letter" style="color: #2c4459;">!</div>
           <div class="letter">&nbsp;</div>
           <div class="letter" style="color: #e68c0e;">K</div>
           <div class="letter" style="color: #e68c0e;">E</div>
           <div class="letter" style="color: #e68c0e;">D</div>
           <div class="letter" style="color: #e68c0e;">A</div>
           <div class="letter" style="color: #e68c0e;">I</div>
           <div class="letter" style="padding-top: 1%;"><i class="fa-solid fa-paw fa-2xs"></i></div>
      </div>
   </div>
</body>
</html>