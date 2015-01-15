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

  @all_data = get_data_for_site('hackerfarm')

  erb :dashboard, locals:{ data:JSON.parse(@all_data), json_data:@all_data }

  # NOTE so I don't forget the different API call response
  #test2 = Net::HTTP.get_response(URI.parse("http://128.199.191.249/reading/node_XX/distance&date_range=1week"))
  #erb :dashboard, locals:{ dist:@dist["objects"][0]["value"], humid:@humid["objects"][0]["value"], temp:@temp["objects"][0]["value"] }
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/node/:site/:uuid' do
  @all_data = JSON.parse(get_data_for_site(params[:site]))
  @all_data["objects"].each do |node|
    if node["alias"] == params[:uuid]
      node["sensors"].each do |x|
        if x["alias"] == 'humidity'
          @humid = x["latest_reading"]["value"]
        end
        if x["alias"] == 'distance'
          @dist  = x["latest_reading"]["value"]
        end
        if x["alias"] == 'temperature'
          @temp  = x["latest_reading"]["value"]
        end
      end
    end
  end

  erb :nodedetail, locals:{ id:params[:uuid], dist:@dist, humid:@humid, temp:@temp }
end

get '/settings' do
  erb :settings, locals:{ site:"hackerfarm" }
end

get '/map' do
  redirect '/map/hackerfarm'
end

get '/map/:site' do

  if params[:site] != 'hackerfarm'
    redirect '/map/hackerfarm'
  end
  # TODO
  # filter cache based on :site

  @all_data = get_data_for_site(params[:site])

  erb :map, locals:{ data:@all_data, site:params[:site] }
end

get '/list' do
  redirect '/list/hackerfarm'
end

get '/list/:site' do
  @all_data = get_data_for_site('hackerfarm')

  erb :list, locals:{ data:JSON.parse(@all_data), json_data:@all_data, site:params[:site] }
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

private

def get_data_for_site(site)

  # Dummy data for testing
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

  cache_file = File.join("cache", "alldata")

  if site == 'hackerfarm'

    #if !File.exist?(cache_file) || (File.mtime(cache_file) < (Time.now - 60*60))
      #all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/node/all"))
      all_data_call = Net::HTTP.get_response(URI.parse("http://128.199.191.249/site/17"))

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
    #else
    #  @all_data = File.read(cache_file)
    #end

  # TODO placeholder for other sites
  else
    @all_data = {"objects" => test_data}
  end

  return @all_data
end
