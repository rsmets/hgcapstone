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
      numSkipped1 = 0
      numSkipped2 = 0
      index = 0
      array1.each_with_index{|point, k|
        if point.nil?
          #puts "  skipped x[#{i}][#{k}]"
          numSkipped1 +=1
        elsif array2[k].nil?
          #puts "  skipped y[#{j}][#{k}]"
          numSkipped2 +=1
        else
          x[index] = point
          y[index] = array2[k]
          #puts x[index]
          index +=1
        end
      }
      #puts " x[#{i}]= #{x}"
      #puts " y[#{j}]= #{y}"

      if numSkipped1 == array1.length
        ans[i][j] = 0.0
      elsif numSkipped2 == array2.length
        ans[i][j] = 0.0
      else
        # convert to proper input syntax
        c=x.collect {|point| point }.to_scale
        d=y.collect {|point| point }.to_scale
        #puts "c= #{c}"
        #puts "d= #{d}"

        # run algorithm
        ans[i][j]=Statsample::Bivariate.spearman(c,d)
        #return output
      end
      #puts "-ans[#{i}][#{j}]= #{ans[i][j]}"
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
    a1=[[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]]
    a2=[[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9]]

    test(1,2,a1,a2)

    a3=[[nil,nil,3,4,5,6,7,8],[1,2,nil,nil,nil,nil,7,8],[1,2,3,4,5,6,nil,nil],[nil,nil,nil,nil,nil,nil,nil,nil]]
    a4=[[1,2,3,4,5,6,7,8]]

    test(4,3,a4,a3) # empty values

    a5=[[2,2,3,3,4,3,4,5],[8,7,6,5,4,3,2,1]]

    test(4,5,a4,a5) # not totally correlated, inversely correlated

    a6=[[2,2,3,3,4,4],[1,2,3,3,5,4,6,5,7]]

    test(4,6,a4,a6) # different length
  end
end