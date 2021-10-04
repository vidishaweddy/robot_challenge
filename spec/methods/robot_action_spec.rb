# frozen_string_literal: true

require './spec/spec_helper'
require './lib/methods/tabletop_action'
require './lib/objects/tabletop'
require './lib/objects/robot'

RSpec.describe 'tabletop_action' do
  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
    @tabletop = Tabletop.new(Robot)
  end

  context 'execute' do
    it 'returns the current tabletop position' do
      movements = [%w[place 0,0,north], ['move'], ['left']]
      movements.each.with_index do |movement, index|
        TabletopActionMethods.execute(movement, @tabletop, index + 1)
      end
      expect(@tabletop.item.current_position).to eq('0,1,WEST')
    end

    it 'returns the info message if tabletop action can cause tabletop to fall ' do
      movements = [%w[place 0,0,south], ['move'], ['left']]
      movements.each.with_index do |movement, index|
        TabletopActionMethods.execute(movement, @tabletop, index + 1)
      end
      expect(@tabletop.item.current_position).to eq('0,0,EAST')
      $stderr.rewind
      expect($stderr.string).to eq('Warning: Input on line 2 is invalid. Details: '\
        "[\"item cannot be placed outside the tabletop. Action will be ignored\"]\n")
    end

    it 'returns the info message if tabletop action is unknown ' do
      movements = [%w[place 0,0,east], ['move'], ['turn']]
      movements.each.with_index do |movement, index|
        TabletopActionMethods.execute(movement, @tabletop, index + 1)
      end
      expect(@tabletop.item.current_position).to eq('1,0,EAST')
      $stderr.rewind
      expect($stderr.string).to eq("Warning: Unknown action 'turn' for Robot on line 3\n")
    end
  end

  after do
    $stderr = @orig_stderr
  end
end