class Admin::ProjectsController < Admin::BaseController
  before_action :load_project, only: [:show, :edit, :update, :destroy]
  before_action :load_projects, only: [:index]

  def index
    
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "Thêm mới thành công"
      redirect_to admin_projects_path()
    else
      flash[:danger] = @project.errors.full_messages
      render :new
    end
  end

  def edit
    
  end

  def update
    if @project.update_attributes(project_params)
      flash[:success] = "Chỉnh sửa thàng công"
      redirect_to admin_projects_path()
    else
      flash[:danger] = @project.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @project
      project_title = @project.title
      if @project.destroy
        flash[:success] = "Xóa dự án #{project_title} thành công!"
      else
        flash[:danger] = @project.errors.full_messages
      end
    end
    redirect_to admin_projects_path
  end

  private

  def load_projects
    @projects = Project.all
  end

  def load_project
    @project = Project.friendly.find params[:id]
  end

  def project_params
    params.require(:project).permit(Project::PROJECT_ATTRIBUTES)
  end
end
