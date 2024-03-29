class Api::V1::ProjectsController < Api::V1::ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_company.projects.order("#{params[:order_by]} #{params[:direction]}")
    @projects = @projects.apply_filter(params[:search_query]) if params[:search_query].present?
    @projects = paginate @projects, per_page: 20
    render json: {data: @projects, csv_file_link: ENV['PROJECTS_CSV_EXPORT_PATH']}
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if @project
      render json: @project.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.company_id = current_company.id
    if @project.save
      render json: @project.to_json, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update(project_params)
      render json: @project.to_json, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if @project.present?
      @project.destroy
    else
      render json: {error_message: "project can not be found"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_company.projects.where(id: params[:id])&.first
      render json: {error_message: "project can not be found"}, status: :not_found unless @project.present?
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :start_date, :end_date)
    end
end
