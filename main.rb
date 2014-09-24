require 'sinatra'
require 'json'
require 'net/http'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  erb :main
end

get '/dashboard' do
  no_data = {"data" => [{"value" => "N/A"}]}
  dist_api_url  = "http://128.199.191.249/reading/node_2/distance"
  humid_api_url = "http://128.199.191.249/reading/node_2/humidity"
  temp_api_url  = "http://128.199.191.249/reading/node_2/temperature"

  dist_resp   = Net::HTTP.get_response( URI.parse(dist_api_url) )
  if dist_resp.code == "200"
    dist_result = JSON.parse(dist_resp.body)
    @dist = (!dist_result.nil? && !dist_result["data"].empty? && dist_result["errors"].empty?) ? dist_result : no_data
  else
    @dist = no_data
  end

  humid_resp   = Net::HTTP.get_response( URI.parse(humid_api_url) )
  if humid_resp.code == "200"
    humid_result = JSON.parse(humid_resp.body)
    @humid = (!humid_result.nil? && !humid_result["data"].empty? && humid_result["errors"].empty?) ? humid_result : no_data
  else
    @humid = no_data
  end

  temp_resp   = Net::HTTP.get_response( URI.parse(temp_api_url) )
  if temp_resp.code == "200"
    temp_result = JSON.parse(temp_resp.body)
    @temp = (!temp_result.nil? && !temp_result["data"].empty? && temp_result["errors"].empty?) ? temp_result : no_data
  else
    @temp = no_data
  end

  erb :dashboard, locals:{ dist:@dist["data"][0]["value"], humid:@humid["data"][0]["value"], temp:@temp["data"][0]["value"] }
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/dashboard/nodes/:uuid' do
  # Placeholder for all node data
  #
  #api_url = "http://128.199.191.249/nodes/all"
  no_data = {"data" => [{"value" => "N/A"}]}
  
  dist_api_url  = "http://128.199.191.249/reading/node_#{params[:uuid].to_s}/distance"
  humid_api_url = "http://128.199.191.249/reading/node_#{params[:uuid]}/humidity"
  temp_api_url  = "http://128.199.191.249/reading/node_#{params[:uuid]}/temperature"

  dist_resp   = Net::HTTP.get_response( URI.parse(dist_api_url) )
  if dist_resp.code == "200"
    dist_result = JSON.parse(dist_resp.body)
    @dist = (!dist_result.nil? && !dist_result["data"].empty? && dist_result["errors"].empty?) ? dist_result : no_data
  else
    @dist = no_data
  end

  humid_resp   = Net::HTTP.get_response( URI.parse(humid_api_url) )
  if humid_resp.code == "200"
    humid_result = JSON.parse(humid_resp.body)
    @humid = (!humid_result.nil? && !humid_result["data"].empty? && humid_result["errors"].empty?) ? humid_result : no_data
  else
    @humid = no_data
  end

  temp_resp   = Net::HTTP.get_response( URI.parse(temp_api_url) )
  if temp_resp.code == "200"
    temp_result = JSON.parse(temp_resp.body)
    @temp = (!temp_result.nil? && !temp_result["data"].empty? && temp_result["errors"].empty?) ? temp_result : no_data
  else
    @temp = no_data
  end

  erb :nodedetail, locals:{ id:params[:uuid], dist:@dist["data"][0]["value"], humid:@humid["data"][0]["value"], temp:@temp["data"][0]["value"] }
end

get '/dashboard/settings' do
  erb :settings
end

get '/dashboard/map' do
  data = [
    { latitude:35.143951, longitude:139.988560, status:"ok" },
    { latitude:35.143945, longitude:139.988236, status:"ok" },
    { latitude:35.144150, longitude:139.988486, status:"disabled" },
    { latitude:35.144115, longitude:139.988134, status:"disabled" }
  ]
  erb :map, locals:{ data:data.to_json }
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
