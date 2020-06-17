import 'package:dio/dio.dart';
import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/parser/restaurant_parser.dart';
import 'package:dogeeats/service/http_service.dart';
import 'package:dogeeats/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'exploration_list.dart';

class ExplorationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IndexSearch();
  }
}
