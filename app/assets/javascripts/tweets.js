$(function(){
    var charLimit = 140;
    var currentCount = $("textarea[name=tweet]").val().length;
    var tweetCount = Math.ceil(currentCount / charLimit);

	$(".count span").text(currentCount + "/140 [Tweets: "+tweetCount+"]");
    
    $("textarea[name=tweet]").keyup(function(){
       currentCount = $(this).val().length;
       tweetCount = Math.ceil(currentCount / charLimit);
       $(".count span").text(currentCount + "/140 [Tweets: "+tweetCount+"]");
         
    });
});