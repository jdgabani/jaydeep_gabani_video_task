import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaydeep_gabani_video_task/Screens/screen_two_controller.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ScreenTwoController());
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<ScreenTwoController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Video Screen'),
        ),
        body: Obx(() {
          return controller.isScreenLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white70),
                    child: SizedBox(
                      height: height * 0.88,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        itemCount: controller.video.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == controller.video.length) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            var data = controller.video[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * 0.3,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(data['thumb_url']),
                                          fit: BoxFit.fill)),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
        }),
      );
    });
  }
}
