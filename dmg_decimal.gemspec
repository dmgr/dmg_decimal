# -*- encoding: utf-8 -*-
require File.expand_path "../lib/dmg_decimal/version", __FILE__

Gem::Specification.new do |s|
  s.name        = "dmg_decimal"
  s.version     = Dmg::Decimal::VERSION
  s.authors     = ["Dawid Marcin Grzesiak"]
  s.email       = ["dawid+dmg_decimal@grzesiak.pro"]
  s.homepage    = "https://github.com/dmgr/dmg_decimal"
  s.summary     = %q{Decimal data type.}
  s.description = %q{The library let you specify scale and precision on decimals.}

  s.rubyforge_project = "dmg_decimal"

  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end