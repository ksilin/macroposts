module ApplicationHelper

  #we are using helpers for minor tasks related to views, like here - creating a proper title for the pages

  def title
    base_title = "Ruby on Rails Tutorial Sample App"

    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    logo = image_tag("rails.png", :alt => "Sample App", :class => "round")
  end
end
