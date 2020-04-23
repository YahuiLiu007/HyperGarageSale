import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/screens/account_screen.dart';
import 'package:hyper_garage_sale/screens/post_screen.dart';
import 'package:hyper_garage_sale/components.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyper_garage_sale/style.dart';

class GarageScreen extends StatefulWidget {
  static String id = 'garage_screen';
  @override
  _GarageScreenState createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  var _browseScaffoldKey = GlobalKey<ScaffoldState>();

  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '💰Garage💰',
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PostScreen.id);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.account_circle),
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountScreen(loggedInUser: loggedInUser),
                    ));
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.grey,
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
      body: ShowPosts(),
      backgroundColor: Colors.white,
    );
  }
}

class ShowPosts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ShowPostsState();
  }
}

class _ShowPostsState extends State<ShowPosts> {
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('salelist').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return new ListView(
      padding: const EdgeInsets.all(16.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    PostDetail postItem = new PostDetail(
        record.title, record.price, record.description, record.photos);
    MyTextStyle textStyle = new MyTextStyle();

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                leading:
                Image.network(record.photos[0]),
                /*Text(
                  '\$${record.price}',
                  style: textStyle.get('price'),
                ),*/

                title: Row(
                  children: <Widget>[
                    Text(
                      '${record.title}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '💰\$${record.price}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  '${record.description}',
                  maxLines: 3,
                  style: textStyle.get('description'),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return DetailPage(
                    postDetail: postItem,
                  );
                }));
              },
            ),

//            ButtonBarTheme(
//              data: ButtonBarThemeData(),
//              child: ButtonBar(
//                children: <Widget>[
//                  FlatButton(
//                    child: const Text('View Detial'),
//                    onPressed: (){
//                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
//                        return DetailPage(postDetail: postItem,);
//                      }));
//
//                    },
//                  ),
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final PostDetail postDetail;
  static String routeName = "/detialPage";

  const DetailPage({
    Key key,
    @required this.postDetail,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _detailPageState(postDetail);
  }
}

class _detailPageState extends State<DetailPage> {
  PostDetail postDetail;
  MyTextStyle textStyle = new MyTextStyle();

  _detailPageState(PostDetail postDetail) {
    this.postDetail = postDetail;
  }

  Widget titleSection() {
    return new Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*1*/
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${postDetail.title}',
                  style: textStyle.get('price'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '\$${postDetail.price}',
                  style: textStyle.get('price'),
                ),
              ),
            ],
          ),
          /*3*/

          new Text(
            '${postDetail.description}',
            style: textStyle.get('description'),
          ),
//          new Container(
//            height: 100,
//            child: new ListView(
//              children: <Widget>[
//                new Text(
//                  '${postDetial.description}',
//                  style: textStyle.get('description'),
//                ),
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title:
            new Text("PostDetial", style: new TextStyle(color: Colors.white)),
      ),
      body: new Column(
        children: <Widget>[
          titleSection(),
          Expanded(
            child: new Container(
              margin: new EdgeInsets.symmetric(vertical: 10),
              height: 500,
              child: photoSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoSection() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      primary: false,
      children: _getGrid(),
      shrinkWrap: true,

    );
  }

  List<Widget> _getGrid() {
    List<Widget> gridList = new List();
    List<String> photoList = postDetail.pathList;
    for (int i = 0; i < photoList.length; i++) {
      gridList.add(photoGridItem(photoList[i]));
    }
    return gridList;
  }

  Widget photoGridItem(String path) {
    return Container(
      child: PhotoHero(
        photo: path,
        //width: 100.0,
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Photo'),
              ),
              body: Container(
                // Set background to blue to emphasize that it's a new route.
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: PhotoHero(
                  photo: path,
                  //width: 300.0,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          }));
        },
      ),
    );
    //return Text("test");
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

//
//  Widget _buildGarages() {
//    return ListView.builder(
//        itemBuilder: (BuildContext _context, int i) {
//          // Add a one-pixel-high divider widget before each row
//          // in the ListView.
//          if (i.isOdd) {
//            return Divider();
//          }
//
//          // The syntax "i ~/ 2" divides i by 2 and returns an
//          // integer result.
//          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
//          // This calculates the actual number of word pairings
//          // in the ListView,minus the divider widgets.
//          final int index = i ~/ 2;
//          // If you've reached the end of the available word
//          // pairings...
//
//          return _buildRow();
//        }
//    );
//  }
