require "json"

module Mercury
  # ファイルへの書き出し
  class JsonWriter
    def initialize(options)
      @outfile = options[:outfile]
    end

    def write(pintnews)
      outfile = @outfile || "pintnews.json"
      write_file(outfile, { pintnews: pintnews}.to_json)
    end

    def write_file(path, text)
      File.open(path, "w") { |file| file.write(text) }
    end
  end
end