require 'spec_helper'

describe Dissever do
  describe '#new' do
    it 'creates a Processor object' do
      expect(Dissever.new(targets: [])).to be_an_instance_of Dissever::Processor
    end
  end
end
