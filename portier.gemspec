Gem::Specification.new do |s|
  s.name = 'portier'
  s.version = '0.0.2'

  s.authors = ['Roland Venesz']
  s.date = '2010-10-28'
  s.description = 'Yet another authentication engine for Rails 3'
  s.files = %w(README.md) + Dir['lib/**/*.rb']
  s.require_paths = %w(lib)
  s.summary = 'Yet another authentication engine'

  s.add_runtime_dependency 'bcrypt-ruby', ['>= 0']
end
