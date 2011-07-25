module Scour
  class Scourer
    include Term::ANSIColor

    def initialize(output)
      @output = output
    end

    def search(args)
      @options = Options.parse!(args)
      @query   = args.first

      unless @query
        @output.puts red('What are you looking for?')
        return
      end

      Project.projects(@options.direction).each do |project|
        @current_project = project
        FileUtils.cd(@current_project.path) { search_project }
      end
    end

    private

    def search_project
      output_project_name

      IO.popen(search_command) do |io|
        parse_search_results(io)
      end

      @output.puts
    end

    def output_project_name
      separator    = '#' * @current_project.name.size
      project_name = bold(blue( "#{separator}\n#{@current_project.name}\n#{separator}" ))

      @output.puts project_name
    end

    def search_command
      # -I      exclude binary files
      # --null  use \0 to seperate files and line numbers
      # -C      lines of context around result
      "GIT_PAGER='' git grep --color -I --full-name --line-number --null -C 1 #{@query}"
    end

    def parse_search_results(io)
      @matches_found_in_current_project = false
      @previous_file_with_matches = nil

      io.each { |line| parse_line(line) }

      unless @matches_found_in_current_project
        @output.puts "\n#{red('No matches.')}"
      end
    end

    def parse_line(line)
      file, line_number, match = line.split("\0")

      return unless match
      @matches_found_in_current_project = true

      unless file == @previous_file_with_matches
        output_file_path(file)
        @previous_file_with_matches = file
      end

      output_matching_line(match, line_number)
    end

    def output_file_path(file)
      file_path = "#{@current_project.path}/#{file}"
      file_path = bold(green( file_path ))

      @output.puts "\n#{file_path}"
    end

    def output_matching_line(match, line_number)
      line_number = "#{line_number}:".ljust(4)
      line_number = bold(yellow( line_number ))

      @output.puts "#{line_number}\t#{match}"
    end
  end
end
