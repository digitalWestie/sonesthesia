require "midicraft"

options = ARGV
puts options

hash = options[0]
values = []
durations = []
notes = []
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
