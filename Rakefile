require 'rubygems'
require 'rake'

require File.expand_path('../lib/arel-mongo/version.rb', __FILE__)

version = Arel::Mongo::VERSION

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "arel-mongo"
    gem.version = version
    gem.summary = %Q{MongoDB engine for Arel}
    gem.description = %Q{Arel Mongo is a MongoDB engine for Arel featuring support
for embedded documents, modifiers and other Mongo-specific features.}
    gem.email = "alekswilliams@earthlink.net"
    gem.homepage = "http://github.com/akdubya/arel-mongo"
    gem.authors = ["akdubya"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "arel-mongo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end