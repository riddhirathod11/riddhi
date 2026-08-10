import 'dart:io';

String formatFollowers(int followers) {
  if (followers >= 1000000) {
    return "${(followers / 1000000).toStringAsFixed(1)}M";
  } else if (followers >= 1000) {
    return "${(followers / 1000).toStringAsFixed(1)}K";
  } else {
    return followers.toString();
  }
}

void main() {
  print("Enter followers:");
  int followers = int.parse(stdin.readLineSync()!);

  print("Formatted followers: ${formatFollowers(followers)}");
}