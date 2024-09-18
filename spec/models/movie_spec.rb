require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:user) { create(:user) } # 通知を受けるユーザー
  let(:movie) { create(:movie) }
  let(:current_user) { create(:user) } # 通知を送るユーザー

  describe 'Validations' do
    it 'is valid with a tmdb_id' do
      expect(movie).to be_valid
    end

    it 'is invalid without a tmdb_id' do
      movie.tmdb_id = nil
      expect(movie).not_to be_valid
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:link_of_shuffled_overview_movies) }
    it { is_expected.to have_many(:shuffled_overviews).through(:link_of_shuffled_overview_movies) }
    it { is_expected.to have_many(:bookmark_of_movies).dependent(:destroy) }
    it { is_expected.to have_many(:bookmarked_by_users).through(:bookmark_of_movies).source(:user) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
  end

  ## visited_idの渡し方について要検討　#185参照
    # describe '#create_notification_bookmark!' do
    #   context 'when a bookmark notification does not exist' do
    #     it 'creates a new bookmark notification' do
    #       expect {
    #         movie.create_notification_bookmark!(current_user, user.id) # user.id を渡す　2変数メソッドとして影響ないか？
    #       }.to change(Notification, :count).by(1)

    #       notification = Notification.last
    #       expect(notification.visitor_id).to eq(current_user.id)
    #       expect(notification.visited_id).to eq(user.id)
    #       expect(notification.movie_id).to eq(movie.id)
    #       expect(notification.action).to eq('bookmark-of-movie')
    #     end
    #   end

    #   context 'when a bookmark notification already exists' do
    #     before do
    #       create(:notification, visitor: current_user, visited: user, movie: movie, action: 'bookmark-of-movie')
    #     end

    #     it 'does not create a new notification' do
    #       expect {
    #         movie.create_notification_bookmark!(current_user, user.id) # user.id を渡す　2変数メソッドとして影響ないか？
    #       }.not_to change(Notification, :count)
    #     end
    #   end
    # end
end
