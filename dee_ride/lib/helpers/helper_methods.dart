import 'package:dee_ride/data_handler/address.dart';
import 'package:dee_ride/data_handler/directionDetails.dart';
import 'package:dee_ride/helpers/request_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dee_ride/config_maps.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:dee_ride/data_handler/app_data.dart';

class HelperMethods{
  static Future<String> searchCoordinateAddress(Position position, context)async{
    String st1, st2, st3, st4;

    String placeAddress = '';
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if(response!= 'failed'){
      // placeAddress = response['results'][0]['formatted_address'];
      st1 = response["results"][0]["address_components"][3]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      st3 = response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][0]["long_name"];

      placeAddress = '$st1, $st2, $st3, $st4';

      Address userPickUpAddress = new Address();

      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition)async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    
    var res = await RequestHelper.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["distance"]["value"];
    return directionDetails;
  }
}