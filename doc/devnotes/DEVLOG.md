   ```rake "db:new_migration[CreateHypotheses, value:string{40} terms_count:integer factor:string{40} parent:references ]"```
   ```rake "db:new_migration[CreateRefutations, hypothesis:references reason:integer parameter:bigint ]"```
   
   
   
   
       sqlite> .schema 
       CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
       CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
       CREATE TABLE "hypotheses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "value" varchar(40), "terms_count" integer, "factor" varchar(40), "parent_id" integer);
       CREATE INDEX "index_hypotheses_on_parent_id" ON "hypotheses" ("parent_id");
       CREATE TABLE "refutations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "hypothesis_id" integer, "reason" integer, "parameter" bigint);
       CREATE INDEX "index_refutations_on_hypothesis_id" ON "refutations" ("hypothesis_id");
   
## Тайминг
   Запись 117649 *2/7 в таблицу sqlite без транзакций длилась десятки минут, с транзакцией -- 21 секнду
   
## Терминология
   
   * tactics 
   * backward (top-down) chaining
   * subgoals
   
   Мы можем рассматривать каждую гипотезу как цель (goal). Количество  слагаемых в гипотезе назовем рангом
   Каждую цель ранга N мы можем с помощью тактики/стратегии свести(reduce) к множеству альтернативных (дизъюнктивных) 
   подцелей ранга N-1
   Цель истинна тогда и только тогда, если хотя бы одна или более из  подцелей истинна
   
   Исключая (опровергая) подцели мы опровергаем цель 
   
   reducing
   
## Тайминг   
   Process5: 10 секунд вычисления, 50 секунд запись
   Поскольку идея заключается в  документированности и отслеживаемости логики -- мы записываем в БД все результаты, а фильтруем потом
   Можно отфильтровать и заранее -- сократить количество. Тогда  время записи сократится
   
   Можно посмотреть, как тайминги будут работать для  Postgres
   
## refutation 
   Появляется первая причина отвержения гипотезы -- не удается сформулировать ни одной _подцели_

 Hypothesis.for_terms(5).left_outer_joins(:subgoals).where( "subgoals_hypotheses.id" => nil).to_sql
 ```
 SELECT "hypotheses".* FROM "hypotheses" LEFT OUTER JOIN "hypotheses" "subgoals_hypotheses" ON "subgoals_hypotheses"."parent_id" = "hypotheses"."id" WHERE "hypotheses"."terms_count" = 5 AND "subgoals_hypotheses"."id" IS NULL
 ```
   
## Тайминг   
   bin\filter4   
   ( 32.281798)
   
   
   Hypothesis.for_terms(4).count
   
   Предыдущая реализация давала
   10320
   
   Нынешняя дает 51313 отфильтрованных гипотез из 84033
```ruby
   Hypothesis.for_terms(4).unrefuted.count
```   

Будем искать ошибку

_11/09_ дополнительная ошибка  -- нельзя проверять сумму делящейся на 2 и на 3
Только 8 и 9

После исправления регрессии
```ruby
 Hypothesis.for_terms(4).unrefuted.count
 ```
 #=> 10419


sqlite> select count(*), reason from refutations group by reason;
5601|1
65522|2
8092|3

Добавил проверку на представимость суммы степеней по модулю 31

```ruby
 Hypothesis.for_terms(4).unrefuted.count
 ```
 #=> 10321
 
 Что на 1 больше предыдущего варианта алгоритма!
 
 
 Повторный запуск после очистки базы приводит к регрессии -- снова 10419 результатов, 
 
 И в старом и в новом вычислении два дубликата
 ```
 mode csv
 sqlite> .output data.csv
 sqlite> SELECT customerid,
    ...>        firstname,
    ...>        lastname,
    ...>        company
    ...>   FROM customers;
 sqlite> .quit
 ```
 
 
1271964863790286291 присутствует в старом списке и нет в новом.
Дубликаты являются кратными вариантами -- один результат сокращенный вариант другого


Еще одна эвристика ~ 0.1%  Если F делится на 31, то E не может делиться на 31!

Отслеживаем старую версию
F6=100846601232737496855712890625 E6=61617958999827439062623452929
100846601232737496855712890625 - 61617958999827439062623452929 = 39228642232910057793089437696 =
333437957253440809467904 * 117649 


    #<S6pHypothesis:0x007f0219f220c0 @x=333437957253440809467904, @factor=117649, @terms_count=4>
[333437957253440809467904, 5209968082085012647936, 81405751282578322624, 1271964863790286291]

В новом расчете все-таки есть аналог -- просто не до конца редуцирован по какой-то причине

     #<Hypothesis id: 393696, value: "5209968082085012647936", terms_count: 4, factor: "7529536", parent_id: 354276>
и порождающая гипотеза
 
     #<Hypothesis id: 354276, value: "100846601232737496855712890625", terms_count: 5, factor: "1", parent_id: nil>


В старом расчете отсутствуют newonly.txt

100879995337641642321784
10094463753056061885712
10309760494796398779496
10339565395177047493216
104937806576027687749552
11076052157530750000
11438806891080947149720
118842464435020136821504
119984645590029443496520
120335940686100097745776
12049896498928987487841
12051384937205135057560
12183707203319067771448
1255801730319829312048
125618781912439601924632
1265129566265373316120
12727079023060414511577
12904225232902094216385
13019391470019109617
1323946521316051547265
132473662448997539018728
1352697788259879219873
135371391935805035286040
13893127508471206816
153751636949093078831272
1585207008807163116544
167057626611790055025
16858511340049832272768
17110334284799830255792
173063314961417968750000
174525544194177910637800
1814525107693290472
1874979225720610984
18998463241025762598352
190030185802902857634064
19189575361816664394592
198188467602877365328
202569881873671936989640
20406662688354265
2045175789660119789985
206126706496604377520296
217080117319862606500000
218465160236357912906680
2216813609932510081168
23075198771519561677480
2486815853497426183384
25630947364444834388392
260302918911550796197360
26401753190050420395033
2741406828276037957696
274290223896585
276943033730576310219280
282265327824961653520840
289481854802496673525912
29296550401884546625000
294502919625073160663896
298679317961933698840
306584240071312729108360
3276937881251281
33349288432191034773808
3421104834205851206752
3421567247260085880112
348067134170695313361
3629137414496485824712
3862352985518655784
3961852432010435526904
4071691015123616105769
41208543459700504027192
42436698445436348332864
4285784748384140625
43229510091133826848048
4418998963392484547920
46339348969367493040
4648929601758860587312
485921863336458019185
504445566165409
5209968082085012647936
5240388198958391335816
52770561031609116536152
5378504789005224053320
53961828165458041884976
55126396432241581750552
574838273922192937360
60349265398728996625000
604305551671147000
61186627719085347734608
616857216304964686480
64465107645046654671112
647000499282265
6620699205329269301865
68723575122313423683136
708867338081968
71255421114931614848536
74680988486365512444880
75367320662625412473
7800548337748096800040
8029108240442165502784
80352922326456896465464
8104549807229168560240
81635008503462297700960
82148608242413677168696
83545583432080758976
84665334819909555657712
9442274244861671875000
98746649882939582793280


Старый алгоритм фильтрации оставил из этого списка всего 6 элементов

1856913506797189637836 x 64
42834481691813093089 x 64
1271964863790286291 x 4096
1073805861286147245049 x 64
1305399741126261859 x 64
1542916404420930981145 x 64

Все они представлены в старом списке!



Тестируем и получаем, что значение должно быть отвергнуто!

```ruby
  let(:regression2a_bad) {FactoryGirl.build(:hypothesis,value:100879995337641642321784)}

  it 'refuses regression 1 example ' do
    pending
    expect(div64_checker.check(regression2a_bad)).to be_falsey
    expect(regression2a_bad.refutation).to be_present
  end
```

Вместе с тем, в базе оно присуттвует без опровержения 

```
sqlite> select * from hypotheses where value = '100879995337641642321784';
423483|100879995337641642321784|4|7529536|362142

sqlite> select count(*) from refutations where hypothesis_id = 423483;
0
```


Генерируем новый набор
bin/generate5
bin/process5


 100879995337641642321784 * 64 = 6456319701609065108594176

В новом наборе
```
sqlite>  select * from hypotheses where value = '6456319701609065108594176';
541130|6456319701609065108594176|4|117649|479789
```

Очистка
```ruby
ActiveRecord::Base.transaction { Hypothesis.for_terms(4).each {|h| next unless h.refutation ; h.refutation.destroy!}};nil
```

commit b95b1b44
fixed regression 10320

# Тайминг Process4
Общее время 10 минут -- что сопоставимо с 8 минутами прототипа с учетом времени, необходимого
для персистентности



25 сентября

irb(main):003:0> h3 = Hypothesis.for_terms(3);

irb(main):008:0> h3.group_by {|h| h.x % 7}.map {|k,a| [k,a.size]}.sort
=> [[0, 213], [1, 211597], [2, 242838], [3, 243256], [4, 34882], [5, 198], [6, 206]]
irb(main):009:0> h3.group_by {|h| h.x % 8}.map {|k,a| [k,a.size]}.sort
=> [[0, 357236], [1, 358563], [2, 4695], [3, 4859], [4, 3037], [5, 1602], [6, 1603], [7, 1595]]
irb(main):010:0> h3.group_by {|h| h.x % 9}.map {|k,a| [k,a.size]}.sort
=> [[0, 81034], [1, 83570], [2, 85210], [3, 83469], [4, 80951], [5, 79430], [6, 79695], [7, 79696], [8, 80135]]
irb(main):011:0> h3.group_by {|h| h.x % 31}.map {|k,a| [k,a.size]}.sort
=> [[0, 39368], [1, 22157], [2, 28502], [3, 23084], [4, 22659], [5, 14615], [6, 17180], [7, 23108], [8, 22380], [9, 11958], [10, 8966], [11, 30306], [12, 22496], [13, 24358], [14, 23359], [15, 27255], [16, 14758], [17, 24777], [18, 14983], [19, 26093], [20, 14371], [21, 32475], [22, 22525], [23, 30860], [24, 22364], [25, 28760], [26, 30841], [27, 34437], [28, 18535], [29, 27062], [30, 28598]]

Предыдущая версия фильтровала в методе report в следующем порядке 8,9,7,31,19

31 исключает следующие суммарные{3} невычеты [15,23,27,29,30] что составляет 148212

Проверка суммарных невычетов должна происходить быстрее, чем проверка делимости на шестую степень
Замерить.
Практически все то же, что с Filter4, только еще 19
Начинать нужно с 9, затем либо 8 либо 31
Переместить сохранение в отдельный блок для замера времени
Посмотреть суммарные невычеты для 19

Формулировка n-aggregated power k residue (non-residue) modulo m.


 bin/filter4
 66.230000   0.770000  67.000000 ( 69.062410)


Для трех членов мы можем использовать суммарные невычеты для 19 в дополнение к 7,8,9

И, кроме этого нули для 31
                        67
                        79
                        139
                        223

Для четырех членов нули только для 31
                        
                        
30.09 Переделал process4 на отдельное создание и сохранение
                          
Calculation time:  87.870000   1.140000  89.010000 ( 89.217953)
Saving time: 767.410000  13.930000 781.340000 (905.509358)

## Перехожу на postgres
[Инструкция на DO](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04)

Пользователь baranov уже существует    
                      
### Замеры производительности с postgres
                      
generate5 28.250000   1.020000  29.270000 ( 38.007207)
process5  85.930000   3.080000  89.010000 (114.381986)
filter4   84.560000   3.200000  87.760000 (108.089281)
process4:
Calculation time:  83.440000   0.780000  84.220000 ( 84.504624)
Saving time: 822.640000  26.480000 849.120000 (1032.951768)

заметно медленнее, чем с sqlite! 
                     
### Замеры производительности с mariadb

 26.570000   0.920000  27.490000 ( 32.509672)
 78.430000   2.780000  81.210000 ( 95.740431)
 81.890000   3.050000  84.940000 ( 97.663994)
Calculation time:  81.050000   0.970000  82.020000 ( 82.538949)
Saving time: 719.550000  23.550000 743.100000 (844.527841)


Включил опцию 

``` 
innodb_flush_log_at_trx_commit=2 
``` 

Стало чуть медленнее
Saving time: 799.640000  26.010000 825.650000 (929.018686)


Наконец, еще раз postgres с опциями                      
                     
    fsync = off
    full_page_writes = off                          

незначительные изменения
Saving time: 821.990000  26.800000 848.790000 (1029.675484)



### возвращаемся к sqlite3  и используем activerecord-import  

Calculation time:  84.110000   0.850000  84.960000 ( 85.093572)
Saving time: 153.770000   0.580000 154.350000 (155.658925)


## Гипотезы с тремя членами

```
irb(main):006:0* hyps.count
=> 733190
irb(main):007:0> hyps.partition {|h| h % 31 == 0 }.map {|set| set.count}
=> [39368, 693822]
irb(main):008:0> hyps.partition {|h| h % 67 == 0 }.map {|set| set.count}
=> [13337, 719853]
irb(main):009:0> hyps.partition {|h| h % 79 == 0 }.map {|set| set.count}
=> [9791, 723399]
irb(main):010:0> hyps.partition {|h| h % 139 == 0 }.map {|set| set.count}
=> [5873, 727317]
irb(main):011:0> hyps.partition {|h| h % 223 == 0 }.map {|set| set.count}
=> [4969, 728221]
irb(main):012:0> hyps.partition {|h| h % 7 == 0 }.map {|set| set.count}
=> [213, 732977]
irb(main):013:0> hyps.partition {|h| h % 8 == 0 }.map {|set| set.count}
=> [357236, 375954]
irb(main):014:0> hyps.partition {|h| h % 9 == 0 }.map {|set| set.count}
=> [81034, 652156]
irb(main):015:0> 
```

Фильтрация сокращает гипотезы в 9 раз

```
euler6_counterexample_search > bin/filter3
Candidates(3) count: 733190
Filtering time: 176.200000   1.550000 177.750000 (178.099204)
Filtered(3) count: 84939
Writing time: 149.220000   1.020000 150.240000 (152.915318)
```



Анализируем результаты фильтрации 

```
 hyp3 = Hypothesis.for_terms(3).unrefuted.unreduced
 [7,8,9,19].each do |p|
     print "\n#{p}:"; p hyp3.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
 end
``` 
 и получаем что-то странное
```
7:[[1, 24983], [2, 30129], [3, 29827]]
8:[[1, 74555], [2, 2535], [3, 3105], [4, 1456], [5, 1093], [6, 987], [7, 1208]]
9:[[1, 27911], [2, 29432], [3, 27426], [4, 42], [5, 23], [6, 30], [7, 44], [8, 31]]
19:[[0, 2850], [1, 1426], [2, 6598], [3, 5633], [4, 4211], [6, 4718], [7, 1340], [8, 13976], [9, 3236], [10, 1365], [11, 737], [12, 15255], [13, 956], [14, 7039], [15, 877], [18, 14722]]
```

4,5,6,7 для 8 и 9 должны были быть отвергнуты на этапе filter3 !

Скорее всего, дело в редукции и нужно еще раз пройтись с фильтрами 8 и 9

для 19 в принципе все OK


Для 7 нет по чистой случайности -- слишком мало сокращений на 7**6
Включаем повторную проверку после сокращений -- неоптимально, но можно пока пренебречь
-- теряем всего 4 секунды 
Filtering time: 180.830000   1.580000 182.410000 (182.690978)
Filtered(3) count: 80035

```
7:[[1, 23714], [2, 28121], [3, 28200]]
8:[[1, 74404], [2, 2530], [3, 3101]]
9:[[1, 26419], [2, 27763], [3, 25853]]
19:[[0, 2658], [1, 1348], [2, 6202], [3, 5267], [4, 4069], [6, 4489], [7, 1287], [8, 13083], [9, 2963], [10, 1315], [11, 650], [12, 14415], [13, 911], [14, 6760], [15, 783], [18, 13835]]
```

## Математическое отступление

Для всех случаев, когда получение суммарного вычета
 (при 2,3,4 членов) требует конгруэнтности нулю всех, кроме одного члена
 
 сумма вычетов всегда конгруэнтна 0
 
 Интересны случаи, когда сумма вычетов равна модулю -- 19 и 31
 В первом случае эвристика работает при 3, во втором -- не работает вообще
 Однако работают нули, когда число членов меньше числа вычетов (тривиально).
 

## TODO

lib/goal_replacement.rb -- разработать тактику для 19 (3)
и  [5, 13, 19, 43, 61, 97, 157, 277] (2)


t = Benchmark.measure {
$a = Hypothesis.for_terms(2).pluck(:value).map {|v| v.to_i}
}


 [5,13,19,37,43].each do |p|
     print "#{p}:"; p $a.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
 end;nil
 
 
  [5,13,19,37,43].each do |p|
      print "#{p}:"; p $b.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
  end;nil
  
  
    [7,8,9,19,31].each do |p|
      print "#{p}:"; p $a.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
    end;nilhttps://www.google.ru/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwjZv4mlueLPAhVhCZoKHXTyCaEQFggeMAA&url=https%3A%2F%2Fwww.kinopoisk.ru%2Ffilm%2F726794%2F&usg=AFQjCNEv9aUMwwGgpkw0qbz46xFE10H9xw
  
   $a.partition {|x| x % 4 == 3}.map {|a| a.size}
 # => [2080130, 9807498]


7:[[0, 699], [1, 5133993], [2, 6112539], [3, 638345], [4, 705], [5, 707], [6, 640]]
8:[[0, 1324399], [1, 2202560], [2, 3168467], [3, 1041595], [4, 1036812], [5, 1037232], [6, 1038028], [7, 1038535]]
9:[[0, 66372], [1, 4243590], [2, 5826565], [3, 1424565], [4, 65391], [5, 65324], [6, 65326], [7, 65243], [8, 65252]]

  
  Возвращаемся назад

   [7,8,9,19,31].each do |p|
        print "#{p}:"; p hyp3.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
      end;nil

7:[[1, 23714], [2, 28121], [3, 28200]]
8:[[1, 74404], [2, 2530], [3, 3101]]
9:[[1, 26419], [2, 27763], [3, 25853]]
19:[[0, 2658], [1, 1348], [2, 6202], [3, 5267], [4, 4069], [6, 4489], [7, 1287], [8, 13083], [9, 2963], [10, 1315], [11, 650], [12, 14415], [13, 911], [14, 6760], [15, 783], [18, 13835]]
31:[[1, 3270], [2, 4083], [3, 3432], [4, 3427], [5, 2191], [6, 2604], [7, 3367], [8, 3318], [9, 1716], [10, 1282], [11, 4232], [12, 3160], [13, 3430], [14, 3490], [16, 2171], [17, 3760], [18, 2258], [19, 3941], [20, 2181], [21, 4760], [22, 3218], [24, 3281], [25, 4240], [26, 4420], [28, 2803]]
    
    
Похоже, какая-та нестыковка    

## 16.10

Изменил алгоритм обработки гипотез для трех слагаемых -- корни по модулю 64 с заглядыванием вперед по модулю 512

Результаты по модулю 8 довольно странные  откуда остаток 3?!
7: [[0, 699], [1, 2925685], [2, 3506603], [3, 265326], [4, 705], [5, 707], [6, 640]]
8: [[0, 1324399], [1, 2202560], [2, 3168467], [3, 4939]]
9: [[0, 66372], [1, 2483726], [2, 3248368], [3, 575363], [4, 65391], [5, 65324], [6, 65326], [7, 65243], [8, 65252]]

my_db.sqlite3.2-512la

Вот такая парочка
#<Hypothesis id: 852828, value: "12141160352763", terms_count: 2, factor: "729", parent_id: 119773>

#<Hypothesis id: 119773, value: "8897951778164227", terms_count: 3, factor: "729", parent_id: 35688>

8897951778164227 % 9 => 1
(8897951778164227 - 190**6) /729 = 12141160352763
Возможно, стоило бы перемножать факторы родительской цели и подцели!

 12141160352763 % 9 => 6

Заглядывание вперед по модулю 6561 позволит отсеять эту гипотезу до записи вторым способом


Запоуск process3 вычисления скопом 
Calculation time: 1255.840000   5.610000 1261.450000 (1263.281380)

А транзацционная запись не заканчивается несколько часов и отжирает всю возможную память ...
 free
             total       used       free     shared    buffers     cached
Mem:      16333280   16107564     225716      10144      59116     161912
-/+ buffers/cache:   15886536     446744
Swap:     23832980   11944892   11888088




Возвращаясь к обработке пачками по 4000
Candidates(3) count: 80035
.....................
Subgoals(2) count: 6308592
Calculation time: 601.910000   0.680000   0.000000 (603.517389)
Writing time: 1278.220000   3.640000   0.000000 (1293.558848)


 [5,7,8,9,13,19,37,43].each do |p|
     print "#{p}:"; p $a.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
 end;nil
 
 
 
 
 
 Список простых чисел, для которых существуют суммарные невычеты для двух членов
 По крайней мере, из первых 200 простых чисел
 [7, 13, 19, 31, 37, 43, 61, 67, 73, 79, 109, 139, 223]
 
 
  В предыдущей версии мы зря спользовали 5 и 97
  
  К этому списку не забыть добавить 8 и 9
  
 
 filter2 -- первая версия трэшовая. Читаем группами по 10000 
 
 
 Candidates(2) count: 6308592
 Filtered(2) count: 194606
 Filtering time: 1218.700000   0.350000   0.000000 (1220.900787)
 Writing time: 778.880000   1.630000   0.000000 (849.276263)

 
 Блок encore фильтрует около дюжины случаев
 Убираем 'encore' и запускаем с батчем 100_000
 
 Процесс занимает меньше мегабайта
 
 Несмотря на сокращение кода и накладных расходов на транзакции, время обработки выросло -- вереоятно, в связи с тем что рабочий набор данных не помещается
 в кэш 
 
 
 
 Пропустил 8 -- запускаю расчет и увеличил размер пакета до 600 000. Процесс занимает 2.75G резидентной памяти
 
 
   [7,8,9,19,31].each do |p|
         print "#{p}:"; p hyps.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
       end;nil
 
 
 
 Увеличение пакета приводит к  дальнейшему возрастанию времени обработки.
 
 Candidates(2) count: 6308592
 ...........
 Filtered(2) count: 167988
 Filtering time: 1770.650000   2.440000   0.000000 (1775.661149)
 Writing time: 1011.440000   1.960000   0.000000 (1025.503426)


Сокращаю до 6000 байт в следующей версии




Filtered(2) count: 165688
Filtering time: 4936.940000   0.610000   0.000000 (4945.011762)
Writing time: 1522.800000   5.690000   0.000000 (1665.599404)


Время опять выросло! Правда, и фильтрация улучшилась. А что если размер пакета сделать 12000?



Время только растет
Filtered(2) count: 165688
Filtering time: 5073.420000   6.990000   0.000000 (5101.809999)
Writing time: 1573.800000   7.940000   0.000000 (1645.591932)




Оптимальный порядок обработки с остатком 1 [19, 7, 9, 5, 8, 43, 13, 277, 61, 97, 157]


Обработка двух членов без лобовой тактики

Candidates(2) count: 165688
..........................................
6th power values count: 845834
Unprocessed hypotheses(2) left: 2079
Calculation time: 122.780000   0.310000   0.000000 (125.311278)
Writing time: 174.210000   1.040000   0.000000 (188.752249)



   [5, 7,8,9,19].each do |p|
         print "#{p}:"; p unp2.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
       end;nil
```       
5:[[0, 756], [2, 666], [3, 657]]hy
7:[[2, 2079]]
8:[[2, 2079]]
9:[[2, 2079]]
19:[[2, 463], [3, 278], [8, 321], [12, 276], [14, 454], [18, 287]]
```       
 
 Тактика чуть более умного перебора с проверкой по модулю 19 позволит сократить число кандитатов втрое
 2 = 1+1 3 = 11+11 8 = 7 + 1 12 = 11 + 1 14 = 7 + 7 18 = 11 + 7
 
  unp2.select {|x| x % 5 == 0 && x % 15625 == 0}
  #=> []
  
  таких нет, но проверять все равно надо -- тактика все равно сократит вдвое
  
  
  метод 
      def is_sixth_power?(h)
        sixth_root=Math.cbrt(Math.sqrt(h.x))
        sixth_root.round ** 6 == h.x
      end
      
работает очень быстро       
845834 кандидатов обрабатываются за 10 секунд
Но использование плавающей точки дает ошибочные результаты для достаточно больших
чисел

работает для всех по крайней мере  < 100_000_000**6 

И, по крайней мере, выборочно работает для чисел от
 1_000_000_000_000_000 ** 6
   но не на порядок большего значения 10_000_000_000_000_000 ** 6



   [5, 7,8,9,13,19].each do |p|
         print "#{p}:"; p c6p.group_by {|h| h % p}.map {|k,a| [k,a.size]}.sort
       end;nil
       
       
Такая проверка занимает 6 секунд и сокращает число кандидатов в 100 раз:
```       
def could_be_a_6th_power?(h)
 [0,1,4].include?( h % 5) &&
   [7,8,9].all? {|m| [0,1].include? h % m} &&
       [0,1,12].include?(h % 13) &&
     [0,1,7,11].include?(h % 19) &&
     [0,1,2,4,8,16].include?(h % 31)
end
```       
       
Обработка с использованием грубой силы как запасного варианта:
Candidates(2) count: 165688
..........................................
6th power candidate values count: 2018886
Unprocessed hypotheses(2) left: 0
Calculation time: 213.020000   0.330000   0.000000 (213.605421)
Writing time: 390.200000   1.480000   0.000000 (409.418965)

Оптимизация грубой силы была бы небесполезна
1.25% гипотез-2 с тактикой "грубой силы" порождает 58% кандидатов-1 (возможных 6-х степеней)



c6p.any? {|h| is_sixth_power? h }


Таблица confirmations




```rake "db:new_migration[CreateConfirmations, hypothesis:references root:bigint ]"```


Candidates for sixth power count: 2018886
.....................................................................................................
Total solutions found: 0
Calculation time: 263.500000   0.180000   0.000000 (264.087729)
Writing time: 285.260000   0.680000   0.000000 (297.706937)


Накладные расходы на создание опровержений съедают заметную часть вычислений. 
Вычисления без сохранений занимали менее минуты



Проверка порожденных одной гипотезой
1631446248734681551884649609267
11921⁶ + 83552⁶ + 102459⁶ + 62510⁶ + 64891⁶ 
process3 занял больше половины памяти! Пришлось снизить расход до 1000 записей
все равно отжирает до 20%


process3 -- batch сокращен до 100

Candidates(3) count: 16306
....................................................................................................................................................................
Subgoals(2) count: 100108825
Calculation time: 8405.850000   1.310000   0.000000 (8419.786239)

Слишком большие вычислительные нагрузки -- наш алгоритм оптимизирован
для истинных степеней, поэтому псевдошестые степени должны удовлетворять
ограничениям по модулю 8 и 9


Создаем такую выборку
[77763, 96964, 87318, 89082, 1272]

1995202340343310983330572859097 = 77763⁶ + 96964⁶ + 87318⁶ + 89082⁶ + 1272⁶ 

 bin/rake db:create
 bin/rake db:drop
 bin/rake db:schema:load


Calculation time:   0.320000   0.020000   0.340000 (  0.352347)
Subgoals(4) count: 5
Writing time:   0.000000   0.000000   0.000000 (  0.057416)
Candidates(4) count: 5
Filtering time:   0.030000   0.000000   0.030000 (  0.055618)
Filtered(4) count: 1
Writing time:   0.010000   0.000000   0.010000 (  0.070379)
Calculation time:   0.330000   0.000000   0.330000 (  0.325372)
Subgoals(3) count: 3
Writing time:   0.000000   0.000000   0.000000 (  0.074852)
Candidates(3) count: 3
Filtering time:   0.020000   0.010000   0.030000 (  0.030871)
Filtered(3) count: 1
Writing time:   0.000000   0.000000   0.000000 (  0.069866)
Candidates(3) count: 1
.
Subgoals(2) count: 2
Calculation time:   0.300000   0.020000   0.000000 (  0.312574)
Writing time:   0.000000   0.000000   0.000000 (  0.064692)
Candidates(2) count: 2
.
Filtered(2) count: 1
Filtering time:   0.020000   0.000000   0.000000 (  0.021802)
Writing time:   0.010000   0.000000   0.000000 (  0.076875)
Candidates(2) count: 1
.
6th power candidate values count: 1
Calculation time:   0.310000   0.020000   0.000000 (  0.334062)
Writing time:   0.010000   0.000000   0.000000 (  0.054273)
Candidates for sixth power count: 1
.
Total solutions found: 1
Calculation time:   0.010000   0.000000   0.000000 (  0.009638)
Writing time:   0.000000   0.010000   0.000000 (  0.053039)

_02.11.2016_

Эксперимент с 1000 псевдошестыми степенями выдал перевыполнение плана!
Алгоритм нашел 1726 решений


_08.11.2016_


Оценка потенциала оптимизации разложения на три члена

Простые числа
p: 2 => exclusions: 0/2; requisites: 2/2
p: 3 => exclusions: 0/3; requisites: 2/3
p: 5 => exclusions: 0/5; requisites: 3/5
p: 7 => exclusions: 2/4; requisites: 4/4
p: 13 => exclusions: 4/7; requisites: 7/7
p: 19 => exclusions: 15/16; requisites: 12/16
p: 31 => exclusions: 26/26; requisites: 11/26
p: 37 => exclusions: 30/37; requisites: 24/37
p: 43 => exclusions: 42/43; requisites: 14/43
p: 61 => exclusions: 50/61; requisites: 1/61
p: 67 => exclusions: 67/67; requisites: 1/67
p: 73 => exclusions: 60/73; requisites: 0/73
p: 79 => exclusions: 79/79; requisites: 1/79
p: 97 => exclusions: 0/97; requisites: 1/97
p: 109 => exclusions: 90/109; requisites: 0/109
p: 139 => exclusions: 139/139; requisites: 1/139
p: 157 => exclusions: 0/157; requisites: 1/157
p: 223 => exclusions: 223/223; requisites: 1/223



p: 2 =>  zero-requisites: 1/2
p: 3 =>  zero-requisites: 2/3
p: 5 =>  zero-requisites: 1/5
p: 7 =>  zero-requisites: 3/4
p: 13 =>  zero-requisites: 3/7
p: 19 =>  zero-requisites: 6/16
p: 31 =>  zero-requisites: 1/26
p: 43 =>  zero-requisites: 7/43
p: 61 =>  zero-requisites: 1/61
p: 67 =>  zero-requisites: 1/67
p: 79 =>  zero-requisites: 1/79
p: 97 =>  zero-requisites: 1/97
p: 139 =>  zero-requisites: 1/139
p: 157 =>  zero-requisites: 1/157
p: 223 =>  zero-requisites: 1/223


Врезка баг в gzip !

baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search/db > gunzip -lv pseudo6pdb.sqlite3.gz
method  crc     date  time           compressed        uncompressed  ratio uncompressed_name
defla ec9f0b14 Nov  3 21:47          1948250702          1736258560 -12.2% pseudo6pdb.sqlite3
baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search/db > gunzip -k !$
gunzip -k pseudo6pdb.sqlite3.gz
baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search/db > ll *pseud*
-rw-r--r-- 1 baranov baranov 6031225856 Nov  3 21:47 pseudo6pdb.sqlite3
-rw-r--r-- 1 baranov baranov 1948250702 Nov  3 21:47 pseudo6pdb.sqlite3.gz
baranov@deep42:~/work/.activities/Euler/euler6_counterexample_search/db > 


## Терминология
https://en.wikipedia.org/wiki/Partition_(number_theory)
partition/composition/summands


## 1.12.2016 Переименование веток git'а

master -> maindev:
```
git checkout master
git branch -m maindev
git checkout -b master
```

