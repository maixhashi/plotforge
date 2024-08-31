module ApplicationHelper
  def truncate_without_html_tags(text, length, omission: '...')
    # HTMLタグを取り除いたテキストを取得
    text_content = ActionView::Base.full_sanitizer.sanitize(text)
    
    # テキストが指定した文字数を超える場合、切り詰め
    truncated_text = text_content.length > length ? text_content[0, length] + omission : text_content
    
    # 元のテキスト内で対応する部分を強調表示
    highlighted_truncated_text = text.gsub(text_content, truncated_text)

    # HTMLタグを含んだ状態で切り詰めたテキストを返す
    highlighted_truncated_text.html_safe
  end
end
