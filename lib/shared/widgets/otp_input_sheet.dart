import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'em_button.dart';

void showOtpInputSheet(
  BuildContext context, {
  required String phone,
  required Future<void> Function(String otp) onVerify,
  VoidCallback? onResend,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    builder: (_) => OtpInputSheet(
      phone: phone,
      onVerify: onVerify,
      onResend: onResend,
    ),
  );
}

class OtpInputSheet extends StatefulWidget {
  const OtpInputSheet({
    super.key,
    required this.phone,
    required this.onVerify,
    this.onResend,
  });

  final String phone;
  final Future<void> Function(String otp) onVerify;
  final VoidCallback? onResend;

  @override
  State<OtpInputSheet> createState() => _OtpInputSheetState();
}

class _OtpInputSheetState extends State<OtpInputSheet> {
  static const _length = 6;
  static const _resendSeconds = 45;

  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  int _secondsLeft = _resendSeconds;
  Timer? _timer;
  bool _loading = false;
  String? _error;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _submit() async {
    final otp = _otp;
    if (otp.length < _length) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.onVerify(otp);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _attempts++;
      setState(() {
        _loading = false;
        _error = _attempts >= 3
            ? 'Too many attempts. Please request a new OTP.'
            : e.toString().replaceAll('Exception: ', '');
      });
      // Clear OTP fields on error
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_otp.length == _length) {
      _submit();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _resend() {
    if (_secondsLeft > 0) return;
    widget.onResend?.call();
    _startCountdown();
    setState(() => _error = null);
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius:
                  BorderRadius.circular(AppSpacing.borderRadiusPill),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter OTP', style: AppTypography.h2),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Sent to ${widget.phone}',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: AppSpacing.lg),

                // 6-box OTP input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_length, (i) {
                    return SizedBox(
                      width: 46,
                      height: 54,
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (e) => _onKeyEvent(i, e),
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: AppTypography.h2,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusLg),
                              borderSide: BorderSide(
                                color: _error != null
                                    ? AppColors.err
                                    : AppColors.rule,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusLg),
                              borderSide: BorderSide(
                                color: _error != null
                                    ? AppColors.err
                                    : AppColors.rule,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusLg),
                              borderSide: BorderSide(
                                color: _error != null
                                    ? AppColors.err
                                    : AppColors.textPrimary,
                                width: 2,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (v) => _onDigitChanged(i, v),
                        ),
                      ),
                    );
                  }),
                ),

                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: AppTypography.small.copyWith(color: AppColors.err),
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                // Resend row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      canResend
                          ? 'Didn\'t receive it? '
                          : 'Resend in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                      style: AppTypography.bodyR,
                    ),
                    if (canResend)
                      GestureDetector(
                        onTap: _resend,
                        child: Text(
                          'Resend OTP',
                          style: AppTypography.body.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                EmButtonFull(
                  label: 'Verify',
                  loading: _loading,
                  onPressed: _loading || _otp.length < _length
                      ? null
                      : _submit,
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
