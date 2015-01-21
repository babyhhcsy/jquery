(function(){
	var person1 = {
		id:'1',
		sex:'ÄÐ'
	}
	var person2 = {
		id:'2',
		sex:'Å®'
	}
	var mixPerson = $.extend({},person1,person2);
	$.initExtends = {};
	console.log($.initExtends);
})(jQuery)