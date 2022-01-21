require "nokogiri"

html = File.open("pintnews.html", "r") { |f| f.read }
# parse => Rubyのオブジェクトに変換して返すメソッド
doc = Nokogiri::HTML.parse(html, nil, "utf-8")

# xpathメソッドを使って<h6>タグを取得
nodes = doc.xpath("//h6")
nodes.each { |node| pp node }
