import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/components.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

class PostScreen extends StatefulWidget {
  static String id = 'post_screen'; //to build the route
  final FirebaseStorage storage;
  PostScreen({Key key, this.storage}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState(storage: storage);
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseStorage storage;
  _PostScreenState({Key key, this.storage});
  var _titleController = new TextEditingController();
  var _priceController = new TextEditingController();
  var _descriptionController = new TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> photoList = new List();
  List<String> firePathList = new List();

  bool ifPhoto = false;

//function declare******************************************

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _inputPhoto(String path) {
    if (path != null) {
      photoList.add(path);
      ifPhoto = true;
      print("rebuild path:  ${path}");
    }
  }

  Future<String> _uploadFile(String path) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child("data/${basename(path)}");
    StorageUploadTask uploadTask = ref.putFile(File(path));

    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    firePathList.add(url);

    print("download url: ${url}");
    return url;
  }

  _updatePath(String title, String price, String description) async {
    for (String path in photoList) {
      await _uploadFile(path);
    }
    PostDetail item = new PostDetail(title, price, description, firePathList);
    await Firestore.instance
        .collection('salelist')
        .document()
        .setData(item.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final PostDetail args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, right: 15),
            child: GestureDetector(
              child: Text(
                "Post!",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Pacifico',
                ),
              ),
              onTap: () {
                String title = _titleController.text;
                String price = _priceController.text;
                String description = _descriptionController.text;

                if (title == "" || price == "" || description == "") {
                  final snackBar = SnackBar(
                    content: Text("Please Complete all information!"),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                } else {
                  _updatePath(title, price, description);


                  final snackBar = SnackBar(
                    content: Text("You post successfully!"),

                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);

                  new Future.delayed(const Duration(seconds: 1),
                      () => Navigator.of(context).pop());
                }
              },
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '💰Garage💰',
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _titleController,
              maxLength: 50,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: 'Enter title of the item.',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              maxLength: 20,
              textAlign: TextAlign.start,
              controller: _priceController,

              decoration: InputDecoration(
                hintText: 'Enter the price /\$.',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              maxLines: 7,
              maxLength: 200,
              textAlign: TextAlign.start,
              controller: _descriptionController,

              decoration: InputDecoration(
                hintText: 'Enter the description.',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
          Text(
           "Pictures of the items:"
          ),
            SizedBox(
            height: 15,
            ),

            photoSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_enhance),
          onPressed: () {
            if (photoList.length < 4) {
              Navigator.pushNamed(context, TakePictureScreen.routeName).then((value) {
                _inputPhoto(value);
              });
            } else {
              showDialog(
                context: context,
                child: new SimpleDialog(
                  contentPadding: const EdgeInsets.all(10.0),
                  title: new Center(
                    child: Text("You can\'t add more photos"),
                  ),
                  children: <Widget>[
                    new Center(
                      child: Text("the max photo you can attach is 4"),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              );
            }
          }
      ),
    );
  }

  Widget photoSection() {
    if (ifPhoto) {
      print("photo count: ${photoList.length}");
      return  GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
        primary: false,
        children: _getGrid(),
        shrinkWrap: true,
      );
    }
    return Text('No photo attached');
  }


  List<Widget> _getGrid() {
    List<Widget> gridList = new List();
    for (int i = 0; i < photoList.length; i++) {
      gridList.add(photoGridItem(photoList[i]));
    }
    return gridList;
  }

  Widget photoGridItem(String path) {
    return Container(
      child: Image.file(
        File(path),
        fit: BoxFit.contain,
        width: 20,
        height: 20,
      ),
    );
    //return Text("test");
  }


}


class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  static String routeName ="/cameraPage";
  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key : key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),

      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),

        // press take photos button
        onPressed: () async {
          // pass the photo to the cloud and display it on screen
          try {
            await _initializeControllerFuture;

            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            Navigator.of(context).pop(path);

          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

