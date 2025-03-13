# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LeadOrders', type: :system do
  let(:lead_order) { create(:lead_order) }

  it 'shows a confirmation before canceling' do
    visit lead_order_path(lead_order)

    # Stub the confirm dialog to accept
    page.driver.browser.stub_confirm('Are you sure you want to cancel this order?') { true }
    click_link 'Cancel Order'

    expect(page).to have_content('Order canceled successfully')
  end

  it 'aborts cancellation if declined' do
    visit lead_order_path(lead_order)

    # Stub the confirm dialog to cancel
    page.driver.browser.stub_confirm('Are you sure you want to cancel this order?') { false }
    click_link 'Cancel Order'

    expect(page).not_to have_content('Order canceled successfully')
  end
end
