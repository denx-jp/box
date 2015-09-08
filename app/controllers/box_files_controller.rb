class BoxFilesController < ApplicationController
  before_action :set_box_file, only: [:show, :edit, :update, :destroy]

  # GET /box_files
  # GET /box_files.json
  def index
    @box_files = BoxFile.all
  end

  # GET /box_files/1
  # GET /box_files/1.json
  def show
  end

  # GET /box_files/new
  def new
    @box_file = BoxFile.new
  end

  # GET /box_files/1/edit
  def edit
  end

  # POST /box_files
  # POST /box_files.json
  def create
    @box_file = BoxFile.new(box_file_params)

    respond_to do |format|
      if @box_file.save
        format.html { redirect_to @box_file, notice: 'Box file was successfully created.' }
        format.json { render :show, status: :created, location: @box_file }
      else
        format.html { render :new }
        format.json { render json: @box_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /box_files/1
  # PATCH/PUT /box_files/1.json
  def update
    respond_to do |format|
      if @box_file.update(box_file_params)
        format.html { redirect_to @box_file, notice: 'Box file was successfully updated.' }
        format.json { render :show, status: :ok, location: @box_file }
      else
        format.html { render :edit }
        format.json { render json: @box_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_files/1
  # DELETE /box_files/1.json
  def destroy
    @box_file.destroy
    respond_to do |format|
      format.html { redirect_to box_files_url, notice: 'Box file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box_file
      @box_file = BoxFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_file_params
      params[:box_file]
    end
end
