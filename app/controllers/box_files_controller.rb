class BoxFilesController < ApplicationController
  before_action :authenticate_user!

  DATA_DIR = Rails.root.join('data')

  # GET /
  def index
    @path = Pathname.new(CGI.unescape(params[:path] || ''))
    if File.directory?(DATA_DIR + @path)
      @box_files = glob_files('*')
    else
      send_file target, disposition: :inline
    end
  end

  def search
    keyword = params[:keyword]
    @box_files = glob_files('**/*').select do |box_file|
      box_file[:basename].include?(keyword)
    end
    render :index
  end

  def upload
    upload_file = params[:upload_file]
    target_dir = Pathname.new(params[:target_dir])
    abs_target_dir = Rails.root.join('data', target_dir)
    redirect_path = Pathname.new('/files/').join(target_dir).to_s
    redirect_to redirect_path unless upload_file
    # TODO: file validation
    # TODO: overwrite check
    path = target_dir.join(upload_file.original_filename)
    save_path = abs_target_dir.join(upload_file.original_filename)
    overwrite = File.exists?(save_path)
    File.open(save_path, "wb") do |f|
      f.write(upload_file.read)
    end
    flash[:notice] = "アップロード成功：#{path}"
    UpdateHistory.create(
      action: overwrite ? 'update' : 'create',
      path: path,
    )
    redirect_to redirect_path
  end

  private
  def glob_files(pattern)
    Dir.glob(DATA_DIR + pattern).reject {|n| n == '.'}.map do |path|
      abs_path = DATA_DIR.join(path)
      {
        path: path,
        basename: File.basename(path),
        is_directory: File.directory?(abs_path),
        updated_at: File.mtime(abs_path),
      }
    end
  end
end
