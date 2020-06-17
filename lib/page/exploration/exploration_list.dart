part of 'exploration_page.dart';

class IndexSearch extends StatefulWidget {
  @override
  State<IndexSearch> createState() => _IndexSearchState();
}

class _IndexSearchState extends State<IndexSearch> {
  Future future;
  HttpService _http = HttpService.instance;

  @override
  Widget build(BuildContext context) => _buildFutureBuilder();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    future = getdata();
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
      future: future,
    );
  }

  Widget _buildListView(BuildContext context, List<RestaurantCard> list) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0.h),
          child: InkWell(
            child: list[index],
            onTap: () {
              Navigator.pushNamed(context, "/restaurant");
            },
          ),
        );
      },
    );
  }

  Future<List<RestaurantCard>> getdata() async {
    try {
      String baseUrl = HttpService.baseUrl;
      Future<Response> favorites =
          _http.getJsonData("$baseUrl/restaurant/favorites");
      Future<Response> restaurants = _http.getJsonData("$baseUrl/restaurants");
      List favoriteJsonList = (await favorites).data;
      List restaurantJsonList = (await restaurants).data;
      List<int> favoriteID = [];
      for (var item in favoriteJsonList) favoriteID.add(item['restaurant_id']);
      return RestaurantParser.fromJsonArray(
          restaurantJsonList, 1020.w, 1020.w, favoriteID, null);
    } catch (e) {
      return null;
    }
  }

  Future refresh() async {
    setState(() {
      try {
        future = getdata();
      } catch (e) {}
    });
  }
}
