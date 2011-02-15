module ApplicationHelper
  
  # Returns a default title if there's no specific one
  def title
    if @title.nil?
      return "Sasi"
    else
      return "Sasi | #{@title}"
    end
  end
end
