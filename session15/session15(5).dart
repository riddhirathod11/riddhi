Set<String> filterUniqueCuisines(List<String> cuisines) {
  return cuisines.toSet();
}

void main() {
  var sampleCuisines = [
    'Italian',
    'Chinese',
    'Italian',
    'Mexican',
    'Chinese'
  ];

  var uniqueCuisines = filterUniqueCuisines(sampleCuisines);

  print(uniqueCuisines);
}