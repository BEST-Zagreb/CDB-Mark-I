require 'sinatra'
require 'dm-core'

use Rack::Auth::Basic do |username, password|
  # Real value removed for publication; set your own before running.
  [username, password] == ['CHANGE_ME_USERNAME', 'CHANGE_ME_PASSWORD']
end


class Company
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String
  property :url, String
  property :address, String
  property :city, String
  property :zip, String
  property :country, String
  
  has n, :people
  has n, :collaborations
  #has n, :projects
end

class Person
  include DataMapper::Resource
  
  property :id,    Serial
  property :name,  String
  property :email, String
  property :phone, String
  
  belongs_to :company
end

class Project
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String
  #property :date, Date
  
  #belongs_to :company
  has n, :collaborations
end

class Collaboration
  include DataMapper::Resource
  
  property :id, Serial
  property :company_id, Integer
  property :project_id, Integer
  property :person_id, Integer
  property :responsible, String
  property :comment, Text
  property :contacted, Boolean
  property :letter, Boolean
  property :meeting, Boolean
  property :successful, Boolean

  belongs_to :company
  belongs_to :project
end
  

DataMapper.setup(:default, 'sqlite3:development.sqlite3')
DataMapper.auto_upgrade!

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
      
  def email_link(email)
    "<a href='mailto:#{email}'>#{email}</a>"
  end
  
  def show_person(person)
    output = person.name
    
    if person.email and !person.email.empty?
      output += " (#{email_link person.email})"
    end
    if person.phone and !person.phone.empty?
      output += " tel. #{person.phone}"
    end
    
    output
  end
end

# main page (list of companies)
get '/' do
  @companies = Company.all
  @projects = Project.all
  erb :index
end


# create new company form
get '/companies/new' do
  erb :new_company
end

# action to create new company
post '/companies' do
  company = Company.create params[:company]
  redirect company_path(company)
end

# show company
get '/companies/:id' do
  @company = Company.get params[:id]
  erb :show
end

# show edit company form
get '/companies/:id/edit' do
  @company = Company.get params[:id]
  erb :edit_company
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
  erb :new_person
end

# action to save the new contact
post '/companies/:company_id/people' do
  @company = Company.get params[:company_id]
  @company.people.create params[:person]
  redirect company_path(@company)
end

# show edit person form
get '/companies/:id/people/:id/edit' do
  @company = Company.get params[:id]
  @person = Person.get params[:id]
  erb :edit_person
end

# update a contact
put '/companies/:company_id/people/:id' do
  company = Company.get params[:company_id]
  person = Person.get params[:id]
  person.update params[:person]
  redirect '/'
end

# destroy person
delete '/companies/:company_id/people/:id' do
  company = Company.get params[:company_id]
  person = Person.get params[:id]
  # destroy person
  person.destroy
  redirect '/'
end

# form to create new project
get '/projects/new' do
  @companies = Company.all
  erb :new_project
end

# action to create new project
post '/projects' do
  project = Project.create params[:project]
  redirect '/'
end

# show project
get '/projects/:id' do
  @project = Project.get params[:id]
  @collaborations = Collaboration.all
  erb :show_project
end

# show edit project form
get '/projects/:id/edit' do
  @project = Project.get params[:id]
  erb :edit_project
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
get '/companies/:id/collaborations/new' do
  @companies = Company.all
  @company = Company.get params[:id]
  @projects = Project.all
  erb :new_company_collaboration
end

# form to create new collaboration from project
get '/projects/:id/collaborations/new' do
  @companies = Company.all
  @projects = Project.all
  @project = Project.get params[:id]
  erb :new_project_collaboration
end

# action to create new collaboration from project
post '/collaborations' do
  collaboration = Collaboration.create params[:collaboration]
  redirect "/collaborations/#{collaboration.id}/edit"
end

# show edit collaboration form
get '/collaborations/:id/edit' do
  @collaboration = Collaboration.get params[:id]
  erb :edit_collaboration
end

# update collaboration
put '/collaborations/:id' do
  collaboration = Collaboration.get params[:id]
  collaboration.update params[:collaboration]
  redirect "/projects/#{collaboration.project.id}"
end

# destroy collaboration
delete '/collaborations/:id' do
  collaboration = Collaboration.get params[:id]
  collaboration.destroy
  redirect '/'
end

