import 'package:flutter/material.dart';

const double _bookCardWidth = 135;
const double _bookCardHeight = 140;

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.title,
    required this.isbn,
    required this.imageUrl,
  });

  final String title;
  final String isbn;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          SizedBox(
            width: _bookCardWidth,
            height: _bookCardHeight,
            child: Image(
              image: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('assets/images/book_placeholder.png')
                        as ImageProvider,
            ),
          ),
          SizedBox(
            width: _bookCardWidth,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
