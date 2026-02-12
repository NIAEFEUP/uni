import 'package:flutter/material.dart';
import 'floor_selector_menu.dart';

class FloorSelectorButton extends StatefulWidget {
  const FloorSelectorButton({
    required this.floors,
    required this.selectedFloor,
    required this.onFloorSelected,
    super.key,
  });

  final List<int> floors;
  final int? selectedFloor;
  final void Function(int?) onFloorSelected;

  @override
  State<FloorSelectorButton> createState() => _FloorSelectorButtonState();
}

class _FloorSelectorButtonState extends State<FloorSelectorButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggle() {
    _isOpen ? _close() : _open();
  }

  void _open() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder:
          (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _close,
            child: Stack(
              children: [
                CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(0, -260),
                  showWhenUnlinked: false,
                  child: Material(
                    color: Colors.transparent,
                    child: FloorSelectorMenu(
                      floors: widget.floors,
                      selectedFloor: widget.selectedFloor,
                      onFloorSelected: (floor) {
                        widget.onFloorSelected(floor);
                        _close();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggle,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Color(0x40000000), blurRadius: 4),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.selectedFloor?.toString() ?? '-',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
