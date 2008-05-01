function new_ajax_id() {
	ajax_id_counter++ ;
	return "spreadsheet_ajax_id_" + ajax_id_counter ;
}

function ajax(ajax_counter) {
	javascript = "" ;
	for (i = 0 ; i < ajax_counter ; i++) {
		javascript += ajax_template.evaluate({div: ("spreadsheet_ajax_id_" + i),
																					url: ("/spreadsheet/update/" + spreadsheet_id),
																					form_auth_token: moronic_excessive_security})
	}
	return javascript ;
}

function columns(column_names) {
	var columns  = "" ;
	column_names.each(
		function(name, index) {
			columns += columns_template.evaluate({column_name: name}) ;
		}
	) ;
	return columns ;
}

function rows(row_arrays) {
	var rows  = "" ;
	var counter_which_should_match_ajax_counter = 0 ;
	row_arrays.each(
		function(array, index) {
			var this_row = ""
			array.each(
				function(content, index) {
					this_row += cells_template.evaluate({content: content,
																							id: "spreadsheet_ajax_id_" + counter_which_should_match_ajax_counter}) ;
					counter_which_should_match_ajax_counter++ ;
				}
			) ;
			rows += rows_template.evaluate({cells: this_row}) ;
		}
	) ;
	return rows ;
}

function render_table() {
	spreadsheet_table.update({rows: rows(row_arrays),
														columns: columns(column_names)}) ;
	eval(ajax(ajax_counter)) ;
}

function new_column() {
	column_names.push($('new_page_type').value) ;
	pad_column() ;
	render_table() ;
}

function pad_column() {
	row_arrays.each(
		function(array, index) {
			array.push("undefined") ;
		}
	) ;
	pad_ajax() ;
}

function new_row() {
	pad_row() ;
	render_table() ;
}

function pad_row() {
	var empty_row = [$('new_variable').value] ;
	for (i = 0 ; i < (row_arrays[0].length - 1) ; i++) {
		empty_row.push("undefined") ;
	}
	row_arrays.push(empty_row) ;
	pad_ajax() ;
}

function pad_ajax() {
	ajax_counter += row_arrays[0].length ;
}

function editor_callback(form, value) {
	return "authenticity_token=#{form_auth_token}&" + spreadsheet_table.serialize() ;
}
