class BoxFilesController < ApplicationController
  # GET /
  def index
    @path = Pathname.new(CGI.unescape(params[:path]) || '')
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
end
