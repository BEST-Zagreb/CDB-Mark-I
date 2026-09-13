# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dm-active_model"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Gamsjaeger (snusnu)"]
  s.date = "2010-10-23"
  s.description = "A datamapper plugin for active_model compliance and thus rails 3 compatibility."
  s.email = "gamsnjaga [a] gmail [d] com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc", "TODO"]
  s.files = ["LICENSE", "README.rdoc", "TODO"]
  s.homepage = "http://github.com/datamapper/dm-active_model"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "datamapper"
  s.rubygems_version = "1.8.10"
  s.summary = "active_model compliance for datamapper"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.0.0"])
      s.add_development_dependency(%q<dm-validations>, ["~> 1.0.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<test-unit>, ["= 1.2.3"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_dependency(%q<activemodel>, ["~> 3.0.0"])
      s.add_dependency(%q<dm-validations>, ["~> 1.0.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<test-unit>, ["= 1.2.3"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
    s.add_dependency(%q<activemodel>, ["~> 3.0.0"])
    s.add_dependency(%q<dm-validations>, ["~> 1.0.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<test-unit>, ["= 1.2.3"])
  end
end
