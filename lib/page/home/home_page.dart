import 'package:dogeeats/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => HomeNavigation();
}

class HomeNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [
    AdvertPage(),
    ExplorationPage(),
    //MapScreen(),
    //OrderListPage(), //LocationPickerPage(), //ShoppingCartPage(),
    OrderListPage(),
    ProfilePage(),
  ];
  final List<BottomNavigationBarItem> _navigationButtons = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('首頁'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('探索'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.widgets),
      title: Text('訂單'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text('帳戶'),
    ),
  ];

  PreferredSizeWidget _appbar = AppBar(
    title: Text("送至: 這邊還沒寫"),
  );

  int _index = 0;

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

  @override
  Widget build(BuildContext context) {
    _screenInit(context);
    return BlocListener<AppbarBloc, AppbarState>(
      listener: (context, state) {
        if (state is AppbarModify) setState(() => _appbar = state.props[0]);
      },
      child: Scaffold(
        key: _scaffoldkey,
        appBar: _appbar,
        body: _pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          fixedColor: Colors.grey[850],
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: _navigationButtons,
          currentIndex: _index,
          onTap: (int index) => setState(() {
            _screenInit(context);
            _scaffoldkey.currentState.hideCurrentSnackBar();
            _index = index;
          }),
        ),
      ),
    );
  }
}
