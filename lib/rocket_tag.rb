module RocketTag
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def clean_tags(tags)
      return tags unless tags.is_a?(Array)

      tags = tags.dup
      tags = tags.map(&:downcase) if RocketTag.configuration.force_lowercase
      tags = tags.map {|tag| tag.gsub(%r{\s+}, ' ')} if RocketTag.configuration.force_single_space
      tags = tags.map do |tag|
        RocketTag.configuration.invalid_words.each {|word| tag = tag.gsub(%r{(?<=(\s)|^)#{Regexp.escape(word)}?(?=($|\s))}, '') }
        tag.strip
      end unless RocketTag.configuration.invalid_words.empty?
      tags = tags.map do |tag|
        tag.gsub(%r{[^a-z0-9 #{Regexp.escape(RocketTag.configuration.valid_special_chars.join)}]}, '') # \-\'\#,; 
      end unless RocketTag.configuration.valid_special_chars.empty?
      tags = tags.map(&:singularize) if RocketTag.configuration.force_singular
      tags
    end
  end
end

require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rocket_tag/configuration'
require "rocket_tag/tagging"
require "rocket_tag/tag"
require "rocket_tag/alias_tag"
require "rocket_tag/taggable"

$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    include RocketTag::Taggable
  end
end
