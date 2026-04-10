import 'package:cipher/core/widgets/cipher_button.dart';
import 'package:flutter/material.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16162A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Login to continue'),
            const SizedBox(height: 16),
            CipherButton(label: 'Continue with Google', onPressed: () => Navigator.pop(context)),
            const SizedBox(height: 10),
            const CipherButton(label: 'Phone OTP', onPressed: null, variant: CipherButtonVariant.secondary),
          ],
        ),
      ),
    );
  }
}
