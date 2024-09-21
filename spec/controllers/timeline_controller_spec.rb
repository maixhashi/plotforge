require 'rails_helper'

RSpec.describe TimelineController, type: :controller do
  let(:user) { create(:user) }
  let(:follower) { create(:user) }
  let!(:shuffled_overview) { create(:shuffled_overview, user: user) }
  let!(:follower_overview) { create(:shuffled_overview, user: follower) }

  before do
    user.following << follower
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @shuffled_overviews" do
      get :index
      expect(assigns(:shuffled_overviews)).to include(shuffled_overview, follower_overview)
    end

    it "fetches movies data from TMDB service" do
      expect_any_instance_of(TmdbService).to receive(:fetch_movie_details).twice
      get :index
    end

    it "paginates shuffled_overviews" do
      get :index, params: { shuffled_overviews_page: 1 }
      expect(assigns(:shuffled_overviews_on_timeline).count).to be <= 5
    end
  end

  describe "GET #timeline_shuffled_overviews" do
    it "returns a successful response" do
      get :timeline_shuffled_overviews
      expect(response).to be_successful
    end

    it "assigns @shuffled_overviews" do
      get :timeline_shuffled_overviews
      expect(assigns(:shuffled_overviews)).to include(shuffled_overview, follower_overview)
    end
  end

  describe "GET #timeline_movies" do
    it "returns a successful response" do
      get :timeline_movies
      expect(response).to be_successful
    end

    it "assigns @shuffled_overviews" do
      get :timeline_movies
      expect(assigns(:shuffled_overviews)).to include(shuffled_overview, follower_overview)
    end
  end
end
