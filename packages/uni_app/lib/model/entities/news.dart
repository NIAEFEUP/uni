import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

@JsonSerializable()
@Entity()
class News {
  News({
    this.id = 0,
    required this.title,
    required this.description,
    required this.image,
    required this.link,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    final yoast = json['yoast_head_json'] as Map<String, dynamic>?;
    final title = yoast?['title'] as String? ?? '';
    final description = yoast?['og_description'] as String? ?? '';
    final image = json['featured_image_src'] as String? ?? '';
    final link = json['link'] as String? ?? '';

    return News(
      title: title,
      description: description,
      image: image,
      link: link,
    );
  }

  @Id()
  int id;

  final String title;
  final String description;
  final String image;
  final String link;
}
