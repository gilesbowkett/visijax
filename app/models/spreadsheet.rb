class Spreadsheet < ActiveRecord::Base
  has_many :rows
  has_many :columns
  has_many :boxes
  
  # this file does some pretty painful JavaScript object to Ruby object conversions. this
  # should all be handled via JSON but I couldn't remember if there was an easy way to
  # send JSON back up to the server. (I know it's easy to get JSON from Rails but couldn't
  # recall if getting JSON *into* Rails was equally easy.) the more I look at this code the
  # more painfully obvious it becomes that it needs a JSON rewrite, especially since it's
  # almost all controller stuff taking place in a damn model.

  def from_javascript(params)
    clear
    parse_columns_from_params(params[:column_names])
    parse_rows_from_params(params[:row_arrays])
    parse_boxes_from_params(params[:row_arrays])
    save
    parse_changed_value_from_params(params)
    save
  end
  
  def clear
    [rows, columns, boxes].each do |association|
      association.destroy_all
    end
  end
  
  def parse_columns_from_params(column_arrays)
    column_arrays.each do |index, column_name|
      next if column_name.empty?
      column = Column.new(:name => column_name)
      columns << column
    end
  end
  
  def parse_rows_from_params(row_arrays)
    row_arrays.each do |index, row_hash|
      row_hash.each do |index, cell|
        if 0 == index.to_i
          row = Row.new(:name => cell)
          rows << row
        end
      end
    end
  end
  
  def parse_boxes_from_params(row_arrays)
    row_arrays.each do |row_index, row_hash|
      row_index = row_index.to_i
      row_hash.each do |index_within_row, cell|
        index_within_row = index_within_row.to_i
        next if 0 == index_within_row
        box = Box.new(:content => cell,
                      :row => rows[row_index],
                      :column => self.columns[index_within_row - 1]) # columns and rows both consistently wrong
                      # -1 because we don't make the "variables" column into a Column model
        boxes << box
      end
    end
  end
  
  def parse_changed_value_from_params(params)
    edited = edited_box(params[:editorId])
    case edited
    when Box
      edited_box(params[:editorId]).content = params["#{params[:editorId]}-inplaceeditor".to_sym]
    when Row
      edited_box(params[:editorId]).name = params["#{params[:editorId]}-inplaceeditor".to_sym]
    end
  end
  
  def edited_box(ajax_in_place_editor_dynamic_id)
    rows_and_boxes = (rows.collect {|row| [row, row.boxes]}).flatten
    box_number = extract_box_number(ajax_in_place_editor_dynamic_id)
    rows_and_boxes[box_number]
  end
  
  def extract_box_number(ajax_dynamically_generated_id)
    (ajax_dynamically_generated_id.match(/spreadsheet_ajax_id_(\d+)/))[1].to_i
  end
  
  def to_javascript
    javascript =<<JAVASCRIPT
      spreadsheet_id = #{(id ? id : 'new').inspect} ;
      column_names = #{column_names.inspect} ;
      row_arrays = #{row_arrays.inspect} ;
      ajax_counter = #{ajax_counter.inspect} ;
JAVASCRIPT
    javascript
  end

  def column_names
    if columns.empty?
      ["", "LandingPage"]
    else
      [""] + columns.collect {|column| column.name}
    end
  end
  
  def row_arrays
    if rows.empty?
      [
       ["s.pageName", "'latimes.com:example: || front.'"],
       ["s.server", "'example.latimes.com'"],
       ["s.channel", "'latimes.com:example'"]
      ]
    else
      rows.collect {|row| [row.name, row.boxes.collect {|box| box.content}].flatten}
    end
  end
  
  def ajax_counter
    row_arrays.flatten.size
  end
  
end
