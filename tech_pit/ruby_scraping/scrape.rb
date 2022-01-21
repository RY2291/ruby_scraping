require "net/http"
require "nokogiri"
require "json"
require "optparse"

class PreProcessor
  def self.exec(argv)
    # オプション解析
    opt = OptionParser.new
    opt.on("--infile=VAL")
    opt.on("--outfile=VAL")
    opt.on("--category=VAL")

    params = {}
    opt.parse!(ARGV, into: params)

    if params[:infile] && params[:category]
      puts "Error: --infile と --category は同時に指定できません。"
      exit(1)
    end

    params
  end
end

params = PreProcessor.exec(ARGV)

if params[:infile]
  html = File.read(params[:infile])
end


# HTMLの読み込み
class HtmlReader
  def self.get_from(url)
    Net::HTTP.get(URI(url))
  end

  def self.read(params)
    if params[:infle]
      html = File.read(params[:infle])
    else
      url = 'https://masayuki14.github.io/pit-news/'
      if params[:category]
        url = url + "?category=" + params[:category]
      end
      html = get_from(url)
    end

    html
  end
end

html = HtmlReader.read(params)

# 各要素をスクレイピングする
class Scraper
  def self.scrape_news(news)
    {
      title: news.xpath("./p/strong/a").first.text,
      url: news.xpath("./p/strong/a").first["href"]
    }
  end

  def self.scrape_section(section)
    {
      category: section.xpath("./h6").first.text,
      news: section.xpath("./div/div").map { |node| scrape_news(node) }
    }
  end

  def self.scrape(html)
    doc = Nokogiri::HTML.parse(html, nil, "utf-8")
    pintnews = doc.xpath("/html/body/main/section[position() > 1]").map { |section| scrape_section(section)}
    pintnews
  end
end

pintnews = Scraper.scrape(html)


# ファイルへの書き出し
class JsonWriter
  def self.write(params, pintnews)
    if params[:outfile]
      outfile = params[:outfile]
    else
      outfile = "pintnews.json"
    end
    write_file(outfile, { pintnews: pintnews}.to_json)
  end

  def self.write_file(path, text)
    File.open(path, "w") { |file| file.write(text) }
  end
end

JsonWriter.write(params, pintnews)










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