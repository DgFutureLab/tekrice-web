# encoding: utf-8

require 'spec_helper'

describe '/list' do

  it 'should contain the table list' do
    visit '/list'
    expect( page.body ).to include( 'id="node-list"' )
  end

end
