import 'package:flutter/material.dart';
import 'package:shotcaller_app/common/widgets/app_snackbar.dart';
import 'package:shotcaller_app/features/user/presentation/pages/create_load_pick_up_detail_page.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_button.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_text_field.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/custom_app_bar.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/progress_bar.dart';

class CreateLoadBrokerInfoPage extends StatefulWidget {
  const CreateLoadBrokerInfoPage({super.key});

  @override
  State<CreateLoadBrokerInfoPage> createState() =>
      _CreateLoadBrokerInfoPageState();
}

class _CreateLoadBrokerInfoPageState extends State<CreateLoadBrokerInfoPage> {
  final TextEditingController _nameController = .new();
  final TextEditingController _phoneController = .new();
  final TextEditingController _emailController = .new();

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateProgress);
    _phoneController.addListener(_updateProgress);
    _emailController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    int filledFields = 0;
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty)
      filledFields++;
    // final controllers = [_nameController, _phoneController, _emailController];

    setState(() {
      // Calculate progress as a fraction (e.g., 1/3, 2/3, 3/3)
      _progress = filledFields / 7;
    });
  }

  void onSubmit() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      AppSnackbar.showError(context, "Name, Phone and Email are required");
      return;
    }

    Navigator.push(context, CreateLoadPickUpDetailPage.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: CustomAppBar(
        leadingIcon: Icons.close,
        iconPressed: () {},
        title: 'Create Load',
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressBar(progressValue: _progress),

                    const SizedBox(height: 24),

                    Text(
                      "Broker Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Broker Name
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Broker Name',
                      textInputType: .name,
                    ),

                    const SizedBox(height: 32),

                    // Broker Phone
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Broker Phone',
                      textInputType: .number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the broker\'s phone';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Broker Email
                    AppTextField(
                      controller: _emailController,
                      labelText: 'Broker Email',
                      textInputType: .emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the broker\'s email';
                        }

                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AppButton(title: 'Continue', onPressed: onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
