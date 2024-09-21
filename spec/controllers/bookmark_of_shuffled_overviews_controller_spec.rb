require 'rails_helper'

RSpec.describe BookmarkOfShuffledOverviewsController do
  let(:user) { create(:user) }
  let(:shuffled_overview) { create(:shuffled_overview) }

  # Before each test, sign in the user (if you're using Devise)
  before do
    sign_in user
  end

  describe 'POST #create' do
    it 'bookmarks a shuffled_overview' do
      # Ensure the route and params align with the nested structure
      post :create, params: { user_id: user.id, shuffled_overview_id: shuffled_overview.id }, format: :js
      expect(response).to have_http_status(:success)
      # Additional assertions can be added here to verify functionality
    end

    it 'responds with JS format' do
      post :create, params: { user_id: user.id, shuffled_overview_id: shuffled_overview.id }, format: :js
      expect(response.content_type).to include 'text/javascript'
    end
  end

  describe 'DELETE #destroy' do
    let!(:bookmark) { create(:bookmark_of_shuffled_overview, user: user, shuffled_overview: shuffled_overview) }

    it 'removes a bookmarked shuffled_overview' do
      delete :destroy, params: { user_id: user.id, shuffled_overview_id: shuffled_overview.id }, format: :js
      expect(response).to have_http_status(:success)
      # Additional assertions to verify deletion
    end

    it 'responds with JS format' do
      delete :destroy, params: { user_id: user.id, shuffled_overview_id: shuffled_overview.id }, format: :js
      expect(response.content_type).to include 'text/javascript'
    end
  end
end
