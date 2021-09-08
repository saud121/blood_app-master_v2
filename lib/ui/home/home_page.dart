import 'package:blood_app/base_main.dart';
import 'package:blood_app/ui/home/homepage_viewmodel.dart';
import 'package:blood_app/ui/profile_detail/profile_detail.dart';
import 'package:blood_app/ui/profile_detail/profiledetail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'maps_view.dart';

class HomePage extends Base {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  HomePageViewModel model;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> districts = ["Quetta", "Bostan", "Mastung", "Pishin"];

  @override
  Widget build(BuildContext context) {
    model = Provider.of<HomePageViewModel>(context, listen: false);
    // model.usersList();

    var _usersListWidget = Consumer<HomePageViewModel>(
      builder: (_, model, child){
      return  Expanded(
          child: model.isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : ListView.builder(
              itemCount: model.users.length, itemBuilder: (_, i) {
            return Column(
              children: [
                ListTile(
                  onTap: (){
                    Navigator.of(context).push( MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider(
                        create: (context) => ProfileDetailViewModel(model.users[i], model.userCurrent),
                        lazy: false,
                        child: ProfileDetail(),
                      ),
                    ));
                  },
                  title: Text(
                      // model.users[i].firstName gets username from firebase
                    "Avalible Donor"
                  ),
                  subtitle: Text(
                      // model.users[i].email gets user email from firebase
                  "Click to Request"
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 30.0,
                      child: ClipOval(
                        child: Text(model.users[i].bloodGroup, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      )),
                  trailing: Icon(Icons.arrow_forward_ios, size: 15,),
                ),
                Divider(
                  height: 0.2,
                )
              ],
            );
          }));
      },
    );

    var _searchWidget  = Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
      height: 50,
      child: TextFormField(
        controller: searchController,
        onChanged: (_) {
          model.filterTheList(_);
        },
        onTap: (){
          showDistrictsDialogue();
        },
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.search,
              color: Colors.pink,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Search by districts ...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
    return DefaultTabController(

      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("${model.bloodGroup} Donors"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.supervised_user_circle_sharp)),
              Tab(icon: Icon(Icons.map)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            widget.showProgressDialogue(context, "Sending notifications ...").then((value){
              model.sendBroadcast(widget, context);
            });
            },
          label: Text('Send notification to all'),
          icon: Icon(Icons.directions_boat),
        ),
        body:  TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: Column(
                children: [
                  // _searchWidget,
                  _usersListWidget,
                ],
              ),
            ),
            MapsView(model.users, model.userCurrent)
          ],
        ),
      ),
    );
    // return Scaffold(
    //   key: _scaffoldKey,
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.notifications),
    //     onPressed: (){
    //       model.sendBroadcast(widget, context);
    //     },
    //   ),
    //   appBar: AppBar(
    //     title: Text("${model.bloodGroup} Users"),
    //     // bottom: ,
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: [
    //         // _searchWidget,
    //         _usersListWidget,
    //         MapsView(model.users, model.userCurrent)
    //       ],
    //     ),
    //   ),
    // );
  }


  showDistrictsDialogue () {
    showMaterialDialog<String>(
      context: context,
      child: SimpleDialog(
        title: const Text('Select your district'),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width *.80,
            child: ListView.builder(
                itemCount: districts.length,
                shrinkWrap: true,
                itemBuilder: (_, i){
                  return ListTile(
                    title:  Text(districts[i]),
                    leading: CircleAvatar(child: Text(districts[i][0])),
                    onTap: () {
                      Navigator.pop(context, 'Y');
                      searchController.text = districts[i];
                      model.fetchUser(districts[i]);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }



  void showMaterialDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    )
        .then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
//        _scafoldKey.currentState.showSnackBar(SnackBar(
//          content: Text('You selected: $value'),
//        ));
      }
    });
  }






}
