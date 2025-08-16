import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/restaurants/no_restaurants_home_card.dart';
import 'package:uni/view/home/widgets/restaurants/restaurants_card_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/restaurant/widgets/restaurant_utils.dart';
import 'package:uni_ui/cards/restaurant_card.dart';
import 'package:uni_ui/cards/widgets/restaurant_menu_item.dart';

class RestaurantHomeCard extends GenericHomecard {
  const RestaurantHomeCard({super.key});

  @override
  String getTitle(BuildContext context) {
    return S.of(context).restaurants;
  }

  @override
  void onCardClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navRestaurants.route}');

  @override
  Widget buildCardContent(BuildContext context) =>
      RestaurantSlider(onClick: onCardClick);
}

class RestaurantSlider extends StatefulWidget {
  const RestaurantSlider({super.key, required this.onClick});

  final void Function(BuildContext) onClick;

  @override
  RestaurantSliderState createState() => RestaurantSliderState();
}

class RestaurantSliderState extends State<RestaurantSlider> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LazyConsumer<RestaurantProvider, List<Restaurant>>(
      builder: (context, restaurants) {
        final favoriteRestaurants =
            restaurants
                .where(
                  (restaurant) => PreferencesController.getFavoriteRestaurants()
                      .contains(restaurant.namePt + restaurant.period),
                )
                .toList();

        final dailyRestaurants = getRestaurantInformation(
          context,
          favoriteRestaurants,
        );

        return Column(
          children: [
            ExpandablePageView(
              children: dailyRestaurants,
              onPageChanged:
                  (value) => setState(() {
                    _currentIndex = value;
                  }),
            ),
            const SizedBox(height: 5),
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: dailyRestaurants.length,
              effect: WormEffect(
                dotHeight: 4,
                dotWidth: 4,
                activeDotColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
      hasContent: (restaurants) {
        final favoriteRestaurants =
            restaurants
                .where(
                  (restaurant) => PreferencesController.getFavoriteRestaurants()
                      .contains(restaurant.namePt + restaurant.period),
                )
                .toList();
        return getRestaurantInformation(
          context,
          favoriteRestaurants,
        ).isNotEmpty;
      },
      onNullContent: NoRestaurantsHomeCard(onClick: widget.onClick),
      contentLoadingWidget: const ShimmerRestaurantsHomeCard(),
    );
  }
}

List<RestaurantCard> getRestaurantInformation(
  BuildContext context,
  List<Restaurant> favoriteRestaurants,
) {
  final locale = Provider.of<LocaleNotifier>(context).getLocale();

  final today = parseDateTime(DateTime.now());

  final restaurantsWidgets =
      favoriteRestaurants
          .where((element) => element.getMealsOfDay(today).isNotEmpty)
          .map((restaurant) {
            final menuItems = getMainMenus(today, restaurant, locale);
            return RestaurantCard(
              name: RestaurantUtils.getRestaurantName(
                context,
                locale,
                restaurant.namePt,
                restaurant.namePt,
                restaurant.period,
              ),
              icon: RestaurantUtils.getIcon(
                restaurant.typeEn ?? restaurant.typePt,
              ),
              isFavorite: PreferencesController.getFavoriteRestaurants()
                  .contains(restaurant.namePt + restaurant.period),
              onFavoriteToggle: () => {},
              menuItems: menuItems,
              showFavoriteButton: false,
            );
          })
          .toList();

  return restaurantsWidgets;
}

List<RestaurantMenuItem> getMainMenus(
  DayOfWeek dayOfWeek,
  Restaurant restaurant,
  AppLocale locale,
) {
  final meals = restaurant.getMealsOfDay(dayOfWeek);

  if (meals.isEmpty) {
    return [];
  }

  final mainMeals =
      meals
          .where(
            (meal) => [
              'Carne',
              'Vegetariano',
              'Peixe',
              'Pescado',
            ].any((keyword) => meal.type.contains(keyword)),
          )
          .toList()
        ..sort((a, b) => a.type.compareTo(b.type));

  final filteredMeals = mainMeals.isEmpty ? meals.take(2) : mainMeals;

  final menuItems = <RestaurantMenuItem>[];
  for (final meal in filteredMeals) {
    menuItems.add(
      RestaurantMenuItem(
        name: RestaurantUtils.getLocaleTranslation(
          locale,
          meal.namePt,
          meal.nameEn,
        ),
        icon: RestaurantUtils.getIcon(meal.type),
      ),
    );
  }
  return menuItems;
}
