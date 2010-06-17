#!/usr/bin/env ruby
# coding: utf-8

require 'oauth'

# TwitterのAPIとのやりとりを行うクラス
class TwitterOauth
  def initialize
    # カレントディレクトリのsercret_keys.ymlをloadします。
    @secret_keys = YAML.load_file(File.dirname(__FILE__) + '/secret_keys.yml')
    @consumer = ''
    @res = ''
  end
  
  def consumer_key
    @secret_keys["ConsumerKey"]
  end

  def consumer_secret
    @secret_keys["ConsumerSecret"]
  end

  def access_token_key
    @secret_keys["AccessToken"]
  end

  def access_token_secret
    @secret_keys["AccessTokenSecret"]
  end

  def consumer
    @consumer = OAuth::Consumer.new(
      consumer_key,
      consumer_secret,
      :site => 'http://twitter.com'
    )
  end

  def access_token
    consumer
    access_token = OAuth::AccessToken.new(
      @consumer,
      access_token_key,
      access_token_secret
    )
  end

  # See Twitter API Documentation http://apiwiki.twitter.com/Twitter-API-Documentation

  def post(tweet=nil)
    @res = access_token.post(
      'http://twitter.com/statuses/update.json',
      'status'=> tweet
    )
  end

  def get_timeline
    @res = access_token.get('http://twitter.com/statuses/friends_timeline.atom')
    @res.body
  end

  def get_mentions
    @res = access_token.get('http://api.twitter.com/1/statuses/mentions.xml')
    @res.body
  end

  def get_rate_limit_status
    @res = access_token.get('http://api.twitter.com/1/account/rate_limit_status.xml')
    @res.body
  end

  def response_success?
    return true if @res.class == Net::HTTPOK

    false
  end
end
