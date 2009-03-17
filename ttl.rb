require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'hpricot'
require 'lab_file'

get '/' do
   erb :new
end         

post '/' do
   @url = params[:ttl_url]
   @results = get_samples(@url)
   erb :results
end          

helpers do
   def get_samples(url)
      pid = url.match(/(\/)([0-9]+)(\.html)/).to_a[2] 
      xml_file = vinyl?(url) ? "http://turntablelab.com/vinyl/preview_playlist.xml?pid=#{pid}" : "http://turntablelab.com/digital/preview_playlist.xml?tid=#{pid}"
      parsed = Hpricot.XML(open(xml_file))
      results = []
      (parsed/:item).each do |item|
        title = (item/:title).inner_html
        file = (item/:enclosure).first.attributes['url']
        artist = (item/'itunes:author').inner_html
        results << LabFile.new(:artist=>artist, :file=>file, :title=>title)
      end
      return results         
   end
   
   def vinyl?(url)
      !!url.match(/\/vinyl\//)
   end
end