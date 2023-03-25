import 'package:flutter/material.dart';
import '../../models/chandima/Bid.dart';
import '../../services/bid_service.dart';

class EditBidScreen extends StatefulWidget {
  final Bid bid;

  const EditBidScreen({Key? key, required this.bid}) : super(key: key);

  @override
  _EditBidScreenState createState() => _EditBidScreenState();
}

class _EditBidScreenState extends State<EditBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bidderNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _bidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bidderNameController.text = widget.bid.bidderName;
    _itemDescriptionController.text = widget.bid.itemDescription;
    _bidAmountController.text = widget.bid.bidAmount.toString();
  }

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
        title: Text('Edit Bid'),
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
                child: Text('Save Bid'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedBid = Bid(
                      id: "",
                      bidderName: _bidderNameController.text,
                      itemDescription: _itemDescriptionController.text,
                      bidAmount: double.parse(_bidAmountController.text),
                      createdAt: widget.bid.createdAt,
                    );
                    await BidService.editBid(updatedBid, widget.bid.id);
                    Navigator.of(context).pop();
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
