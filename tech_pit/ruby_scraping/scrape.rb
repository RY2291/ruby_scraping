require "net/http"

url = 'https://masayuki14.github.io/pit-news/'
uri = URI(url)
html = Net::HTTP.get(uri)
puts html
