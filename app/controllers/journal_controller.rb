class JournalController < ApplicationController
  def index
    #debugger
  	
    @journalrows = Array.new
    
    # todo get paginate working
    #@journalrows = @journalrows.paginate(:per_page => 10) 

  end

  def search
  	#debugger

    @journalrows = data(params[:flags])

    render 'index'
  end

  # for API call
  def journalctl
    @journalrows = data(params[:flags])
    
    render json: @journalrows
  end

  private def data(flags)
    cmd = "journalctl"

    if !flags.nil? && flags != ""
      cmd = cmd + " " + flags
    end

    @journalrows = Array.new
    for row in %x[ #{cmd} ].split("\n")    
      journalrow = JournalRow.new
      journalrow.text = row
      @journalrows.push(journalrow)
    end

    return @journalrows
  end
end

