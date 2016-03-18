require 'oauth'
require 'json'

caminho = @newid
baseurl = "https://api.twitter.com"
path    = "/1.1/geo/id/"
address = URI("#{baseurl}#{path}#{caminho}.json")
request = Net::HTTP::Get.new address.request_uri


def print_geo(tweets)
  @newlat = tweets['centroid'][1]
  @newlong = tweets['centroid'][0]
end

http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER


consumer_key = OAuth::Consumer.new("FQp22B3IU1I8JHA6HxPx1lV3W", "5py62DEs5hUdSBvKZ1WcbT5JTCvg6E1RUm3OWQMsL252GtAtaj")
access_token = OAuth::Token.new("4915384379-uJXlNdjMkIcM8gRpV85ENNkhTbH3YNiaJb8OMfs", "e0kTGbkytdfWgV0lSWIhlQnBW8bYhaXvP1BrSufJIkGgm")


request.oauth! http, consumer_key, access_token
http.start
response = http.request request

tweets = nil
if response.code == '200' then
  tweets = JSON.parse(response.body)
  print_geo(tweets)
end
