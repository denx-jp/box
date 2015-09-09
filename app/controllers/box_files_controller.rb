class BoxFilesController < ApplicationController
  # GET /
  def index
    @path = Pathname.new(CGI.unescape(params[:path] || ''))
    target = Rails.root.join('data', @path)
    if File.directory?(target)
      @box_files = Dir.foreach(target).reject {|n| n == '.'}.map do |name|
        abs_path = target.join(name)
        rel_path = @path.join(name)
        {
          path: rel_path,
          basename: File.basename(rel_path),
          is_directory: File.directory?(abs_path),
          updated_at: Time.now,
        }
      end
    else
      send_file target, disposition: :inline
    end
  end

  def upload
    upload_file = params[:upload_file]
    target_dir = Pathname.new(params[:target_dir])
    abs_target_dir = Rails.root.join('data', target_dir)
    return unless upload_file
    # TODO: file validation
    # TODO: overwrite check
    save_path = abs_target_dir.join(upload_file.original_filename)
    File.open(save_path, "wb") do |f|
      f.write(upload_file.read)
    end
    flash[:notice] = "アップロード成功：#{target_dir.join(upload_file.original_filename)}"
    redirect_to '/' + target_dir.to_s
  end
end
