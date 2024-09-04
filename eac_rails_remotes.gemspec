# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'eac_rails_remotes/version'

Gem::Specification.new do |s|
  s.name        = 'eac_rails_remotes'
  s.version     = EacRailsRemotes::VERSION
  s.authors     = ['Put here the authors']
  s.summary     = 'Put here de description.'

  s.files = Dir['{app,config,db,lib}/**/*']
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'eac_active_scaffold', '~> 0.6', '>= 0.6.1'
  s.add_dependency 'eac_rails_gem_support', '~> 0.10', '>= 0.10.1'
  s.add_dependency 'eac_rails_utils', '~> 0.22', '>= 0.22.2'
  s.add_dependency 'eac_ruby_utils', '~> 0.121'

  s.add_development_dependency 'eac_rails_gem_support', '~> 0.9', '>= 0.9.1'
end
