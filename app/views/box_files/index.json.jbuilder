json.array!(@box_files) do |box_file|
  json.extract! box_file, *box_file.keys
  json.url "#{root_url}files/#{box_file[:path]}"
end
