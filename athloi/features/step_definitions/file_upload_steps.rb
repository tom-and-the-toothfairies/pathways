Then(/^I should see the found drugs panel$/) do
  panel = find('#drugs-panel', wait: 15)

  expect(panel).to be_visible
end

Then(/^I should see the following drugs in the found drugs panel:$/) do |drugs|
  panel = find('#drugs-panel')

  drugs.raw.flatten.each do |drug|
    expect(panel).to have_content(drug)
  end
end

Then(/^I should see the unidentified drugs panel$/) do
  panel = find('#unidentified-drugs-panel', wait: 15)

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
  title_element = find('#error-title')

  expect(title_element.text).to eq(title)
end

Then(/^I should see the found DDIs panel$/) do
  panel = find('#ddis-panel', wait: 15)

  expect(panel).to be_visible
end

Then(/^I should see the following DDIs in the found DDIs panel:$/) do |ddis|
  panel = find('#ddis-panel')

  ddis.raw.flatten.each do |ddi|
    expect(panel).to have_content(ddi)
  end
end

# Very likely to change with improved UI
Then(/^I should not see any DDIs in the found DDIs panel$/) do
  ddis_element = find('#ddis-text')

  expect(ddis_element.text).to eq('I have not identified any interactions between the drugs in this file.')
end
