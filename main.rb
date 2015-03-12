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

get '/node/:site/:uuid/:sensor' do
  site_list   = get_site_list.keys
  sensor_list = [ "温度", "水位", "湿度" ]
  sensor_unit = { "温度" => "&deg;C", "水位" => "cm", "湿度" => "%" }

  if !sensor_list.include? params[:sensor]
    redirect '/node/' + params[:site] + '/' + params[:uuid]
  end

  @site_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @site_data = make_up_dummy_data_for_dataset(@site_data)

  node_list = get_node_list(@site_data)

  @site_data = JSON.parse(@site_data)

  #TODO Remove fake data
  rand = Random.new
  dataset = [
    { "index"=>"0", "value"=>rand(15...90).to_s, "day"=>"月" },
    { "index"=>"1", "value"=>rand(15...90).to_s, "day"=>"火" },
    { "index"=>"2", "value"=>rand(15...90).to_s, "day"=>"水" },
    { "index"=>"3", "value"=>rand(15...90).to_s, "day"=>"木" },
    { "index"=>"4", "value"=>rand(15...90).to_s, "day"=>"金" },
    { "index"=>"5", "value"=>rand(15...90).to_s, "day"=>"土" },
    { "index"=>"6", "value"=>rand(15...90).to_s, "day"=>"日" }
  ]

  @site_data["objects"][0]["nodes"].each do |node|
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

  erb :sensordetail, locals:{
    id:params[:uuid],
    sensor:params[:sensor],
    sensor_unit:sensor_unit[params[:sensor]],
    dataset:dataset.to_json,
    site:params[:site],
    site_list:site_list,
    node_list:node_list,
    sensor_list:sensor_list
  }
end

get '/node/:site/:uuid' do
  site_list   = get_site_list.keys
  sensor_list = [ "温度", "水位", "湿度" ]

  @site_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @site_data = make_up_dummy_data_for_dataset(@site_data)

  node_list = get_node_list(@site_data)

  @site_data = JSON.parse(@site_data)

  @site_data["objects"][0]["nodes"].each do |node|
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

  erb :nodedetail, locals:{
    id:params[:uuid],
    dist:@dist,
    humid:@humid,
    temp:@temp,
    site:params[:site],
    site_list:site_list,
    node_list:node_list,
    sensor_list:sensor_list
  }
end

get '/map/:site' do
  site_list = get_site_list.keys

  if !(site_list.include?(params[:site]))
    redirect '/map/' + site_list[0]
  end

  @site_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @site_data = make_up_dummy_data_for_dataset(@site_data)

  node_list  = get_node_list(@site_data)

  erb :map, locals:{ data:@site_data, site:params[:site], site_list:site_list, node_list:node_list }
end

get '/map' do
  site_list = get_site_list.keys
  redirect '/map/' + site_list[0]
end

get '/map/' do
  site_list = get_site_list.keys
  redirect '/map/' + site_list[0]
end

get '/list/:site' do
  @all_data = get_data_for_site(params[:site])

  #TODO remove when real data is available
  @all_data = make_up_dummy_data_for_dataset(@all_data)

  erb :list, locals:{ data:JSON.parse(@all_data), json_data:@all_data, site:params[:site] }
end

# UNUSED ROUTES

get '/dashboard' do
  @all_data = get_data_for_site('hackerfarm')

  erb :dashboard, locals:{ data:JSON.parse(@all_data), json_data:@all_data }
end

get '/dashboard/nodes' do
  erb :nodes
end

get '/settings' do
  erb :settings, locals:{ site:"hackerfarm" }
end

get '/testimonials' do
  erb :testimonials
end

# HELPERS

helpers do
  def partial template
    erb template, layout:false
  end
end

# PRIVATE REPEATABLE FUNCTIONS

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
  site_id_hash = get_site_list

  if !File.exist?(cache_file) || (File.mtime(cache_file) < (Time.now - 60*60))
    api_link = "http://satoyamacloud.com/site/" + site_id_hash[site].to_s
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

def get_node_list(data)
  node_list   = Array.new
  parsed_data = JSON.parse(data)
  parsed_data["objects"][0]["nodes"].each do |node|
    node_list << node["alias"]
  end

  return node_list
end

def get_site_list
  site_hash = {}

  api_link = "http://satoyamacloud.com/sites"
  all_data_call = Net::HTTP.get_response(URI.parse( api_link ))

  if all_data_call.code == "200"
    all_data = JSON.parse(all_data_call.body)
    all_data["objects"].each do |site|
      site_hash[ site["alias"].downcase.gsub(" ", "") ] = site["id"]
    end
  else
    #TODO This is pretty useless & volatile
    site_hash = {'hackerfarm' => 80, 'kamakura' => 82, 'digitalgarage' => 81}
  end

  return site_hash
end
