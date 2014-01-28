require 'sinatra'
require 'json'
require './twalert.rb'

get "/ping" do
	"alive"
end
get "/" do
	Twalert.alert request
end

