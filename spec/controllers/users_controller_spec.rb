require 'rails_helper'
require 'devise'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }  # FactoryBotを使ってユーザーを作成
  let(:valid_attributes) { { name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
  let(:invalid_attributes) { { name: '', email: 'invalid', password: 'short', password_confirmation: 'nomatch' } }

  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new User' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it 're-renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #mypage' do
    before do
      sign_in user  # Deviseのログインヘルパーを使用
    end

    it 'assigns the requested user to @user' do
      get :mypage, params: { user_id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the mypage template' do
      get :mypage, params: { user_id: user.id }
      expect(response).to render_template(:mypage)
    end
  end

  describe 'GET #mypage_notifications' do
    before do
      sign_in user
    end

    it 'assigns notifications for the user' do
      get :mypage_notifications, params: { user_id: user.id }
      expect(assigns(:notifications_on_mypage)).to eq(user.passive_notifications)
    end

    it 'marks notifications as read' do
      notification = create(:notification, visited: user, checked: false)
      get :mypage_notifications, params: { user_id: user.id }
      notification.reload
      expect(notification.checked).to be_truthy
    end
  end
end
