(function(){
	var person1 = {
		id:'1',
		sex:'��'
	}
	var person2 = {
		id:'2',
		sex:'Ů'
	}
	var mixPerson = $.extend({},person1,person2);
	$.initExtends = {};
	console.log($.initExtends);
})(jQuery)