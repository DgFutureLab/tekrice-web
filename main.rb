require 'sinatra'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  erb :main
end

get '/dashboard' do
  erb :dashboard
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/dashboard/nodes/:uuid' do
  erb :nodedetail, locals:{ id:params[:uuid] }
end

get '/dashboard/settings' do
  erb :settings
end

get '/test.json' do
  data = { :location => "here", :data => "test data" }
  response_data = data.to_json
end

get '/mapbox' do
  test = "jojojojo"
  erb :mapbox, locals:{foo: test}
end

get '/googlemap' do
  erb :googlemap
end

helpers do
  def partial template
    erb template, layout:false
  end
end
