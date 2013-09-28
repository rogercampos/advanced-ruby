class ProjectsController < ApplicationController
  def create
    @project = Project.find_by_name params[:name].to_sym
  end
end

