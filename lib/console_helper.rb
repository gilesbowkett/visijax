def show_all
  [Spreadsheet, Column, Row, Box].each do |model|
    puts model
    model.find(:all).each {|instance| puts instance.inspect}
    puts
  end
end

def devastate
  [Spreadsheet, Column, Row, Box].each do |model|
    model.destroy_all
  end
end
