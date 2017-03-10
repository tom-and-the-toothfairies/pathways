Given(/^I am on the home page$/) do
  visit '/'
end

When(/^I select "([^"]*)"$/) do |filename|
  # Capybara won't let you interact with hidden elements
  execute_script("document.getElementById('file-input').classList.remove('hidden')")
  attach_file 'file-input', Pathname.pwd.join('features', 'fixtures', filename)
end
