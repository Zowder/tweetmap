require 'rubygems'
require 'oauth'
require 'json'
#Infos para dar o GET lá na api.

baseurl = "https://api.twitter.com"
path    = "/1.1/search/tweets.json"
query   = URI.encode_www_form(
    "q" => "%23#{$hashtagid}",
    "type_result" => "mixed",
    "count" => 100
)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Pega os tweets mais recentes de uma determinada hashtag, verifica se tem geolocalização habilitada para aquele tweet. Se tiver a
#localização direta ele monta os dados no myhash e armazena no array coords. Se não tiver as coordenadas diretas, ele roda o outro script
#para pegar as coordenadas aproximadas do local, que faz o mesmo procedimento anterior.
@contador = 0
def print_tw(tweets)
@coords = []
@coords1 = []
  tweets['statuses'].each do |tweet|
    if(tweet['geo'].nil? != true)
      @name = tweet['user']['screen_name']
      @txt = tweet['text']
      lat = tweet['geo']['coordinates'][0]
      long = tweet['geo']['coordinates'][1]
      @contador = @contador + 1
      myhash = {
        "Id": @contador,
            "Latitude": lat,
            "Longitude": long,
        "Descricao": "GEO != true #{@name} - #{@txt}"
      }
      @coords << myhash
    elsif(tweet['geo'].nil? == true)
      if(tweet['place'].nil? != true)
        @contador = @contador + 1
        @newid = tweet['place']['id']
        @name = tweet['user']['screen_name']
        @txt = tweet['text']
        load './searchgeo.rb'
        myhash1 = {
          "Id": @contador,
              "Latitude": @newlat,
              "Longitude": @newlong,
          "Descricao": "Passou pelo if do place #{@name} - #{@txt}"
        }
        @coords << myhash1

      end
    end
  end
  File.open("public/pontos.json","w") do |f|
    f.write(JSON.pretty_generate(@coords))
    end
end

# Configurando o HTTP para poder mandar a requisição pra API
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

#Keys para autenticar e ter acesso a api.
consumer_key = OAuth::Consumer.new("QLh5sEbXwSqlZ5okcXMGvem8c", "SpERuh1UNh2ND9IodBjS7RNZMkKNDyvcgAExFrmK4KqsKVkwfX")
access_token = OAuth::Token.new("4915384379-tV2EMCmd1RwNXz3O9MP2KntJ3u743LFOE2hIGRu", "9ny7XsbHu3DtTkGN3HvIQ6CHIsklmnkHovgij6rbp1gk7")

# Request
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Se der certo a request, pega a response.body e converte de JSON p/ um hash.
tweets = nil
if response.code == '200' then
  tweets = JSON.parse(response.body)
  print_tw(tweets)
end
