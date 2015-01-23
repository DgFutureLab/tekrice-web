# encoding: utf-8

require 'spec_helper'

describe 'Routes respond' do

  it '/' do
    get '/'
    expect( last_response ).to be_ok
  end

  it '/map redirects to /map/hackerfarm' do
    visit '/map'
    expect( current_path ).to eq("/map/hackerfarm")
  end

  it '/settings' do
    get '/dashboard'
    expect( last_response ).to be_ok
  end

  it '/list redirects to /list/hackerfarm' do
    visit '/list'
    expect( current_path ).to eq("/list/hackerfarm")
  end

end
