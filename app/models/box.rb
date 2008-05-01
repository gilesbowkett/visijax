class Box < ActiveRecord::Base
  belongs_to :spreadsheet
  belongs_to :row
  belongs_to :column
end
