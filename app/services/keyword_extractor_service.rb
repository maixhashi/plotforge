class KeywordExtractorService
  ENCLOSED_PATTERNS = [
    /「[^」]+」/,  # 「」
    /『[^』]+』/,  # 『』
    /“[^”]+”/      # “”
  ].freeze

  def self.extract_and_assign_keywords(content, shuffled_overview)
    return if content.nil? || shuffled_overview.nil?

    keywords = []
    ENCLOSED_PATTERNS.each do |pattern|
      content.scan(pattern).each do |matched_text|
        keyword_content = matched_text.strip
        keywords << keyword_content unless keywords.include?(keyword_content)
      end
    end

    keywords.each do |keyword_content|
      keyword = Keyword.find_or_create_by(content: keyword_content)
      shuffled_overview.keywords << keyword unless shuffled_overview.keywords.include?(keyword)
    end
  end
end
