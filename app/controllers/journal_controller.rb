class JournalController < ApplicationController
  def index
    debugger
  	@journalrows = Array.new
    @journalrows = @journalrows.paginate(:per_page => 10) 
  end

  def search
  	#debugger
  	
    @journalrows = Array.new

    for row in %x(journalctl -b).split("\n")
      journalrow = JournalRow.new
      journalrow.text = row      
      @journalrows.push(journalrow)
    end
  	
    @journalrows = @journalrows.paginate(:per_page => 10)

    render 'index'
  end
end

#https://gitter.im/noelbk/OpenHack