import 'dart:math';

// Generate a random integer between 0 and a large number (e.g., 1 billion)
int generateRandomId() {
  Random random = Random();
  return random.nextInt(1000000000); // Up to 1 billion
}
