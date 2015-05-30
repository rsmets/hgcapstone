# output: decimal value between -1 to 1 where:
#         -1 = inversely correlated
#         0 = not correlated
#         1 = perfectly correlated

require 'statsample'

def spearman(a,b)

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

  # convert to proper input syntax
  c=x.collect {|point| point }.to_scale
  d=y.collect {|point| point }.to_scale

  # run algorithm
  output=Statsample::Bivariate.spearman(c,d)

  if tests==1
    finish = Time.now
    puts "end= #{finish-start} secs"
  end

  if output.nan?
    return 0
  else
    return output.real
  end
end

def test(num1 = 0, num2 = 0, a1 = [0.0], a2 = [0.0])
  puts "spearman(#{num1},#{num2})= #{spearman(a1,a2)}"
end

if __FILE__ == $0

  tests = 0
  if tests == 1
    a1 = [1,2,3,4,5,6,7,8]
    a2 = [2,3,4,5,6,7,8,9]   # directly correlated with a1

    #test(1,2,a1,a2)

    a3=[1,2,3,4,5,6]
    a4=[1,2,3,4,5,6,7,8]   # different size
    a5=[1,2,3,4,5,6,nil,nil]   # missing values at back end
    a6=[nil,nil,3,4,5,6,7,8]   # missing values at front end
    a7=[1,2,nil,nil,nil,nil,nil,nil]   # no values to correlate with a6

    # test(3,4,a3,a4)
   #  test(3,5,a3,a5)
   #  test(4,5,a4,a5)
   #  test(5,6,a5,a6)
   #  test(6,7,a6,a7)

    a8=[2,3,5,6,8,9,12,13,14,18,23,12,23,24,14,35,65]
    a9=[23,25,24,29,29,10,30,30,31,32,36,44,71]

    # test(8,9,a8,a9)
    # test(1,8,a1,a8)
    # test(8,1,a8,a1)

    # non-linear correlations
    a10=[1,4,9,16,25,36,49,64] # square of a1
    a11=[1,3,10,14,28,40,45,66] # square of a1, but noisy

    # test(1,10,a1,a10)
    # test(1,11,a1,a11)

    a12=[]
    a13=[]
    (0..1000).each do |i|
      a12[i] = (i-3)*(i-8)*(i-20)*(i-44) # non-linear compared to a13
      a13[i] = i
    end

    # test(12,13,a12,13)


    # Primary Surplus or Deficit by Country.csv
    a20=[
 -272.357,
-259.619,
-302.04,
-386.22,
-405.203,
-586.104,
-607.236,
-1022.657,
-1182.383,
-1381.167,
-1669.565,
-730.209,
-158.688,
-53.232,
-187.953,
-327.619,
-352.056,
-214.143,
155.705,
397.9,
322.6,
302.0,
200.325,
91.7,
21.675,
-20.325,
-103.4,
-140.625,
-75.375,
-42.8,
4.425,
-20.4,
-50.225,
-98.15,
-76.1,
-63.3,
-96.025,
-65.875,
8.9,
-11.375,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil
]
    # Arms Import - USA.csv
    a21=[
nil,
nil,
nil,
nil,
nil,
nil,
759000000.0,
1215000000.0,
1014000000.0,
1113000000.0,
973000000.0,
944000000.0,
821000000.0,
647000000.0,
523000000.0,
558000000.0,
592000000.0,
505000000.0,
502000000.0,
345000000.0,
234000000.0,
280000000.0,
600000000.0,
595000000.0,
805000000.0,
1028000000.0,
1008000000.0,
570000000.0,
550000000.0,
358000000.0,
1879000000.0,
1912000000.0,
2114000000.0,
479000000.0,
667000000.0,
362000000.0,
413000000.0,
198000000.0,
451000000.0,
326000000.0,
223000000.0,
321000000.0,
357000000.0,
449000000.0,
333000000.0,
581000000.0,
652000000.0,
667000000.0,
526000000.0,
32000000.0,
70000000.0,
70000000.0,
84000000.0,
144000000.0,
230000000.0,
366000000.0,
358000000.0,
264000000.0,
238000000.0,
219000000.0
]
    # Armed Forces Personnel - USA.csv
    a22=[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
1492200.0,
1520100.0,
1569417.0,
1563996.0,
1540000.0,
1555000.0,
1498000.0,
1546000.0,
1473000.0,
1480000.0,
1467000.0,
1420700.0,
1454800.0,
1575000.0,
1594000.0,
1533300.0,
1572100.0,
1635600.0,
1720000.0,
1820000.0,
1920000.0,
2120000.0,
2180000.0,
2240000.0,
nil,
nil,
nil,
2151600.0,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil
]

    test(20,21,a20,a21)
    test(20,22,a20,a22)
  end
end