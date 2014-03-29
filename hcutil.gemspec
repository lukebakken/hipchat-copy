# -*- encoding: utf-8 -*-

#############
# WARNING: Separate from the Gemfile. Please update both files
#############

$:.push File.expand_path('../lib', __FILE__)
require 'hcutil/version'

Gem::Specification.new do |s|
  s.name        = 'hcutil'
  s.version     = HCUtil::VERSION.dup
  s.authors     = ['Luke Bakken']
  s.email       = %w(luke@bowbak.org)
  s.homepage    = 'http://github.com/lukebakken/hipchat-util'
  s.summary     = %q{
    Utility for working with HipChat from the command line
  }
  s.executables       = %w{hcutil}
  s.rubyforge_project = 'hipchat-util'
  s.files             = %w(LICENSE) + Dir['lib/**/*']
  s.require_paths     = %w(lib)

  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'rest_client', '~> 1.7'
  # s.add_development_dependency 'rr', '~> 1.0'
end

