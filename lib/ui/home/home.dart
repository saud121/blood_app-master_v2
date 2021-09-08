import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/chat/all_chat.dart';
import 'package:blood_app/ui/chat/all_chat_viewmodel.dart';
import 'package:blood_app/ui/chat/chat_viewmodel.dart';
import 'package:blood_app/ui/home/dashboard.dart';
import 'package:blood_app/ui/home/dashboard_viewmodel.dart';
import 'package:blood_app/ui/home/home_page.dart';
import 'package:blood_app/ui/home/home_viewmodel.dart';
import 'package:blood_app/ui/home/homepage_viewmodel.dart';
import 'package:blood_app/ui/home/notificationpage_viewmodel.dart';
import 'package:blood_app/ui/home/notifications_page.dart';
import 'package:blood_app/ui/home/profile_page.dart';
import 'package:blood_app/ui/home/profilepage_viewmodel.dart';
import 'package:blood_app/ui/home/response.dart';
import 'package:blood_app/ui/home/response_viewmodel.dart';
import 'package:blood_app/ui/login/login.dart';
import 'package:blood_app/ui/login/login_viewmodel.dart';
import 'package:blood_app/ui/registration/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {



  String pageTitle = "Home";
  int _selectedIndex = 0;
  HomeViewModel model;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );


  }



  @override
  Widget build(BuildContext context) {
    model = Provider.of<HomeViewModel>(context, listen: false);
    _selectedIndex = model.index;
    model.fetchUser();


    return Consumer<HomeViewModel>(
      builder: (_, model, child){
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(model.pageTitle),
            actions: [
              IconButton(
                onPressed: signOut,
                icon: Icon(Icons.airline_seat_flat, color: Colors.white,),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report),
                title: Text('Seekers'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit),
                title: Text('Donors'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                title: Text('Chat'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.accessible),
                title: Text('Profile'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.black26,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
          body: Container(
            child: model.user == null ? Container(child: Center(child: CircularProgressIndicator(),),) : setWidgetOnBottomSheet()
          ),
        );
      },
    );
  }


  setWidgetOnBottomSheet() {
    if (_selectedIndex == 0) {
      model.changePageTitle("Home");
       return ChangeNotifierProvider(
        create: (_) => new DashboardViewModel(model.user),
        lazy: false,
        child: Dashboard(),
      );
    } else if (_selectedIndex == 1) {
      model.changePageTitle("Requests");
      return ChangeNotifierProvider(
        create: (_) => new NotificationViewModel(model.user),
        lazy: false,
        child: NotificationsPage(),
      );
    } else if (_selectedIndex == 2) {
      model.changePageTitle("Response");
      return ChangeNotifierProvider(
        create: (_) => new ResponseViewModel(model.user),
        lazy: false,
        child: Response(),
      );
    }else if (_selectedIndex == 3) {
      model.changePageTitle("Chat");
      return ChangeNotifierProvider(
        create: (_) => new AllChatViewModel(model.user),
        lazy: false,
        child: AllChat(),
      );
    }else if (_selectedIndex == 4) {
      model.changePageTitle("Profile");
      return ChangeNotifierProvider(
        create: (_) => new ProfileViemodel(model.user),
        lazy: false,
        child: Profile(),
      );
    }
  }

  void _onItemTapped(int index) {
      _selectedIndex = index;
      if (index == 0) {
        model.changePageTitle("Home");
      }
      if (index == 1) {
        model.changePageTitle("Requests");
      }
      if (index == 2) {
        model.changePageTitle("Response");
      }
      if (index == 3) {
        model.changePageTitle("Chat");
      }
      if (index == 4) {
        model.changePageTitle("Profile");
      }
  }

  signOut () {
    FirebaseAuth.instance.signOut().then((value){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (context) => LoginViewModel(),
              lazy: false,
              child: SignInScreen(),
            ),
          ),
              (e) => false);
    });
  }




}
