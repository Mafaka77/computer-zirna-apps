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
import 'package:open_file/open_file.dart';

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
  String p='';
  Future <void> _openFile() async{
    final _results=await OpenFile.open(p);
    //print(_results.message);
}
  Future downloads(Dio dio, String url, String savePath) async {
    final storage = new Storage.FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var s = await Permission.storage.status;
    if (!s.isGranted) {
      await Permission.storage.request();
    } else {
      try {
        setState(() {
          p=savePath.toString();
        });
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
        //print(response.data);
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading....'),duration: Duration(seconds: 3),));
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Download Complete'),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: (){
                          //print(savePath);
                          _openFile();
                        },
                        child: Text('View',style: TextStyle(color: Colors.red,fontSize: 18),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading error!! Try again!!')));
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
    return Container(
      child: InkWell(
        onTap: () async {
          var path = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          print(path);
          var tempDir = await getTemporaryDirectory();
          Random ran = new Random();
          const chars = 'computerzirna-materials';

          String a=this.widget.path.toString();
          String res=a.substring(10);
          String result=res.toString();
          print(result);
          String fullPath =
              path + '/'+ ran.nextInt(10000).toString() + result;
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
