$(function(){
  console.log('2222')
  $('.cardHead button').click(
    function(){
      $('.popupWrap').css({display : 'flex'})
    }
  );
  $('.popupHead button').click(
    function(){
      $('.popupWrap').css({display : 'none'})
    }
  );
})