class LocalResource
  attr_reader :uri
  
  def initialize(uri, name)
    @uri = uri
    @name = name
  end
  
  def file
    @file ||= File.new(@name, 'w+').tap do |f|
      io.rewind
      f.write(io.read)
    end
  end
  
  def io
    @io ||= uri.open
  end
  
  def encoding
    io.rewind
    io.read.encoding
  end
  
  def tmp_filename
    [
      Pathname.new(uri.path).basename,
      Pathname.new(uri.path).extname
    ]
  end
  
  def tmp_folder
    # If we're using Rails:
    Rails.root.join('activities')
    # Otherwise:
    # '/wherever/you/want'
  end
end

def local_resource_from_url(url, name)
  LocalResource.new(URI.parse(url), name)
end

require 'wikipedia'
acts = Activity.all[1..2]
acts.each do |act|
	entry = Wikipedia.find act.name
	urls = entry.image_urls
	if urls
		url = urls.first
		local_resource = local_resource_from_url(url, act.name)
  # We have a copy of the remote file for processing
  	local_copy = local_resource.file
  	p local_copy.path
	end
end



	

