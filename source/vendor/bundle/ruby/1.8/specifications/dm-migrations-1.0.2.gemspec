# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dm-migrations"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Sadauskas"]
  s.date = "2010-09-07"
  s.description = "DataMapper plugin for writing and speccing migrations"
  s.email = "psadauskas [a] gmail [d] com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/datamapper/dm-migrations"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "datamapper"
  s.rubygems_version = "1.8.10"
  s.summary = "DataMapper plugin for writing and speccing migrations"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end
