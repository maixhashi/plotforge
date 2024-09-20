require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:visitor) { create(:user) }
  let(:visited) { create(:user) }
  let(:notification) { build(:notification, visitor: visitor, visited: visited) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(notification).to be_valid
    end

    it 'is not valid without a visitor' do
      notification.visitor = nil
      expect(notification).not_to be_valid
    end

    it 'is not valid without a visited user' do
      notification.visited = nil
      expect(notification).not_to be_valid
    end

    it 'has a default value of false for checked' do
      expect(notification.checked).to be_falsey
    end
  end

  context 'associations' do
    it 'belongs to a visitor' do
      association = described_class.reflect_on_association(:visitor)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:class_name]).to eq 'User'
    end

    it 'belongs to a visited' do
      association = described_class.reflect_on_association(:visited)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:class_name]).to eq 'User'
    end

    it 'can belong to a shuffled overview' do
      association = described_class.reflect_on_association(:shuffled_overview)
      expect(association.macro).to eq :belongs_to
    end

    it 'can belong to a movie' do
      association = described_class.reflect_on_association(:movie)
      expect(association.macro).to eq :belongs_to
    end
  end

  context 'scopes' do
    it 'orders by created_at in descending order' do
      older_notification = create(:notification, created_at: 1.day.ago)
      newer_notification = create(:notification, created_at: 1.hour.ago)

      notifications = Notification.all
      expect(notifications.first).to eq newer_notification
    end
  end
end
