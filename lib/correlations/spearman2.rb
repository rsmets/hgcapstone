# Input: 2 matrices
#        arrays1: each row corresponds to a dataset on the left side of the Explore map
#        arrays2: each row corresponds to a dataset on the top side of the Explore map
# Output: 1 matrix
#         where each entry[i][j] is the correlation of the ith dataset on the left side
#           with the jth dataset on the top side

require 'statsample'

# the following ruby_pearson was altered and copied from http://blog.chrislowis.co.uk/2008/11/24/ruby-gsl-pearson.html
def spearman2(arrays1, arrays2)

  # the following 3 lines were altered and copied from http://stackoverflow.com/questions/5372701/how-to-declare-an-empty-2-dimensional-array-in-ruby
  width = arrays1.length
  height = arrays2.length
  ans = Array.new(width){Array.new(height, 0.0)}
  # -- end copy --

  arrays1.each_with_index{|array1, i|
    
    arrays2.each_with_index{|array2, j|

      # sift out empty values
      x = [0.0]
      y = [0.0]
      index = 0
      array1.each_with_index{|point, k|
        if point.nil?
          #puts "  skipped x[#{i}][#{k}]"
        elsif array2[k].nil?
          #puts "  skipped y[#{j}][#{k}]"
        else
          x[index] = point
          y[index] = array2[k]
          index +=1
        end
      }

      # convert to proper input syntax
      c=x.collect {|point| point }.to_scale
      d=y.collect {|point| point }.to_scale

      # run algorithm
      ans[i][j]=Statsample::Bivariate.spearman(c,d)
      if ans[i][j].nan?
        ans[i][j] = 0
      end
    }
  }
  return ans
end

def test(a,b,x,y)
  puts "corr(#{a},#{b})= #{spearman2(x,y)}"
end

if __FILE__ == $0

  tests = 0
  if tests == 1
    # a1=[[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]]
    # a2=[[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9]]

    # test(1,2,a1,a2)

    # a3=[[nil,nil,3,4,5,6,7,8],[1,2,nil,nil,nil,nil,7,8],
    #     [1,2,3,4,5,6,nil,nil],[nil,nil,nil,nil,nil,nil,nil,nil]]
    # a4=[[1,2,3,4,5,6,7,8]]

    # test(4,3,a4,a3) # empty values

    # a5=[[2,2,3,3,4,3,4,5],[8,7,6,5,4,3,2,1]]

    # test(4,5,a4,a5) # not totally correlated, inversely correlated

    # a6=[[2,2,3,3,4,4],[1,2,3,3,5,4,6,5,7]]

    # test(4,6,a4,a6) # different length

    # a7=[[nil,nil,nil,nil,5,6,7,8]]
    # a8=[[1,2,3,4,nil,nil,nil,nil]]

    # test(7,8,a7,a8) # empty values



    # Primary Surplus or Deficit by Country.csv
    a20=[[
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
]]

    # Arms Import - USA.csv
    a21=[[
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
]]

    # Armed Forces Personnel - USA.csv
    a22=[[
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
]]

    test(20,21,a20,a21)
    test(20,22,a20,a22)
  end
end