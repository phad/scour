module Scour
  class ProjectGraph
    DEPS = 'deps.yml'

    class << self
      def for_direction(direction)
        new direction
      end

      def known_projects
        @known_projects ||= begin
          project_index = ENV['PROJECT_INDEX']
          project_paths = YAML.load_file(File.expand_path(project_index))
          project_paths.map do |name, path|
            Project.new(name, File.expand_path(path))
          end
        end
      end
    end

    def initialize(direction)
      @direction = direction
    end

    def projects
      [focused_project].concat(focused_project.send(@direction))
    end

    private

    def focused_project
      deps_file = focused_project_deps_file
      path      = File.dirname(deps_file)

      ProjectGraph.known_projects.detect { |project| File.identical?(path, project.path) }
    end

    def focused_project_deps_file
      dir = Dir.getwd
      root_dir = '/'

      while dir != root_dir do
        deps_file = File.join(dir, DEPS)
        return deps_file if File.exist?(deps_file)

        dir = File.dirname(dir)
      end

      raise 'No dependencies file found.'
    end

  end
end
