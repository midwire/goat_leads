# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadOrdersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/lead_orders').to route_to('lead_orders#index')
    end

    it 'routes to #new' do
      expect(get: '/lead_orders/new').to route_to('lead_orders#new')
    end

    it 'routes to #show' do
      expect(get: '/lead_orders/1').to route_to('lead_orders#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/lead_orders/1/edit').to route_to('lead_orders#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/lead_orders').to route_to('lead_orders#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/lead_orders/1').to route_to('lead_orders#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/lead_orders/1').to route_to('lead_orders#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/lead_orders/1').to route_to('lead_orders#destroy', id: '1')
    end
  end
end
