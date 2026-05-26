import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/locations/atm.dart';
import 'package:uni/model/entities/locations/coffee_machine.dart';
import 'package:uni/model/entities/locations/parking.dart';
import 'package:uni/model/entities/locations/printer.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/store_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/model/entities/locations/wc_location.dart';
import 'package:uni_ui/icons.dart';

enum AmenityFilter {
  coffee(UniIcons.coffee),
  restaurants(UniIcons.restaurant),
  snacks(UniIcons.cookie),
  atm(UniIcons.money),
  printer(UniIcons.printer),
  wc(UniIcons.toilet),
  parking(UniIcons.carPark),
  store(UniIcons.storefront);

  const AmenityFilter(this.icon);

  final IconData icon;

  String label(BuildContext context) {
    final strings = S.of(context);
    return switch (this) {
      AmenityFilter.coffee => strings.coffee_machine,
      AmenityFilter.restaurants => strings.restaurants,
      AmenityFilter.snacks => strings.snacks,
      AmenityFilter.atm => strings.atm,
      AmenityFilter.printer => strings.printer,
      AmenityFilter.wc => strings.wc,
      AmenityFilter.parking => strings.parking,
      AmenityFilter.store => strings.stores,
    };
  }

  bool matches(Location location) {
    return switch (this) {
      AmenityFilter.coffee => location is CoffeeMachine,
      AmenityFilter.restaurants => location is RestaurantLocation,
      AmenityFilter.snacks => location is VendingMachine,
      AmenityFilter.atm => location is Atm,
      AmenityFilter.printer => location is Printer,
      AmenityFilter.wc => location is WcLocation,
      AmenityFilter.store => location is StoreLocation,
      AmenityFilter.parking => location is CarPark,
    };
  }
}

class AmenityFilterBar extends StatelessWidget {
  const AmenityFilterBar({
    required this.selectedAmenity,
    required this.onAmenitySelected,
    super.key,
  });

  final AmenityFilter? selectedAmenity;
  final void Function(AmenityFilter?) onAmenitySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: AmenityFilter.values.indexed.map((entry) {
          final (index, amenity) = entry;
          final isLast = index == AmenityFilter.values.length - 1;
          final isSelected = selectedAmenity == amenity;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8, bottom: 8),
            child: _AmenityChip(
              amenity: amenity,
              isSelected: isSelected,
              onTap: () => onAmenitySelected(isSelected ? null : amenity),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({
    required this.amenity,
    required this.isSelected,
    required this.onTap,
  });

  final AmenityFilter amenity;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: isSelected ? primaryColor : secondaryColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  amenity.icon,
                  size: 18,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  amenity.label(context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
