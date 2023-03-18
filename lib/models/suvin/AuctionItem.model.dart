import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionItem {
  String id;
  String sellermail;
  String subject;
  List<dynamic> items;
  String description;
  String contactno;
  String startprice;
  String buyoutprice;
  dynamic expdatetime;
  List<dynamic> imageurls;
  String biddermail;
  double currentbid;

  AuctionItem(
      this.id,
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
        data.id,
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
