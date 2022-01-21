require "net/http"
require "nokogiri"


def get_from(url)
  Net::HTTP.get(URI(url))
end

def write_file(path, text)
  File.open(path, "w") { |file| file.write({text: pintnews}.to_json) }
end

html = File.open("pintnews.html", "r") { |f| f.read }
doc = Nokogiri::HTML.parse(html, nil, "utf-8")

pintnews = []
doc.xpath("/html/body/main/section").each_with_index do |section, index|

  next if index.zero?
  contents = { category: nil, news: [] }
  contents[:category] = section.xpath("./h6").first.text

  section.xpath("./div/div").each do |node|
    title = node.xpath("./p/strong/a").first.text
    url = node.xpath("./p/strong/a").first["href"]

    news = {title: title, url: url}
    contents[:news] << news
  end

  pintnews << contents
end

require "json"
File.open("pintnews.json", "w") { |file| file.write({ pintnews: pintnews}.to_json)}


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