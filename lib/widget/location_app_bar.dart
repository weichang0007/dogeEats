import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/page/location_picker/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationAppBar extends StatefulWidget implements PreferredSizeWidget {
  LocationAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  State<StatefulWidget> createState() => _LocationAppBarState();
}

class _LocationAppBarState extends State<LocationAppBar> {
  String address = "";

  @override
  void didChangeDependencies() {
    _loadSetting();
    super.didChangeDependencies();
  }

  void _loadSetting() async {
    Setting setting = await Setting.instance;
    address = setting.address;
    if (address.isEmpty ||
        setting.hasSetLocation == null ||
        !setting.hasSetLocation) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LocationPickerPage()),
      );
      _loadSetting();
      return;
    }
    address = setting.address;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("送往: $address", overflow: TextOverflow.ellipsis),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LocationPickerPage()),
            );
            _loadSetting();
          },
          child: Text("變更", style: TextStyle(color: Colors.blue)),
        )
      ],
    );
  }
}
