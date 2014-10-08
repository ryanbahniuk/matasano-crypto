class String
	CHARS = ('a'..'z').to_a + ('A'..'Z').to_a
	def hex_to_b64
		[[self].pack("H*")].pack("m0")
	end

	def xor_hexes(hex)
		self.to_i(16) ^ hex.to_i(16)
	end

	def brute
		normals = (32..126).to_a
		scores = Hash.new
		CHARS.each do |char|
			phrase = [self].pack("H*").bytes.map {|ascii| ascii ^ char.bytes.first }
			selected = phrase.select {|byte| normals.include?(byte) }
			if phrase.length == selected.length
				sentence = phrase.map(&:chr).join
				scores[sentence] = score(sentence)
			end
		end
		scores.sort_by { |k, v| v }.last.first
	end

	private

	def score(sentence)
		commons = "ETAOIN SHRDLU".split('').reverse
		commons.each_with_index.reduce(0) do |score, (letter, index)|
			score += sentence.count(letter) * index + 1
		end
	end
end
