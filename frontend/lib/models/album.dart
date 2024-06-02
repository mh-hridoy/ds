class Album {
  final int id;
  final String artist;
  final String title;
  final double price;

  const Album(
      {required this.id,
      required this.artist,
      required this.title,
      required this.price});

  factory Album.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("id") &&
        json.containsKey("artist") &&
        json.containsKey("title") &&
        json.containsKey("price")) {
      final price = (json["price"]).toDouble();

      return Album(
          id: json["id"],
          title: json["title"],
          artist: json["artist"],
          price: price);
    } else {
      throw const FormatException("Could not parse json");
    }
  }
}
