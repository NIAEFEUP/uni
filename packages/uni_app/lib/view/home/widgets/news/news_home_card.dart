import 'package:flutter/material.dart';
import 'package:uni/controller/fetchers/news_fetcher.dart';
import 'package:uni/model/entities/news.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni_ui/cards/news_card.dart';

class NewsHomeCard extends GenericHomecard {
  const NewsHomeCard({super.key})
    : super(titlePadding: const EdgeInsets.symmetric(horizontal: 20));

  @override
  String getTitle(BuildContext context) {
    return 'Notícias';
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final newsList = snapshot.data!;
          if (newsList.isEmpty) {
            return const SizedBox.shrink();
          }
          return SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length + 2,
              itemBuilder: (context, index) {
                if (index == 0 || index == newsList.length + 1) {
                  return const SizedBox(width: 15);
                }
                final news = newsList[index - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: NewsCard(
                    title: news.title,
                    description: news.description,
                    image: news.image,
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void onCardClick(BuildContext context) {
    // TODO: implement onCardClick
  }
}
