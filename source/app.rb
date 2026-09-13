require 'sinatra'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/multibyte'
require 'dm-core'
require 'dm-timestamps'
require 'models'
require 'form_helpers'
require 'haml'

set :haml, :format => :html5

class Querry
  attr_accessor :contacted, :letter, :meeting, :successful
end
  
configure :development, :production do
  DataMapper.setup(:default, 'sqlite3:development.sqlite3')
  DataMapper.auto_upgrade!
end

configure :test do
  DataMapper.setup(:default, 'sqlite3::memory:')
  DataMapper.auto_migrate!
end

configure :production do
  use Rack::Auth::Basic do |username, password|
    # Real value removed for publication; set your own before running.
    [username, password] == ['CHANGE_ME_USERNAME', 'CHANGE_ME_PASSWORD']
  end
end

helpers do
  def company_path(company)
    "/companies/#{company.id}"
  end

  def project_path(project)
    "/projects/#{project.id}"
  end

  def collaboration_path(collaboration)
    "/collaborations/#{collaboration.id}"
  end
  
  def person_path(company, person)
    company_path(company) + "/people/#{person.id}"
  end
  
  def email_link(email)
    "<a href='mailto:#{email}'>#{email}</a>"
  end
  
  def link_to(object)
    case object
    when Project
      "<a href='#{project_path(object)}'>#{object.name}</a>"
    when Company
      "<a href='#{company_path(object)}'>#{object.name}</a>"
    else
      raise ArgumentError
    end
  end
  
  def image_tag(file, attributes = {})
    attributes = attributes.merge(:src => "/images/#{file}")
    attributes[:alt] ||= ''
    "<img#{html_attributes(attributes)}>"
  end
  
  def html_attributes(hash)
    hash.map { |key, value|
      case value
      when NilClass, FalseClass
        ''
      when TrueClass
        " #{key}"
      else
        " #{key}='#{value}'"
      end
    }.join('')
  end
  
  def filter_checkbox(name, text)
    input = { :value => name, :type => 'checkbox', :name => 'f[]' }
    input[:checked] = @filters.include?(name)
    "<label><input#{html_attributes(input)}> #{text}</label>"
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
    end
  end
  
  def truncate(text, length = 30)
    text = text.to_s.mb_chars
    if text.length > length
      short = text[0, length - 3] + '…'
      "<span title='#{text}'>#{short}</span>"
    else
      text
    end
  end
  
  DefaultPageTitle = "Baza kompanija"
  
  def page_title(title)
    title ||= DefaultPageTitle
    if request.path == '/' or title == DefaultPageTitle or title.length > 20
      title
    else
      title + " — " + DefaultPageTitle
    end
  end

  def sort_by_priority(collaborations)
    collaborations.sort do |c1,c2|
      (c1.priority? == c2.priority?) ?
        (c1.company.name <=> c2.company.name) :
        (c2.priority? and !c1.priority?) ? 1 : -1
    end
  end
  
  def delete_link(path, name)
    %(<a href="#{path}" data-method="delete" data-confirm="Zaista želiš obrisati #{name}?">Izbriši #{name}</a>)
  end
end

# main page (list of companies)
get '/' do
  @projects = Project.all(:order => [:created_at.desc])
  erb :index
end

get '/companies' do
  @companies = Company.all(:order => [:name.asc])
  erb :'company/index'
end

# create new company form
get '/companies/new' do
  @company = Company.new
  haml :'company/new'
end

# action to create new company
post '/companies' do
  company = Company.create params[:company]
  redirect company_path(company)
end

# show company
get '/companies/:id' do
  @company = Company.get params[:id]
  erb :'company/show'
end

# show edit company form
get '/companies/:id/edit' do
  @company = Company.get params[:id]
  haml :'company/edit'
end

# update company
put '/companies/:id' do
  company = Company.get params[:id]
  company.update params[:company]
  redirect company_path(company)
end

# destroy company
delete '/companies/:id' do
  company = Company.get params[:id]
  # destroy contacts from this company
  company.people.destroy
  # destroy collaborations from this company, too
  company.collaborations.destroy
  company.destroy
  redirect '/'
end

# form to create new contact for a company
get '/companies/:company_id/people/new' do
  @company = Company.get params[:company_id]
  @person = Person.new
  haml :'company/new_person'
end

# action to save the new contact
post '/companies/:company_id/people' do
  @company = Company.get params[:company_id]
  @company.people.create params[:person]
  redirect company_path(@company)
end

# show edit person form
get '/companies/:company_id/people/:id/edit' do
  @company = Company.get params[:company_id]
  @person = @company.people.get params[:id]
  haml :'company/edit_person'
end

# update a contact
put '/companies/:company_id/people/:id' do
  company = Company.get params[:company_id]
  person = company.people.get params[:id]
  person.update params[:person]
  redirect company_path(company)
end

# destroy person
delete '/companies/:company_id/people/:id' do
  company = Company.get params[:company_id]
  person = company.people.get params[:id]
  # destroy person
  person.destroy
  redirect company_path(company)
end

# form to create new project
get '/projects/new' do
  @project = Project.new
  haml :'project/new'
end

# action to create new project
post '/projects' do
  project = Project.create params[:project]
  redirect project_path(project)
end

# show project
get '/projects/:id' do
  @filters = params[:f] || []
  @project = Project.get params[:id]
  @collaborations = @project.filter_collaborations(@filters).all
  erb :'project/show'
end

# show edit project form
get '/projects/:id/edit' do
  @project = Project.get params[:id]
  haml :'project/edit'
end

# update project
put '/projects/:id' do
  project = Project.get params[:id]
  project.update params[:project]
  redirect project_path(project)
end

# destroy project
delete '/projects/:id' do
  project = Project.get params[:id]
  # destroy collaborations from this project
  project.collaborations.destroy
  project.destroy
  redirect '/'
end

# form to create new collaboration from company
get '/collaborations/new' do
  @collaboration = Collaboration.new(:company_id => params[:company_id], :project_id => params[:project_id])
  @projects = Project.all(:order => [:name.asc])
  @companies = Company.all(:order => [:name.asc])
  haml :'collaboration/new'
end

# action to create new collaboration from project
post '/collaborations' do
  collaboration = Collaboration.create params[:collaboration]
  redirect collaboration_path(collaboration) + '/edit'
end

# show edit collaboration form
get '/collaborations/:id/edit' do
  @collaboration = Collaboration.get params[:id]
  haml :'collaboration/edit'
end

# update collaboration
put '/collaborations/:id' do
  collaboration = Collaboration.get params[:id]
  collaboration.update params[:collaboration]
  redirect project_path(collaboration.project)
end

# destroy collaboration
delete '/collaborations/:id' do
  collaboration = Collaboration.get params[:id]
  project = collaboration.project
  collaboration.destroy
  redirect project_path(project)
end
