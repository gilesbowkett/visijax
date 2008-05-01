var columns_template = new Template('<th>#{column_name}</th>') ;

var rows_template = new Template('<tr>#{cells}</tr>') ;

var cells_template = new Template('<td><span id="#{id}">#{content}</span></td>') ;

var table_template = new Template('\
<table id="spreadsheet_table" class="sortable resizable editable">\
	<thead>\
		<tr>\
			#{columns}\
		</tr>\
	</thead>\
	<tbody>\
		#{rows}\
	</tbody>\
</table>\
') ;

var ajax_template = new Template('new Ajax.InPlaceEditor("#{div}",\
"#{url}",\
{htmlResponse: false,\
 highlightcolor: "#FFFFFF",\
 callback: function(form, value) {\
  return "authenticity_token=#{form_auth_token}&" + spreadsheet_table.serialize(form, value);\
 }\
}) ;\
') ;
