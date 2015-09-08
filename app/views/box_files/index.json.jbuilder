json.array!(@box_files) do |box_file|
  json.extract! box_file, :id
  json.url box_file_url(box_file, format: :json)
end
