import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionItem {
  String sellermail;
  String subject;
  List<String> items;
  String description;
  String contactno;
  double startprice;
  double buyoutprice;
  DateTime expdatetime;
  List<String> imageurls;
  String biddermail;
  double currentbid;

  AuctionItem(
      this.sellermail,
      this.subject,
      this.items,
      this.description,
      this.contactno,
      this.startprice,
      this.buyoutprice,
      this.expdatetime,
      this.imageurls,
      this.biddermail,
      this.currentbid);

  Map<String, dynamic> toMap() {
    return {
      'sellermail': sellermail,
      'subject': subject,
      'items': items,
      'description': description,
      'contactno': contactno,
      'startprice': startprice,
      'buyoutprice': buyoutprice,
      'expdatetime': expdatetime,
      'imageurls': imageurls,
      'biddermail': biddermail,
      'currentbid': currentbid
    };
  }

  factory AuctionItem.fromMap(DocumentSnapshot data) {
    return AuctionItem(
        data['sellermail'],
        data['subject'],
        data['items'],
        data['description'],
        data['contactno'],
        data['startprice'],
        data['buyoutprice'],
        data['expdatetime'],
        data['imageurls'],
        data['biddermail'],
        data['currentbid']);
  }
}
