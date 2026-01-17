import 'package:flutter/material.dart';

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
                      "Broker Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Broker Name
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Broker Name',
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
                          return 'Please enter the broker\'s name';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Broker Phone
                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Broker Phone',
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
                          return 'Please enter the broker\'s phone';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Broker Email
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        labelText: 'Broker Email',
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
