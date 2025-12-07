import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../src/app_localization.dart';
import '../../src/app_string.dart';

class MyField extends StatefulWidget {
  const MyField({
    super.key,
    required this.hint,
    required this.icon,
    this.isEnabled,
    this.validator,
    this.formatters,
    this.isObscure = false,
    this.controller,
    this.onChanged,
    this.onTap,
    this.keyType,
    this.hasBorder = true,
    this.canBeEmpty = false,
    this.clearable = false,
    this.maxLength,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final bool? isEnabled;
  final List<TextInputFormatter>? formatters;
  final String hint;
  final IconData icon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final int? maxLength, maxLines;
  final TextInputType? keyType;
  final bool hasBorder, isObscure, canBeEmpty, clearable;

  @override
  State<MyField> createState() => _MyFieldState();
}

class _MyFieldState extends State<MyField> {
  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_refresh);
  }

  void _refresh() => mounted ? setState(() {}) : null;

  @override
  void dispose() {
    widget.controller?.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 10),
          child: Text(
            widget.hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2538),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D3548)),
          ),
          child: TextFormField(
            validator: (value) {
              if ((value?.isEmpty ?? true) && !widget.canBeEmpty) {
                return AppString.empty.tr();
              }
              if (widget.validator != null) {
                widget.validator!(value);
              }

              return null;
            },
            obscureText: widget.isObscure,
            onChanged: widget.onChanged,
            controller: widget.controller,
            keyboardType: widget.keyType,
            textInputAction: TextInputAction.next,
            maxLines: widget.maxLines,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText:
                  "${AppLocalization.isEnglish(context) ? "Enter" : "أدخل"} ${widget.hint}",
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(widget.icon, color: const Color(0xFFB8FF57)),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
              errorStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
