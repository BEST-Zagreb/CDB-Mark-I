class CollaborationsController < ApplicationController
  
  def new
    @collaboration = Collaboration.new(:company_id => params[:company_id], :project_id => params[:project_id])
    @projects = Project.all(:order => [:name.asc])
    @companies = Company.all(:order => [:name.asc])
  end

  def create
    collaboration = Collaboration.create params[:collaboration]
    redirect_to edit_collaboration_path(collaboration)
  end

  def edit
    @collaboration = Collaboration.get params[:id]
  end

  def update
    collaboration = Collaboration.get params[:id]
    collaboration.update params[:collaboration]
    redirect_to project_path(collaboration.project)
  end

  def destroy
    collaboration = Collaboration.get params[:id]
    project = collaboration.project
    collaboration.destroy
    redirect_to project_path(project)
  end
  
end
