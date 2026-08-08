import 'dart:io';
void main()
{
  List<int> scores=[45,78,100,23,56];

  int halfCenturies = 0;
for(int score in scores){
  if(score>50){
    halfCenturies++;
  }
}
print("halfCenturies is $halfCenturies");
}