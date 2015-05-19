# output: returns the mode of 2 vectors collectively
#     output Error: I think 0.0 means no mode returned

require 'statsample'

def median(a,b)

  # sift out empty values
  x = [0.0]
  y = [0.0]
  sum = 0.0
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

  z = x.concat y

  output=z.collect {|point| point }.to_scale

  return output.median()
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
  puts "median(#{num1},#{num2})= #{median(a1,a2)}"
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

  a8=[1,1,2,3,4,4,4,4]
  a9=[1,2,3,5,6,7,8,9]

  test(8,9,a8,a9)

  # median is in between two points
  a10=[1,2,3,4,5,6,7,8] 
  a11=[8,9,10,11,12,13,14]

  test(10,11,a10,a11)

  # unsorted arrays
  a12=[1,1,2,2,2,2,2,9] 
  a13=[9,9,2,2,2,2,2,2]

  test(12,13,a12,a13)
  end
end
