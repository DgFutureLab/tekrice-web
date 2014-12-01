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

  # Checks cache file status before attempting to make API call

  cache_file = File.join("cache", "alldata")

  if !File.exist?(cache_file) || (File.mtime(cache_file) < (Time.now - 60*5))
    all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/node/all"))

    # Inserts new data into cache file
    if all_data_call.code == "200"
      @all_data = all_data_call.body
      File.open(cache_file, "w"){ |f| f << @all_data }
    else
      if File.exist?(cache_file)
        @all_data = File.read(cache_file)
      else
        @all_data = {"objects" => test_data}
      end
    end
  else
    @all_data = File.read(cache_file)
  end

  erb :dashboard, locals:{ data:JSON.parse(@all_data), json_data:@all_data }

  # NOTES
  #test2 = Net::HTTP.get_response(URI.parse("http://128.199.191.249/reading/node_XX/distance&date_range=1week"))
  #erb :dashboard, locals:{ dist:@dist["objects"][0]["value"], humid:@humid["objects"][0]["value"], temp:@temp["objects"][0]["value"] }
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/dashboard/nodes/:uuid' do
  # Placeholder for all node data
  #
  #api_url = "http://128.199.191.249/nodes/all"
  no_data = {"objects" => [{"value" => "N/A"}]}
  
  dist_api_url  = "http://128.199.191.249/reading/node_1/distance"
  humid_api_url = "http://128.199.191.249/reading/node_1/humidity"
  temp_api_url  = "http://128.199.191.249/reading/node_1/temperature"

  dist_resp   = Net::HTTP.get_response( URI.parse(dist_api_url) )
  if dist_resp.code == "200"
    dist_result = JSON.parse(dist_resp.body)
    @dist = (!dist_result.nil? && !dist_result["objects"].empty? && dist_result["errors"].empty?) ? dist_result : no_data
  else
    @dist = no_data
  end

  humid_resp   = Net::HTTP.get_response( URI.parse(humid_api_url) )
  if humid_resp.code == "200"
    humid_result = JSON.parse(humid_resp.body)
    @humid = (!humid_result.nil? && !humid_result["objects"].empty? && humid_result["errors"].empty?) ? humid_result : no_data
  else
    @humid = no_data
  end

  temp_resp   = Net::HTTP.get_response( URI.parse(temp_api_url) )
  if temp_resp.code == "200"
    temp_result = JSON.parse(temp_resp.body)
    @temp = (!temp_result.nil? && !temp_result["objects"].empty? && temp_result["errors"].empty?) ? temp_result : no_data
  else
    @temp = no_data
  end

  erb :nodedetail, locals:{ id:params[:uuid], dist:@dist["objects"][0]["value"], humid:@humid["objects"][0]["value"], temp:@temp["objects"][0]["value"] }
end

get '/dashboard/settings' do
  erb :settings
end

get '/dashboard/map' do

  # Testing the new API server responses
  all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/node/all"))
  if all_data_call.code == "200"
    @all_data = all_data_call.body
  end

  # Check & creating cache file every 5 minutes
  cache_file = File.join("cache", "alldata")
  if !File.exist?(cache_file) || (File.mtime(cache_file) < (Time.now - 60*5))
    File.open(cache_file, "w"){ |f| f << @all_data }
  end

  # Dummy data for testing
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

  erb :map, locals:{ data:File.read(cache_file) }
end

get '/test/test.json' do
  data = { :location => "here", :data => "test data" }
  response_data = data.to_json
end

helpers do
  def partial template
    erb template, layout:false
  end
end
