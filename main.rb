require 'sinatra'
require 'json'
require './twalert.rb'

get "/ping" do
	"alive"
end
post "/" do
	request.body.rewind
	buf = request.body.read
	p "buf = #{buf}"
        if buf =~ /alert\s*=\s*(.*)$/ then
        	data = JSON.parse URI.decode $1
		p "json = #{data}"
		Twalert.alert request, data
	end
end

