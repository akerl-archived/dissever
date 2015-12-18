require 'spec_helper'

describe Dissever do
  it 'runs multiple processes' do
    test = Dissever.new(quiet: true) do
      1.upto(10).map { |x| [x, proc { Process.pid }] }
    end
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
  it 'accepts an array of tasks' do
    tasks = 1.upto(10).map { |x| [x, proc { Process.pid }] }
    test = Dissever.new(tasks: tasks, quiet: true)
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
  it 'accepts a block for tasks loading' do
    test = Dissever.new(quiet: true) do
      1.upto(10).map { |x| [x, proc { Process.pid }] }
    end
    res = test.run!
    expect(res.values.uniq.size).to eql 10
  end
end
