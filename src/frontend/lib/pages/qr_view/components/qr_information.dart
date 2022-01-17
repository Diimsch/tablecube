class QrInformation {
  String tableId;

  QrInformation(this.tableId);

  factory QrInformation.fromJson(dynamic json) {
    return QrInformation(json['tableId'] as String);
  }

  @override
  String toString() {
    return '{ $tableId }';
  }
}
