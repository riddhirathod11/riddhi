String getMovieTickets(int tickets) {
  if (tickets > 6) {
    throw Exception('Cannot book more than 6 tickets');
  }

  return 'Tickets Booked';
}

void main() {
  try {
    String result = getMovieTickets(8);

    print(result);
  } catch (e) {
    print('Error: $e');
  }
}