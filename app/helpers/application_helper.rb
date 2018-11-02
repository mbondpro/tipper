module ApplicationHelper

  # Create table header row from list
  def header_row(heads)
    content_tag :tr do
      if heads.respond_to?(:each)
        heads.collect {|hd| concat(content_tag(:th, hd))}
      else
        content_tag(:th, heads)
      end
    end
  end
end
