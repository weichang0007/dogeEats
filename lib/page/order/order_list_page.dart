import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  void _modifyAppbar(BuildContext context) {
    BlocProvider.of<AppbarBloc>(context).add(ModifyAppbarEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    _modifyAppbar(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            labelStyle: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey[350],
            labelColor: Colors.grey[800],
            tabs: [Tab(text: "即將抵達"), Tab(text: "過去的訂單")],
            indicatorColor: Colors.grey[800],
          ),
        ),
        body: TabBarView(
          children: [_buildCurrentPage(context), _buildHistoryPage(context)],
        ),
      ),
    );
  }

  Widget _buildHistoryPage(BuildContext context) {
    return Center();
  }

  Widget _buildCurrentPage(BuildContext context) {
    return ListView(
      children: <Widget>[
        OrderInfoCard(),
      ],
    );
  }
}
