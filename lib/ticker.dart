class Ticker {
  const Ticker();

  Stream<int> ticker({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
