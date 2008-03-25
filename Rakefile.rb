# Ensure exocora library is part of the include path
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
$:.uniq!

require 'find'
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'exocora/version'

# Gem specification
exocora_gemspec = Gem::Specification.new do |s|
  s.name = 'exocora'
  s.version = Exocora::APP_VERSION
  s.author = Exocora::APP_AUTHOR
  s.email = Exocora::APP_EMAIL
  s.homepage = Exocora::APP_URL
  s.platform = Gem::Platform::RUBY
  s.summary = 'A small framework for cgi scripts'

  s.files = FileList['{lib}/**/*', 'LICENSE'].to_a
  s.require_path = 'lib'
  s.has_rdoc = true

  s.required_ruby_version = '>= 1.8.6'
  
  s.add_dependency('erubis', '>=2.5.0')
end

Rake::GemPackageTask.new(exocora_gemspec) do |p|
  p.need_tar_gz = true
end

Rake::RDocTask.new do |rd|
  rd.main = 'Exocora'
  rd.title = 'Exocora'
  rd.rdoc_dir = 'doc'

  rd.rdoc_files.include('lib/**/*.rb')
end

desc 'install Exocora'
task :install => :gem do
  sh "gem install pkg/exocora-#{Exocora::APP_VERSION}.gem"
end
