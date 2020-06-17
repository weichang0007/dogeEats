import 'dart:io';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String _version = "v1.0.0";
  Setting _setting;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loading = true;
    _loadSetting();
  }

  void _loadSetting() async {
    while (!await Permission.storage.request().isGranted) {}
    _setting = await Setting.instance;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LinearProgressIndicator();
    } else {
      return ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [_buildAvatar(context), _buildMenu(context)],
      );
    }
  }

  Widget _buildAvatar(BuildContext context) {
    final nameStyle = TextStyle(
      fontSize: 56.sp,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
    );
    final infoStyle = TextStyle(
      fontSize: 38.sp,
      color: Colors.grey[700],
    );
    final infoWidget = [
      Padding(padding: EdgeInsets.only(top: 30.sp)),
      Text(_setting.name, style: nameStyle),
      Padding(padding: EdgeInsets.only(top: 5.sp)),
      Text(_setting.email, style: infoStyle),
    ];

    return Card(
      child: Container(
        height: 620.h,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                  CircleAvatar(
                    radius: 130.sp,
                    backgroundColor: Colors.blue,
                    child:
                        Icon(Icons.person, size: 140.sp, color: Colors.white),
                  ),
                ] +
                infoWidget),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Card(
      child: Container(
        height: 800.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(40.w, 20.h, 40.w, 20.h),
                title: Text("登出作業", style: TextStyle(fontSize: 40.sp)),
                leading:
                    _buildOptionIcon(Icons.delete_forever, Colors.green[300]),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _showClearSettingDialog(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(40.w, 20.h, 40.w, 20.h),
                title: Text("意見與問題回報", style: TextStyle(fontSize: 40.sp)),
                leading: _buildOptionIcon(Icons.forum, Colors.yellow[800]),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _launchFormURL(),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(40.w, 20.h, 40.w, 20.h),
                title: Text("版本資訊", style: TextStyle(fontSize: 40.sp)),
                leading: _buildOptionIcon(Icons.dns, Colors.red[400]),
                subtitle: Text(_version),
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildOptionIcon(IconData iconData, Color color) {
    return Container(
      padding: EdgeInsets.all(6.sp),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Icon(iconData, color: Colors.white),
    );
  }

  void _showClearSettingDialog(BuildContext context) {
    final titleStyle = TextStyle(
      letterSpacing: 1,
      color: Colors.red[900],
    );
    final AlertDialog alert = AlertDialog(
      title: Text("登出作業", style: titleStyle),
      content: Text("您確定要清除登入設定嗎 ?"),
      actions: [
        FlatButton(child: Text("取消"), onPressed: () => Navigator.pop(context)),
        FlatButton(
          child: Text("確定"),
          onPressed: () async {
            await Setting.claen();
            _setting = null;
            await (HttpService.instance).clearCookie();
            Phoenix.rebirth(context); // restart
          },
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _launchFormURL() async {
    bool isAndroid = Platform.isAndroid;
    final String versionString = _version + (isAndroid ? " Android" : " iOS");
    final url =
        'https://docs.google.com/forms/d/e/1FAIpQLSdmXEtspnpCKqZSyADhe7lU78qaSaoEWrqsR32A_ligOLeWRA/viewform?usp=pp_url&entry.522788031=' +
            Uri.encodeComponent(versionString);
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
