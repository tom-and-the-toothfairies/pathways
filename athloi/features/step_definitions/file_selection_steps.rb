Then(/^I should see "([^"]*)" in the file input$/) do |filename|
  filename_display = find('#filename-display').value

  expect(filename_display).to eq(filename)
end
