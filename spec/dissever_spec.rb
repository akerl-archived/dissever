require 'spec_helper'

describe Dissever do
  describe '#new' do
    it 'creates a Processor object' do
      subject = Dissever.new(tasks: [], quiet: true)
      expect(subject).to be_an_instance_of Dissever::Processor
    end
  end
end
