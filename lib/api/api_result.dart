class ApiResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? status;
  final dynamic raw;
  const ApiResult(this.success, {this.data, this.error, this.status, this.raw});
}

String extractErrorMessage({int? status, dynamic data, String? fallback}) {
  final direct = _pickFirstValue(data, const ['detail', 'non_field_errors', 'message', 'error']);
  if (direct != null && direct.trim().isNotEmpty) return direct.trim();

  final parts = <String>[];

  void collectValues(dynamic v) {
    final t = _flattenValuesOnly(v);
    if (t != null && t.trim().isNotEmpty) parts.add(t.trim());
  }

  if (data is Map) {
    final map = (data).map((k, v) => MapEntry(k.toString(), v));
    for (final v in map.values) collectValues(v);
  } else {
    collectValues(data);
  }

  if (parts.isNotEmpty) return parts.join('\n');

  return fallback ?? 'خطای نامشخص از سرور';
}

String? _pickFirstValue(dynamic data, List<String> keys) {
  if (data is Map) {
    final map = (data).map((k, v) => MapEntry(k.toString(), v));
    for (final k in keys) {
      final t = _flattenValuesOnly(map[k]);
      if (t != null && t.trim().isNotEmpty) return t;
    }
  } else if (data is String) {
    return data;
  }
  return null;
}

String? _flattenValuesOnly(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;

  if (v is List) {
    final items = v
        .map((e) => _flattenValuesOnly(e) ?? e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();
    return items.isEmpty ? null : items.join('، ');
  }

  if (v is Map) {
    final map = (v).map((k, val) => MapEntry(k.toString(), val));
    final items = <String>[];
    for (final val in map.values) {
      final t = _flattenValuesOnly(val);
      if (t != null && t.trim().isNotEmpty) items.add(t);
    }
    return items.isEmpty ? null : items.join('، ');
  }

  return v.toString();
}
