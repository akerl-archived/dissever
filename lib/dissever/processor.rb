require 'tempfile'
require 'json'

module Dissever
  ##
  # Processor object, for running multiprocessed tasks
  class Processor
    def initialize(params = {}, &block)
      @options = params
      @options[:size] ||= 10
      @targets = params[:targets] || block && block.call
      fail('No targets given') unless @targets
    end

    def run!
      log '*' * @targets.size
      readers = fork_master
      log
      parse_readers(readers)
    end

    private

    def fork_master
      @targets.each_slice(@options[:size]).flat_map { |slice| fork_pool(slice) }
    end

    def fork_pool(slice)
      res = slice.map do |name, block|
        reader, writer = IO.pipe
        fork { thread_run(reader, writer, name, &block) }
        writer.close
        [name, reader]
      end
      Process.waitall
      res
    end

    def thread_run(reader, writer, name, &block)
      $PROGRAM_NAME = "#{$PROGRAM_NAME} thread #{name}"
      reader.close
      writer << create_file(block.call)
      writer.close
      log '*', false
    rescue StandardError => e
      error "#{name}: #{e.message}"
    end

    def create_file(results)
      tempfile = Tempfile.new('dissever')
      ObjectSpace.undefine_finalizer(tempfile)
      # Since JSON objects need to be objects or arrays, encapsulate the results
      tempfile << JSON.dump([results])
      tempfile.close
      tempfile.path
    end

    def parse_readers(readers)
      files = readers.map { |name, reader| [name, reader.read] }
      files = check_files(files)
      results = files.map do |name, file|
        # Results are encapsulated in an array in create_file. Reverse this here
        [name, JSON.parse(File.read(file)).first]
      end
      files.each { |_, file| File.unlink file }
      Hash[results]
    end

    def check_files(files)
      files, bad_apples = files.partition { |_, file| File.exist?(file) }
      if bad_apples.nil?
        bad_apples.each { |name, _| error "Failed to load results for #{name}" }
      end
      files
    end

    def log(msg = nil, newline = true)
      STDERR.print("#{msg}#{"\n" if newline}") unless @options[:quiet]
    end

    def error(msg)
      STDERR.puts msg
    end
  end
end
