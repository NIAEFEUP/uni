import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/news.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/news_provider.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/news/news_card_shimmer.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/news_card.dart';
import 'package:uni_ui/icons.dart';
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
    return DefaultConsumer<List<News>>(
      provider: newsProvider,
      loadingWidget: const Center(child: NewsCardShimmer()),
      nullContentWidget: Center(
        child: IconLabel(
          icon: const UniIcon(size: 45, UniIcons.news),
          label: S.of(context).no_news,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      hasContent: (newsList) => newsList.isNotEmpty,
      builder: (context, ref, newsList) {
        return ExpandablePageView.builder(
          controller: PageController(viewportFraction: 0.9),
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            final news = newsList[index];
            return NewsCard(
              title: news.title,
              description: news.description,
              image: news.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: news.image,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const SizedBox(height: 90),
                    )
                  : null,
              openLink: () {
                final uri = Uri.tryParse(news.link);
                if (uri != null) {
                  launchUrl(uri);
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void onCardClick(BuildContext context) {
    // no action
  }
}
