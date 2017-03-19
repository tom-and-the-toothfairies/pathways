Then(/^I should see the PML download button$/) do
  button = find('#pml-download-anchor')

  expect(button).to be_visible
end

Then(/^the PML download button should have the correct href$/) do
  button = find('#pml-download-anchor')

  expect(button[:href]).to have_content('authorization_token=')
  expect(button[:href]).to have_content('ast=')
end
