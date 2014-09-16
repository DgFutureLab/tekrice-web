require 'sinatra'
require 'json'
require 'net/http'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  erb :main
end

get '/dashboard' do
  api_url = "http://128.199.191.249/nodes/all"
  resp    = Net::HTTP.get_response( URI.parse(api_url) )
  result  = resp.body
  data    = JSON.parse(result)

  erb :dashboard, locals:{ data:data }
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/dashboard/nodes/:uuid' do
  api_url = "http://128.199.191.249/reading/node_2/distance"
  resp    = Net::HTTP.get_response( URI.parse(api_url) )
  result  = resp.body
  data    = JSON.parse(result)

  erb :nodedetail, locals:{ id:params[:uuid], data:data }
end

get '/dashboard/settings' do
  erb :settings
end

get '/dashboard/map' do
  erb :googlemap
end

get '/test/test.json' do
  data = { :location => "here", :data => "test data" }
  response_data = data.to_json
end

get '/test/mapbox' do
  test = "jojojojo"
  erb :mapbox, locals:{foo: test}
end

helpers do
  def partial template
    erb template, layout:false
  end
end
