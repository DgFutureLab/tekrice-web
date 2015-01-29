# encoding: utf-8

require 'spec_helper'

describe 'Routes respond' do

  it '/' do
    get '/'
    expect( last_response ).to be_ok
  end

  it '/map redirects to /map/hackerfarm' do
    get '/map'
    expect( last_response ).to be_redirect
    expect( last_response.location ).to include( '/map/hackerfarm' )
  end

  it '/settings' do
    get '/dashboard'
    expect( last_response ).to be_ok
  end

  it '/list redirects to /list/hackerfarm' do
    get '/list'
    expect( last_response ).to be_redirect
    expect( last_response.location ).to include( '/list/hackerfarm' )
  end

end
