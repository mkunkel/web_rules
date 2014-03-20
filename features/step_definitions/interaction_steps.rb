When(/^I go to the homepage$/) do
  visit root_path
end

Then(/^I should see(?::)? "(.*)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should not see(?::)? "([^"]*)"$/) do |text|
  page.should_not have_content(text)
end

When(/^show me the page$/) do
  save_and_open_page
end
