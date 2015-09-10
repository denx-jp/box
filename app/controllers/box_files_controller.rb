class BoxFilesController < ApplicationController
  before_action :authenticate_user!

  DATA_DIR = Rails.root.join('data')

  # GET /
  def index
    @path = Pathname.new(CGI.unescape(params[:path] || ''))
    if File.directory?(DATA_DIR + @path)
      @box_files = glob_files(DATA_DIR + @path + '*')
    else
      send_file DATA_DIR + @path, disposition: :inline
    end
  end

  def search
    keyword = params[:keyword]
    @box_files = glob_files(DATA_DIR + '**/*').select do |box_file|
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

  def delete
    @path = Pathname.new(CGI.unescape(params[:path] || ''))
    abs_path = DATA_DIR + @path
    if File.directory?(abs_path)
      FileUtils.rm_r(abs_path)
    else
      FileUtils.rm(abs_path)
    end
    flash[:notice] = "削除成功：#{@path}"
    UpdateHistory.create(
      action: 'delete',
      path: @path,
    )
    redirect_path = File.dirname(Pathname.new('/files/').join(@path).to_s)
    redirect_to redirect_path
  end

  private
  def glob_files(pattern)
    Dir.glob(pattern).reject {|n| n == '.'}.map do |abs_path|
      {
        path: Pathname.new(abs_path).relative_path_from(DATA_DIR).to_s,
        basename: File.basename(abs_path),
        is_directory: File.directory?(abs_path),
        updated_at: File.mtime(abs_path),
        is_image: ['.jpg', '.gif', '.png'].include?(File.extname(abs_path)),
      }
    end
  end
end
