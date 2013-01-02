Feature: Article creation via raketask import of markdown document
  In order to ensure Articles are persistant
  As a Developer
  I want to test Article Creation

  Scenario: Load Article Data via Markdown imgort
      Given A markdown article exists
       When I import an Article
       Then I should see that Article in the database
  
  @dev
  Scenario: Load an imported Article from the database
      Given There is an Article in the Database
       When I load load an Article from the Database
       Then I should be able to access that object

  Scenario: Uptade an Article in the Database from a markdown file
      Given A change was made to a markdown source
       When The Application is updated
       Then I should see the updated Article in the Database
