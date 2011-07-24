Gem::Specification.new do |s|
  s.name          = 'scour'
  s.version       = '0.1.0'
  s.summary       = 'Scour interdependent git projects for text.'
  s.author        = 'Matt Johnson'
  s.email         = 'grillpanda@gmail.com'
  s.homepage      = 'https://github.com/grillpanda/scour'

  s.executables   = ['scour']
  s.files         = %w(README.md) + Dir['{bin,lib}/**/*']
  s.require_paths = ['lib']

  s.add_dependency('term-ansicolor', '>=1.0.6')
end
