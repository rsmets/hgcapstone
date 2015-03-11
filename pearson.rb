#/fs/student/wcb/cs/cs189a

# the following ruby_pearson was altered and copied from http://blog.chrislowis.co.uk/2008/11/24/ruby-gsl-pearson.html
def pearson(a,b)

  # sift out empty values
  x = [0.0]
  y = [0.0]
  idx = 0
  a.each_with_index{|point, i|
    if point.nil?
      #puts "    skipped x[#{i}]"
    elsif b[i].nil?
      #puts "    skipped y[#{i}]"
    else
      x[idx] = point
      y[idx] = b[i]
      idx += 1
    end
  }
  #puts "  x= #{x}"
  #puts "  y= #{y}"

  n=x.length

  sumx=x.inject(0) {|r,i| r + i}
  sumy=y.inject(0) {|r,i| r + i}

  sumxSq=x.inject(0) {|r,i| r + i**2}
  sumySq=y.inject(0) {|r,i| r + i**2}

  prods=[]; x.each_with_index{|this_x,i| prods << this_x*y[i]}
  pSum=prods.inject(0){|r,i| r + i}

  # Calculate Pearson score
  num=pSum-(sumx*sumy/n)
  den=((sumxSq-(sumx**2)/n)*(sumySq-(sumy**2)/n))**0.5
  if den==0
    return 0
  end
  r=num/den
  return r.real
end

def test(a,b,x,y)
	puts "corr(#{a},#{b})= #{ruby_pearson(x,y)}"
end

if __FILE__ == $0

  tests = 0
  if tests == 1
  	a1 = [1,2,3,4,5,6,7,8]
  	a2 = [2,3,4,5,6,7,8,9]   # directly correlated with a1

  	test(1,2,a1,a2)

  	a3=[1,2,3,4,5,6]
  	a4=[1,2,3,4,5,6,7,8]   # different size
  	a5=[1,2,3,4,5,6,nil,nil]   # missing values at back end
  	a6=[nil,nil,3,4,5,6,7,8]   # missing values at front end
  	a7=[1,2,nil,nil,nil,nil,nil,nil]   # no values to correlate with a6

  	test(3,4,a3,a4)
    test(3,5,a3,a5)
    test(4,5,a4,a5)
    test(5,6,a5,a6)
    test(6,7,a6,a7)
  end
end