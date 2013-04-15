$(function(){
    var charLimit = 140;
    var tweetCount = 0;
    var currentCount = $("textarea[name=tweet]").val().length;

	$(".count span").text(currentCount + "/140 [Tweets: "+Math.ceil(currentCount / charLimit)+"]");
    
    $("textarea[name=tweet]").keyup(function(){

       currentCount = $(this).val().length;
       if(currentCount > 0) { tweetCount = Math.ceil(currentCount / charLimit);}
       
       $(".count span").text(currentCount + "/140 [Tweets: "+tweetCount+"]");
         
    });
});