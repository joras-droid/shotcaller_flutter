import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../core/utils/page_route_utils.dart';
import '../bloc/auth_bloc.dart';
import 'signup_details_page.dart';
import 'reset_password_page.dart';

/// OTP Verification Page - Fourth page
class OtpVerificationPage extends StatefulWidget {
  final String email;
  final bool isSignup; // true for signup flow, false for password reset flow

  const OtpVerificationPage({
    super.key,
    required this.email,
    this.isSignup = true,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _currentIndex = 0;
  int _resendCountdown = 60;
  Timer? _countdownTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleOtpChange(String value, int index) {
    if (value.length == 1) {
      _controllers[index].text = value;
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
        setState(() {
          _currentIndex = index + 1;
        });
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      setState(() {
        _currentIndex = index - 1;
      });
    }
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      if (widget.isSignup) {
        // For signup, OTP verification happens in signup details page
        Navigator.of(context).push(
          createBlackPageRoute(
            SignupDetailsPage(
              email: widget.email,
              otp: otp,
            ),
          ),
        );
      } else {
        // For password reset, navigate directly to reset password page
        // The OTP itself is used as the token for password reset
        Navigator.of(context).push(
          createBlackPageRoute(
            ResetPasswordPage(
              email: widget.email,
              token: otp,
            ),
          ),
        );
      }
    }
  }

  void _resendOtp() {
    if (_canResend) {
      context.read<AuthBloc>().add(
            SendOtpRequested(email: widget.email),
          );
      _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "You've Got OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We have sent the OTP verification code to your email. Check your email and enter the code below.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(0xFFD4A574).withOpacity(0.3)
                            : Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        showCursor: false,
                        onChanged: (value) => _handleOtpChange(value, index),
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive OTP?",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _canResend ? _resendOtp : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          color: _canResend
                              ? const Color(0xFFFF6B35)
                              : Colors.grey[600],
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'You can resend code in ${_resendCountdown}s',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Continue Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    final otp = _controllers.map((c) => c.text).join();
                    final canContinue = otp.length == 6 && !isLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canContinue ? _verifyOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canContinue
                              ? const Color(0xFFD4A574)
                              : Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

