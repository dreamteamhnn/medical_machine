concern :SeoSupport do
  BLOCK_CHARS = ["✅", "【", "】"]

  def simple_text text, limit = nil
    simple_text = helper.strip_tags(text).gsub(/#{BLOCK_CHARS.join('|')}|\?|\!/, "").gsub(/(\r|\n)+/, ".").gsub(/(\s*(\.)+\s*)/, '. ').gsub(/(\s*)\.(\s*)$/, '')
    limit ? simple_text.truncate(limit, omission: "", separator: " ") : simple_text
  end

  private
  def helper
    @helper ||= Class.new do
      include ActionView::Helpers
    end.new
  end
end
