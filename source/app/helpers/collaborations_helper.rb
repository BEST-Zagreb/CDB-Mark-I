# encoding: utf-8
module CollaborationsHelper
  
  def sort_by_priority(collaborations)
    collaborations.sort do |c1,c2|
      (c1.priority? == c2.priority?) ?
        (c1.company.name <=> c2.company.name) :
        (c2.priority? and !c1.priority?) ? 1 : -1
    end
  end
  
  def filter_checkbox(name, text)
    input = { :value => name, :type => 'checkbox', :name => 'f[]' }
    input[:checked] = @filters.include?(name)
    "<label>#{content_tag(:input, nil, input)} #{text}</label>".html_safe
  end
  
  def collaboration_status_icon(collaboration)
    if collaboration.unsuccessful?
      '<span class="unicon" title="odbijeno">✖</span>'
    elsif collaboration.successful?
      '<span class="unicon" title="uspješno">€€</span>'
    elsif collaboration.meeting?
      '<span class="unicon-small" title="sastanak">◷</span>'
    elsif collaboration.letter?
      '<span class="unicon-small" title="dopis">✉</span>'
    elsif collaboration.contacted?
      '<span class="unicon-small" title="kontaktirano">☎</span>'
    end.try :html_safe
  end
  
end
