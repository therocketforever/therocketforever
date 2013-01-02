Given /^A markdown article exists$/ do
  File.exist?('./views/articles/test_article.md').should == true
  @article_data = YAML.load(File.read('./views/articles/test_article.md'))
end

When /^I import an Article$/ do
  @md_article = File.read('./views/articles/test_article.md')
  @article_data = {:meta => YAML.load(@md_article.split("---")[0]), :body => YAML.load(@md_article.split("---")[1])}
  @article = Article.create(:title => @article_data[:meta][:title], :body => @article_data[:body])
end

Then /^I should see that Article in the database$/ do
    article = Article.get(@article.id)
    article === @article
end

Given /^There is an Article in the Database$/ do
    pending # express the regexp above with the code you wish you had
end

When /^I load load an Article from the Database$/ do
    pending # express the regexp above with the code you wish you had
end

Then /^I should be able to access that object$/ do
    pending # express the regexp above with the code you wish you had
end

Given /^A change was made to a markdown source$/ do
    pending # express the regexp above with the code you wish you had
end

When /^The Application is updated$/ do
    pending # express the regexp above with the code you wish you had
end

Then /^I should see the updated Article in the Database$/ do
    pending # express the regexp above with the code you wish you had
end
