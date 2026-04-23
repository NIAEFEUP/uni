enum CertificateStatus { pending, delivered, cancelled }

class Certificate {
  Certificate({
    required this.type,
    this.detailUrl,
    this.requestedOn,
    required this.requested,
    required this.processed,
    required this.result,
    this.deliveredOn,
    this.downloadUrl,
    required this.status,
  });

  final String type;
  final Uri? detailUrl;
  final DateTime? requestedOn;
  final bool requested;
  final bool processed;
  final String result;
  final DateTime? deliveredOn;
  final Uri? downloadUrl;
  final CertificateStatus status;

  bool get isDelivered {
    return status == CertificateStatus.delivered;
  }

  bool get isCanceled {
    return status == CertificateStatus.cancelled;
  }

  bool get isPending => status == CertificateStatus.pending;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Certificate &&
            type == other.type &&
            detailUrl == other.detailUrl &&
            requestedOn == other.requestedOn &&
            requested == other.requested &&
            processed == other.processed &&
            result == other.result &&
            deliveredOn == other.deliveredOn &&
            downloadUrl == other.downloadUrl &&
            status == other.status;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      detailUrl,
      requestedOn,
      requested,
      processed,
      result,
      deliveredOn,
      downloadUrl,
      status,
    );
  }
}
