import 'package:flutter/material.dart';
import '../widgets/CourseWidget.dart';
import '../models/course.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_pro/carousel_pro.dart';

class HomeScreenWidget extends StatelessWidget {
  final List<Course> courseList = [
    Course(
        id: '1',
        name: 'DCA',
        details: 'DCA course is for 6 months',
        imageUrl:
            'https://www.freecodecamp.org/news/content/images/2020/03/illustration_cover.png',
        price: '6000',
        vidUrl: 'https://www.youtube.com/watch?v=5mFTXbZzOAE'),
    Course(
        id: '2',
        name: 'CCC',
        details: 'CCC is for 3 Months',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwgWVgzEpNo6FVTWvlowZngttxRheolOynDQ&usqp=CAU',
        price: '5000',
        vidUrl: 'https://www.youtube.com/watch?v=1cALsSfROiE'),
    Course(
        id: '3',
        name: 'Office Automation',
        details: 'THis is for 6 months course',
        imageUrl:
            'https://www.futurity.org/wp/wp-content/uploads/2020/06/quantum-computer-programming-language-silq_1600.jpg',
        price: '5000',
        vidUrl: 'https://www.youtube.com/watch?v=MuB7HHeuNbc'),
    Course(
        id: '4',
        name: 'Tally',
        details: 'Tally is for 4 months',
        imageUrl:
            'https://resources.tallysolutions.com/us/wp-content/uploads/2020/11/Website-logo.jpg',
        price: '4000',
        vidUrl: 'https://www.youtube.com/watch?v=p54r-ZoCVq4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 250.0,
              width: 500.0,
              child: Carousel(
                images: [
                  NetworkImage(
                      'https://www.herzing.edu/sites/default/files/styles/fp_960_480/public/2020-09/it_computer_programming.jpg?h=b3660f0d&itok=ta1LXhcI'),
                  NetworkImage(
                      'https://cdn.britannica.com/30/199930-131-B3D1D347/computer.jpg'),
                ],
              )),
          Container(
            margin: new EdgeInsets.only(top: 10),
            child: Text(
              'Hot Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 500,
            height: 5,
            color: Colors.redAccent,
          ),
          Container(
              margin: new EdgeInsets.only(top: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: courseList.length,
                itemBuilder: (ctx, i) => CourseWidget(
                    courseList[i].id,
                    courseList[i].name,
                    courseList[i].details,
                    courseList[i].imageUrl,
                    courseList[i].price,
                    courseList[i].vidUrl),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Sample Videos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 5,
            width: 500,
            color: Colors.amberAccent,
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (ctx, i) => Container(
                      color: Colors.pink,
                      margin: EdgeInsets.only(right: 10),
                      width: 300,
                      child: Text('Hello'),
                    )),
          )
        ],
      ),
    );
  }
}
