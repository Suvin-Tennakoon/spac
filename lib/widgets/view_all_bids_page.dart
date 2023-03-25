import 'package:flutter/material.dart';
import 'package:spac/screens/chandima/edit_bid_screen.dart';
import 'package:spac/widgets/remove_bid_dialog.dart';
import '../models/chandima/Bid.dart';
import '../services/bid_service.dart';

class ViewAllBidsPage extends StatefulWidget {
  @override
  _ViewAllBidsPageState createState() => _ViewAllBidsPageState();
}

class _ViewAllBidsPageState extends State<ViewAllBidsPage> {
  late Stream<List<Bid>> _bidsStream;

  @override
  void initState() {
    super.initState();
    _bidsStream = BidService.getBids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Bids'),
      ),
      body: StreamBuilder<List<Bid>>(
        stream: _bidsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final bids = snapshot.data!;

          return ListView.builder(
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return ListTile(
                title: Text(bid.itemDescription),
                subtitle: Text(
                    'Bidder: ${bid.bidderName} - Amount: ${bid.bidAmount}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedBid = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditBidScreen(bid: bid)),
                    );
                    if (updatedBid != null) {
                      setState(() {
                        // We don't need to call BidService.getBids() again
                        // since the StreamBuilder will automatically update
                        // when new data is available
                      });
                    }
                  },
                ),
                onLongPress: () async {
                  final removeBid = await showDialog(
                    context: context,
                    builder: (context) => RemoveBidDialog(bid: bid),
                  );
                  if (removeBid == true) {
                    setState(() {
                      // We don't need to call BidService.getBids() again
                      // since the StreamBuilder will automatically update
                      // when new data is available
                    });
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
