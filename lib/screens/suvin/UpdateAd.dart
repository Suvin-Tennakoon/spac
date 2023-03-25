import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:spac/models/suvin/AuctionItem.model.dart';
import 'package:spac/repositories/suvin/AuctionItem.repository.dart';
import 'package:spac/screens/suvin/ViewItems.dart';

//this is the base widget
//it applies the theme for the inner components
class UpdateItem extends StatelessWidget {
  final dynamic auctionitem;
  final String itemid;
  const UpdateItem(
      {super.key, required this.auctionitem, required this.itemid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      builder: (context, child) {
        return FormThemeProvider(
          theme: const FormTheme(
            checkboxTheme: CheckboxFieldTheme(
              canTapItemTile: true,
            ),
            radioTheme: RadioFieldTheme(
              canTapItemTile: true,
            ),
          ),
          child: child!,
        );
      },
      home: UpdateFieldsForm(itemid: itemid, auctionitem: auctionitem),
    );
  }
}

//added dependency:form_bloc class to handle user inputs
class AllFieldsFormBloc extends FormBloc<String, String> {
  //handling other input fields
  late final subject = TextFieldBloc(initialValue: auctionitem.subject);
  final tempitem = TextFieldBloc();
  late final description = TextFieldBloc(initialValue: auctionitem.description);
  late final startprice = TextFieldBloc(initialValue: auctionitem.startprice);
  late final buyoutprice = TextFieldBloc(initialValue: auctionitem.buyoutprice);
  late final contactno = TextFieldBloc(initialValue: auctionitem.contactno);

  late final multiSelect1 = MultiSelectFieldBloc<String, dynamic>(
    items: (auctionitem.items as List).map((e) => e as String).toList(),
  );
  late final dateAndTime1 = InputFieldBloc<DateTime?, Object>(
      initialValue: auctionitem.expdatetime.toDate());

  final dynamic auctionitem;
  AllFieldsFormBloc({required this.auctionitem}) : super(autoValidate: false) {
    addFieldBlocs(fieldBlocs: [
      subject,
      tempitem,
      description,
      startprice,
      buyoutprice,
      contactno,
      dateAndTime1,
      multiSelect1
    ]);
  }

  @override
  void onSubmitting() async {}
}

//main widget with form fields and image handling
class UpdateFieldsForm extends StatefulWidget {
  final dynamic auctionitem;
  final String itemid;

  const UpdateFieldsForm(
      {Key? key, required this.auctionitem, required this.itemid})
      : super(key: key);

  @override
  State<UpdateFieldsForm> createState() => _UpdateFieldsFormState();
}

class _UpdateFieldsFormState extends State<UpdateFieldsForm> {
  //start - states to handle images
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();

  String? _retrieveDataError;

  //image uploading function
  Future uploadImageToFirebase(
      BuildContext context, AllFieldsFormBloc formBloc) async {
    LoadingDialog.show(context);

    List<String> imageUrls =
        (widget.auctionitem.imageurls as List).map((e) => e as String).toList();

    if (_imageFileList != null) {
      await Future.wait(_imageFileList!.map((element) async {
        //take file name
        String fileName = basename(element.path);
        FirebaseStorage storage = FirebaseStorage.instance;

        //set file path to be uploaded
        Reference ref = storage.ref().child('uploads/$fileName');
        //get file path using 'path' dependency
        File file = File(element.path);

        //StorageReference class has been removed since firebase_storage 5.0.1
        //use UploadTask instead
        UploadTask uploadTask = ref.putFile(file);

        return await uploadTask.then((res) async {
          String downloadUrl = await res.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        });
      }));
    }

    // All uploads completed, send items to database with the image URLs
    AuctionItem auctionItem = AuctionItem(
        "",
        widget.auctionitem.sellermail,
        formBloc.subject.value,
        formBloc.multiSelect1.value,
        formBloc.description.value,
        formBloc.contactno.value,
        formBloc.startprice.value,
        formBloc.buyoutprice.value,
        formBloc.dateAndTime1.value,
        imageUrls,
        "",
        double.parse(formBloc.startprice.value));

    AuctionItemRepository repo = AuctionItemRepository();
    repo.updateAuctionItem(widget.itemid, auctionItem);

    LoadingDialog.hide(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewAuctionItems(userdata: widget.auctionitem.sellermail)));
  }

  //end

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllFieldsFormBloc(auctionitem: widget.auctionitem),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);

          return Scaffold(
            backgroundColor: const Color(0xffF7EBE1),
            appBar: AppBar(
                title: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                        )),

                    SizedBox(width: 80), // Add spacing between icon and text
                    Text('Update Auction'),
                  ],
                ),
                backgroundColor: Color(0xff132137)),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: formBloc.submit,
                    icon: const Icon(Icons.send),
                    label: const Text('SUBMIT'),
                  ),
                ],
              ),
            ),

            //submit button
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: FormBlocListener<AllFieldsFormBloc, String, String>(
              onSubmitting: (context, state) {
                if (formBloc.subject.value == "") {
                  formBloc.subject
                      .addFieldError("Must enter a subject to continue");
                } else if (formBloc.multiSelect1.value.isEmpty) {
                  formBloc.multiSelect1
                      .addFieldError("Enter atleast one item to continue");
                  formBloc.tempitem
                      .addFieldError("Enter atleast one item to continue");
                } else if (formBloc.description.value == "") {
                  formBloc.description.addFieldError("Enter a description");
                } else if (formBloc.startprice.value == "") {
                  formBloc.startprice.addFieldError("Enter a starting price");
                } else if (formBloc.buyoutprice.value == "") {
                  formBloc.buyoutprice.addFieldError("Enter a buyout price");
                } else if (formBloc.dateAndTime1.value == null) {
                  formBloc.dateAndTime1
                      .addFieldError("Enter auction closing date and time");
                } else if (formBloc.contactno.value == "") {
                  formBloc.contactno.addFieldError("Enter a contact number");
                } else if (formBloc.contactno.value.length < 10) {
                  formBloc.contactno
                      .addFieldError("Enter a valid contact number");
                } else {
                  uploadImageToFirebase(context, formBloc);
                }
              },
              child: ScrollableFormBlocManager(
                formBloc: formBloc,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(34.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Hello, ${widget.auctionitem.sellermail} !!",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //text input 1 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "This will be displayed as the topic for the advertisement.",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.subject,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          prefixIcon: Icon(Icons.abc),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 1 end

                      //text input 2 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Add all of the items you wish you auction.",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.tempitem,
                              decoration: const InputDecoration(
                                labelText: 'Auction Item/Items',
                                prefixIcon: Icon(Icons.sell),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                formBloc.multiSelect1
                                    .addItem(formBloc.tempitem.value);
                                formBloc.multiSelect1
                                    .select(formBloc.tempitem.value);
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "You can de-select items if you don't want it to be included.",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      FilterChipFieldBlocBuilder<String>(
                        multiSelectFieldBloc: formBloc.multiSelect1,
                        itemBuilder: (context, value) => ChipFieldItem(
                          label: Text(value),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 2 end

                      //text input 3 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Add a great description, Good description = Good offers",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.description,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 3 end

                      //text input 4.1 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Add a starting price and buyout price for auctioning items",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.startprice,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Starting Price',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          //text input 4.1 end

                          //text input 4.2 start
                          Expanded(
                            child: TextFieldBlocBuilder(
                              textFieldBloc: formBloc.buyoutprice,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Buyout Price',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 4.2 end

                      //text input 5 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Set date and time to auction termination.",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      DateTimeFieldBlocBuilder(
                        dateTimeFieldBloc: formBloc.dateAndTime1,
                        canSelectTime: true,
                        format: DateFormat('dd-MM-yyyy  hh:mm'),
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        decoration: const InputDecoration(
                          labelText: 'Exp. Date and Time',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 5 end

                      //text input 6 start
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Enter contact person's mobile number.",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFieldBlocBuilder(
                        textFieldBloc: formBloc.contactno,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          prefixIcon: Icon(Icons.add_call),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //text input 6 end

                      //text input 7 start
                      //this is the image part
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                            child: Text(
                              "Add one/more images of the auctioning item(s).",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _retrieveDataError != null
                                ? Colors.red
                                : Color.fromARGB(255, 114, 110, 110),
                            width: _retrieveDataError != null ? 2 : 0.7,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        //image upload buttons - 2 buttons for upload images from gallery and
                        // take a picture and upload it through camera
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton(
                                  tooltip: 'Pick Multiple Images from gallery',
                                  heroTag: 'image1',
                                  onPressed: () {
                                    _onImageButtonPressed(
                                      ImageSource.gallery,
                                      context: context,
                                      isMultiImage: true,
                                    );
                                  },
                                  child: const Icon(Icons.collections),
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    _onImageButtonPressed(ImageSource.camera,
                                        context: context);
                                  },
                                  tooltip: 'Take a Photo',
                                  heroTag: 'image2',
                                  child: const Icon(Icons.add_a_photo),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            //this widget will display the selected image(s) previews
                            //may not work in operating systems other than android.
                            Center(
                              child: !kIsWeb &&
                                      defaultTargetPlatform !=
                                          TargetPlatform.android
                                  ? FutureBuilder<void>(
                                      builder: (BuildContext context,
                                          AsyncSnapshot<void> snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return const Text(
                                              'You have not yet picked an image.',
                                              textAlign: TextAlign.center,
                                            );
                                          case ConnectionState.done:
                                            return _previewImages();
                                          case ConnectionState.active:
                                            if (snapshot.hasError) {
                                              return Text(
                                                'Pick image/video error: ${snapshot.error}}',
                                                textAlign: TextAlign.center,
                                              );
                                            } else {
                                              return const Text(
                                                'You have not yet picked an image.',
                                                textAlign: TextAlign.center,
                                              );
                                            }
                                        }
                                      },
                                    )
                                  : _previewImages(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

//invoked when image upload request initialized
  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      //executed if selected from gallery
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final List<XFile> pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      //executed if selected from camera
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          //width and height are set to low values,
          //otherwise the camera image size would be huge and
          //may take lot of resources.
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: 640,
            maxHeight: 480,
            imageQuality: quality,
          );
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

//preview image widget start
  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      print(_imageFileList![0].path);
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
//preview image widget end

//error handling in image uploading
  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

//displaypickimagedialog has been altered to simplify the application
  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final double? width = null;
          final double? height = null;
          final int? quality = null;
          onPick(width, height, quality);
          Navigator.of(context).pop();
          return Container();
        });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

@override
void initState() {
  initState();
}

@override
void dispose() {
  dispose();
}

@override
Widget build(BuildContext context) {
  return Container();
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 150,
            height: 130,
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Please Wait While We Update Your Auction...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
