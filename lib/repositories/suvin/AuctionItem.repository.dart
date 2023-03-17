import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spac/models/suvin/AuctionItem.model.dart';

class AuctionItemRepository {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('auctionitems');

  Stream<List<AuctionItem>> auctionitems() {
    return _collectionReference.orderBy('subject').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AuctionItem.fromMap(doc)).toList());
  }

  Future<List<AuctionItem>> getAllAuctionItems() async {
    final snapshot = await _collectionReference.get();
    return snapshot.docs.map((doc) => AuctionItem.fromMap(doc)).toList();
  }

  Future<void> addAuctionItem(AuctionItem auctionItem) {
    return _collectionReference.add(auctionItem.toMap());
  }

  Future<void> updateAuctionItem(String adId, AuctionItem auctionItem) {
    return _collectionReference.doc(adId).update(auctionItem.toMap());
  }

  Future<void> deleteAuctionItem(String adId) {
    return _collectionReference.doc(adId).delete();
  }
}
