Gem::Specification.new do |s|
  s.name         = 'paperclip_schema'
  s.summary      = 'A Ruby Micro Gem for use Paperclip with ActiveRecordSchema and S3.'
  s.version      = '0.0.2'
  s.platform     = Gem::Platform::RUBY

  s.files        = %w(paperclip_schema.rb)
  s.require_path = '.'

  s.author      = 'Maurizio Casimirri'
  s.email       = 'maurizio.cas@gmail.com'

  s.add_dependency 'paperclip' 
  s.add_dependency "active_record_schema"
end