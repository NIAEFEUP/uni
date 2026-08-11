import 'package:objectbox/objectbox.dart';

/// File in Sigarra's Dynamic Email.
///
/// information contained:
/// Name of the attached file.
/// Subject of the email where the file was received.
/// File size as displayed by Sigarra (e.g. "816 Kb").
/// Relative or absolute URL used to download the file.
/// Date when the email was sent.
@Entity()
class MailAttachment {
  MailAttachment({
    this.fileName = '',
    this.subject = '',
    this.size = '',
    this.downloadUrl = '',
    DateTime? date,
  }) : date = date ?? DateTime.fromMillisecondsSinceEpoch(0);

  @Id()
  int? id;

  final String fileName;
  final String subject;
  final String size;
  final String downloadUrl;
  final DateTime date;
}
