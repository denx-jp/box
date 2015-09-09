class BoxFile < ActiveRecord::Base
  has_attached_file :content_file, size: { in: 0..100.megabytes }
end
