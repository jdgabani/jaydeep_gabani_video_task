import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(_onScroll);
  }

  ScrollController _scrollController = ScrollController();
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getData();
    }
  }

  bool isScreenLoading = true;
  int itemsPerPage = 5;
  int pageIndex = 0;
  List video = [];
  Future<dynamic> getData() async {
    http.Response response = await http.get(Uri.parse(
      "https://api.indiatvshowz.com/v1/getVideos.php?type=song&start-index=${video.length + 1}&max-results=$itemsPerPage&language%50id=1",
    ));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Iterable dataList = data['data'];

      video.addAll(dataList);

      log("dataList>>>>>>>>>>>>>>$dataList");
      log("dataListLength>>>>>>>>>>>>>>${dataList.length}");
      log("videoListLength>>>>>>>>>>>>>>${video.length}");
      pageIndex++;
      setState(() {
        isScreenLoading = false;
      });
    } else {
      log('${response.statusCode}');
      setState(() {
        isScreenLoading = false;
      });
    }
  }

  String formatDuration(String durationString) {
    int durationInSeconds = int.tryParse(durationString) ?? 0;
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String formatViewCount(String viewCount) {
    int count = int.tryParse(viewCount) ?? 0;

    if (count >= 10000000) {
      double croreCount = count / 10000000;
      return '${croreCount.toStringAsFixed(2)} Cr';
    } else if (count >= 100000) {
      double lakhCount = count / 100000;
      return '${lakhCount.toStringAsFixed(2)} Lakh';
    } else if (count >= 1000) {
      double thousandCount = count / 1000;
      return '${thousandCount.toStringAsFixed(2)} K';
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Video Screen'),
      ),
      body: isScreenLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white70),
                child: SizedBox(
                  height: height * 0.88,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: video.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == video.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          video[index]['thumb_url']),
                                      fit: BoxFit.fill)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          formatDuration(
                                              video[index]['duration']),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video[index]['video_title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatViewCount(
                                            video[index]['view_count']),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text(
                                        ' Views • ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        video[index]['uploaded'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Text(
                                        ' • uploaded',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'youtube_id • ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        video[index]['youtube_id'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
