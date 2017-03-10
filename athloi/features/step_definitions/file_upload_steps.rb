When(/^I submit the upload form$/) do
  click_on 'Submit'
end

Then(/^I should see the found drugs panel$/) do
  panel = find('#drugs-panel')

  expect(panel).to be_visible
end

Then(/^I should see the following drugs in the found drugs panel:$/) do |drugs|
  panel = find('#drugs-panel')

  drugs.raw.flatten.each do |drug|
    expect(panel).to have_content(drug)
  end
end

Then(/^I should see the unidentified drugs panel$/) do
  panel = find('#unidentified-drugs-panel', wait: 5)

  expect(panel).to be_visible
end

Then(/^I should see the following drugs in the unidentified drugs panel:$/) do |drugs|
  panel = find('#unidentified-drugs-panel')

  drugs.raw.flatten.each do |drug|
    expect(panel).to have_content(drug)
  end
end

Then(/^I should see the error panel$/) do
  panel = find('#error-panel')

  expect(panel).to be_visible
end

Then(/^the error panel title should be "([^"]*)"$/) do |title|
  title_text = find('#error-title').text

  expect(title_text).to eq(title)
end
