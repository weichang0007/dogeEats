part of 'advert_page.dart';

class IndexFavorite extends StatefulWidget {
  @override
  State<IndexFavorite> createState() => _IndexFavoriteState();
}

class _IndexFavoriteState extends State<IndexFavorite> {
  Future future;
  HttpService _http = HttpService.instance;

  @override
  Widget build(BuildContext context) => _buildFutureBuilder();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      future = getdata();
    } catch (e) {}
  }

  FutureBuilder<List<Widget>> _buildFutureBuilder() {
    return FutureBuilder<List<Widget>>(
      builder: (context, AsyncSnapshot<List<Widget>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
            child: CircularProgressIndicator(),
          );
        } else if (async.connectionState == ConnectionState.done) {
          if (async.hasData) {
            List<Widget> list = async.data;
            return Container(
              padding: EdgeInsets.only(left: 15.w),
              child: RefreshIndicator(
                onRefresh: refresh,
                child: _buildListView(context, list),
              ),
            );
          }
        }
        return Container(
          height: 1000.h,
          padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              children: <Widget>[
                Text(
                  "發生錯誤, 清稍後再試",
                  style: TextStyle(fontSize: 40.sp),
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

  Widget _buildListView(BuildContext context, List<Widget> list) {
    if (list.length == 0)
      return Container(
        height: 1000.h,
        padding: EdgeInsets.only(top: 100.h),
        child: ListView(
          children: <Widget>[
            Text(
              "點擊餐廳愛心按鈕, 即可加入我的最愛",
              style: TextStyle(fontSize: 40.sp),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: list),
    );
  }

  Future<List<Widget>> getdata() async {
    try {
      String baseUrl = HttpService.baseUrl;
      Response response =
          await _http.getJsonData("$baseUrl/restaurant/favorites");
      List jsonList = response.data;
      if (jsonList.length == 0) return [];
      List<Widget> result = [];
      for (var item in jsonList)
        result.add(
          InkWell(
            child: RestaurantParser.fromJson(
              json.encode(item['restaurant']),
              700.w,
              1000.h,
              true,
              onLikeChecged,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantPage(id: item['restaurant_id'].toString()),
                ),
              );
            },
          ),
        );
      return result;
    } catch (e) {
      Setting setting = await Setting.instance;
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonClickEvent(setting.email, setting.passwd),
      );
      return null;
    }
  }

  void onLikeChecged(bool isLiked) async {
    Future.delayed(Duration(seconds: 1), refresh);
  }

  Future refresh() async {
    setState(() {
      try {
        future = getdata();
      } catch (e) {}
    });
  }
}
