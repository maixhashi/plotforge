class TutorialMessage
  attr_accessor :text, :image, :id, :redirect_path, :show_flag_spotlight

  def initialize(id:, text:, image: nil, redirect_path: nil, show_flag_spotlight: false)
    @id = id
    @text = text
    @image = image
    @redirect_path = redirect_path
    @show_flag_spotlight = show_flag_spotlight
  end

  # 全てのチュートリアルメッセージを定義
  def self.all
    [
      new(
        id: 'welcome',
        text: 'plotforgeにようこそ！ \r\n plotforgeは「この映画いいかも！」を見つける映画の探索・共有アプリです',
        image: 'picture_on_tutorial_message.png',
        redirect_path: Rails.application.routes.url_helpers.root_path,
        show_flag_spotlight: false
      )
      # チュートリアル終了は特に定義しない
    ]
  end

  # idでメッセージを検索する
  def self.find_by_index(index)
    all[index]
  end

  # idでメッセージを検索する新しいメソッド
  def self.find_by_id(id)
    all.find { |message| message.id == id }
  end
end
