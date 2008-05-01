// model
var SpreadsheetTable = Class.create({
	initialize: function(div_name, template) {
		this.div_name = div_name ;
		this.template = template ;
		this.html = "" ;
	},
	display: function(){
		$(this.div_name).innerHTML = this.html ;
	},
	serialize: function(form, value) {
		var params = "id=" + spreadsheet_id ;
		column_names.each(
			function(name, index) {
				params += "&column_names[" + index + "]=" + column_names[index] ;
			}
		) ;
		row_arrays.each(
			function(array, row_arrays_index) {
				array.each(
					function(content, array_index) {
						params += "&row_arrays[" + row_arrays_index + "][" + array_index + "]=" + content ;
					}
				) ;
			}
		) ;
		params += "&" + form.id + "=" + value ;
		return params ;
	},
	update: function(params){
		this.html = this.template.evaluate(params)
		this.display() ;
	}
}) ;
