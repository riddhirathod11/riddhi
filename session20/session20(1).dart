import 'dart:async';

Future<String> fetchTrendingSongs() async {
  await Future.delayed(const Duration(seconds: 2));

  return 'Trending songs fetched successfully!';
}

void main() {
  fetchTrendingSongs().then((result) {
    print(result);
    print('Top songs loaded!');
  });
}