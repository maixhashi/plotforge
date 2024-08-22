class CharacterExtractorService
  def self.extract_and_assign_characters(content)
    raise ArgumentError, "Text to parse cannot be nil" if content.nil?

    characters = []
    natto = Natto::MeCab.new
    current_name_parts = []
    full_name_set = Set.new  # 完成した名前を保存するためのセット

    # MeCabによる解析
    natto.parse(content) do |n|
      feature = n.feature
      surface = n.surface

      # デバッグ出力
      puts "Surface: #{surface}"
      puts "Feature: #{feature}"

      if feature.include?("地名") || feature.include?("国")
        # 地名や国名として分類されたものは保存しない
        current_name_parts.clear
        next
      end

      if feature.include?("固有名詞") || feature.include?("人名")
        # 名前のパーツを追加
        current_name_parts << surface
        puts "Adding part: #{surface}"
      else
        # 名前の終了または中断
        if current_name_parts.any?
          full_name = current_name_parts.join(" ")
          puts "Generated name: #{full_name}"

          # 完成した名前がすでに存在するかチェック
          unless full_name_set.include?(full_name)
            characters << full_name
            full_name_set.add(full_name)
            puts "Added to characters: #{full_name}"
          else
            puts "Duplicate found, not adding: #{full_name}"
          end

          # 名前パーツをクリア
          current_name_parts.clear
        end
      end
    end

    # ループの終わりに残っている名前を追加
    if current_name_parts.any?
      full_name = current_name_parts.join(" ")
      puts "Final name: #{full_name}"

      unless full_name_set.include?(full_name)
        characters << full_name
        full_name_set.add(full_name)
        puts "Added to characters: #{full_name}"
      else
        puts "Duplicate found, not adding: #{full_name}"
      end
    end

    characters
  end
end
