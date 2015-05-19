# Input: currently takes 2 vectors. Could take any number, but needs to be adjusted for that
#
# Output: an array of numbers

require 'statsample'

def anovaOneWay(a,b)

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
  anova=Statsample::Anova::OneWayWithVectors.new([c,d])
  output = Array.new(9)

  output[0] = anova.df_bg() # degrees of freedom between groups
  output[1] = anova.df_wg() # degrees of freedom within groups
  output[2] = anova.k()
  #output[3] = anova.levene()
  output[3] = anova.n() # total number of cases
  output[4] = anova.ssbg() # sum of squares between groups
  output[5] = anova.sswg() # sum of squares within groups
  output[6] = anova.total_mean() # total mean

  output[7] = anova.f() # F-test
  output[8] = anova.probability() # probability of F-test

  #puts output[0]
  #puts output[1]
  #puts output[2]
  #puts output[3]
  #puts output[4]
  #puts output[5]
  #puts output[6]
  #puts output[7]
  #puts output[8]
  #puts output[9]

  o2 = Array.new(8)
  o2[0] = output[0]
  o2[1] = output[1]
  o2[2] = output[2]
  o2[3] = output[3]
  o2[4] = output[4]
  o2[5] = output[5]

  o2[6] = output[7]
  o2[7] = output[8]

  return o2
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
  puts "anovaOneWay(#{num1},#{num2})= #{anovaOneWay(a1,a2)}"
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

    #test(3,4,a3,a4)
    #test(3,5,a3,a5)
    #test(4,5,a4,a5)
    #test(5,6,a5,a6)
    #test(6,7,a6,a7)
  end
end
