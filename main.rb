require 'sinatra'
require 'json'
require './twalert.rb'

get "/ping" do
	"alive"
end
post "/" do
	Twalert.alert request
end

