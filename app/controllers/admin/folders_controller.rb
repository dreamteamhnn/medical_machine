class Admin::FoldersController < Admin::BaseController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  # GET /folders
  # GET /folders.json
  def index
    @folders = Folder.all
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
    @images = @folder.images.all
  end

  # GET /folders/new
  def new
    @folder = Folder.new
    @image = @folder.images.build
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(name: "New folder")

    respond_to do |format|
      if @folder.save
        format.html { redirect_to edit_admin_folder_path(@folder), notice: 'Folder was successfully created.' }
        format.json { render :edit, status: :created, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        @folder.images.where.not(id: params[:current_image_ids]).destroy_all if @folder.images.present?
        params[:images]['image_url'].each do |a|
          @image = @folder.images.create!(image_url: a, folder_id: @folder.id)
        end if params[:images].present?
        format.html { redirect_to edit_admin_folder_path(@folder), notice: 'Folder was successfully updated.' }
        format.json { render :edit, status: :ok, location: @folders }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to edit_admin_folder_path(Folder.first), notice: 'Folder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id]) || Folder.first if params[:id].to_i != 0
      @folders = Folder.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name,
        image_attributes: [:id, :image_url, :imageable_id, :imageable_type, :image_url_cache, :_destroy])
    end
end
