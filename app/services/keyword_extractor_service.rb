class KeywordExtractorService
  ENCLOSED_PATTERNS = [
    /「[^」]+」/,  # 「」
    /『[^』]+』/,  # 『』
    /“[^”]+”/      # “”
  ].freeze

  def self.extract_and_assign_keywords(content, shuffled_overview)
    return if content.nil? || shuffled_overview.nil?

    keywords = []

    # 1. ENCLOSED_PATTERNSからキーワードを抽出
    ENCLOSED_PATTERNS.each do |pattern|
      content.scan(pattern).each do |matched_text|
        keyword_content = matched_text.strip
        keywords << keyword_content unless keywords.include?(keyword_content)
      end
    end

    # 2. NEologdを使って「名詞 + の + 名詞」のパターンを抽出
    titles = extract_noun_phrases(content)
    titles.each do |title|
      keywords << title unless keywords.include?(title)
    end

    # 3. キーワードをShuffledOverviewに関連付け
    keywords.each do |keyword_content|
      keyword = Keyword.find_or_create_by(content: keyword_content)
      shuffled_overview.keywords << keyword unless shuffled_overview.keywords.include?(keyword)
    end
  end

  private

  def self.extract_noun_phrases(content)
    require 'natto'

    natto = Natto::MeCab.new
    titles = []
    buffer = []

    natto.parse(content) do |n|
      if n.feature.start_with?('名詞')
        buffer << n.surface  # 名詞をバッファに追加
      elsif n.surface == 'の' && buffer.any?
        buffer << n.surface  # 名詞の後の「の」をバッファに追加
      else
        # パターンが「名詞 の 名詞」であることを確認
        if buffer.length >= 3 && buffer[1] == 'の'
          titles << buffer.join
        end
        buffer.clear  # バッファをクリア
      end
    end

    # 最後のバッファのチェック
    if buffer.length >= 3 && buffer[1] == 'の'
      titles << buffer.join
    end

    titles
  end
end
