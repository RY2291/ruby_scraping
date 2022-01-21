require "net/http"
require "nokogiri"
require "json"


def get_from(url)
  Net::HTTP.get(URI(url))
end

def write_file(path, text)
  File.open(path, "w") { |file| file.write(text) }
end

def scrape_news(news)
  {
    title: news.xpath("./p/strong/a").first.text,
    url: news.xpath("./p/strong/a").first["href"]
  }
end

def scrape_section(section)
  {
    category: section.xpath("./h6").first.text,
    news: section.xpath("./div/div").map { |node| scrape_news(node) }
  }
end

html = File.read('pintnews.html')
doc = Nokogiri::HTML.parse(html, nil, "utf-8")
pintnews = doc.xpath("/html/body/main/section[position() > 1]").map { |section| scrape_section(section)}
write_file("pintnews.json", { pintnews: pintnews}.to_json)


# # //はルートノード以下の全要素が対象になる
# section = doc.xpath("/html/body/main/section[2]").first

# # .は基準ノードとして自分自身を示すのでこの場合はsection要素自身になり、ロケーションパスはsection要素からの相対パスを意味します。
# category = section.xpath("./h6").first.text

# contents = {category: nil, news: []}
# contents[:category] = section.xpath("./h6").first.text
# section.xpath("./div/div").each do |node|
#   title = node.xpath("./p/strong/a").first.text
#   url = node.xpath("./p/strong/a").first["href"]

#   news = { title: title, url: url }
#   contents[:news] << news
# end

# pp contents