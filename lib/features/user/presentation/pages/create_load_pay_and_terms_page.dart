import 'package:flutter/material.dart';
import 'package:shotcaller_app/common/widgets/app_snackbar.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_button.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_text_field.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/custom_app_bar.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/progress_bar.dart';

class CreateLoadPayAndTermsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => CreateLoadPayAndTermsPage());

  const CreateLoadPayAndTermsPage({super.key});

  @override
  State<CreateLoadPayAndTermsPage> createState() =>
      _CreateLoadPayAndTermsPageState();
}

class _CreateLoadPayAndTermsPageState extends State<CreateLoadPayAndTermsPage> {
  final TextEditingController _rateController = .new();
  final TextEditingController _distanceController = .new();
  final TextEditingController _payNoteController = .new();

  double _progress = 3 / 7;

  @override
  void initState() {
    super.initState();
    _rateController.addListener(_updateProgress);
    _distanceController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _rateController.dispose();
    _distanceController.dispose();
    _payNoteController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    int filledFields = 3;
    if (_rateController.text.isNotEmpty && _distanceController.text.isNotEmpty)
      filledFields++;

    setState(() {
      _progress = filledFields / 7;
    });
  }

  void onSubmit() {
    if (_rateController.text.isEmpty || _distanceController.text.isEmpty) {
      AppSnackbar.showError(
        context,
        "Pick up date, State/Province and City are required",
      );
      return;
    }

    AppSnackbar.showSuccess(
      context,
      "Field validation success, aba move to next page",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // CRITICAL: Keeps the button from jumping up when keyboard appears
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        leadingIcon: Icons.close,
        iconPressed: () {
          Navigator.pop(context);
        },
        title: 'Create Load',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                // Large bottom padding allows the user to scroll fields
                // high enough to be seen above the keyboard
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(progressValue: _progress),
                    const SizedBox(height: 24),
                    const Text(
                      "Pay & Terms",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Per Mile Rate Amount(USD)
                    AppTextField(
                      controller: _rateController,
                      labelText: 'Per Mile Rate Amount(USD)',
                      textInputType: TextInputType.number,
                    ),

                    const SizedBox(height: 32),

                    // Miles
                    AppTextField(
                      controller: _distanceController,
                      labelText: 'Miles',
                      textInputType: TextInputType.number,
                      suffix: const Text(
                        'mi',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Pay Note
                    AppTextField(
                      controller: _payNoteController,
                      labelText: 'Pay Notes (Optional)',
                    ),
                  ],
                ),
              ),
            ),

            // 2. Fixed Bottom Button
            AppButton(title: 'Continue', onPressed: onSubmit),
          ],
        ),
      ),
    );
  }
}
