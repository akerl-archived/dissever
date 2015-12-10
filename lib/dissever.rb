##
# This module provides a simple interface to multiprocessing tasks
module Dissever
  class << self
    ##
    # Insert a helper .new() method for creating a new Processor object

    def new(*args, &block)
      self::Processor.new(*args, &block)
    end
  end
end

require 'dissever/processor'
