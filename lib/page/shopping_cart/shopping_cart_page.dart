import 'package:dogeeats/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  bool _switchState = false;

  void _modifyAppbar(BuildContext context) {
    BlocProvider.of<AppbarBloc>(context).add(ModifyAppbarEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("您的購物車"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: 1800.h,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      _buildAddressInfo(context),
                      Divider(),
                      _buildStoreInfo(context),
                      Divider(),
                      _buildTablewareInfo(context),
                      Divider(),
                      _buildOrderDetail(context),
                      _buildOrderTotal(context),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120.h,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text('一鍵下單', style: TextStyle(fontSize: 40.sp)),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreInfo(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    return ListTile(
      title: Text("漢堡王 - 美食外送服務", style: titleStyle),
      trailing: Text("30 TWD", style: titleStyle.copyWith(fontSize: 38.sp)),
      leading: Icon(Icons.local_shipping, color: Colors.grey[400], size: 66.sp),
    );
  }

  Widget _buildAddressInfo(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.grey[700], fontSize: 36.sp);
    final addressStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(30.w, 15.h, 0.w, 15.h),
              alignment: Alignment.centerLeft,
              child: Text("送餐位置資訊:", style: titleStyle),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(60.w, 0.h, 0.w, 15.h),
              alignment: Alignment.centerLeft,
              child: Text(
                "台北市大安區忠孝東路",
                style: addressStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
      ],
    );
  }

  Widget _buildTablewareInfo(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    final subTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 36.sp);
    return ListTile(
      title: Text("提供餐具、吸管等", style: titleStyle),
      subtitle: Text("除非您提出這些要求, 否則餐廳不會主動為您提供這些餐具", style: subTitleStyle),
      leading: Icon(Icons.local_dining, color: Colors.green, size: 66.sp),
      trailing: Switch.adaptive(
          value: _switchState,
          onChanged: (value) {
            setState(() {
              _switchState = value;
            });
          }),
    );
  }

  Widget _buildOrderDetail(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 60.w, right: 60.w),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0.w, top: 20.h, bottom: 20.h),
            child: Text("您的訂單", style: titleStyle),
          ),
          _buildOrderDetailInfo(context),
          Divider(),
          _buildOrderDetailInfo(context),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildOrderDetailInfo(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.grey[800], fontSize: 38.sp);
    final subTitleStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final subTitleStyle2 = TextStyle(color: Colors.grey[500], fontSize: 38.sp);
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      title: Row(
        children: <Widget>[
          Container(
            width: 66.w,
            margin: EdgeInsets.fromLTRB(0, 0, 30.w, 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              "1",
              style: titleStyle.copyWith(color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
          Text("茶碗蒸", style: subTitleStyle)
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.fromLTRB(98.w, 0, 0, 0),
        child: Text("加辣、不要蛋、不要茶", style: subTitleStyle2),
      ),
      trailing: Text("NT\$30", style: titleStyle),
    );
  }

  Widget _buildOrderTotal(BuildContext context) {
    final totalStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 72.w, 0),
      trailing: Text("NT\$ 55688", style: totalStyle),
    );
  }
}
