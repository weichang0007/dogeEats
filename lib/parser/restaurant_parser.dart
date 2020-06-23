import 'dart:convert';
import 'package:dogeeats/widget/restaurant_card.dart';

class RestaurantParser {
  static List<RestaurantCard> fromJsonArray(List jsonList, double width,
      double height, List<int> favoriteList, Function(bool) onLikeChenged) {
    List<RestaurantCard> result = [];
    for (var item in jsonList)
      result.add(
        fromJson(
          json.encode(item),
          width,
          height,
          favoriteList.contains(item['id']),
          onLikeChenged,
        ),
      );
    return result;
  }

  static RestaurantCard fromJson(String jsonString, double width, double height,
      bool isLike, Function(bool) onLikeChenged) {
    Map jsonMap = json.decode(jsonString);
    return RestaurantCard(
      id: jsonMap['id'],
      url: jsonMap['img_url'] ??
          "https://visualsound.com/wp-content/uploads/2019/05/unavailable-image.jpg",
      name: jsonMap['name'],
      address: jsonMap['address'],
      description: jsonMap['description'],
      time: "null",
      star: "null",
      responseCount: 0,
      price: jsonMap['service_fee'].toString(),
      width: width,
      height: height,
      isLiked: isLike,
      onLikeChenged: onLikeChenged,
    );
  }
}
