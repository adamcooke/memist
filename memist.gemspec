require File.expand_path('lib/memist/version', __dir__)
Gem::Specification.new do |s|
  s.name          = 'memist'
  s.description   = 'A Ruby Memoization Helper'
  s.summary       = s.description
  s.homepage      = 'https://github.com/adamcooke/memist'
  s.version       = Memist::VERSION
  s.files         = Dir.glob('{lib}/**/*')
  s.require_paths = ['lib']
  s.authors       = ['Adam Cooke']
  s.email         = ['me@adamcooke.io']
  s.licenses      = ['MIT']
  s.cert_chain    = ['certs/adamcooke.pem']
  s.signing_key   = File.expand_path('~/.gem/signing-key.pem') if $PROGRAM_NAME =~ /gem\z/
end
