module Scour
  class Project
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def depends_on?(project)
      dependencies.include?(project)
    end

    def dependencies
      return @dependencies if @dependencies

      deps_file = File.join(File.expand_path(@path), ProjectGraph::DEPS)
      names     = YAML.load_file(deps_file)['projects']

      names.map do |name|
        ProjectGraph.known_projects.detect { |project| project.name == name }
      end
    end

    def dependents
      @dependents ||= ProjectGraph.known_projects.select { |project| project.depends_on?(self) }
    end
  end
end
