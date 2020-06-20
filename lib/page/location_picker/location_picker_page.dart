import 'package:dogeeats/model/models.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final apk = "AIzaSyASwsEBkTlOMxlJPcIPiCKXPMvVtkEKeTI";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: apk,
      onPlacePicked: (PickResult result) async {
        Setting setting = await Setting.instance;
        setting.hasSetLocation = true;
        setting.address = result.formattedAddress;
        setting.latitude = result.geometry.location.lat;
        setting.longitude = result.geometry.location.lng;
        await Setting.save();
        Navigator.of(context).pop();
      },
      useCurrentLocation: false,
      initialPosition: LatLng(25.0424162, 121.5355554),
      autocompleteLanguage: "zh-TW",
      searchForInitialValue: true,
      region: "TW",
      searchingText: "正在搜尋...",
    );
  }
}
