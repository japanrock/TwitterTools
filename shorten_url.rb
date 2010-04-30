require 'rubygems'
require 'net/http'
Net::HTTP.version_1_2
require 'json'
require 'yaml'

# Thanks!! http://d.hatena.ne.jp/m-kawato/20090603/1244041369

# Usage:
#   shorten_url = ShortenURL.new
#   shorten_url.get_short_url("http://yahoo.co.jp")
#   puts shorten_url.short_url
#     => http://bit.ly/dnBGwo

class ShortenURL
  attr_reader :short_url

  def initialize
    @api_key    = YAML.load_file(File.dirname(__FILE__) + '/bit_ly_api_key.yml')
    @long_url   = ''
    @short_url  = ''
    @api_result = ''
    @query      = ''
  end

  # このメソッドはイケテないのであとで修正・・・
  def get_short_url(long_url)
    set_long_url(long_url)
    make_query
    api_call
    make_short_url
  end

  private

  def set_long_url(long_url)
    @long_url = [long_url]
  end

  # bit.ly Web APIに渡すquery stringの生成
  def make_query
    @query = 'version=2.0.1&' + @long_url.map {|url| "longUrl=#{url}"}.join('&') +
   '&login=' + "#{@api_key['USERNAME']}" + '&apiKey=' + "#{@api_key['API_KEY']}"
  end

  # bit.ly APIの呼び出し
  def api_call
    @api_result = JSON.parse(Net::HTTP.get("api.bit.ly", "/shorten?#{@query}"))
  end

  def make_short_url
    @api_result['results'].each_pair {|long_url, value|
      @short_url = value['shortUrl']
    }
  end
end
