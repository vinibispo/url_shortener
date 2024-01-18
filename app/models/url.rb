class Url < ApplicationRecord
    URL_REGEX = %r{
        \A
        (https?|ftp):\/\/                          # Protocol (http, https, ftp)
        (?:                                       # Non-capturing group for domain
          [a-z0-9]+(?:-[a-z0-9]+)*\.               # Subdomain(s)
        )*
        [a-z0-9]+(?:-[a-z0-9]+)*                   # Domain
        (?:                                       # Non-capturing group for port
          :[0-9]+
        )?
        (?:                                       # Non-capturing group for path
          \/
          [^?\s]*                                  # Path
        )?
        (?:                                       # Non-capturing group for query string
          \?
          [^#\s]*                                 # Query string
        )?
        (?:                                       # Non-capturing group for fragment
          \#
          [^\s]*                                  # Fragment
        )?
        \z
      }ix

    validates :original_url, presence: true, format: { with: URL_REGEX }
    validates :short_url, presence: true, uniqueness: true, length: { minimum: 3, maximum: 255 }

    validate :short_url_is_not_already_shortened, if: -> { original_url.present? && original_url.match?(URL_REGEX) }

    private

    def short_url_is_not_already_shortened
      original_uri = URI.parse(original_url)

      root_uri = URI.parse(Rails.application.routes.url_helpers.root_url)

      return unless original_uri.origin == root_uri.origin

      errors.add(:original_url, :already_shortened)
    end

    public

    def to_param
        short_url
    end
end
