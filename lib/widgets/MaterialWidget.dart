import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'dart:math';
import 'dart:convert';
class MaterialWidget extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String path;

  MaterialWidget(this.id, this.title, this.description, this.path);

  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends State<MaterialWidget> {
  Future downloads(Dio dio, String url, String savePath) async {
    final storage = new Storage.FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var s = await Permission.storage.status;
    if (!s.isGranted) {
      await Permission.storage.request();
    } else {
      try {
        Response response = await dio.get(
          url,
          onReceiveProgress: showDownloadProgress,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
              headers: {'Authorization': 'Bearer $token'}),
        );
        print(response.headers);
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Download Success! Goto Downloads folder to view'),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () async {
          var path = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          print(path);
          var tempDir = await getTemporaryDirectory();
          Random ran=new Random();
          const chars='city';
          String fullPath =path +'/'+ ran.nextInt(chars.length).toString() + '.pdf';
          print('full path ${fullPath}');
          final int i = this.widget.id;
          final String matUrl = 'http://computerzirna.in/api/material/$i';
          var dio = Dio();
          //print(this.widget.id);
          downloads(dio, matUrl, fullPath);
        },
        child: ListTile(
          title: Text(this.widget.title),
          subtitle: Text(this.widget.description),
          trailing: Icon(
            Icons.download,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
