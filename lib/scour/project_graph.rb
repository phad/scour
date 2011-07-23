require 'yaml'

module Scour
  class ProjectGraph

    class << self
      def for_direction(direction)
        new direction
      end

      def path_to_project(project_name)
        project = known_projects.detect { |name, path| name == project_name }

        if project
          File.expand_path(project.last)
        end
      end

      def project_name_from_path(project_path)
        project = known_projects.detect do |name, path|
          File.expand_path(path) == File.expand_path(project_path)
        end

        if project
          project.first
        end
      end

      def known_projects
        @known_projects ||= begin
          project_index = ENV['PROJECT_INDEX']
          YAML.load_file(File.expand_path(project_index))
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
      name      = ProjectGraph.project_name_from_path(path)

      Project.new(name, path)
    end

    def focused_project_deps_file
      dir = Dir.getwd
      root_dir = '/'

      while dir != root_dir do
        deps_file = File.join(dir, 'deps.yml')
        return deps_file if File.exist?(deps_file)

        dir = File.dirname(dir)
      end

      raise 'No dependencies file found.'
    end

  end
end
