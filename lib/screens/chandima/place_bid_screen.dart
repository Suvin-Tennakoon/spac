import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spac/widgets/view_all_bids_page.dart';
import '../../models/chandima/Bid.dart';
import '../../services/bid_service.dart';

class PlaceBidScreen extends StatefulWidget {
  const PlaceBidScreen({Key? key}) : super(key: key);

  @override
  _PlaceBidScreenState createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bidderNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _bidAmountController = TextEditingController();

  @override
  void dispose() {
    _bidderNameController.dispose();
    _itemDescriptionController.dispose();
    _bidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place a Bid'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _bidderNameController,
                decoration: InputDecoration(labelText: 'Bidder Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a bidder name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an item description.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bidAmountController,
                decoration: InputDecoration(labelText: 'Bid Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a bid amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Place Bid'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final bid = Bid(
                      id: "",
                      bidderName: _bidderNameController.text,
                      itemDescription: _itemDescriptionController.text,
                      bidAmount: double.parse(_bidAmountController.text),
                      createdAt: DateTime.now(),
                    );
                    await BidService.placeBid(bid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAllBidsPage()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
