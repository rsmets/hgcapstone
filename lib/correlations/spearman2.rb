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
      #puts" [#{i},#{j}]: #{array1.length}  #{array2.length}"

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
        ans[i][j] = rand() *2 -1 # this used to be 0
      end
    }
  }
  return ans
end

def test(a,b,x,y)
  answer = spearman2(x,y)
  puts "corr(#{a},#{b})="
  answer.each_with_index{|point, row|
    puts " #{row}:#{point}"
  }
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

    #test(20,21,a20,a21)

    # Urban Population - USA (% of Total).csv
    # Alcohol Imports - USA.csv
    # General Government Revenue - USA (USD Billions).csv
    # Military Expenditure - USA.csv
    # Age Dependency Ratio (% of Working-Age Population).csv
    a22=[[
nil,
nil,
nil,
nil,
nil,
nil,
81.277,
81.108,
80.94,
80.772,
80.606,
80.438,
80.269,
80.099,
79.928,
79.757,
79.583,
79.409,
79.234,
79.057,
78.742,
78.377,
78.008,
77.636,
77.257,
76.875,
76.488,
76.097,
75.701,
75.3,
75.089,
74.942,
74.793,
74.644,
74.494,
74.344,
74.194,
74.042,
73.89,
73.738,
73.692,
73.682,
73.673,
73.663,
73.653,
73.643,
73.633,
73.623,
73.613,
73.602,
73.333,
72.974,
72.612,
72.247,
71.879,
71.508,
71.134,
70.757,
70.377,
69.996
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
47.0,
594.0,
1588.0,
1317.0,
2192.0,
407.0,
362.0,
25.0,
39.0,
40.0,
15.0,
11.0,
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
],[
6975.957,
6693.348,
6412.495,
6117.444,
5851.326,
5472.539,
5173.936,
4718.314,
4512.451,
4304.189,
4095.081,
4441.666,
4584.355,
4371.081,
4013.141,
3596.227,
3355.171,
3269.226,
3412.072,
3506.3,
3249.4,
3059.7,
2868.9,
2676.6,
2496.1,
2359.4,
2194.4,
2071.0,
2010.6,
1907.9,
1799.3,
1658.7,
1548.3,
1423.7,
1338.7,
1229.1,
1108.9,
1042.3,
1011.1,
882.6,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,
3.8180890560051,
4.2366586195803,
4.5839862868043,
4.665603031194,
4.6368029017873,
4.220041987689,
3.8470533790131,
3.8081972300608,
3.8442380686895,
3.7855787012521,
3.6072784452727,
3.2495559098155,
2.9443502984428,
2.9334260267579,
2.9084011345051,
3.017625313559,
3.2098971946332,
3.3507444260635,
3.6384702704819,
3.9412625875657,
4.3269367758443,
4.6662639732081,
4.5398769031422,
5.120242156666,
5.3747105714336,
5.579960400563,
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
nil,
nil,
nil,
nil
],[
nil,
nil,
nil,
nil,
nil,
nil,
50.395340961378,
49.839638332499,
49.384544868864,
49.03995685195,
48.810017885103,
48.689404998863,
48.675648015512,
48.762685072122,
48.942809610412,
49.214552493075,
49.569720921102,
49.98365967845,
50.423932379937,
50.86247379478,
51.290676687217,
51.700527234309,
52.063920978984,
52.346696984976,
52.522964378889,
52.577952831745,
52.516006013045,
52.355974633122,
52.12947135109,
51.865006054147,
51.570147105684,
51.253183830653,
50.946266097689,
50.688491218393,
50.511913438383,
50.431508001327,
50.454049555828,
50.592832536571,
50.859139913839,
51.260884667355,
51.80449824826,
52.490313112287,
53.310076142004,
54.248701510481,
55.289267955837,
56.427444585838,
57.65028532039,
58.917443291096,
60.174990213376,
61.375599598366,
62.488987456239,
63.500202259267,
64.395162480906,
65.167717501755,
65.810516207689,
66.311853777171,
66.653615324517,
66.816649738748,
66.78000908646,
66.528816989698
]]

    # Total Investment - USA (% of GDP).csv
    # Mobile Cellular Subscriptions - USA (per 100 People).csv
    # CO2 emissions (kt).csv
    # Life Expectancy at Birth - USA (Total Years).csv
    a23=[[
22.2,
22.064,
21.7,
21.148,
20.466,
19.754,
19.348,
19.17,
18.545,
18.394,
17.513,
20.786,
22.351,
23.333,
23.223,
22.527,
21.66,
21.576,
22.052,
23.569,
23.318,
22.848,
22.364,
21.629,
21.205,
21.216,
20.334,
20.02,
20.059,
21.47,
22.449,
22.757,
23.548,
23.686,
24.145,
25.077,
22.228,
22.063,
24.247,
23.267,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,      
95.529547260879,
96.023919174934,
94.397239262128,
91.311652018589,
88.623646112759,
85.209165168243,
82.064144785353,
76.293538418783,
68.31769507084,
62.54719598459,
54.846814091401,
48.851038222537,
44.690578743969,
38.468091052882,
30.576102982054,
24.890639523335,
20.14238484362,
16.238152475081,
12.604724896414,
9.1049214067417,
6.1037165858924,
4.249049036876,
2.9396439015382,
2.0758023659791,
1.3928170299031,
0.82986340688471,
0.49865991743261,
0.2790603637987,
0.14065944399339,
0.038253436298666,
nil,
nil,
nil,
0.0,
0.0,
0.0,
0.0,
0.0,
0.0,
nil,
nil,
nil,
nil,
0.0,
nil,
nil,
nil,
nil,
0.0,
nil,
nil,
nil,
nil,
0.0
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,      
5433056.536,
5311840.184,
5656838.878,
5828696.5,
5737615.554,
5826393.624,
5790765.052,
5681664.468,
5650949.676,
5601404.839,
5713560.034,
5531691.502,
5456092.63,
5419440.965,
5286046.506,
5156168.7,
5121559.554,
5029767.21,
4922195.765,
4826703.418,
4768137.761,
4951084.391,
4888664.717,
4684431.152,
4491176.585,
4486460.823,
4470326.023,
4334925.715,
4300598.928,
4531792.277,
4721170.825,
4900373.448,
4889112.091,
4742292.745,
4613100.668,
4406329.539,
4598487.673,
4770194.948,
4564952.958,
4356770.034,
4328904.501,
4024748.853,
3831354.94,
3695708.943,
3561878.111,
3390922.571,
3255995.306,
3119230.874,
2987207.873,
2880505.507,
2890696.1
],[      
nil,
nil,
nil,
nil,
nil,
nil,
nil,
78.741463414634,
78.641463414634,
78.541463414634,
78.090243902439,
77.939024390244,
77.839024390244,
77.587804878049,
77.339024390244,
77.339024390244,
76.987804878049,
76.836585365854,
76.736585365854,
76.636585365854,
76.582926829268,
76.580487804878,
76.429268292683,
75.996585365854,
75.621951219512,
75.574390243902,
75.419512195122,
75.642195121951,
75.365853658537,
75.214634146341,
75.017073170732,
74.765853658537,
74.765853658537,
74.614634146342,
74.563414634146,
74.563414634146,
74.463414634146,
74.360975609756,
74.007317073171,
73.658536585366,
73.80487804878,
73.356097560976,
73.256097560976,
72.856097560976,
72.604878048781,
71.956097560976,
71.356097560976,
71.156097560976,
71.107317073171,
70.807317073171,
70.507317073171,
69.951219512195,
70.560975609756,
70.212195121951,
70.214634146341,
70.165853658537,
69.917073170732,
70.119512195122,
70.270731707317,
69.770731707317
      ]]

    #test(22,23,a22,a23)

    # Mobile Cellular Subscriptions - USA (per 100 People).csv
    # Age at First Marriage - Female - USA.csv
    # Unemployment Rate - USA (% of Total Labor Force).csv
    # Smoking Prevalence in Adults Male
    # General Government Revenue - USA (USD Billions).csv
    # Total Production - Jet Fuel - USA.csv
    # Electricity Imports - USA.csv
    # CO2 emissions (kt).csv
    a24=[[
nil,
nil,
nil,
nil,
nil,
nil,
95.529547260879,
96.023919174934,
94.397239262128,
91.311652018589,
88.623646112759,
85.209165168243,
82.064144785353,
76.293538418783,
68.31769507084,
62.54719598459,
54.846814091401,
48.851038222537,
44.690578743969,
38.468091052882,
30.576102982054,
24.890639523335,
20.14238484362,
16.238152475081,
12.604724896414,
9.1049214067417,
6.1037165858924,
4.249049036876,
2.9396439015382,
2.0758023659791,
1.3928170299031,
0.82986340688471,
0.49865991743261,
0.2790603637987,
0.14065944399339,
0.038253436298666,
nil,
nil,
nil,
0.0,
0.0,
0.0,
0.0,
0.0,
0.0,
nil,
nil,
nil,
nil,
0.0,
nil,
nil,
nil,
nil,
0.0,
nil,
nil,
nil,
nil,
0.0
],[
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
26.9,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
26.0,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
25.4,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
23.3,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
21.5,
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
],[
5.237,
5.227,
5.543,
5.751,
5.945,
6.292,
7.35,
8.075,
8.933,
9.625,
9.283,
5.8,
4.617,
4.608,
5.083,
5.542,
5.992,
5.783,
4.742,
3.967,
4.217,
4.5,
4.942,
5.408,
5.592,
6.1,
6.908,
7.492,
6.85,
5.617,
5.258,
5.492,
6.175,
7.0,
7.192,
7.508,
9.6,
9.708,
7.617,
7.175,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,
4364,
5884,
6813,
6685,
6569,
4906,
4906,
4135,
4238,
3495,
3533,
3530,
3462,
3505,
3638,
3616,
3544,
3485,
3652,
3632,
3277,
1799,
1376,
1248,
1088,
1073,
755,
657,
593,
449,
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
],[
6975.957,
6693.348,
6412.495,
6117.444,
5851.326,
5472.539,
5173.936,
4718.314,
4512.451,
4304.189,
4095.081,
4441.666,
4584.355,
4371.081,
4013.141,
3596.227,
3355.171,
3269.226,
3412.072,
3506.3,
3249.4,
3059.7,
2868.9,
2676.6,
2496.1,
2359.4,
2194.4,
2071.0,
2010.6,
1907.9,
1799.3,
1658.7,
1548.3,
1423.7,
1338.7,
1229.1,
1108.9,
1042.3,
1011.1,
882.6,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
67624.0,
66481.0,
71447.0,
69403.0,
70873.0,
73634.0,
73473.0,
70119.0,
71325.0,
72096.0,
76504.0,
73961.0,
72087.0,
73344.0,
72557.0,
67541.0,
69086.0,
67530.0,
66412.0,
68064.0,
70280.0,
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
nil,
nil,
nil,
nil,
nil,
nil
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
45083.0,
52191.0,
57019.0,
51396.0,
42691.0,
44527.0,
34210.0,
30390.0,
36373.0,
38501.0,
48592.0,
43215.0,
39513.0,
43032.0,
45288.0,
46760.0,
52230.0,
39082.0,
37204.0,
30812.0,
22506.0,
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
nil,
nil,
nil,
nil,
nil,
nil
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
nil,
5433056.536,
5311840.184,
5656838.878,
5828696.5,
5737615.554,
5826393.624,
5790765.052,
5681664.468,
5650949.676,
5601404.839,
5713560.034,
5531691.502,
5456092.63,
5419440.965,
5286046.506,
5156168.7,
5121559.554,
5029767.21,
4922195.765,
4826703.418,
4768137.761,
4951084.391,
4888664.717,
4684431.152,
4491176.585,
4486460.823,
4470326.023,
4334925.715,
4300598.928,
4531792.277,
4721170.825,
4900373.448,
4889112.091,
4742292.745,
4613100.668,
4406329.539,
4598487.673,
4770194.948,
4564952.958,
4356770.034,
4328904.501,
4024748.853,
3831354.94,
3695708.943,
3561878.111,
3390922.571,
3255995.306,
3119230.874,
2987207.873,
2880505.507,
2890696.1
        ]]

    # General Government Total Expenditure - USA (USD Billions).csv
    # Ratio of Female to Male Tertiary Enrollment - USA (%).csv

    # Urban Population - USA (% of Total).csv
    # Military Expenditure - USA.csv
    # Unemployment - USA (Youth Total % of Total Labor Force Ages 15-24).csv
    a25=[[
7852.22,
7473.852,
7168.6,
6917.034,
6644.273,
6432.412,
6139.217,
6106.51,
6055.624,
5994.169,
6044.522,
5477.064,
5047.392,
4699.782,
4464.684,
4158.897,
3936.06,
3718.912,
3505.57,
3353.5,
3177.6,
3026.0,
2935.4,
2848.4,
2732.7,
2613.2,
2520.6,
2431.6,
2298.3,
2143.2,
1968.5,
1832.6,
1741.4,
1648.9,
1541.9,
1409.0,
1299.5,
1191.3,
1072.0,
946.7,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,
nil,
139.209,
138.977,
139.491,
139.906,
140.334,
141.746,
142.373,
141.279,
140.094,
137.545,
135.638,
133.58,
132.788,
132.093,
131.951,
nil,
130.851,
129.584,
127.781,
127.22,
nil,
124.913,
123.371,
121.708,
118.976,
115.794,
113.363,
111.334,
109.264,
108.163,
108.967,
107.48,
104.909,
101.084,
96.769,
91.612,
84.044,
84.069,
80.736,
77.536,
71.972,
68.802,
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
],[
nil,
nil,
nil,
nil,
nil,
nil,
81.277,
81.108,
80.94,
80.772,
80.606,
80.438,
80.269,
80.099,
79.928,
79.757,
79.583,
79.409,
79.234,
79.057,
78.742,
78.377,
78.008,
77.636,
77.257,
76.875,
76.488,
76.097,
75.701,
75.3,
75.089,
74.942,
74.793,
74.644,
74.494,
74.344,
74.194,
74.042,
73.89,
73.738,
73.692,
73.682,
73.673,
73.663,
73.653,
73.643,
73.633,
73.623,
73.613,
73.602,
73.333,
72.974,
72.612,
72.247,
71.879,
71.508,
71.134,
70.757,
70.377,
69.996,
],[
nil,
nil,
nil,
nil,
nil,
nil,
3.8180890560051,
4.2366586195803,
4.5839862868043,
4.665603031194,
4.6368029017873,
4.220041987689,
3.8470533790131,
3.8081972300608,
3.8442380686895,
3.7855787012521,
3.6072784452727,
3.2495559098155,
2.9443502984428,
2.9334260267579,
2.9084011345051,
3.017625313559,
3.2098971946332,
3.3507444260635,
3.6384702704819,
3.9412625875657,
4.3269367758443,
4.6662639732081,
4.5398769031422,
5.120242156666,
5.3747105714336,
5.5799604005635,
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
nil,
nil,
nil,
nil
],[
nil,
nil,
nil,
nil,
nil,
nil,
15.800000190735,
16.5,
17.39999961853,
18.700000762939,
17.89999961853,
13.199999809265,
10.800000190735,
10.699999809265,
11.60000038147,
12.10000038147,
12.699999809265,
12.300000190735,
10.699999809265,
9.6000003814697,
10.199999809265,
10.699999809265,
11.5,
12.300000190735,
12.39999961853,
12.800000190735,
13.699999809265,
14.699999809265,
13.800000190735,
11.199999809265,
10.89999961853,
11.0,
12.199999809265,
13.300000190735,
13.60000038147,
13.89999961853,
17.200000762939,
17.799999237061,
14.89999961853,
13.800000190735,
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

    test(24,25,a24,a25)
  end
end