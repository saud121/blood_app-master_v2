import 'dart:async';

import 'package:blood_app/models/user.dart';
import 'package:blood_app/ui/profile_detail/profile_detail.dart';
import 'package:blood_app/ui/profile_detail/profiledetail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsView extends StatefulWidget {
  List<User> users;
  User currentUser;
  MapsView(this.users, this.currentUser);


  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {

  Completer<GoogleMapController> _controller = Completer();

   CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.1798, 66.9750),
    zoom: 14.4746,
  );




  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  final Set<Marker> _markers = {};
  Set<Circle> _circles = {};




  @override
  void initState() {
    // TODO: implement initState

    _circles = Set.from([
      Circle(
          circleId: CircleId("15_KM_circle"),
          radius: 15000,
          center: _createCenter(),
          fillColor: Color.fromRGBO(171, 39, 133, 0.1),
          strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
          onTap: () {
            print('circle pressed');
          })
    ]);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    setLocation();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.currentUser.point.latitude, widget.currentUser.point.longitude),
      zoom: 12,
    );
    return Scaffold(
      body:  GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        circles: _circles,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
    );
  }
  Future<void> _goToTheLake(User user) async {
    final GoogleMapController controller = await _controller.future;
    var userpoints = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(user.point.latitude, user.point.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(userpoints));
  }

  void setLocation  () {
    for(int i=0; i < widget.users.length; i++){
      LatLng latLng = LatLng(widget.users[i].point.latitude, widget.users[i].point.longitude);
      var marker = Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.users[i].firstName),
        position: latLng,
        infoWindow: InfoWindow(
          title: widget.users[i].firstName,
          snippet: widget.users[i].bloodGroup,
          onTap: (){
            Navigator.of(context).push( MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (context) => ProfileDetailViewModel(widget.users[i], widget.currentUser),
                lazy: false,
                child: ProfileDetail(),
              ),
            ));
          }
        ),
        onTap: (){
         _goToTheLake(widget.users[i]);
        },
        icon: BitmapDescriptor.defaultMarker,
      );
      _markers.add(marker);
    }
  }
  LatLng _createCenter() {
    return _createLatLng(widget.currentUser.point.latitude, widget.currentUser.point.longitude);
  }
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

}
