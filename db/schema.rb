ActiveRecord::Schema.define(:version => 0) do
  create_table "spreadsheets" do |t|
    t.string "name"
  end
  create_table "rows" do |t|
    t.integer "spreadsheet_id"
  end
  create_table "columns" do |t|
    t.string "name"
    t.integer "spreadsheet_id"
  end
  create_table "boxes" do |t|
    t.string "content"
    t.integer "row_id", "column_id", "spreadsheet_id"
  end
end
