def dCorr(a,b)

  # Initialize testing mode
  tests = 0

  # Sift out empty values
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


  # Begin algorithm
  if tests==1
    start = Time.now
    puts "\n t0= #{start-start} secs"
  end

  n = x.length

  # Generate matrix of distances for x
  xDist = Array.new(n){Array.new(n)}
  xRMean = Array.new(n,-1.0) # the mean of each row in x
  xCMean = Array.new(n,-1.0) # the mean of each column in x
  xColSum = Array.new(n, 0.0)

  x.each_with_index{|point, i|
  	sum = 0.0
  	x.each_with_index{|point2, i2|
  	  pythag = (i2-i)**2 + (point2-point)**2
  	  if pythag==0
  	  	xDist[i][i2] = 0
  	  else
  	  	tmp = Math.sqrt(pythag)
  	  	xDist[i][i2] = tmp
  	  	sum += tmp
  	    xColSum[i2] += tmp
  	  end
  	}

  	# Find mean of each row of x
  	xRMean[i] = sum / n
  }

  # Find mean of each column of x
  xColSum.each_with_index{|point, i|
    xCMean[i] = point / n
  }

  if tests==1
    t1 = Time.now
    puts " t1= #{t1-start} secs"
  end

  # Calculate matrix mX
  xAvgCMean = xCMean.inject(:+).to_f / n # this line was altered and copied from http://stackoverflow.com/questions/1341271/how-do-i-create-an-average-from-a-ruby-array
  
  sumAA = 0.0 # used later
  mX = Array.new(n){Array.new(n, 0.0)}
  xDist.each_with_index{|point, row|
  	point.each_with_index{|point2, col|
  	  tmp = point2 - xCMean[col] - xRMean[row] + xAvgCMean
      mX[row][col] = tmp
      sumAA += tmp**2
  	}
  }

  if tests==1
    t2 = Time.now
    puts " t2= #{t2-t1} secs"
  end

  # Generate matrix of distances for y
  yDist = Array.new(n){Array.new(n)}
  yRMean = Array.new(n,-1.0) # the mean of each row in y
  yCMean = Array.new(n,-1.0) # the mean of each column in y
  yColSum = Array.new(n, 0.0)

  y.each_with_index{|point, i|
  	sum = 0.0
  	y.each_with_index{|point2, i2|
  	  pythag = (i2-i)**2 + (point2-point)**2
  	  if pythag==0
  	  	yDist[i][i2] = 0
  	  else
  	  	tmp = Math.sqrt(pythag)
  	  	yDist[i][i2] = tmp
  	  	sum += tmp
  	  	yColSum[i2] += tmp
  	  end
  	}

  	# Find mean of each row of y
  	yRMean[i] = sum / n
  }

  # Find mean of each column of y
  yColSum.each_with_index{|point, i|
    yCMean[i] = point / n
  }

  if tests==1
    t3 = Time.now
    puts " t3= #{t3-t2} secs"
  end

  # Calculate matrix mY
  yAvgCMean = yCMean.inject(:+).to_f / n # this line was altered and copied from http://stackoverflow.com/questions/1341271/how-do-i-create-an-average-from-a-ruby-array

  sumAB = 0.0
  sumBB = 0.0
  mY = Array.new(n){Array.new(n, 0.0)}
  yDist.each_with_index{|point, row|
  	point.each_with_index{|point2, col|
  	  tmp = point2 - yCMean[col] - yRMean[row] + yAvgCMean
      mY[row][col] = tmp
      sumBB += tmp**2
      sumAB += mX[row][col] * tmp
  	}
  }

  ans = Math.sqrt(sumAB / Math.sqrt(sumAA*sumBB))

  if tests==1
    t4 = Time.now
    puts " end= #{t4-start} secs"
  end

  if ans.nan?
  	return 0
  else
  	return ans
  end
end

def test(a,b,x,y)
	puts "corr(#{a},#{b})= #{dCorr(x,y)}"
end

if __FILE__ == $0

  tests = 0
  if tests == 1
  	# a1 = [1,2,3,4,5,6,7,8]
  	# a2 = [2,3,4,5,6,7,8,9]   # directly correlated with a1

  	# #test(1,2,a1,a2)

  	# a3=[1,2,3,4,5,6]
  	# a4=[1,2,3,4,5,6,7,8]   # different size
  	# a5=[1,2,3,4,5,6,nil,nil]   # missing values at back end
  	# a6=[nil,nil,3,4,5,6,7,8]   # missing values at front end
  	# a7=[1,2,nil,nil,nil,nil,nil,nil]   # no values to correlate with a6

  	# test(3,4,a3,a4)
   #  test(3,5,a3,a5)
   #  test(4,5,a4,a5)
   #  test(5,6,a5,a6)
   #  test(6,7,a6,a7)

   #  a8=[2,3,5,6,8,9,12,13,14,18,23,12,23,24,14,35,65]
   #  a9=[23,25,24,29,29,10,30,30,31,32,36,44,71]

   #  test(8,9,a8,a9)
   #  test(1,8,a1,a8)
   #  test(8,1,a8,a1)

   #  # non-linear correlations
   #  a10=[1,4,9,16,25,36,49,64] # square of a1
   #  a11=[1,3,10,14,28,40,45,66] # square of a1, but noisy

   #  test(1,10,a1,a10)
   #  test(1,11,a1,a11)

    a12=[]
    a13=[]
 
	numDataSets = 1 # number of datasets to run algorithm on 

	start2 = Time.now   
    (0..numDataSets-1).each do |i2|
      (0..1000).each do |i|
        a12[i] = (i-3)*(i-8)*(i-20)*(i-44) # non-linear compared to a13
        a13[i] = i
      end

      test(12,13,a12,13)
    end
    puts "\n total_time= #{Time.now-start2}\n\n"
  end
end