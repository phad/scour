require 'ostruct'
require 'optparse'

module Scour
  class Options

    class << self
      def parse!(args)
        options = default_options

        opts = OptionParser.new do |opts|
          opts.banner = banner
          opts.separator ''
          opts.separator 'Options:'

          opts.on('-d', '--direction DIRECTION',
                  [:dependencies, :dependents],
                  'Search direction [dependencies, dependents]') do |direction|
            options.direction = direction
          end

          opts.on('-f', '--files', 'Search for files matching query') do |file_search|
            options.file_search = file_search
          end

          opts.on('-h', '--help', 'Show this message') do
            puts opts
            exit
          end
        end

        opts.parse!(args)
        options
      end

      private

      def default_options
        OpenStruct.new({
          :direction    => :dependencies,
          :recurse      => false,
          :file_search  => false
        })
      end

      def banner
<<-BANNER
Scour.

Scour uses git grep to search your current project and any dependencies it has.
BANNER
      end
    end

  end
end
