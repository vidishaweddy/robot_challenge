# frozen_string_literal: true

require './spec/spec_helper'
require './lib/objects/tabletop_item'

RSpec.describe 'tabletop_item' do
  it 'raises an error if trying to instantiate the class' do
    expect { TabletopItem.new }.to raise_error(RuntimeError, 'Error: You are trying to instantiate an abstract class!')
  end
end
