require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'Associations' do
    it { is_expected.to belong_to(:follower).class_name('User') }
    it { is_expected.to belong_to(:followed).class_name('User') }
  end

  describe 'Validations' do
    it 'is valid with a follower and a followed user' do
      follow = Follow.new(follower: user1, followed: user2)
      expect(follow).to be_valid
    end

    it 'is invalid without a follower' do
      follow = Follow.new(follower: nil, followed: user2)
      expect(follow).not_to be_valid
    end

    it 'is invalid without a followed user' do
      follow = Follow.new(follower: user1, followed: nil)
      expect(follow).not_to be_valid
    end
  end
end
