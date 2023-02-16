class DTOCollection < Array
  def total_count=(count)
    @total_count = count
  end

  def total_pages=(pages)
    @total_pages = pages
  end

  def total_count
    @total_count || self.length
  end

  def total_pages
    @total_pages || 1
  end
end  
