import 'package:blood_app/ui/maps/maps_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  MapViewModel model;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double width;
  double height;



  @override
  Widget build(BuildContext context) {
    model = Provider.of<MapViewModel>(context, listen: false);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return Scaffold(

    );
  }
}
