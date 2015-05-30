def pearson(a,b)

  # Initialize testing mode
  tests = 0

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
  
  if tests==1
    start = Time.now
  end

  # the following ruby_pearson algortihm was altered and copied from http://blog.chrislowis.co.uk/2008/11/24/ruby-gsl-pearson.html
  # -- begin copy
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
  # -- end copy

  if tests==1
    finish = Time.now
    puts "end= #{finish-start} secs"
  end

  output=(num/den).real
  if output.nan?
    return 0
  else
    return output
  end
end

def test(a,b,x,y)
	puts "corr(#{a},#{b})= #{pearson(x,y)}"
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

    a8=[2,3,5,6,8,9,12,13,14,18,23,12,23,24,14,35,65]
    a9=[23,25,24,29,29,10,30,30,31,32,36,44,71]

    test(8,9,a8,a9)
    test(1,8,a1,a8)
    test(8,1,a8,a1)

    # non-linear correlations
    a10=[1,4,9,16,25,36,49,64] # square of a1
    a11=[1,3,10,14,28,40,45,66] # square of a1, but noisy

    test(1,10,a1,a10)
    test(1,11,a1,a11)

    a12=[]
    a13=[]
    (0..1000).each do |i|
      a12[i] = (i-3)*(i-8)*(i-20)*(i-44) # non-linear compared to a13
      a13[i] = i
    end

    test(12,13,a12,13)
  end
end