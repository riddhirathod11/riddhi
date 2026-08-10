bool isValidUsername(String username)
 {
   return username.length >= 6 && !username.contains(' ');
 }

 

void main()

{
  print(isValidUsername("riddhi"));
  print(isValidUsername("rushita"));
}
