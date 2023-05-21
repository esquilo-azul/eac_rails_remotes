# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_rails_remotes/version'

Gem::Specification.new do |s|
  s.name        = 'eac_rails_remotes'
  s.version     = EacRailsRemotes::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{lib}/**/*']

  s.add_dependency 'eac_rails_utils', '~> 0.17', '>= 0.17.1'
  s.add_dependency 'eac_ruby_utils', '~> 0.117'

  s.add_development_dependency 'eac_ruby_gem_support', '~> 0.5', '>= 0.5.1'
end
