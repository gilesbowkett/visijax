class Row < ActiveRecord::Base
  belongs_to :spreadsheet
  has_many :boxes
end
