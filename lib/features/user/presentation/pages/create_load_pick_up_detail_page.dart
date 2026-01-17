import 'package:flutter/material.dart';
import 'package:shotcaller_app/common/widgets/app_snackbar.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_button.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/app_text_field.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/custom_app_bar.dart';
import 'package:shotcaller_app/features/user/presentation/widgets/progress_bar.dart';

class CreateLoadPickUpDetailPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => CreateLoadPickUpDetailPage());

  const CreateLoadPickUpDetailPage({super.key});

  @override
  State<CreateLoadPickUpDetailPage> createState() =>
      _CreateLoadPickUpDetailPageState();
}

class _CreateLoadPickUpDetailPageState
    extends State<CreateLoadPickUpDetailPage> {
  final TextEditingController _dateController = .new();
  // final TextEditingController _stateController = .new();
  final TextEditingController _cityController = .new();
  final TextEditingController _streetAddressController = .new();
  final TextEditingController _zipCodeController = .new();

  // we use DropdownButtonFormField<String>, so we
  // dont use controller, but instead we use this variable
  String? _selectedState;
  final List<String> _provinces = [
    'Koshi',
    'Madhesh',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpaschim',
  ];

  double _progress = 1 / 7;

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_updateProgress);
    _cityController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cityController.dispose();
    _streetAddressController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    int filledFields = 1;
    if (_dateController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        (_selectedState != null && _selectedState!.isNotEmpty))
      filledFields++;

    setState(() {
      _progress = filledFields / 7;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest allowed date
      lastDate: DateTime(2101), // Latest allowed date
    );

    if (pickedDate != null) {
      // Format the date as needed (2026/01/17)
      String formattedDate =
          "${pickedDate.year}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}";

      // Update the controller to reflect the selection in the UI
      _dateController.text = formattedDate;
    }
  }

  void onSubmit() {
    if (_dateController.text.isEmpty ||
        _selectedState?.isEmpty == true ||
        _cityController.text.isEmpty) {
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

      appBar: CustomAppBar(
        leadingIcon: Icons.close,
        iconPressed: () {
          Navigator.pop(context);
        },
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
                      "Pick Up Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Pickup Date
                    TextFormField(
                      controller: _dateController,
                      textAlign: TextAlign.right,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Pickup Date',
                        hintText: 'YYYY-MM-DD',
                        prefix: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          // fontSize: 24,
                          fontWeight: .bold,
                        ),

                        floatingLabelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),

                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD4A574).withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD4A574)),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid date';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Select state/province
                    DropdownButtonFormField<String>(
                      value: _selectedState,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      dropdownColor: Color(0xff444444),

                      decoration: InputDecoration(
                        labelText: 'State/Province',
                        hintText: 'YYYY-MM-DD',
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 30,
                        ),

                        labelStyle: const TextStyle(
                          color: Colors.white,
                          // fontSize: 24,
                          fontWeight: .bold,
                        ),

                        floatingLabelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),

                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFD4A574).withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD4A574)),
                        ),
                      ),
                      items: _provinces.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                        _updateProgress();
                      },
                      validator: (value) =>
                          value == null ? 'Please select a state' : null,
                    ),

                    const SizedBox(height: 32),

                    // City
                    AppTextField(
                      controller: _cityController,
                      labelText: 'City',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'City must be provided';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Street Address (Optional)
                    AppTextField(
                      controller: _streetAddressController,
                      labelText: 'Street Address (Optional)',
                    ),

                    const SizedBox(height: 32),

                    // Zip Code (Optional)
                    AppTextField(
                      controller: _zipCodeController,
                      labelText: 'Zip Code (Optional)',
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
