#/fs/student/wcb/cs/cs189a

# the following mode definition was copied from http://www.redundantrobot.com/2013/09/exploring-inject-and-finding-the-mode-in-ruby/
def mode(mode)
  mode_return = mode.inject({}) { |k, v| k[v] = mode.count(v); k }
  mode_return.select { |k,v| v == mode_return.values.max }.keys
end

def corr(a1 = [0.0], a2 = [0.0])

	# Find difference between points
	difIdx = 0
	diff = [Float::INFINITY]
	a1.each_with_index {|point, i|
		if a2[i].nil?
			puts "skipped a2[#{i}]"
		elsif point.nil?
			puts "skipped a1[#{i}]"			
		else
			diff[difIdx] = point - a2[i]
			difIdx += 1
		end
	}

	# Find average of mode(s) of differences
	mode = mode(diff)
	#puts mode
	sumMode = 0.0
	mode.each { |x|
		sumMode += x
	}
	avgMode = sumMode / mode.length
	#puts "avgMode= #{avgMode}"

	# Subtract average mode from differences, then square it
	squares = [0.0]
	diff.each_with_index { |v, i|
		squares[i] = v - avgMode
		squares[i] = squares[i] * squares[i]
	}
	
	# Average the squares, and then square root it
	sumSquares = 0.0
	squares.each do |x|
		sumSquares += x
	end
	avgSquares = sumSquares / squares.length
	output = Math.sqrt(avgSquares)
	return output
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
	puts "corr(#{num1},#{num2})= #{corr(a1,a2)}"
end

if __FILE__ == $0

	tests = 0 	# set tests on or off
	if (tests == 1)
		a1 = [1,1,1,1,1,1,1,1]
		a2 = [2,2,2,2,2,2,2,2]	# directly correlated with a1
		a3 = [1,1,1,1,2,2,2,2]	# 2 modes
		a4 = [1,1,2,2,3,3,4,4]	# 4 modes

		test(1,2,a1,a2)
		test(1,3,a1,a3)
		test(1,4,a1,a4)

		a5 = [1,2,3,4,5,6,7,8]
		a6 = [8,7,6,5,4,3,2,1]	# inversely correlated with a5
		a7 = [9,1,9,1,9,1,9,1]

		test(5,6,a5,a6)
		test(1,7,a1,a7)
		test(5,7,a5,a7)

		a8 = [1,2,3,4,5,6,7,8]
		a9 = [1,99,1,99,1,99,1,99]	#not correlated with a8

		test(8,9,a8,a9)

		a10 = [nil,nil,3,4,5,6,7,8]
		a11 = [1,2,3,4,5,6,nil,nil]
		a12 = [1,2,nil,nil,nil,nil,nil,nil]

		test(8,10,a8,a10)
		test(10,8,a10,a8)
	end
end
