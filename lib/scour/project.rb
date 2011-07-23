module Scour
  class Project
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def dependencies
      deps_file = File.join(File.expand_path(@path), 'deps.yml')

      YAML.load_file(deps_file)['projects'].map do |name|
        path = ProjectGraph.path_to_project(name)
        Project.new(name, path)
      end
    end

    def dependents
      candidates = ProjectGraph.known_projects.reject { |name, _| name == @name }
      dependents = candidates.select { |_, path| depends_on_project?(path) }

      dependents.map { |name, path| Project.new(name, path) }
    end

    private

    def depends_on_project?(path)
      deps_file = File.join(File.expand_path(path), 'deps.yml')
      YAML.load_file(deps_file)['projects'].include?(@name)
    end
  end
end
