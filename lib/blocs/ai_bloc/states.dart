// ══════════════════════════════════════════════════════════════════════════════
// ai_states.dart  –  Locale-neutral states
//
// States carry AppString keys (+ optional args) — never raw display strings.
// The UI resolves .tr() at render time so toasts/snackbars are always in
// the currently active locale.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:easy_localization/easy_localization.dart';

abstract class AIStates {}

class AIInitial extends AIStates {}

class AILoading extends AIStates {}

/// Emitted when insights load successfully.
/// [msgKey] is an AppString constant; widget calls msgKey.tr().
class AISuccess extends AIStates {
  final String msgKey; // e.g. AppString.aiSuccessLoad
  AISuccess({required this.msgKey});
}

/// Emitted on failure.
///
/// Two modes:
///   1. [msgKey] + optional [errorArgs] → widget calls msgKey.tr(namedArgs: errorArgs)
///   2. [rawMsg] → server returned a human-readable message we display as-is
///      (only used when the server itself provides a localised error string).
class AIError extends AIStates {
  final String? msgKey;
  final Map<String, String> errorArgs;
  final String? rawMsg; // only set when server provides its own message

  AIError({this.msgKey, this.errorArgs = const {}, this.rawMsg})
    : assert(
        msgKey != null || rawMsg != null,
        'AIError requires either msgKey or rawMsg',
      );

  String resolve() {
    if (rawMsg != null) return rawMsg!;
    return msgKey!.tr(namedArgs: errorArgs);
  }
}
