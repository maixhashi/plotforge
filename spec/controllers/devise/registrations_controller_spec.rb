require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user_params) do
    {
      name: "Test User",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    }
  end

  let(:avatar) { fixture_file_upload('spec/fixtures/avatar.jpeg', 'image/jpeg') }
  let(:user_params_with_avatar) { user_params.merge(avatar: avatar) }
  let(:user_params_without_avatar) { user_params.merge(avatar: nil) }

  describe "POST #create" do
    it "creates a user with avatar" do
      expect {
        post :create, params: { user: user_params_with_avatar }
      }.to change(User, :count).by(1)
    end

    it "creates a user without an avatar" do
      ## avatarが登録されていなくてもアカウントの登録をすることはできる
      expect {
        post :create, params: { user: user_params_without_avatar }
      }.to change(User, :count).by(1)
    end
  end
end
