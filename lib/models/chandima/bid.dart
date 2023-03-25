class Bid {
  final String id;
  final String bidderName;
  final String itemDescription;
  final double bidAmount;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.bidderName,
    required this.itemDescription,
    required this.bidAmount,
    required this.createdAt,
  });

  factory Bid.fromJson(dynamic json) {
    dynamic temp = json.data();
    return Bid(
      id: json.id,
      bidderName: temp['bidderName'],
      itemDescription: temp['itemDescription'],
      bidAmount: temp['bidAmount'],
      createdAt: DateTime.parse(temp['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bidderName': bidderName,
      'itemDescription': itemDescription,
      'bidAmount': bidAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
