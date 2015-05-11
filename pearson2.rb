#/fs/student/wcb/cs/cs189a

# the following ruby_pearson was altered and copied from http://blog.chrislowis.co.uk/2008/11/24/ruby-gsl-pearson.html
def prsn(arrays1, arrays2)

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
        # Correlation pre-calculations
        n=x.length

        sumx=x.inject(0) {|r,m| r + m}
        sumy=y.inject(0) {|r,m| r + m}

        sumxSq=x.inject(0) {|r,m| r + m**2}
        sumySq=y.inject(0) {|r,m| r + m**2}

        prods=[]; x.each_with_index{|this_x,m| prods << this_x*y[m]}
        pSum=prods.inject(0){|r,m| r + m}

        # Calculate Pearson score
        num=pSum-(sumx*sumy/n)
        den=((sumxSq-(sumx**2)/n)*(sumySq-(sumy**2)/n))**0.5
        if den==0
          return 0
        end
        r=num/den
        ans[i][j] = r.real
      end
      #puts "-ans[#{i}][#{j}]= #{ans[i][j]}"
    }
  }
  return ans
end

def test(a,b,x,y)
	puts "corr(#{a},#{b})= #{prsn(x,y)}"
end

if __FILE__ == $0

  tests = 1
  if tests == 1
    a1=[[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]]
    a2=[[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9],[2,3,4,5,6,7,8,9]]

    test(1,2,a1,a2)

    a3=[[nil,nil,3,4,5,6,7,8],[1,2,nil,nil,nil,nil,7,8],[1,2,3,4,5,6,nil,nil],[nil,nil,nil,nil,nil,nil,nil,nil]]
    a4=[[1,2,3,4,5,6,7,8]]

    test(4,3,a4,a3) # empty values

    a5=[[2,2,3,3,4,3,4,5],[8,7,6,5,4,3,2,1]]

    test(4,5,a4,a5) # not totally correlated, inversely correlated
  end
end