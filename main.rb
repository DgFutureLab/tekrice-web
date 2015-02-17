require 'sinatra'
require 'json'
require 'net/http'

set :public_folder, File.dirname(__FILE__) + '/static'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'techrice' and password == 'tacobeya12'
end

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
  @all_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @all_data = make_up_dummy_data_for_dataset(@all_data)

  @all_data = JSON.parse(@all_data)

  @all_data["objects"][0]["nodes"].each do |node|
    if node["alias"] == params[:uuid]
      node["sensors"].each do |x|
        if x["alias"] == 'humidity'
          @humid = x["latest_reading"]
        end
        if x["alias"] == 'distance'
          @dist  = x["latest_reading"]
        end
        if x["alias"] == 'temperature'
          @temp  = x["latest_reading"]
        end
      end
    end
  end

  erb :nodedetail, locals:{ id:params[:uuid], dist:@dist, humid:@humid, temp:@temp, site:params[:site] }
end

get '/settings' do
  erb :settings, locals:{ site:"hackerfarm" }
end

get '/testimonials' do
  erb :testimonials
end

get '/map/:site' do
  site_list    = ["hackerfarm", "tokyo", "kamakura"]
  #site_list   -= [params[:site]]

  if !(params[:site] == 'hackerfarm' || params[:site] == 'tokyo' || params[:site] == 'kamakura')
    redirect '/map/hackerfarm'
  end

  @site_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @site_data = make_up_dummy_data_for_dataset(@site_data)

  node_list   = Array.new
  parsed_data = JSON.parse(@site_data)
  parsed_data["objects"][0]["nodes"].each do |node|
    node_list << node["alias"]
  end

  erb :map, locals:{ data:@site_data, site:params[:site], site_list:site_list, node_list:node_list }
end


get '/map' do
  redirect '/map/hackerfarm'
end

get '/map/' do
  redirect '/map/hackerfarm'
end

get '/list/:site' do
  @all_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @all_data = make_up_dummy_data_for_dataset(@all_data)

  erb :list, locals:{ data:JSON.parse(@all_data), json_data:@all_data, site:params[:site] }
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
  {
    "errors" => [],
    "objects"=> 
      [{
        "alias" => "dummydata",
        "id"    => 17,
        "nodes" => 
          [{
            "alias" => "testdata1",
            "id"    => 1,
            "latitude" => 35.143465822954,
            "longitude"=> 139.988288016007,
            "sensors"  => [
              {
                  "alias" => "temperature",
                  "id"    => 18,
                  "latest_reading" => 20
              },
              {
                  "alias" => "distance",
                  "id"    => 19,
                  "latest_reading" => 30
              },
              {
                  "alias" => "humidity",
                  "id"    => 20,
                  "latest_reading" => 5
              },
              {
                  "alias" => "vbat",
                  "id"    => 21,
                  "latest_reading" => 90
              }
            ]
          },
          {
            "alias" => "testdata2",
            "id"    => 2,
            "latitude" => 35.1434376171813,
            "longitude"=> 139.988905063503,
            "sensors"  => [
              {
                  "alias" => "temperature",
                  "id"    => 22,
                  "latest_reading" => 20
              },
              {
                  "alias" => "distance",
                  "id"    => 23,
                  "latest_reading" => 28
              },
              {
                  "alias" => "humidity",
                  "id"    => 24,
                  "latest_reading" => 5
              },
              {
                  "alias" => "vbat",
                  "id"    => 25,
                  "latest_reading" => 87
              }
            ]
          },
          {
            "alias" => "testdata3",
            "id"    => 9,
            "latitude" => 35.1433998877005,
            "longitude"=> 139.98802001624,
            "sensors"  => [
              {
                  "alias" => "temperature",
                  "id"    => 26,
                  "latest_reading" => nil
              },
              {
                  "alias" => "distance",
                  "id"    => 27,
                  "latest_reading" => nil
              },
              {
                  "alias" => "humidity",
                  "id"    => 28,
                  "latest_reading" => nil
              },
              {
                  "alias" => "vbat",
                  "id"    => 29,
                  "latest_reading" => nil
              }
            ]
          }]
      }],
    "query" => {}
  }

  cache_file   = File.join("cache", site)
  site_id_hash = {'hackerfarm' => 17, 'kamakura' => 69, 'DG' => 70, 'tokyo' => 62,'webtest' => 63}

  if site == 'hackerfarm' || site == 'kamakura' || site == 'DG' || site == 'tokyo'

    if !File.exist?(cache_file) || (File.mtime(cache_file) < (Time.now - 60*60))
      api_link = "http://128.199.191.249/site/" + site_id_hash[site].to_s
      all_data_call = Net::HTTP.get_response(URI.parse( api_link ))

      # Inserts new data into cache file
      if all_data_call.code == "200"
        @all_data = all_data_call.body
        File.open(cache_file, "w"){ |f| f << @all_data }
      else
        if File.exist?(cache_file)
          @all_data = File.read(cache_file)
        else
          @all_data = test_data
        end
      end
    else
      @all_data = File.read(cache_file)
    end

  # TODO placeholder for other sites
  else
    @all_data = test_data
  end

  return @all_data
end

def make_up_dummy_data_for_dataset(data)
  parsed_data = JSON.parse(data)
  parsed_data["objects"][0]["nodes"].each_with_index do |node, node_index|
    node["sensors"].each_with_index do |reading, sensor_index|
      if reading["latest_reading"].nil?
        parsed_data["objects"][0]["nodes"][node_index]["sensors"][sensor_index]["latest_reading"] = 10 + rand(30)
      end
    end
  end

  return parsed_data.to_json
end
