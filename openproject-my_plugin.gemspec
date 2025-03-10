# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/my_plugin/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-my_plugin"
  s.version     = OpenProject::MyPlugin::VERSION
  s.authors     = "Darren MacKenzie"
  s.email       = "darren277@yahoo.com"
  s.homepage    = "https://community.openproject.org/projects/proto-plugin"  # TODO check this URL
  s.summary     = 'OpenProject My Plugin'
  s.description = "An experimental OpenProject plugin"
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", '~> 7.0'
end
