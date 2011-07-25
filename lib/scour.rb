require 'fileutils'
require 'optparse'
require 'ostruct'
require 'term/ansicolor'
require 'yaml'

module Scour
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Options,  ROOT + '/scour/options'
  autoload :Project,  ROOT + '/scour/project'
  autoload :Search,   ROOT + '/scour/search'
end
