Given(/^I am on the home page$/) do
  visit '/'
end

When(/^I select "([^"]*)"$/) do |filename|
  # Capybara won't let you interact with hidden elements
  execute_script("document.getElementById('file-input').classList.remove('hidden')")

  attach_file 'file-input', Pathname.pwd.join('features', 'fixtures', filename)

  execute_script("document.getElementById('file-input').classList.add('hidden')")
end

When(/^I submit the upload form$/) do
  click_on 'Submit'
end

When(/^I click the warnings tab$/) do
  click_on 'Warnings'
end
