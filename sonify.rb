require 'optparse'
require 'digest/sha1'
require 'midicraft'

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: sonify.rb [hash] [options]"

	opts.on("-v", "--verbose", "Enable verbose mode") do
		options[:verbose] = true
	end

	opts.on("-tText", "--text=TEXT", "Specify a text string to compose with") do |text|
		options[:text] = text
	end
end.parse!


hash = ''
if ARGV[0]
	hash = ARGV[0]
end

if options[:text]
	hash = Digest::SHA1.hexdigest options[:text]
end

values = []
durations = []
notes = []

if options[:verbose]
	puts hash
end

pairs = hash.chars.each_slice(2).map{|p| p.join}
pairs.each do |p|
	values << p.hex
end

values.each do |v|
	durations << (v%100 < 50 ? :quarter : :eighth)
	case v
	when 0..50
		notes << 'C4'
	when 51..100
		notes << 'D4'
	when 101..150
		notes << 'E4'
	when 151..200
		notes << 'F4'
	else
		notes << 'G4'
	end
end

seq = Midicraft.build(tempo: 140, time_signature: [4, 4]) do
  track "Lead", instrument: :clarinet, channel: 0 do
    notes.each_with_index do |n, i|
      note n, velocity: 100, duration: durations[i]
    end
  end
end

seq.write("example.mid")
