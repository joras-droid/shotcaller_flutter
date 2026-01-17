import 'package:flutter/material.dart';

class CreateLoadPickUpDetailPage extends StatefulWidget {
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
        (_selectedState != null && _selectedState!.isNotEmpty)
        )
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
      // Format the date as needed (e.g., 2026-01-17)
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      // Update the controller to reflect the selection in the UI
      _dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.close, fontWeight: FontWeight.bold, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Create Load',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: _progress),
                      builder: (context, value, _) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
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
                      readOnly: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Pickup Date',
                        hintText: 'YYYY-MM-DD',
                        suffixIcon: IconButton(
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
                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded, size: 30,),
                        
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
                      },
                      validator: (value) =>
                          value == null ? 'Please select a state' : null,
                    ),

                    const SizedBox(height: 32),

                    // City
                    TextFormField(
                      controller: _cityController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'City',
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
                      keyboardType: TextInputType.text,
                      
                    ),

                    const SizedBox(height: 32,),


                    // Street Address (Optional)
                    TextFormField(
                      controller: _streetAddressController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Street Address (Optional)',
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
                      keyboardType: TextInputType.text,
                      
                    ),

                    const SizedBox(height: 32),

                    // Zip Code (Optional)
                    TextFormField(
                      controller: _zipCodeController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Zip Code (Optional)',
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
                      keyboardType: TextInputType.text,
                      
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1D1D1D),
                  border: BorderDirectional(
                    top: BorderSide(color: Color(0xFFA16D47)),
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),

                // For Shadow, Container used
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xffA16D47,
                        ).withOpacity(0.4), // Shadow color
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),

                      backgroundColor: Color(0xffA16D47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(16),
                      ),

                      overlayColor: Colors.white,
                    ),

                    onPressed: () {},
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
