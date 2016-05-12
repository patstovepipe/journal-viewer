class JournalController < ApplicationController
  # find better place to store this ddl data
  FLAGS = { "from boot" => "-b", "from date" => "--since=", "kernel ring buffer" => "-k", "unit messages" => "-u" }

  def index
    #debugger

    # do i need to create @flags or can i just reference FLAGS from .erb ?
    @flags = FLAGS
    @units = units()
    @journalrows = Array.new

    # todo get paginate working
    #@journalrows = @journalrows.paginate(:per_page => 10)

  end

  def search
  	#debugger

    @flags = FLAGS
    @units = units()
    @journalrows = journaldata(params[:flag])

    render 'index'
  end

  # for API call
  def journal
    render json: journaldata(params[:flag])
  end

  private def journaldata(flag)
    cmd = "journalctl"

    if !flag.nil? && flag != ""
      cmd = cmd + " " + flag
    end

    journalrows = Array.new
    for row in %x[ #{cmd} ].split("\n")
      journalrows.push(row)
    end

    return journalrows
  end

  private def units
    cmd = "systemctl list-unit-files"

    units = Array.new
    rows = %x[ #{cmd} ].split("\n")

    # We want to get rid of the first, last and second to last item
    rows.delete_at(0)
    rows.delete_at(rows.length-1)
    rows.delete_at(rows.length-1)

    for row in rows
      unit = row
      # the status of the unit is not needed so we get rid of that by finding the first space
      # we just want to list all the units
      pos = row.index(" ")
      if !pos.nil? && pos > -1
        unit = row[0..pos]
      end
      units.push(unit)
    end

    return units
  end
end
