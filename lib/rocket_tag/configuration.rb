module RocketTag
  class Configuration
    VALID_CONFIG_KEYS = [
      :force_lowercase,
      :force_single_space,
      :valid_special_chars,
      :force_singular,
      :invalid_words
    ]

    DEFAULT_FORCE_LOWERCASE = false
    DEFAULT_FORCE_SINGLE_SPACE = false
    DEFAULT_VALID_SPECIAL_CHARS = [] # Allows all chars by default
    DEFAULT_FORCE_SINGULAR = false
    DEFAULT_INVALID_WORDS = [] # Allows all words by default

    attr_accessor *VALID_CONFIG_KEYS

    def initialize
      self.reset
    end

    def options
      VALID_CONFIG_KEYS.each_with_object({}) do |config_key, hash|
        hash[config_key] = self.send(config_key)
      end
    end

    def reset
      VALID_CONFIG_KEYS.each do |key|
        self.send "#{key}=", self.class.const_get("DEFAULT_#{key.upcase}")
      end
    end
  end
end
