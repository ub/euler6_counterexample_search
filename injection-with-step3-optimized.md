Calculation time:   0.830000   0.000000   0.830000 (  0.832098)
Subgoals(4) count: 5475
Writing time:   0.960000   0.030000   0.990000 (  1.093758)
Candidates(4) count: 5475
Filtering time:   1.140000   0.010000   1.150000 (  1.154409)
Filtered(4) count: 1397
Writing time:   1.490000   0.020000   1.510000 (  1.609342)
Calculation time:  20.220000   0.240000  20.460000 ( 20.490074)
Subgoals(3) count: 203624
Writing time:  41.100000   0.160000  41.260000 ( 41.651965)
Candidates(3) count: 203624
Filtering time:  47.970000   0.410000  48.380000 ( 48.446526)
Filtered(3) count: 54780
Writing time:  28.950000   0.180000  29.130000 ( 29.809476)
Candidates(3) count: 54780
..............
Subgoals(2) count: 354561
Calculation time: 109.220000   0.090000   0.000000 (109.495554)
Writing time:  66.560000   0.260000   0.000000 ( 69.271251)
Candidates(2) count: 354561
..............................
Filtered(2) count: 196804
Filtering time: 295.260000   0.230000   0.000000 (296.014803)
Writing time:  37.740000   0.120000   0.000000 ( 41.303425)
Candidates(2) count: 196804
..................................................
6th power candidate values count: 14577746
Calculation time: 1370.520000   3.010000   0.000000 (1376.052084)
Writing time: 3099.310000  10.540000   0.000000 (3140.450993)
Candidates for sixth power count: 14577746
.......................................................
Total solutions found: 1203
Calculation time: 1806.960000   3.460000   0.000000 (1814.784829)
Writing time: 1911.850000   6.940000   0.000000 (2004.293329)


Ура 
baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search > bin/solutions  | wc -l
1203
baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search > bin/solutions  | uniq| wc -l
1000


Теперь нужно оптимзировать process2 аналогичным образом 
как мы сделали со step3
