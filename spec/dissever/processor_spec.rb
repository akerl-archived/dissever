require 'spec_helper'

describe Dissever do
  it 'runs multiple processes' do
    test = Dissever.new { 1.upto(10).map { |x| [x, proc { Process.pid }] } }
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
  it 'accepts an array of targets' do
    targets = 1.upto(10).map { |x| [x, proc { Process.pid }] }
    test = Dissever.new(targets: targets)
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
  it 'accepts a block for target loading' do
    test = Dissever.new { 1.upto(10).map { |x| [x, proc { Process.pid }] } }
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
end
