Given(/^I am on the home page$/) do
  visit '/'
end

When(/^I upload "([^"]*)"$/) do |filename|
  # Capybara won't let you interact with hidden elements
  execute_script("document.getElementById('file-input').classList.remove('hidden')")
  attach_file 'file-input', Pathname.pwd.join('features', 'fixtures', filename)
end

Then(/^I should see "([^"]*)" in the file input$/) do |filename|
  filename_display = find('#filename-display').value

  expect(filename_display).to eq(filename)
end
