require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:notification) { create(:notification, visitor: user, visited: user) }

  before do
    user.bookmarked_movies.create(tmdb_id: movie.tmdb_id)
  end

  it { should have_many(:bookmark_of_movies).dependent(:destroy) }
  it { should have_many(:bookmarked_movies).through(:bookmark_of_movies).source(:movie) }
  it { should have_many(:active_relationships).class_name('Follow').with_foreign_key('follower_id').dependent(:destroy) }
  it { should have_many(:following).through(:active_relationships).source(:followed) }
  it { should have_many(:passive_relationships).class_name('Follow').with_foreign_key('followed_id').dependent(:destroy) }
  it { should have_many(:followers).through(:passive_relationships).source(:follower) }
  it { should have_many(:active_notifications).class_name('Notification').with_foreign_key('visitor_id').dependent(:destroy) }
  it { should have_many(:passive_notifications).class_name('Notification').with_foreign_key('visited_id').dependent(:destroy) }

  describe "Validation" do
    it "is valid with all attributes correctly set" do
      expect(user).to be_valid
    end

    it "is invalid without an email address" do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "requires email addresses to be unique" do
      create(:user, email: "duplicate@example.com")
      user.email = "duplicate@example.com"
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("はすでに存在します")
    end

    it "is invalid without a password" do
      user.password = nil
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "requires a password to be at least 3 characters long" do
      user.password = "ab"
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it "is invalid if the password confirmation doesn't match" do
      user.password_confirmation = "mismatch"
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
    end
  end

  describe "Associations" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:movie) { create(:movie) }
    let(:notification) { create(:notification, visitor: user) }

    it "can have shuffled_overviews" do
      expect(user).to respond_to(:shuffled_overviews)
    end

    it "can have bookmark_of_shuffled_overviews" do
      expect(user).to respond_to(:bookmark_of_shuffled_overviews)
    end

    it "should have many bookmark_of_movies" do
      expect(user).to have_many(:bookmark_of_movies).dependent(:destroy)
    end
  
    it "should have many bookmarked_movies through bookmark_of_movies" do
      expect(user).to have_many(:bookmarked_movies).through(:bookmark_of_movies).source(:movie)
    end
  
    it "should be able to create and access bookmarked movies" do
      expect(user.bookmarked_movies.pluck(:tmdb_id)).to include(movie.tmdb_id)
    end

    it "should have many active_relationships" do
      expect(user).to have_many(:active_relationships).class_name("Follow").with_foreign_key("follower_id").dependent(:destroy)
    end
  
    it "should have many following through active_relationships" do
      expect(user).to have_many(:following).through(:active_relationships).source(:followed)
    end
  
    it "should be able to follow and unfollow users" do
      user.follow(other_user)
      expect(user.following).to include(other_user)
      user.unfollow(other_user)
      expect(user.following).not_to include(other_user)
    end

    it "should have many passive_relationships" do
      expect(user).to have_many(:passive_relationships).class_name("Follow").with_foreign_key("followed_id").dependent(:destroy)
    end
  
    it "should have many followers through passive_relationships" do
      expect(user).to have_many(:followers).through(:passive_relationships).source(:follower)
    end
  
    it "should be able to have followers" do
      other_user.follow(user)
      expect(user.followers).to include(other_user)
    end

    it "should have many active_notifications" do
      expect(user).to have_many(:active_notifications).class_name("Notification").with_foreign_key("visitor_id").dependent(:destroy)
    end
  
    it "should have many passive_notifications" do
      expect(user).to have_many(:passive_notifications).class_name("Notification").with_foreign_key("visited_id").dependent(:destroy)
    end
  
    it "should be able to create and access notifications" do
      user.active_notifications.create(visited_id: user.id, action: "followed")
      expect(user.active_notifications).to include(notification)
    end
  end

  describe "Instance Methods" do
    let(:user) { create(:user) } 
    let(:other_user) { create(:user) }

    it "#follow works" do
      expect(user.following?(other_user)).to be_falsey
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end

    it "#unfollow works" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "avatar icon" do
    let(:valid_avatar) { fixture_file_upload('spec/fixtures/avatar.jpeg', 'image/jpeg') }
    let(:invalid_avatar) { fixture_file_upload('spec/fixtures/invalid_file.txt', 'text/plain') }
    let(:valid_user) { build(:user, avatar: valid_avatar) }
    let(:invalid_user) { build(:user, avatar: invalid_avatar) }

    it "accepts valid avatar file types" do
      expect(valid_user).to be_valid
    end
  
    it "rejects invalid avatar file types" do
      expect(invalid_user).to_not be_valid
    end
  end
end



