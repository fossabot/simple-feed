require 'hashie/extensions/symbolize_keys'
require 'simplefeed/version'

::Dir.glob(::File.expand_path('../simplefeed/*.rb', __FILE__)).each { |f| require_relative(f) }

module SimpleFeed
  @registry = {}

  def self.registry
    @registry
  end

  def self.define(name, **options, &block)
    name   = name.to_sym unless name.is_a?(Symbol)
    feed = registry[name] ? registry[name] : SimpleFeed::Feed.new(name)
    feed.configure(options) do
      block.call(feed) if block
    end
    registry[name] = feed
    feed
  end

  def self.get(name)
    registry[name.to_sym]
  end

  # Returns list of class attributes based on the setter methods.
  # Not fool-proof, but works in this context.
  def self.class_attributes(klass)
    klass.instance_methods.grep(%r{[^=!]=$}).map{ |m| m.to_s.gsub(/=/,'').to_sym}
  end

  def self.symbolize!(hash)
    Hashie::Extensions::SymbolizeKeys.symbolize_keys!(hash)
  end
end