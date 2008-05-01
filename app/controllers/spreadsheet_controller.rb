class SpreadsheetController < ApplicationController
  def index
    if params[:id]
      @spreadsheet = Spreadsheet.find(params[:id])
    else
      @spreadsheet = Spreadsheet.new
    end
  end
  def update
    case params[:id]
    when "new"
      @spreadsheet = Spreadsheet.new
    else
      @spreadsheet = Spreadsheet.find(params[:id])
    end
    @spreadsheet.from_javascript(params)
    render :update do |page|
      page.<< @spreadsheet.to_javascript
      page.<< "render_table() ;"
    end
  end
end
