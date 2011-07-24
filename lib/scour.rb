require 'fileutils'
require 'optparse'
require 'ostruct'
require 'term/ansicolor'
require 'yaml'

module Scour
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Options,      ROOT + '/scour/options'
  autoload :Project,      ROOT + '/scour/project'
  autoload :ProjectGraph, ROOT + '/scour/project_graph'
  autoload :Scourer,      ROOT + '/scour/scourer'
end
