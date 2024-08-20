require 'natto'

class CharacterExtractorService
  def initialize(text)
    @text = text
  end

  def self.extract_and_assign_characters(content)
    raise ArgumentError, "Text to parse cannot be nil" if content.nil?

    characters = []
    natto = Natto::MeCab.new
    last_surface = ""

    natto.parse(content) do |n|
      if n.feature.include?("固有名詞")
        if last_surface.present?
          # 直前の名前と結合して一つのキャラクター名にする
          character_name = last_surface + n.surface
          last_surface = ""
        else
          character_name = n.surface
        end

        # 次回のループ用に現在の名前を保持
        last_surface = character_name if last_surface.present?

        # キャラクターが存在するかを確認し、存在しない場合は新しく作成
        character = Character.find_or_create_by(name: character_name)
        characters << character
      else
        # 固有名詞でない場合は直前の名前をリセット
        last_surface = ""
      end
    end

    # ループの終わりに残っている名前を追加
    characters << Character.find_or_create_by(name: last_surface) if last_surface.present?

    characters
  end
end
