import 'package:flutter/material.dart';
import '../models/chandima/Bid.dart';
import '../services/bid_service.dart';

class RemoveBidDialog extends StatelessWidget {
  final Bid bid;

  const RemoveBidDialog({Key? key, required this.bid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Bid'),
      content: Text('Are you sure you want to remove this bid?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text('Remove'),
          onPressed: () async {
            print(bid.id);
            await BidService.removeBid(bid.id);
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
