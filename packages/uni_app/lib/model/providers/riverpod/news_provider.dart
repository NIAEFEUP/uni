import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/news_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/news.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final newsProvider = AsyncNotifierProvider<NewsNotifier, List<News>?>(
  NewsNotifier.new,
);

class NewsNotifier extends CachedAsyncNotifier<List<News>?> {
  @override
  Duration? get cacheDuration => const Duration(hours: 24);

  @override
  Future<List<News>> loadFromStorage() async {
    return Database().news;
  }

  @override
  Future<List<News>?> loadFromRemote() async {
    final news = await fetchNews();
    Database().saveNews(news);
    return news;
  }
}
