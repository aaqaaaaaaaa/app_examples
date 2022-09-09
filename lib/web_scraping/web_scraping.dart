import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import 'model.dart';

class WebScraping extends StatefulWidget {
  const WebScraping({Key? key}) : super(key: key);

  @override
  State<WebScraping> createState() => _WebScrapingState();
}

class _WebScrapingState extends State<WebScraping> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    getWebSite();
  }

  Future getWebSite() async {
    final response =
        await http.get(Uri.parse('https://www.amazon.com/s?k=phone'));
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('h2 > a > span')
        .map((e) => e.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('h2 > a')
        .map((e) => 'https://www.amazon.com/${e.attributes['href']}')
        .toList();

    final images = html
        .querySelectorAll('span > a > div > img')
        .map((e) => '${e.attributes['src']}')
        .toList();

    setState(
      () {
        articles = List.generate(
          titles.length,
          (index) => Article(
            title: titles[index],
            url: urls[index],
            urlImage: images[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Scraping!'),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: ((context, index) => const Divider()),
        padding: const EdgeInsets.all(12),
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          final article = articles[index];
          return Padding(

            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              title: Text(article.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  Text(article.url, maxLines: 2, overflow: TextOverflow.ellipsis),
              leading: Image.network(article.urlImage),
            ),
          );
        },
      ),
    );
  }
}
