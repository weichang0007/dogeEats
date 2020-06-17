part of 'exploration_page.dart';

class IndexSearch extends StatefulWidget {
  @override
  State<IndexSearch> createState() => _IndexSearchState();
}

class _IndexSearchState extends State<IndexSearch> {
  TextEditingController _controller = TextEditingController();
  Future _future;
  HttpService _http = HttpService.instance;

  @override
  Widget build(BuildContext context) => _buildFutureBuilder();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _future = getdata();
    } catch (e) {}
  }

  FutureBuilder<List<RestaurantCard>> _buildFutureBuilder() {
    return FutureBuilder<List<RestaurantCard>>(
      builder: (context, AsyncSnapshot<List<RestaurantCard>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            List<RestaurantCard> list = async.data;
            return RefreshIndicator(
              child: _buildListView(context, list),
              onRefresh: refresh,
            );
          }
        }
        return Container(
          height: 900.h,
          padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: <Widget>[
                Text(
                  "發生錯誤, 清稍後再試",
                  style: TextStyle(fontSize: 48.sp),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
      future: _future,
    );
  }

  Widget _buildListView(BuildContext context, List<RestaurantCard> list) {
    final searchBar = Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.9),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(192, 192, 192, 0.125),
            blurRadius: 20.sp,
            spreadRadius: 10.w,
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 30.h, left: 60.w, right: 60.w),
      child: TextField(
        controller: _controller,
        onSubmitted: (value) => refresh(query: "?name=" + _controller.text),
        decoration: InputDecoration(
          hintText: "",
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () => refresh(query: "?name=" + _controller.text),
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            onPressed: () => _controller.clear(),
            icon: Icon(Icons.clear),
            color: Colors.grey,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index != 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0.h),
            child: InkWell(
              child: list[index - 1],
              onTap: () {
                Navigator.pushNamed(context, "/restaurant");
              },
            ),
          );
        }
        return searchBar;
      },
    );
  }

  Future<List<RestaurantCard>> getdata({String query}) async {
    try {
      String baseUrl = HttpService.baseUrl;
      Future<Response> favorites =
          _http.getJsonData("$baseUrl/restaurant/favorites");
      String searchUrl = "$baseUrl/restaurants" + (query ?? "");
      Future<Response> restaurants = _http.getJsonData(searchUrl);
      List favoriteJsonList = (await favorites).data;
      List restaurantJsonList = (await restaurants).data;
      List<int> favoriteID = [];
      for (var item in favoriteJsonList) favoriteID.add(item['restaurant_id']);
      return RestaurantParser.fromJsonArray(
          restaurantJsonList, 1020.w, 1020.w, favoriteID, null);
    } catch (e) {
      Setting setting = await Setting.instance;
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonClickEvent(setting.email, setting.passwd),
      );
      return null;
    }
  }

  Future refresh({String query}) async {
    setState(() {
      try {
        _future = getdata(query: query);
      } catch (e) {}
    });
  }
}
