import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:plausible_analytics/plausible_analytics.dart';
import 'package:uni/view/plausible_click_listener/find_element.dart';

class PlausibleClickListener extends StatelessWidget {

  const PlausibleClickListener({required this.child, required this.plausible, super.key});

  final Plausible plausible;
  final Widget child;

  // Element? findElementAt(BuildContext context, Offset position) {
  //   final contextObject = context.findRenderObject();
  //   if (contextObject is! RenderBox) {
  //     print("RIP 2");
  //     return null;
  //   }

  //   final hits = BoxHitTestResult();
  //   final hasHit = contextObject.hitTest(hits, position: position);

  //   if (!hasHit) {
  //     return null;
  //   }

  //   T? tryCast<T>(dynamic value) {
  //     return value is T ? value : null;
  //   }

  //   final renderObjects = hits.path
  //     .map((e) => e.target)
  //     .whereType<RenderObject>()
  //     // .nonNulls
  //     .toList();

  //   if (renderObjects.isEmpty) {
  //     return null;
  //   }

  //   // Code inspired by https://github.com/flutter/flutter/blob/be3a4b37b3e9ab4e80d45b59bed53708b96d211f/packages/flutter/lib/src/widgets/framework.dart#L3005-L3021
  //   RenderObjectElement? descendUntilRenderObjectElement(BuildContext parent) {

  //     Element? getSingleChildOf(BuildContext context) {
  //       Element? result;
  //       context.visitChildElements((child) {
  //         assert(result == null, 'element has a single child');
  //         result = child;
  //       });

  //       return result;
  //     }

  //     BuildContext? result = parent;
  //     while (result is! RenderObjectElement?) {
  //       print(result);
  //       result = getSingleChildOf(result);
  //     }

  //     print(result);
  //     return result;
  //   }
  //   print(renderObjects.reversed.toList());

  //   var currentElement = descendUntilRenderObjectElement(context);
  //   if (currentElement?.renderObject != renderObjects.removeLast()) {
  //     return null;
  //   }

  //   print("\nINITIAL");

  //   while (currentElement != null && renderObjects.isNotEmpty) {
  //     print("");
  //     print("");
  //     print("");
  //     print('On $currentElement');
  //     print("Next two objects: ${renderObjects.reversed.take(2)}");
  //     RenderObjectElement? nextElement;
  //     currentElement.visitChildElements((element) {
  //       print("Searching in $element");
  //       if (nextElement != null) {
  //         print("Ignoring...");
  //         return;
  //       }
  //       final descendedElement = descendUntilRenderObjectElement(element);
  //       print("Using $descendedElement with ${descendedElement?.renderObject}. Looking for ${renderObjects.last}");
  //       print(descendedElement?.mounted);
  //       if (descendedElement?.renderObject == renderObjects.last) {
  //         nextElement = descendedElement;
  //         print("Found!");
  //       }
  //     });

  //     currentElement = nextElement;
  //     renderObjects.removeLast();
  //   }

  //   print("\nRESULT");
  //   print(currentElement);
  //   print(renderObjects);

  //   // for (final renderObject in renderObjects) {

  //   //   RenderObjectElement? selectedChild;
  //   //   currentElement.visitChildElements((element) {

  //   //   })
  //   //   currentElement = descendUntilRenderObjectElement(context);
  //   // }

  //   print(renderObjects);

    

  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    print(context.runtimeType);
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!context.mounted) {
          return;
        }

        
        findElementAt(context as Element, event.position);

        // event.
        // context.(recursiveTraversal(''));
        /// TODO send:
        /// if success:
        ///     - name
        ///     - x, y
        /// if not sucess:
        ///     - x, y

        // plausible.event(
        //   name: 'pointerdown',
        //   props: {
        //     'payload': {
        //       'x': event.position.dx.toString(),
        //       'y': event.position.dy.toString(),
        //       'localX': event.localPosition.dx.toString(),
        //       'localY': event.localPosition.dy.toString(),
        //       'timestamp': event.timeStamp.toString(),
        //       'pointer': event.pointer.toString(),
        //     }.toString(),
        //   }
        // );
      },
      onPointerUp: (event) {
        // plausible.event(
        //   name: 'pointerup',
        //   props: {
        //     'payload': {
        //       'x': event.position.dx.toString(),
        //       'y': event.position.dy.toString(),
        //       'localX': event.localPosition.dx.toString(),
        //       'localY': event.localPosition.dy.toString(),
        //       'timestamp': event.timeStamp.toString(),
        //       'pointer': event.pointer.toString(),
        //     }.toString(),
        //   }
        // );
      },
      child: child,
    );
  }
}
