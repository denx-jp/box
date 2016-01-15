class BoxFilesController < ApplicationController
  before_filter :set_request
  before_action :authenticate_user!
  before_action :set_path

  DATA_DIR = Rails.root.join('data')

  # GET /
  def index
    if @path.directory?
      @box_files = get_contain_box_files(@path)
    elsif @path.file?
      send_file @path, disposition: :inline
    end
  end

  def search
    keyword = params[:keyword]
    return redirect_to '/' if keyword.blank?
    @box_files = get_contain_box_files(@path, recursive: true)
      .select {|file| file[:basename].include?(keyword)}
    render :index
  end

  def upload
    upload_file = params[:upload_file]
    # TODO: file validation
    save_path = @path.join(upload_file.original_filename)
    is_overwrite = File.exists?(save_path)
    FileUtils.move(upload_file.path, save_path)
    # アップロード直後はURLにファイルパスがまだ指定されてないので相対パスが1つ上になってしまうので調整する
    @parent_relative_path = @relative_path
    @relative_path = @relative_path.join(upload_file.original_filename)
    UpdateHistory.create(action: is_overwrite ? 'update' : 'create', path: @relative_path)
    flash[:notice] = "アップロード成功：#{save_path.relative_path_from(DATA_DIR)}"
    redirect_to make_redirect_path(@parent_relative_path)
  end

  def delete
    @path.rmtree
    UpdateHistory.create(action: 'delete', path: @relative_path)
    flash[:notice] = "削除成功：#{@relative_path}"
    redirect_to make_redirect_path(@parent_relative_path)
  end

  def create_folder
    folder_name = get_path_param(:foldername)
    raise 'empty foldername forbidden' if folder_name.blank?
    folder_path = @path.join(folder_name)
    raise 'already exists' if folder_path.exist?
    folder_path.mkdir
    UpdateHistory.create(action: 'create_dir', path: @relative_path.join(folder_name))
    redirect_to make_redirect_path(@relative_path)
  end

  private
  def get_contain_box_files(parent_dir_pathname, recursive: false)
    glob_pattern = recursive ? '**/*' : '*'
    Pathname.glob(parent_dir_pathname + glob_pattern)
      .map {|pathname| map_pathname_to_box_file(pathname)}
      .sort_by {|file| file[:is_directory] ? 0 : 1}
  end

  def set_path
    @path = DATA_DIR + get_path_param(:path)
    @relative_path = @path.relative_path_from(DATA_DIR)
    @parent_relative_path = @path.parent.relative_path_from(DATA_DIR)
    raise "error" unless @path.readable?
  end

  def map_pathname_to_box_file(pathname)
    {
      path: pathname.relative_path_from(DATA_DIR).to_s,
      basename: pathname.basename.to_s,
      is_directory: pathname.directory?,
      is_image: %w(.jpg .gif .png).include?(pathname.extname),
      updated_at: pathname.mtime,
    }
  end

  def make_redirect_path(relative_pathname)
    "/files/#{URI.encode(relative_pathname.to_s)}"
  end

  def get_path_param(param_name_sym)
    URI.decode(params[param_name_sym] || '')
  end

  def set_request
    Thread.current[:request] = request
  end
end
