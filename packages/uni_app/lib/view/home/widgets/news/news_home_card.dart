import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/news_provider.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni_ui/cards/news_card.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsHomeCard extends GenericHomecard {
  const NewsHomeCard({super.key})
    : super(titlePadding: const EdgeInsets.symmetric(horizontal: 20));

  @override
  String getTitle(BuildContext context) {
    return S.of(context).news;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final newsAsync = ref.watch(newsProvider);

        return newsAsync.when(
          data: (newsList) {
            if (newsList == null || newsList.isEmpty) {
              return const SizedBox.shrink();
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  ...newsList.map(
                    (news) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: NewsCard(
                        title: news.title,
                        description: news.description,
                        image: news.image,
                        openLink: () => launchUrl(Uri.parse(news.link)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  @override
  void onCardClick(BuildContext context) {
    // no action
  }
}
