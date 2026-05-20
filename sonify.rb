require 'optparse'
require 'digest/sha1'
require 'midicraft'

DEFAULT_MIDI_OUTPUT_FILE = 'example.mid'
DEFAULT_BPM = 120

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: sonify.rb [hash] [options]"

	opts.on("-v", "--verbose", "Enable verbose mode") do
		options[:verbose] = true
	end

	opts.on("-oOUTPUT", "--output=OUTPUT", "Specify output file. Default is example.mid") do |output|
		options[:output] = output
	end

	opts.on("-tTEXT", "--text=TEXT", "Specify a text string to compose with") do |text|
		options[:text] = text
	end

	opts.on("-bBPM", "--bpm=BPM", "Specify tempo as Beats per Minute. Default is 120") do |bpm|
		options[:bpm] = bpm.to_i
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

scale = %w(A3 B3 C3 D3 E3 F3 G3 A4 B4 C4 D4 E4 F4 G4)
values_per_note = 256 / scale.length

values.each do |v|
	durations << (v%100 < 50 ? :quarter : :eighth)
	scale.length.times.each do |i|
		# puts "#{i * values_per_note} to #{(i + 1) * values_per_note}"
		if v < (i + 1) * values_per_note
			note = scale[i]
			notes << note
			break
		end
	end
end

if options[:verbose]
	puts notes.join(' ')
end

seq = Midicraft.build(tempo: options[:bpm] || DEFAULT_BPM, time_signature: [4, 4]) do
  track "Lead", instrument: :clarinet, channel: 0 do
    notes.each_with_index do |n, i|
      note n, velocity: 100, duration: durations[i]
    end
  end
end

seq.write(options[:output] || DEFAULT_MIDI_OUTPUT_FILE)
