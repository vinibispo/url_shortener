class Url::Generate
  private attr_accessor :original_url, :short_url
  def initialize(url:, short_url: nil)
    self.original_url = url
    self.short_url = short_url
  end

  def call
    link = Url.new(original_url:)
    link.short_url = short_url || generate_short_url

    verify_block(link)
    link.save if link.errors.empty?

    if link.errors.any?
      return [:error, link]
    end

    [:ok, link]
  end

  private

  def generate_short_url
    loop do
      short_url = SecureRandom.hex(3)
      break short_url unless Url.where(short_url:).exists?
    end
  end

  def verify_block(link)
    blocklist_file = Rails.root.join('lib', 'files', 'blocklist.txt')
    blocklist = File.readlines(blocklist_file).map(&:chomp)

    blocklist.each do |word|
      if link.original_url.include?(word)
        link.errors.add(:original_url, :invalid, message: 'contains blocked words')
        break
      end
    end
  end
end
