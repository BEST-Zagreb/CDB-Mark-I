class ProjectsController < ApplicationController
  def index
    @projects = Project.all(:order => [:name.desc])
  end
  
  def new
    @project = Project.new
  end
  
  def create
    project = Project.create params[:project]
    redirect_to project_path(project)
  end
  
  def show
    @filters = params[:f] || []
    @project = Project.get params[:id]
    @collaborations = @project.filter_collaborations(@filters).all
  end
  
  def edit
    @project = Project.get params[:id]
  end
  
  def update
    project = Project.get params[:id]
    project.update params[:project]
    redirect_to project_path(project)
  end
  
  def destroy
    project = Project.get params[:id]
    # destroy collaborations from this project
    project.collaborations.destroy
    project.destroy
    redirect_to '/'
  end
end
