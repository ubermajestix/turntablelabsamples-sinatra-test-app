class LabFile
   attr_reader :artist, :title, :file
   
   def initialize(opts={})
     @artist = opts[:artist]
     @title  = opts[:title]
     @file   = opts[:file]
   end
end