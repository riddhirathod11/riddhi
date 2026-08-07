import 'dart:io';
void main()
{
  double baseprice =300.0;
  double gst= baseprice*0.12;
  double finalprice=baseprice+gst;

  print("original price=$baseprice");
  print("after 12% gst =$finalprice");
}