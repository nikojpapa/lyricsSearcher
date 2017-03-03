require 'awesome_print'
require 'nokogiri'
require 'open-uri'
require 'optparse'

@options = {

}

OptionParser.new do |opts|

	opts.on("-l", "--lyrics LYRICS", "Lyrics") do |l|
		@options[:lyrics] = l
	end

end.parse!

required_options = @options.select{|opt,val| val.nil?}
if !required_options.empty?
	ap "Please enter the following options:"
	ap required_options
	exit
end
ap @options

matched_songs = []

passenger_songs_html = `curl http://www.metrolyrics.com/passenger-lyrics.html`

links_list = passenger_songs_html.scan(/http.*lyrics-passenger\.html/)
links_list.each do |href|
	puts href
	lyrics_page_html = Nokogiri::HTML(open(href))
	# lyrics_page_html_str = `curl #{href}`
	# lyrics_page_html = Nokogiri::HTML(lyrics_page_html_str)

	lyrics = lyrics_page_html.xpath('//*[@id="lyrics-body-text"]').text

	# if href = "www.metrolyrics.com/27-lyrics-passenger.html"
	# 	puts lyrics
	# end

	# ap lyrics.text
	# exit
	if lyrics =~ /#{@options[:lyrics]}/i
		matched_songs << href
	end
end

# ap links_list

ap "MATCHED SONGS:"
ap matched_songs