module Scour
  class Tagger

    def initialize(output)
      @output = output
      @tagged_projects = []
    end

    def write_tags(args)
      @options = Options.parse!(args)

      Project.projects(@options.direction).each do |project|
        @current_project = project
        FileUtils.cd(@current_project.path) { tag_project }
      end
    end

    private

    def tag_project
      return if @tagged_projects.include?(@current_project)

      @output.puts "Generating tags for: #{@current_project.name}"

      system(tag_command)

      @tagged_projects << @current_project
    end

    def tag_command
      "ctags --recurse --links=no #{paths_for_tag_file.join(' ')}"
    end

    def paths_for_tag_file
      ['.'] + @current_project.send(@options.direction).map(&:path)
    end
  end
end
