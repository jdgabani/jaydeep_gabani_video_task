import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApiCallWidget extends StatefulWidget {
  @override
  _MyApiCallWidgetState createState() => _MyApiCallWidgetState();
}

class _MyApiCallWidgetState extends State<MyApiCallWidget> {
  final String apiUrl =
      'https://api.indiatvshowz.com/v1/getVideos.php?type=song&language%20id=1';

  int startIndex = 1; // Specify your start index here
  int maxResults = 50; // Specify your max results here

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('$apiUrl&start-index=$startIndex&max-results=$maxResults'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[
          'items']; // Assuming the response has an 'items' key containing the data you need
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final items = snapshot.data;
          // Render your data here
          return ListView.builder(
            itemCount: items?.length,
            itemBuilder: (context, index) {
              final item = items?[index];
              // Build your item UI here
              return ListTile(
                title: Text(
                    item['title']), // Replace with the actual data structure
              );
            },
          );
        }
      },
    );
  }
}

void main() => runApp(MaterialApp(
      home: MyApiCallWidget(),
    ));
