import 'dart:async';

import 'package:dee_ride/all_screens/search_screen.dart';
import 'package:dee_ride/all_widgets/divider.dart';
import 'package:dee_ride/all_widgets/progress_dialog.dart';
import 'package:dee_ride/data_handler/app_data.dart';
import 'package:dee_ride/helpers/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
class MainScreen extends StatefulWidget {
  static const String idScreen = 'mainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<LatLng> polyLineCordinate = [];
  Set <Polyline> polyLineSet = {};

  Position currentPosition;
  double bottomPaddingOfMap = 0.0;

  var geoLocator = Geolocator();

  Set<Marker> markersSet = {};
  Set <Circle> circlesSet= {};

  void locatePosition()async{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude,position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await HelperMethods.searchCoordinateAddress(position, context);
    print('this is your address: $address');
  }



  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text('Main Screen'),
      ),
      drawer: Container(
        color: Colors.white,
        width:255.0,
        child: Drawer(

          // Drawer Header
          child: ListView(
            children:<Widget> [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color:Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset("images/user_icon.png",height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Arthur',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily:'Brand-Bold'
                            ),
                          ),
                          SizedBox(height:6.0),
                          Text('Visit Profile'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(height: 12.0,),
              //Drawer body controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'History',
                  style:TextStyle(
                    fontSize:15.0,
                    fontFamily: 'Brand-Bold'
                  )
                )
              ),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                      'Profile',
                      style:TextStyle(
                          fontSize:15.0,
                          fontFamily: 'Brand-Bold'
                      )
                  )
              ),
              ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                      'About',
                      style:TextStyle(
                          fontSize:15.0,
                          fontFamily: 'Brand-Bold'
                      )
                  )
              ),
            ],
          )
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: markersSet,
            circles: circlesSet,
            polylines: polyLineSet,
            onMapCreated:(GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState((){
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            }

          ),
          //Hamburger button for Drawer
          Positioned(
            top:45.0,
            left:22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu,
                    color: Colors.black,

                  ),
                  radius: 20.0
                )
              ),
            ),
          ),

          Positioned(
            left:0.0,
            right:0.0,
            bottom:0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(15.0)
                ),
                boxShadow:[
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical:18.0)
                ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0,),
                    Text(
                      'Hey there!',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Brand-Bold',
                      ),
                    ),
                    Text(
                      'Where would you like to go?',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 20.0,),

                    GestureDetector(
                      onTap: ()async{

                        var res = await Navigator.of(context).push(MaterialPageRoute(builder:(context)=>SearchScreen()));

                        if(res == "obtainDirection"){
                          await getPlaceDirection();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow:[
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 16.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7,0.7),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search,
                              color: Colors.blueAccent
                              ),
                              SizedBox(width: 10.0,),
                              Text('Search Drop off location')
                            ],
                          ),
                        )
                      ),
                    ),
                    SizedBox(height:24.0),
                    Row(
                      children: [
                        Icon(Icons.home,
                            color:Colors.grey,
                        ),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Provider.of<AppData>(context).pickUpLocation !=null
                                  ? Provider.of<AppData>(context).pickUpLocation.placeName
                                  : "Add Home",
                            ),
                            SizedBox(height: 4.0,),
                            Text('Residential Address',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize:12.0,
                              )
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height:10.0),
                    DividerWidget(),
                    SizedBox(height:16.0),
                    Row(
                      children: [
                        Icon(Icons.work,
                          color:Colors.grey,
                        ),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Work'),
                            SizedBox(height: 4.0,),
                            Text('Work Address',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize:12.0,
                                )
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
          ),
        ],
      )
    );
  }

  Future<void>getPlaceDirection()async{
    var initialPosition = Provider.of<AppData>(context,listen: false).pickUpLocation;
    var finalPosition = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPosition.latitude, initialPosition.longitude);
    var dropOffLatLng = LatLng(finalPosition.latitude, finalPosition.longitude);
    
    
    showDialog(
        context: context,
        builder: (BuildContext context)=>ProgressDialog(message: "Please wait...",));

    var details = await HelperMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("this are encoded points");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResults = polylinePoints.decodePolyline(details.encodedPoints);

    polyLineCordinate.clear();
    if(decodedPolylinePointsResults.isNotEmpty){
      decodedPolylinePointsResults.forEach((PointLatLng pointLatLng) {

        polyLineCordinate.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: PolylineId('PolylineID'),
        jointType: JointType.round,
        points: polyLineCordinate,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,

      );
      polyLineSet.add(polyline);
    });

    LatLngBounds latlngBounds;

    if(pickUpLatLng.latitude>dropOffLatLng.latitude && pickUpLatLng.longitude>dropOffLatLng.longitude){
      latlngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else  if(pickUpLatLng.longitude>dropOffLatLng.longitude){
      latlngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude)
      );
    }

    else  if(pickUpLatLng.latitude>dropOffLatLng.latitude){
      latlngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude)
      );
    }

    else{
      latlngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latlngBounds, 70));

    Marker pickUpLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: initialPosition.placeName,
        snippet: "My position"
      ),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: initialPosition.placeName,
            snippet: "Drop off location"
        ),
        position: dropOffLatLng,
        markerId: MarkerId("dropOffId")
    );

    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });

    Circle pickUpLocationCircle = Circle(
      fillColor: Colors.yellow,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: CircleId ("pickUpId"),

    );
    Circle dropOffLocationCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.red,
      circleId: CircleId ("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocationCircle);
      circlesSet.add(dropOffLocationCircle);
    });

  }

}
