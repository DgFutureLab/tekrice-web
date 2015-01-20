# encoding: utf-8

require 'spec_helper'

describe 'test' do

  it "does shit" do
    get '/'
    expect( last_response ).to be_ok
  end

  it 'test' do
    visit '/'
    expect( page.body ).to include( "デジタルガレージ" )
  end

end
