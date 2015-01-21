(function($){
	var methods = {
		initIndex :function(callback){
			callback();
		},
		initPerson:function(person){
			person = person||{};
			person.name = "user function InitPerson";
			console.log(person);
		},
		initPersonUserObj:function(person){
			person = person||{};
			person.name = "user function initPersonUserObj";
			console.log(person);
		},
		createPerson:function(){
			var person = {
				id:'1',
				sex:'ÄÐ',
				name:'Ð¡Ã÷'
			}
			$.method.initPerson();
			methods.initPersonUserObj(person);
		}
		
	};
	$.method = methods;
	$.uploadOptition = {
			trNum:0,
			projectName:''
			
	}
})(jQuery);