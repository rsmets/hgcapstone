# output: decimal value between -1 to 1 where:
# 		  -1 = inversely correlated
# 		  0 = not correlated
# 		  1 = perfectly correlated
# 		  NaN = No points in dataSet A have corresponding points in dataSet B
# 		  		and thus they cannot be correlated against each other. Likely
# 		  		the range isn't appropriate for these two dataSets

require 'statsample'

def kendall(a,b)

  # sift out empty values
  x = [0.0]
  y = [0.0]
  idx = 0
  a.each_with_index{|point, i|
	if point.nil?
	  #puts "  skipped x[#{i}]"
	elsif b[i].nil?
	  #puts "  skipped y[#{i}]"
	else
	  x[idx] = point
	  y[idx] = b[i]
	  idx += 1
	end
  }
  #puts "  x= #{x}"
  #puts "  y= #{y}"

  # convert to proper input syntax
  c=x.collect {|point| point }.to_scale
  d=y.collect {|point| point }.to_scale
  #puts "c= #{c}"
  #puts "d= #{d}"

  # run algorithm
  output=Statsample::Bivariate.tau_a(c,d)
  return output
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
  puts "kendall(#{num1},#{num2})= #{kendall(a1,a2)}"
end

if __FILE__ == $0

  tests = 0
  if tests == 1

	a1=[1,2,3,4,5,6,7,8]
	a2=[2,3,4,5,6,7,8,9]

	test(1,2,a1,a2)

	a3=[1,2,3,4,5,6]
	a4=[1,2,3,4,5,6,7,8]  # different size
	a5=[1,2,3,4,5,6,nil,nil]  # missing values at back end
	a6=[nil,nil,3,4,5,6,7,8]  # missing values at front end
	a7=[1,2,nil,nil,nil,nil,nil,nil]  # no values to correlate with a6

	test(3,4,a3,a4)
	test(3,5,a3,a5)
	test(4,5,a4,a5)
	test(5,6,a5,a6)
	test(6,7,a6,a7)
  end
end
