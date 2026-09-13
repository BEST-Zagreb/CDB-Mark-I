# encoding: utf-8
module ApplicationHelper
  
  DefaultPageTitle = "Baza kompanija"
  
  def page_title(title)
    title ||= DefaultPageTitle
    if request.path == '/' or title == DefaultPageTitle or title.length > 20
      title
    else
      title + " — " + DefaultPageTitle
    end
  end
  
  def delete_link(path, name)
    link_to "Izbriši #{name}", path, :method => :delete, :confirm => "Zaista želiš obrisati #{name}?"
  end
  
  def link_to(*args, &block)
    object = args.first
    
    case object
    when Project, Company
      super(object.name, object)
    else
      super(*args, &block)
    end
  end
  
end
