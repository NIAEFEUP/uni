import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Element? _searchElementTreeUntil(Element root, bool Function(Element) predicate) {
  final elementsToSearch = Queue<Element>()..add(root);

  while (elementsToSearch.isNotEmpty) {
    final currentElement = elementsToSearch.removeFirst();
    if (predicate.call(currentElement)) {
      return currentElement;
    }

    currentElement.visitChildElements(elementsToSearch.add);
  }

  return null;
}

Element? _findClickedElement(Element root, HitTestResult hitTestResult) {
    final searchOrder = hitTestResult.path
      .map((e) => e.target)
      .whereType<RenderObject>()
      .toList();

    var currentElement = root;
    while (searchOrder.isNotEmpty) {
      final currentRenderObject = searchOrder.removeLast();
      final currentRenderObjectElement = _searchElementTreeUntil(currentElement, (element) {
        return element is RenderObjectElement && element.renderObject == currentRenderObject;
      });

      if (currentRenderObjectElement == null) {
        return null;
      }

      currentElement = currentRenderObjectElement;
    }

    return currentElement;
}

Element? findElementAt(Element root, Offset position) {
  final contextObject = root.findRenderObject();
  if (contextObject is! RenderBox) {
    return null;
  }

  final hits = BoxHitTestResult();
  final hasHit = contextObject.hitTest(hits, position: position);

  if (!hasHit) {
    return null;
  }

  var element = _findClickedElement(root, hits);
  if (element == null) {
    return null;
  }

  element.visitAncestorElements((ancestor) {
    print(ancestor);
    return true;
  });
}