import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chandima/Bid.dart';

class BidService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _bidsCollection =
      _firestore.collection('bids');

  static Stream<List<Bid>> getBids() {
    return _bidsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Bid.fromJson(doc)).toList();
    });
  }

  static Future<void> placeBid(Bid bid) {
    return _bidsCollection.add(bid.toJson());
  }

  static Future<void> editBid(Bid bid, String bidId) {
    return _bidsCollection.doc(bidId).set(bid.toJson());
  }

  static Future<void> removeBid(String bidId) {
    return _bidsCollection.doc(bidId).delete();
  }
}
