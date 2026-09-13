class CompaniesController < ApplicationController
  def index
    @companies = Company.all(:order => [:name.asc])
  end
  
  def new
    @company = Company.new
  end
  
  def create
    company = Company.create params[:company]
    redirect_to company_path(company)
  end
  
  def show
    @company = Company.get params[:id]
  end
  
  def edit
    @company = Company.get params[:id]
  end
  
  def update
    company = Company.get params[:id]
    company.update params[:company]
    redirect_to company_path(company)
  end
  
  def destroy
    company = Company.get params[:id]
    # destroy contacts from this company
    company.people.destroy
    # destroy collaborations from this company, too
    company.collaborations.destroy
    company.destroy
    redirect_to root_path
  end
end
