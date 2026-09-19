import 'dart:async';

Future<String> fetchCricketScore() async {
  try {
    await Future.delayed(const Duration(milliseconds: 1500));

    // Simulate a successful API response
    return 'India 185/4 - 18.2 overs';
  } catch (e) {
    return 'Error fetching score: $e';
  }
}

void main() async {
  try {
    String score = await fetchCricketScore();

    print('Cricket Match Score: $score');
  } catch (e) {
    print('Failed to fetch score: $e');
  }
}