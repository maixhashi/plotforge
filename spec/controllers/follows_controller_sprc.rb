require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user) { create(:user) }
  let(:followed_user) { create(:user) }

  before do
    sign_in user
  end
  
  describe 'GET #index_followings' do
    before do
      create(:follow, follower: user, followed: followed_user)
      get :index_followings, params: { user_id: user.id }
    end

    it 'assigns @followings' do
      expect(assigns(:followings)).to include(followed_user)
    end

    it 'renders the index_followings template' do
      expect(response).to render_template(:index_followings)
    end
  end

  describe 'GET #index_followers' do
    before do
      create(:follow, follower: followed_user, followed: user)  # フォロワー関係を作成
      get :index_followers, params: { user_id: user.id }
    end

    it 'assigns @followers' do
      expect(assigns(:followers)).to include(followed_user)
    end

    it 'renders the index_followers template' do
      expect(response).to render_template(:index_followers)
    end
  end

  describe 'POST #create' do
    it 'follows a user' do
      expect {
        post :create, params: { followed_id: followed_user.id }, format: :js
      }.to change { user.following.count }.by(1)
    end

    it 'creates a notification' do
      expect_any_instance_of(User).to receive(:create_notification_follow!).with(user)
      post :create, params: { followed_id: followed_user.id }, format: :js
    end

    it 'responds with JS format' do
      post :create, params: { followed_id: followed_user.id }, format: :js
      expect(response.content_type).to start_with('text/javascript')  # 修正
    end
  end

  describe 'DELETE #destroy' do
    before do
      user.follow(followed_user)
    end

    it 'unfollows a user' do
      expect {
        delete :destroy, params: { id: Follow.last.id }, format: :js
      }.to change { user.following.count }.by(-1)
    end

    it 'responds with JS format' do
      delete :destroy, params: { id: Follow.last.id }, format: :js
      expect(response.content_type).to start_with('text/javascript')  # 修正
    end
  end
end
