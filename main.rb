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
  # Placeholder for individual node data
  #
  #dist_api_url  = "http://128.199.191.249/reading/node_#{params[:uuid]}/distance"
  #humid_api_url = "http://128.199.191.249/reading/node_#{params[:uuid]}/humidity"
  #temp_api_url  = "http://128.199.191.249/reading/node_#{params[:uuid]}/temperature"
  #dist_resp   = Net::HTTP.get_response( URI.parse(dist_api_url) )
  #dist_result = dist_resp.body
  #dist = JSON.parse(dist_result)
  #humid_resp   = Net::HTTP.get_response( URI.parse(humid_api_url) )
  #humid_result = humid_resp.body
  #humid= JSON.parse(humid_result)
  #temp_resp   = Net::HTTP.get_response( URI.parse(temp_api_url) )
  #temp_result = temp_resp.body
  #temp = JSON.parse(temp_result)

  api_url = "http://128.199.191.249/nodes/all"
  resp    = Net::HTTP.get_response( URI.parse(api_url) )
  result  = JSON.parse(resp.body)

  result.each do |d|
    if d["id"].to_s == params[:uuid].to_s
      @data = d
      @data_temp = "N/A"
      @data_humid = "N/A"
      @data_dist = "N/A"
      @data["sensors"].each do |readings|
        if readings["alias"].to_s == "temperature"
          @data_temp = readings["number of readings"].to_s
        end
        if readings["alias"].to_s == "humidity"
          @data_humid = readings["number of readings"].to_s
        end
        if readings["alias"].to_s == "distance"
          @data_dist = readings["number of readings"].to_s
        end
      end
    end
  end

  erb :nodedetail, locals:{ id:params[:uuid], dist:@data_dist, humid:@data_humid, temp:@data_temp }
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
