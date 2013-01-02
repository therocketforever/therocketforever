ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:default, :development)

require './application.rb'

#eval("Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/config.ru') + "\n )}")

task :default => 'development:article_encode'

task :analyze do
  puts "Analyzing changes..."
end

namespace :development do
  task :hello do
    puts "Hello from Rakefile!"
  end

  task :deploy do
    puts "I am Deploy!"
  end

  ##########
  
  task :article_analyze do
  end

  task :article_encode do
    puts "I am the Article Encoder"

    @articles = []
 
    Dir["./views/articles/*.md"].each do |f|
      article = File.read(f).split("---\n")
      meta = YAML::load(article[0])
      puts File.basename(f)
      
      a = Article.create(:title => meta[:title], :body => article[1])

      meta[:tags].split(",").each do |t|
        a.tags.first_or_create(:name => t.strip)
      end
      
      puts a
      puts a.title

      #puts article[1]
      #puts meta

      Binding.pry
    end

  end

  ##########

  task :image_analyze do
  end

  task :image_encode do
    puts "I am the Image encoder"
  end

end
