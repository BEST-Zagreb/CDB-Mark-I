class PeopleController < ApplicationController
  before_filter :find_company

  def new
    @person = Person.new
  end

  def create
    @company.people.create params[:person]
    redirect_to company_path(@company)
  end

  def edit
    @person = @company.people.get params[:id]
  end

  def update
    person = @company.people.get params[:id]
    person.update params[:person]
    redirect_to company_path(@company)
  end

  def destroy
    person = @company.people.get params[:id]
    # destroy person
    person.destroy
    redirect_to company_path(@company)
  end

  protected

  def find_company
    @company = Company.get params[:company_id]
  end
end

