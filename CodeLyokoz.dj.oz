
local

   % START
   % FIRST TWO COUPLETS
    PartD1 = [partition([stretch(factor:0.25 [f f c5 f a#4 f a f]) silence(duration:0.25) stretch(factor:0.25 [f c5 f a#4 f a f]) silence(duration:0.25) stretch(factor:0.25 [f c5 f a#4 f a f]) silence(duration:0.25) stretch(factor:0.25 [f c5 f a#4 a f g])])]
    PartG1 = [partition([stretch(factor:2.0 [f3]) stretch(factor:2.0 [c3]) stretch(factor:2.0 [d3]) stretch(factor:1.0 [b2 f3])])]

    PartG2 = [partition([stretch(factor:0.25 [silence(duration:0.5) c5 silence(duration:1.0) c5 silence(duration:1.0) c5 silence(duration:1.0)]) stretch(factor:0.125 [c5 c5 e5]) stretch(factor:0.25 [silence(duration:0.5) e5 silence(duration:1.0) e5 silence(duration:1.0) e5 silence(duration:1.0)]) stretch(factor:0.125 [e5 e5 g5]) stretch(factor:0.25 [silence(duration:0.5) g5 silence(duration:1.0) g5 silence(duration:1.0) g5 silence(duration:1.0)]) stretch(factor:0.125 [g5 g5 a5]) stretch(factor:0.25 [silence(duration:0.5) a5 silence(duration:1.0) a5 silence(duration:1.0) a5 silence(duration:1.0)]) stretch(factor:0.125 [a5 a5 a#5])])]


    Couplet1D = [repeat(amount:2 PartD1)] 
    Couplet1G = [repeat(amount:2 PartG1)]

     Couplet1 = [merge([0.5#PartD1 0.5#PartG1])]
     Couplet2 = [merge([0.425#PartD1 0.425#PartG1 0.15#PartG2])]


   % SECOND TWO COUPLETS (Couplet 3x2)
   Acc1 = [c5 f5 a5]
   Acc2 = [c5 e5 g5]
   Acc3 = [d5 f5 a5]
   Acc4 = [d5 f5 a#5]

   Couplet3G = [partition([stretch(factor:0.25 [Acc1 Acc1 Acc1 Acc1 Acc1 Acc1 Acc1 Acc1]) stretch(factor:0.25 [Acc2 Acc2 Acc2 Acc2 Acc2 Acc2 Acc2 Acc2]) stretch(factor:0.25 [Acc3 Acc3 Acc3 Acc3 Acc3 Acc3 Acc3 Acc3]) stretch(factor:0.25 [Acc4 Acc4 Acc4 Acc4 Acc4 Acc4 Acc4 Acc4])])]


   Couplet3 = [merge([0.1#PartG2 0.3#Couplet3G 0.3#PartD1 0.3#PartG1])]


   % START SINGING
   % COUPLET 5-6

   Couplet5D = [partition([silence(duration:0.75) stretch(factor:0.25 [f a c5 a c5]) silence(duration:1.5) stretch(factor:0.25 [a c5]) stretch(factor:0.5 [d5]) stretch(factor:0.25 [c5]) stretch(factor:0.5 [c5 a]) stretch(factor:0.25 [f]) stretch(factor:0.5 [f]) silence(duration:1.5)])]
   Couplet5 = [merge([0.5#Couplet5D 0.5#Couplet3G])]

   Couplet6D =[partition([silence(duration:0.75) stretch(factor:0.25 [f a c5 a d5 d5]) stretch(factor:0.5 [c5]) silence(duration:0.75) stretch(factor:0.25 [a c5]) stretch(factor:0.5 [d5]) stretch(factor:0.25 [c5]) stretch(factor:0.5 [d5]) stretch(factor:0.5 [f5]) stretch(factor:0.25 [f5]) stretch(factor:0.5 [f5]) silence(duration:1.5)])]

   Couplet6 = [merge([0.7#Couplet6D 0.3#Couplet3G])]


   % Couplet 7-8

   Acc5 = [d5 f5 a#5]
   Acc6 = [e5 g5 c6]
   Acc7 = [f5 a5 c6]
   Acc8 = [g5 c6 e6]

   Couplet7D = [partition([silence(duration:0.75) stretch(factor:0.25 [d5 d5 d5 d5 e5 e5]) silence(duration:1.25) stretch(factor:0.25 [d5 e5]) stretch(factor:0.5 [f5]) stretch(factor:0.25 [e5]) stretch(factor:0.5 [f5]) stretch(factor:0.5 [g5]) stretch(factor:0.25 [g5]) stretch(factor:1.0 [g5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5]) silence(duration:0.25)])]
   Couplet7G = [partition([stretch(factor:0.25 [Acc5 Acc5 Acc5 Acc5 Acc5 Acc5 Acc5 Acc5]) stretch(factor:0.25 [Acc6 Acc6 Acc6 Acc6 Acc6 Acc6 Acc6 Acc6]) stretch(factor:0.25 [Acc7 Acc7 Acc7 Acc7 Acc7 Acc7 Acc7 Acc7]) stretch(factor:0.25 [Acc8 Acc8 Acc8 Acc8 Acc8 Acc8 Acc8 Acc8])])]

   Couplet7 = [merge([0.7#Couplet7D 0.3#Couplet7G])]

   % REFRAIN

   Acc9 = [c5 f5 a5]
   Acc10 = [c5 e5 g5]
   Acc11 = [d5 f5 a5]
   Acc12 = [d5 f5 a#5]

   Refrain1G = [partition([stretch(factor:0.25 [Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9]) stretch(factor:0.25 [Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10]) stretch(factor:0.25 [Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11]) stretch(factor:0.25 [Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12]) stretch(factor:0.25 [Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9]) stretch(factor:0.25 [Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10]) stretch(factor:0.25 [Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11]) stretch(factor:0.25 [Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12])])]
   Refrain1D = [partition([silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5 f5 e5 d5 e5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5 f5]) stretch(factor:0.5 [e5]) stretch(factor:0.5 [d5]) stretch(factor:0.25 [c5 f5 f5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5 f5 e5 d5 e5]) silence(duration:0.25) stretch(factor:0.25 [c5 f5 f5]) stretch(factor:1.0 [f5]) silence(duration:0.75) stretch(factor:0.25 [a#5 a#5 a5]) stretch(factor:0.5 [g5 f5]) stretch(factor:0.25 [f5])])]

   Refrain1 = [merge([0.3#Refrain1G 0.7#Refrain1D])]

 % IF YOU GOT ENOUGH MEMORY

   % Refrain2G = [partition([stretch(factor:0.25 [Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9]) stretch(factor:0.25 [Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10]) stretch(factor:0.25 [Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11]) stretch(factor:0.25 [Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12]) stretch(factor:0.25 [Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9 Acc9]) stretch(factor:0.25 [Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10 Acc10]) stretch(factor:0.25 [Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11 Acc11]) stretch(factor:0.25 [Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12 Acc12])])]
   % Refrain2D = [partition([stretch(factor:0.25 [f5]) silence(duration:0.25) stretch(factor:0.25 [c6]) silence(duration:0.25) stretch(factor:0.25 [a#5 a5]) silence(duration:0.25) stretch(factor:0.25 [g5]) silence(duration:0.5) stretch(factor:0.25 [c5]) stretch(factor:0.5 [d5 e5]) stretch(factor:0.25 [b4 b4]) silence(duration:0.25) stretch(factor:0.25 [c6]) silence(duration:0.25) stretch(factor:0.25 [a#5 a5]) silence(duration:0.25) stretch(factor:0.25 [f5]) silence(duration:0.5) stretch(factor:0.25 [f5]) stretch(factor:0.5 [g5 a5]) silence(duration:0.25) stretch(factor:0.25 [c6]) silence(duration:0.25) stretch(factor:0.25 [a#5 a5]) silence(duration:0.25) stretch(factor:0.25 [g5]) silence(duration:0.5) stretch(factor:0.25 [e5]) stretch(factor:0.5 [f5 g5]) stretch(factor:0.25 [d5]) silence(duration:0.5) stretch(factor:0.25 [c6]) silence(duration:0.25) stretch(factor:0.25 [a#5 a5]) silence(duration:0.25) stretch(factor:0.25 [f5 f5]) silence(duration:0.25) stretch(factor:0.25 [f5]) stretch(factor:0.5 [g5 a5]) stretch(factor:0.25 [f5])])]

   % Refrain2 = [merge([0.3#Refrain2G 0.7#Refrain2D])]
   % APPENDING

   Part2 = {Append Couplet1 Couplet2}
   Part3 = {Append Part2 Couplet3}
   Part4 = {Append Part3 Couplet3}
   Part5 = {Append Part4 Couplet5}
   Part6 = {Append Part5 Couplet6}
   Part7 = {Append Part6 Couplet7}
   Part8 = {Append Part7 Refrain1}
   %Part9 = {Append Part8 Refrain2}



 in
    % This is a music :)
    Part8
 end
