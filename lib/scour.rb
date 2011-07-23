module Scour
  SCOUR_DIR = File.expand_path('scour', File.dirname(__FILE__))

  require SCOUR_DIR + '/scourer'
  require SCOUR_DIR + '/options'
  require SCOUR_DIR + '/project_graph'
  require SCOUR_DIR + '/project'
end
