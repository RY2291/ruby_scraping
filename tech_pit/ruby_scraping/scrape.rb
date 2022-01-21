require_relative 'lib/mercury'

Mercury.main(ARGV)










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