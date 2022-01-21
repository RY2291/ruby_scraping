require "optparse"
opt = OptionParser.new

params = {}

# onメソッドのブロックは、onメソッドが呼ばれた時点では実行されない。
opt.on('--infile=VAL')
opt.on('--outfile')
opt.on("--category=VAL")
opt.parse!(ARGV, into: params)
pp params


# pp $0

# pp ARGV.class
# pp ARGV

# ARGV.append("argument")
# pp $*