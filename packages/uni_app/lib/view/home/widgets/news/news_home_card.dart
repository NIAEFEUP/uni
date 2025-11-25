import 'package:flutter/material.dart';
import 'package:uni/controller/fetchers/news_fetcher.dart';
import 'package:uni/model/entities/news.dart';
import 'package:uni_ui/cards/news_card.dart';

class NewsHomeCard extends StatelessWidget {
  const NewsHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}
