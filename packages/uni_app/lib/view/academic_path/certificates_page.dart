import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/certificate.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/providers/riverpod/certificates_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/widgets/general_error_view.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/widgets/toast_message.dart';
import 'package:uni_ui/cards/certificates_card.dart';

class CertificatesPage extends ConsumerStatefulWidget {
  const CertificatesPage({
    required this.course,
    required this.courseAbbreviation,
    super.key,
  });

  final Course course;
  final String courseAbbreviation;

  @override
  ConsumerState<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends SecondaryPageViewState<CertificatesPage> {
  @override
  String? getTitle() => S.of(context).certificates;

  @override
  String? getSubtitle() => widget.courseAbbreviation;

  @override
  Widget getBody(BuildContext context) {
    final certificatesAsync = ref.watch(certificatesProvider(widget.course));

    return certificatesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const GeneralErrorView(),
      data: (certificates) {
        if (certificates.isEmpty) {
          return Center(
            child: Text(S.of(context).no_certificates_for_course),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: certificates.length * 2 - 1,
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return const SizedBox(height: 8);
            }

            final certificate = certificates[index ~/ 2];
            return CertificatesCard(
              type: certificate.type,
              subtitle: _buildSubtitle(context, certificate),
              delivered: certificate.isDelivered,
              canceled: certificate.isCanceled,
              onTap: certificate.downloadUrl == null
                  ? null
                  : () => _downloadCertificate(context, certificate),
            );
          },
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    ref.invalidate(certificatesProvider(widget.course));
  }

  Future<void> _downloadCertificate(
    BuildContext context,
    Certificate certificate,
  ) async {
    final downloadUrl = certificate.downloadUrl;
    if (downloadUrl == null) {
      return;
    }

    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      if (context.mounted) {
        await ToastMessage.error(context, S.of(context).download_error);
      }
      return;
    }

    final filename = _resolveDownloadFileName(certificate);
    final file = await loadFileFromStorageOrRetrieveNew(
      filename,
      downloadUrl.toString(),
      session,
      forceRetrieval: true,
    );

    if (file?.path == null) {
      if (context.mounted) {
        await ToastMessage.error(context, S.of(context).download_error);
      }
      return;
    }

    final result = await OpenFile.open(file!.path);
    if (!context.mounted) {
      return;
    }
    switch (result.type) {
      case ResultType.done:
        await ToastMessage.success(context, S.of(context).successful_open);
      case ResultType.error:
        await ToastMessage.error(context, S.of(context).open_error);
      case ResultType.noAppToOpen:
        await ToastMessage.warning(context, S.of(context).no_app);
      case ResultType.permissionDenied:
        await ToastMessage.warning(context, S.of(context).permission_denied);
      case ResultType.fileNotFound:
        await ToastMessage.error(context, S.of(context).download_error);
    }
  }

  String _buildSubtitle(BuildContext context, Certificate certificate) {
    final l10n = S.of(context);
    final parts = <String>[];

    if (certificate.requestedOn != null) {
      parts.add('${l10n.requested_on} ${_formatDate(certificate.requestedOn!)}');
    }

    if (certificate.deliveredOn != null) {
      final label = certificate.isCanceled ? l10n.canceled_on : l10n.delivered_on;
      parts.add('$label ${_formatDate(certificate.deliveredOn!)}');
    }

    if (parts.isEmpty) {
      return l10n.requested;
    }

    return parts.join(' • ');
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _resolveDownloadFileName(Certificate certificate) {
    final fileNameFromQuery =
        certificate.downloadUrl?.queryParameters['pv_nome_fich'];
    if (fileNameFromQuery != null && fileNameFromQuery.isNotEmpty) {
      return fileNameFromQuery;
    }

    final normalizedType = certificate.type
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp('[^A-Za-z0-9_.-]'), '');
    final suffix = certificate.deliveredOn != null
        ? '${certificate.deliveredOn!.year}${certificate.deliveredOn!.month.toString().padLeft(2, '0')}${certificate.deliveredOn!.day.toString().padLeft(2, '0')}'
        : 'certificate';
    return '${normalizedType}_$suffix.pdf';
  }
}
