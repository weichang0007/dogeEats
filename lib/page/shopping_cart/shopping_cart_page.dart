import 'package:dio/dio.dart';
import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/page/location_picker/location_picker_page.dart';
import 'package:dogeeats/service/services.dart';
import 'package:dogeeats/widget/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int total = 0;
  Future future;
  HttpService _http = HttpService.instance;
  bool _switchState = false;
  CreditCardModel _creditCardModel = CreditCardModel("", "", "", "", false);

  void _modifyAppbar(BuildContext context) {
    BlocProvider.of<AppbarBloc>(context).add(ModifyAppbarEvent(null));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      future = getdata();
    } catch (e) {}
  }

  FutureBuilder<List<Widget>> _buildFutureBuilder(BuildContext context) {
    _modifyAppbar(context);
    return FutureBuilder<List<Widget>>(
      builder: (context, AsyncSnapshot<List<Widget>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            List<Widget> list = async.data;
            list[5] = _buildTablewareInfo(context);
            list[7] = _buildPaymentMethod(context);
            return Scaffold(
              bottomSheet: Container(
                alignment: Alignment.center,
                height: 140.h,
                color: Colors.green,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.shopping_cart, color: Colors.white),
                  title: Text(
                    "一鍵下單",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  trailing: Text(
                    "NT\$ $total",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text("您的購物車", style: TextStyle(fontSize: 48.sp)),
              ),
              body: SingleChildScrollView(child: Column(children: list)),
            );
          }
        }
        final text = "發生錯誤, 清稍後再試";
        final style = TextStyle(fontSize: 40.sp);
        final align = TextAlign.center;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 800.h),
                    child: Text(text, style: style, textAlign: align)),
              ],
            ),
          ),
        );
      },
      future: future,
    );
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return _buildFutureBuilder(context);
  }

  Widget _buildStoreInfo(BuildContext context, String name, String fee) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    return ListTile(
      title: Text("$name - 美食外送服務", style: titleStyle),
      trailing: Text("$fee TWD", style: titleStyle.copyWith(fontSize: 38.sp)),
      leading: Icon(Icons.local_shipping, color: Colors.grey[400], size: 66.sp),
    );
  }

  Future<Widget> _buildAddressInfo(BuildContext context) async {
    final titleStyle = TextStyle(color: Colors.grey[700], fontSize: 36.sp);
    final addressStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    Setting setting = await Setting.instance;
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
                setting.address,
                style: addressStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => LocationPickerPage()),
            );
            await refresh();
          },
        ),
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

  Widget _buildOrderDetail(BuildContext context, List orderList) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    final List<Widget> orderDetail = [];
    for (Map order in orderList) {
      orderDetail.add(_buildOrderDetailInfo(context, order['count'].toString(),
          order['name'], order['option'], order['price'].toString()));
      orderDetail.add(Divider());
    }
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
            ] +
            orderDetail,
      ),
    );
  }

  Widget _buildOrderDetailInfo(BuildContext context, String count, String name,
      String option, String price) {
    final titleStyle = TextStyle(color: Colors.grey[800], fontSize: 38.sp);
    final subTitleStyle = TextStyle(color: Colors.black, fontSize: 36.sp);
    final subTitleStyle2 = TextStyle(color: Colors.grey[500], fontSize: 38.sp);
    option = option.substring(0, option.length - 1);
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      title: Row(
        children: <Widget>[
          Container(
            width: 66.w,
            margin: EdgeInsets.fromLTRB(0, 0, 30.w, 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              count,
              style: titleStyle.copyWith(color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
          Text(name, style: subTitleStyle)
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.fromLTRB(98.w, 0, 0, 0),
        child: Text(option, style: subTitleStyle2),
      ),
      trailing: Text("NT\$$price", style: titleStyle),
    );
  }

  Widget _buildOrderTotal(BuildContext context, int total) {
    final totalStyle = TextStyle(color: Colors.black, fontSize: 38.sp);
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 72.w, 0),
      trailing: Text("NT\$ $total", style: totalStyle),
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    final titleStyle = TextStyle(color: Colors.black, fontSize: 40.sp);
    final subTitleStyle = TextStyle(color: Colors.grey[700], fontSize: 36.sp);
    return ListTile(
      onTap: () async {
        if (_creditCardModel.cardNumber.isEmpty) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreditCardInputForm(_creditCardModel),
            ),
          );
        } else {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "變更為貨到付款",
            desc: "若變更為貨到付款, 將清除您的信用卡資訊!",
            buttons: [
              DialogButton(
                child: Text(
                  "確定",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  _creditCardModel = CreditCardModel("", "", "", "", false);
                  Navigator.pop(context);
                  setState(() {});
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
              DialogButton(
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.grey,
              )
            ],
          ).show();
        }
        setState(() {});
      },
      title: Text("付款方式", style: titleStyle),
      subtitle: Text(
          _creditCardModel.cardNumber.isEmpty
              ? "貨到付款"
              : "${_creditCardModel.cardNumber.split(" ")[0]} **** **** **** (信用卡)",
          style: subTitleStyle),
      leading: Icon(
          _creditCardModel.cardNumber.isEmpty
              ? Icons.monetization_on
              : Icons.payment,
          color: Colors.deepPurple,
          size: 66.sp),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  Future<List<Widget>> getdata() async {
    try {
      total = 0;
      String baseUrl = HttpService.baseUrl;
      Response cartResponse = await _http.getJsonData("$baseUrl/cart");
      if (cartResponse.data.length == 0) return null;
      Map cartList = cartResponse.data[0];
      Map restaurant = (await _http
              .getJsonData("$baseUrl/restaurant/${cartList['restaurant_id']}"))
          .data;
      List<Map> products = _getRestaurantProducts(restaurant);
      List<Map> orderList = [];
      for (Map item in cartList['products']) {
        Map product = products
            .where((element) => element['id'] == item['id'])
            .toList()[0];
        String optionSting = "";
        for (Map option in item['options']) {
          optionSting += (option['option_name'] as Map)['name'] + "、";
        }
        total += 1 * int.parse(product['price'].toString());
        orderList.add({
          "name": product['name'],
          "count": 1,
          "option": optionSting,
          "price": product['price'],
        });
      }
      List<Widget> result = [
        Divider(),
        await _buildAddressInfo(context),
        Divider(),
        _buildStoreInfo(
            context, restaurant['name'], restaurant['service_fee'].toString()),
        Divider(),
        _buildTablewareInfo(context),
        Divider(),
        _buildPaymentMethod(context),
        Divider(),
        _buildOrderDetail(context, orderList),
        _buildOrderTotal(context, total),
        Divider(),
        Padding(padding: EdgeInsets.only(bottom: 140.h)),
      ];
      return result;
    } catch (e) {
      return null;
    }
  }

  List<Map> _getRestaurantProducts(Map restaurant) {
    List<Map> result = [];
    for (Map type in restaurant['categories']) {
      for (var item in type['products']) {
        result.add({
          "name": item['name'],
          "id": item['id'],
          "price": item["price"],
        });
      }
    }
    return result;
  }

  Future refresh() async {
    setState(() {
      try {
        future = getdata();
      } catch (e) {}
    });
  }
}
