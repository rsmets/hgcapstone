# Input: 2 vectors
#
# Output: an array of numbers
#    Output error: [nil, nil] if the vectors don't have any corresponding values

require 'statsample'

def twoSamples(a,b)

  # sift out empty values
  x = [0.0]
  y = []
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

  #puts "length= #{y.length()}"

  if y.length() == 0
    #puts "Warning: the arrays don't have any corresponding values (ie: the ranges they cover are mutually exlusive)"
    #puts "    => : returning empty array"
    return [nil, nil]
  else
    # run algorithm
    t=Statsample::Test::T::TwoSamplesIndependent.new(c,d)
    output = Array.new(2)

    output[0] = t.compute() # "set t and probability for given u"
  			  # ...so basically idk
    output[1] = t.d() # Cohen's d is how much "effect size"

    return output
  end
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
  puts "twoSamples(#{num1},#{num2})= #{twoSamples(a1,a2)}"
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
