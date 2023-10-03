import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ScreenTwoController extends GetxController {
  @override
  void onInit() {
    getData();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  ScrollController scrollController = ScrollController();

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      getData();
    }
  }

  RxBool isScreenLoading = true.obs;
  RxInt itemsPerPage = 5.obs;
  RxInt pageIndex = 0.obs;
  RxList video = [].obs;
  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(
      "https://api.indiatvshowz.com/v1/getVideos.php?type=song&start-index=${video.length + 1}&max-results=$itemsPerPage&language%50id=1",
    ));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Iterable dataList = data['data'];

      video.addAll(dataList);
      pageIndex++;
      isScreenLoading.value = false;
    } else {
      log('${response.statusCode}');

      isScreenLoading.value = false;
    }
  }

  // String formatDuration(String durationString) {
  //   int durationInSeconds = int.tryParse(durationString) ?? 0;
  //   int minutes = durationInSeconds ~/ 60;
  //   int seconds = durationInSeconds % 60;
  //   return '$minutes:${seconds.toString().padLeft(2, '0')}';
  // }
  //
  // String formatViewCount(String viewCount) {
  //   int count = int.tryParse(viewCount) ?? 0;
  //
  //   if (count >= 10000000) {
  //     return '${(count / 10000000).toStringAsFixed(2)} Cr';
  //   } else if (count >= 100000) {
  //     return '${(count / 100000).toStringAsFixed(2)} Lakh';
  //   } else if (count >= 1000) {
  //     return '${(count / 1000).toStringAsFixed(2)} K';
  //   } else {
  //     return count.toString();
  //   }
  // }
}
