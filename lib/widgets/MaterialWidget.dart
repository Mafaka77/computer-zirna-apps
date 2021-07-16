
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
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
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    }catch(e){
      print(e);
    }
  }
@override
  void initState() {
    // TODO: implement initState
    getPermission();
    super.initState();
  }

  //get storage permission
  void getPermission() async {
    await Permission.storage;
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
          String fullPath = path + "/ab.pdf'";
          print('full path ${fullPath}');
          final String i = this.widget.path;
          var dio = Dio();
          print(this.widget.path);
          downloads(dio, i, fullPath);
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
