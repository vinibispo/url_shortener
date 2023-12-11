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
    validates :short_url, presence: true
end
