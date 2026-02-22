import 'pill_chip.dart';

String money(String? v) {
  if (v == null || v.trim().isEmpty) return "—";
  return "Rs. $v";
}

String formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return "";
  // keep it simple; you can replace with intl if needed
  return iso.length >= 10 ? iso.substring(0, 10) : iso;
}

PillType pillTypeFromStatus(String status) {
  final s = status.toLowerCase();
  if (s.contains("delivered") || s.contains("completed")) {
    return PillType.success;
  }
  if (s.contains("pending") || s.contains("processing")) {
    return PillType.warning;
  }
  if (s.contains("cancel") || s.contains("failed")) return PillType.danger;
  return PillType.info;
}

PillType pillTypeFromPayment(String payment) {
  final p = payment.toLowerCase();
  if (p.contains("paid") || p.contains("success")) return PillType.success;
  if (p.contains("pending")) return PillType.warning;
  if (p.contains("fail") || p.contains("unpaid")) return PillType.danger;
  return PillType.info;
}
