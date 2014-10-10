require 'sinatra'
require 'json'
require 'net/http'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  erb :main
end

get '/dashboard' do
  # Old no data object
  #no_data = {"objects" => [{"value" => "N/A"}]}

  # Testing the new API server responses
  all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/node/all"))
  if all_data_call.code == "200"
    @all_data = JSON.parse(all_data_call.body)
  end

  # TEST until API server works
  test_data = 
    [{'latitude' => 35.143465822954,
      'alias'    => 'None',
      'sensors'  => [{'id' => 1}, {'id' => 2}, {'id' => 3}, {'id' => 4}, {'id' => 5}],
      'id' => 1,
      'longitude'=> 139.988288016007
     },
     {'latitude' => 35.1434376171813,
      'alias'    => 'None',
      'sensors'  => [{'id' => 6}, {'id' => 7}],
      'id' => 2,
      'longitude'=> 139.988905063503
     },
     {'latitude' => 35.1433998877005,
      'alias'    => 'None',
      'sensors'  => [{'id' => 8}, {'id' => 9}, {'id' => 10}],
      'id' => 3,
      'longitude'=> 139.98802001624
     },
     {'latitude' => 35.1437971184588,
      'alias'    => 'None',
      'sensors'  => [{'id' => 11}, {'id' => 12}, {'id' => 13}],
      'id' => 4,
      'longitude'=> 139.988863921149
     },
     {'latitude' => 35.1434500656277,
      'alias'    => 'None',
      'sensors'  => [{'id' => 14}, {'id' => 15}, {'id' => 16}, {'id' => 17}, {'id' => 18}, {'id' => 19}, {'id' => 20}, {'id' => 21}, {'id' => 22}],
      'id' => 5,
      'longitude'=> 139.988013523927
     },
     {'latitude' => 35.1438024370132,
      'alias'    => 'None',
      'sensors'  => [{'id' => 23}, {'id' => 24}, {'id' => 25}, {'id' => 26}, {'id' => 27}, {'id' => 28}],
      'id' => 6,
      'longitude'=> 139.98876174814
     }]

  #test2 = Net::HTTP.get_response(URI.parse("http://128.199.191.249/reading/node_XX/distance&date_range=1week"))

  #erb :dashboard, locals:{ dist:@dist["objects"][0]["value"], humid:@humid["objects"][0]["value"], temp:@temp["objects"][0]["value"] }

  erb :dashboard, locals:{ data:@all_data["objects"] }
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

  # Testing the new API server responses
  all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/node/all"))
  if all_data_call.code == "200"
    @all_data = JSON.parse(all_data_call.body)
  end

  data =
    [{'latitude' => 35.143465822954,
      'alias'    => 'None',
      'sensors'  => [{'id' => 1}, {'id' => 2}, {'id' => 3}, {'id' => 4}, {'id' => 5}],
      'id' => 1,
      'longitude'=> 139.988288016007
     },
     {'latitude' => 35.1434376171813,
      'alias'    => 'None',
      'sensors'  => [{'id' => 6}, {'id' => 7}],
      'id' => 2,
      'longitude'=> 139.988905063503
     },
     {'latitude' => 35.1433998877005,
      'alias'    => 'None',
      'sensors'  => [{'id' => 8}, {'id' => 9}, {'id' => 10}],
      'id' => 3,
      'longitude'=> 139.98802001624
     },
     {'latitude' => 35.1437971184588,
      'alias'    => 'None',
      'sensors'  => [{'id' => 11}, {'id' => 12}, {'id' => 13}],
      'id' => 4,
      'longitude'=> 139.988863921149
     },
     {'latitude' => 35.1434500656277,
      'alias'    => 'None',
      'sensors'  => [{'id' => 14}, {'id' => 15}, {'id' => 16}, {'id' => 17}, {'id' => 18}, {'id' => 19}, {'id' => 20}, {'id' => 21}, {'id' => 22}],
      'id' => 5,
      'longitude'=> 139.988013523927
     },
     {'latitude' => 35.1438024370132,
      'alias'    => 'None',
      'sensors'  => [{'id' => 23}, {'id' => 24}, {'id' => 25}, {'id' => 26}, {'id' => 27}, {'id' => 28}],
      'id' => 6,
      'longitude'=> 139.98876174814
     }]

  erb :map, locals:{ data:@all_data["objects"].to_json }
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
