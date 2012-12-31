require 'bundler'
Bundler.require(:default, :development)

#eval("Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/config.ru') + "\n )}")

task :default => 'development:hello'

namespace :development do
  task :hello do
    puts "Hello from Rakefile!"
  end

  task :deploy do
    puts "I am Deploy!"
  end

  task :article_encode do
    puts "I am the Article Encoder"         
  end

  task :image_encode do
    puts "I am the Image encoder"
  end

end
