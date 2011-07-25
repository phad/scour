module Scour
  class Project
    DEPS_FILENAME = 'deps.yml'

    attr_reader :name, :path

    class << self

      def projects(direction)
        [current].concat(current.send(direction))
      end

      def current
        @current ||= begin
          path = project_path_from_working_dir
          known_projects.detect { |project| File.identical?(project.path, path) }
        end
      end

      def known_projects
        @known_projects ||= begin
          project_index = ENV['PROJECT_INDEX']

          project_paths = YAML.load_file(File.expand_path(project_index))
          project_paths.map { |name, path| new(name, File.expand_path(path)) }
        end
      end

      private

      def project_path_from_working_dir
        dir  = Dir.getwd
        root = '/'

        while dir != root do
          deps_file = File.join(dir, DEPS_FILENAME)
          return dir if File.exist?(deps_file)

          dir = File.dirname(dir)
        end

        raise 'Could not detect project path: No dependencies file found.'
      end
    end

    def initialize(name, path)
      @name = name
      @path = path
    end

    def depends_on?(project)
      dependencies.include?(project)
    end

    def dependencies
      return @dependencies if @dependencies

      deps_file = File.join(File.expand_path(@path), DEPS_FILENAME)
      names     = YAML.load_file(deps_file)['projects']

      names.map do |name|
        Project.known_projects.detect { |project| project.name == name }
      end
    end

    def dependents
      @dependents ||= Project.known_projects.select { |project| project.depends_on?(self) }
    end
  end
end
