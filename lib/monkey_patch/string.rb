class String
  VIETNAMESE_CHARS = [
     "aAeEoOuUiIdDyY",
     "áàạảãâấầậẩẫăắằặẳẵ",
     "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
     "éèẹẻẽêếềệểễ",
     "ÉÈẸẺẼÊẾỀỆỂỄ",
     "óòọỏõôốồộổỗơớờợởỡ",
     "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
     "úùụủũưứừựửữ",
     "ÚÙỤỦŨƯỨỪỰỬỮ",
     "íìịỉĩ",
     "ÍÌỊỈĨ",
     "đ",
     "Đ",
     "ýỳỵỷỹ",
     "ÝỲỴỶỸ"
  ];

  def convert_vietnamese_to_unicode
    result = ActionController::Base.helpers.strip_tags(self.dup).downcase
    VIETNAMESE_CHARS.each_with_index do |segment, i|
      next if i == 0
      segment.split('').each do |c|
        result.gsub! c, VIETNAMESE_CHARS[0][i - 1]
      end
    end
    result.gsub(/[^\x00-\x7F]/, '').gsub(/(\s-*)+/, '-')
      .gsub(/[\/\|\\\!\?\*\;:'"<>@#\$%\^\&\(\)]/, '').gsub '.', ','
  end
end
