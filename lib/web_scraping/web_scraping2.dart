import 'package:app_examples/web_scraping/web_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class WebScraping2 extends StatefulWidget {
  const WebScraping2({Key? key}) : super(key: key);

  @override
  State<WebScraping2> createState() => _WebScraping2State();
}

class _WebScraping2State extends State<WebScraping2> {
  List<CourseModel> courseModel = [];

  @override
  void initState() {
    super.initState();
    getWebScraping();
  }

  Future getWebScraping() async {
    final response =
        await http.get(Uri.parse('https://freecodecamp.org/news/tag/blog/'));

    dom.Document html = dom.Document.html(response.body);

    final authorImage = html
        .querySelectorAll('a.static-avatar > img')
        .map((e) => e.attributes['src'])
        .toList();

    final titles = html
        .querySelectorAll('h2 > a')
        .map(
          (e) => e.innerHtml.trim(),
        )
        .toList();
    print(titles.length);

    final author = html
        .querySelectorAll('span.meta-content > a')
        .map((e) => e.innerHtml.trim())
        .toList();

    final imgUrl = html
        .querySelectorAll('a.post-card-image-link > img')
        .map((e) => e.attributes['src']!)
        .toList();

    final dateUrl = html
        .querySelectorAll('span > time')
        .map((e) => e.innerHtml.trim())
        .toList();

    final hashTagUrl = html
        .querySelectorAll('span.post-card-tags > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    setState(() {
      courseModel = List.generate(
          titles.length,
          (index) => CourseModel(
              imgUrl: imgUrl[index],
              title: titles[index],
              authorName: author[index],
              authorImg: authorImage[index] ?? '',
              date: dateUrl[index],
              hashTag: hashTagUrl[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebScraping 2'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: courseModel.length,
          itemBuilder: (context, index) {
            final course = courseModel[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.hashTag ?? ''),
                    Text(course.title),
                  ],
                ),
                subtitle: Row(
                  children: [
                    course.authorImg != null
                        ? Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.network(
                              course.authorImg,
                              fit: BoxFit.cover,
                            ))
                        : Container(width: 50),
                    Text(course.imgUrl),
                    const Spacer(),
                    Text(course.date ?? '')
                  ],
                ),
                leading: course.imgUrl != null
                    ? SizedBox(
                        width: 100,
                        height: double.infinity,
                        child: Image.network(
                          course.imgUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(width: 50),
              ),
            );
          }),
    );
  }
}
