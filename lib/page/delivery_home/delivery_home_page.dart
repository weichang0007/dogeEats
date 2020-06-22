import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dogeeats/bloc/login_bloc/login_bloc.dart';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryHomePage extends StatefulWidget {
  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

void _screenInit(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  if (mediaQuery.size.width > mediaQuery.size.height) {
    ScreenUtil.init(context,
        width: 1920, height: 1080, allowFontScaling: false);
  } else {
    ScreenUtil.init(context,
        width: 1080, height: 1920, allowFontScaling: false);
  }
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  static final api = "AIzaSyASwsEBkTlOMxlJPcIPiCKXPMvVtkEKeTI";
  double _originLatitude = 25.0431988, _originLongitude = 121.5313617;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = api;
  Location location;
  LocationData currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  bool _jobActive = false;
  bool _hasJob = false;
  bool _hasTaken = false;
  HttpService _http = HttpService.instance;
  String _url = HttpService.baseUrl;
  Timer _timer;
  String dstAddress = "";
  String srcAddress = "";
  LatLng srcLoc;
  LatLng dstLoc;
  LatLng dstPinLoc;

  @override
  void initState() {
    super.initState();
    _changeMode();
    location = Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      //updatePinOnMap();
    });
    Timer.periodic(Duration(seconds: 3), (Timer timer) => updatePinOnMap());
  }

  void updatePinOnMap() async {
    _markers.clear();
    CameraPosition cPosition = CameraPosition(
      zoom: 15,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(10)));
      polylineCoordinates.clear();
      _polylines.clear();
      if (_hasJob) {
        if (!_hasTaken) {
          dstPinLoc = srcLoc;
        } else {
          dstPinLoc = dstLoc;
        }
        _markers.removeWhere((m) => m.markerId.value == 'destPin');
        _markers.add(Marker(
            markerId: MarkerId('destPin'),
            position: dstPinLoc,
            icon: BitmapDescriptor.defaultMarkerWithHue(100)));
        setPolylines();
      }
    });
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      api,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(dstPinLoc.latitude, dstPinLoc.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = _buildJobInactiveFAB();
    if (_jobActive && !_hasJob)
      fab = _buildJobActiveFAB();
    else if (!_jobActive && !_hasJob)
      fab = _buildJobInactiveFAB();
    else if (_hasJob && !_hasTaken)
      fab = _buildTakenFAB();
    else if (_hasJob && _hasTaken) fab = _buildFinishedFAB();
    _screenInit(context);
    return SafeArea(
      child: Scaffold(
          appBar: _hasJob
              ? (!_hasTaken
                  ? AppBar(
                      title: Text("前往餐廳: $srcAddress",
                          overflow: TextOverflow.ellipsis),
                    )
                  : AppBar(
                      title: Text("送至: $dstAddress",
                          overflow: TextOverflow.ellipsis),
                    ))
              : null,
          floatingActionButton: fab,
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude), zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(_markers),
            polylines: Set<Polyline>.of(_polylines),
          )),
    );
  }

  Widget _buildJobActiveFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await _changeMode();
      },
      label: Shimmer.fromColors(
        baseColor: Colors.white70,
        highlightColor: Colors.white,
        child: Text('快速接單已啟用',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.sp,
            )),
      ),
      icon: Icon(Icons.navigation),
      backgroundColor: Colors.green,
    );
  }

  Widget _buildJobInactiveFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        await _changeMode();
      },
      label: Text(
        '快速接單已停用',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40.sp,
        ),
      ),
      icon: Icon(Icons.navigation),
      backgroundColor: Colors.red[800],
    );
  }

  Widget _buildTakenFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        try {
          Response response =
              await _http.postJson("$_url/transporter/order/getfood", "{}");
          Alert(
            context: context,
            type: AlertType.success,
            title: "已收到您的完成餐廳取餐訊息",
            desc: "",
            buttons: [
              DialogButton(
                child: Text(
                  "了解",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  updatePinOnMap();
                  setState(() {});
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ],
          ).show();
          _hasTaken = true;
        } catch (e) {}
      },
      label: Shimmer.fromColors(
        baseColor: Colors.white70,
        highlightColor: Colors.white,
        child: Text(
          '通知完成餐廳取餐',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.sp,
          ),
        ),
      ),
      icon: Icon(Icons.fastfood),
      backgroundColor: Colors.green[400],
    );
  }

  Widget _buildFinishedFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        try {
          Response response =
              await _http.postJson("$_url/transporter/order/sent", "{}");
          _hasJob = false;
          _hasTaken = false;
          _jobActive = false;
          Alert(
            context: context,
            type: AlertType.success,
            title: "已收到您的通知成功送達訊息",
            desc: "",
            buttons: [
              DialogButton(
                child: Text(
                  "了解",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  updatePinOnMap();
                  setState(() {});
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ],
          ).show();
        } catch (e) {}
      },
      label: Shimmer.fromColors(
        baseColor: Colors.white70,
        highlightColor: Colors.white,
        child: Text(
          '通知成功送達',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.sp,
          ),
        ),
      ),
      icon: Icon(Icons.fastfood),
      backgroundColor: Colors.green[400],
    );
  }

  Future _changeMode() async {
    try {
      Response response;
      if (_jobActive)
        response = await _http.postJson("$_url/transporter/active", "{}");
      else
        response = await _http.postJson("$_url/transporter/deactive", "{}");
      Map jsonData = json.decode(response.data);
      if (jsonData['message'] != "success") throw Exception(jsonData);
      _jobActive = !_jobActive;
      if (_jobActive == true) {
        if (_timer != null && _timer.isActive) _timer.cancel();
        _timer = Timer.periodic(Duration(seconds: 3), _timerCallback);
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
      Setting setting = await Setting.instance;
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonClickEvent(setting.email, setting.passwd),
      );
    }
  }

  void _timerCallback(Timer timer) async {
    if (_jobActive == false) {
      timer.cancel();
    }
    try {
      Response response = await _http.getJsonData("$_url/transporter/order");
      Map jsonData = response.data;
      if (!jsonData.containsKey("message")) {
        _timer.cancel();
        _hasJob = true;
        _hasTaken = false;
        dstAddress = jsonData["address_destination"];
        srcAddress = jsonData["address_source"];
        srcLoc = LatLng(
            double.parse(jsonData["position_source"].toString().split(",")[0]),
            double.parse(jsonData["position_source"].toString().split(",")[1]));
        dstLoc = LatLng(
            double.parse(
                jsonData["position_destination"].toString().split(",")[0]),
            double.parse(
                jsonData["position_destination"].toString().split(",")[1]));
        Alert(
          context: context,
          type: AlertType.info,
          title: "偵測到訂單",
          desc: "您已接了新訂單, 請盡快前往餐廳取餐!",
          buttons: [
            DialogButton(
              child: Text(
                "了解",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                updatePinOnMap();
                setState(() {});
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
      }
    } catch (e) {}
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }
}
