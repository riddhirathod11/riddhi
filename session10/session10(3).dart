import 'dart:io';
void main()
{
  var p1=200;
  var p2=300;
  var p3=400;
  var total=p1+p2+p3;
  var final_amount=total;
 if(total>1000)

 {
   final_amount=total-(total*10);
   print("10% discount apply");
 }
 else
   {
     print("not apply discount");

   }
print("final amount pay:$final_amount");
 }
