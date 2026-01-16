import 'package:flutter/material.dart';
import '../../../../common/widgets/app_snackbar.dart';

/// Truck Type selection page
class TruckTypePage extends StatefulWidget {
  const TruckTypePage({super.key});

  @override
  State<TruckTypePage> createState() => _TruckTypePageState();
}

class _TruckTypePageState extends State<TruckTypePage> {
  final Set<String> _selectedTypes = {'Flatbed'};

  // Map truck type names to their PNG file names
  String _getTruckTypeImagePath(String name) {
    final Map<String, String> imageMap = {
      'Flatbed': 'assets/truck_type/dropdeck.png', // Using dropdeck as Flatbed
      'Drop deck': 'assets/truck_type/dropdeck.png',
      'Extendable drop dock': 'assets/truck_type/extrendable drop deck.png',
      'Hot shot': 'assets/truck_type/hot_shot.png',
      'Sandbox': 'assets/truck_type/sandbox.png',
      'Bus': 'assets/truck_type/Bus.png',
      'City Bus': 'assets/truck_type/City_Bus.png',
      'Cargo Vans': 'assets/truck_type/Cargo_bus.png',
      'Dry van': 'assets/truck_type/dryVan.png',
      'Reefer': 'assets/truck_type/reefer.png',
      'Tanker': 'assets/truck_type/tanker.png',
      'Curtain sided': 'assets/truck_type/curtain_sided.png',
      'Pneumatic tanker': 'assets/truck_type/pneumatic.png',
      'Conestoga': 'assets/truck_type/conestoga.png',
      'Double decker': 'assets/truck_type/doubledecker.png',
      'Hopper': 'assets/truck_type/Hopper.png',
      'End dump': 'assets/truck_type/End dump.png',
      'Box Truck': 'assets/truck_type/box truck.png',
      'Auto hauler': 'assets/truck_type/auto hauler.png',
      'Power truck': 'assets/truck_type/power truck.png',
      'Cement truck': 'assets/truck_type/cement truck.png',
      'Dump truck': 'assets/truck_type/dump truck.png',
      'Straight Truck': 'assets/truck_type/straight truck.png',
      'Heavy Haul': 'assets/truck_type/heavy houl.png',
      'Container Trailer': 'assets/truck_type/container trailer.png',
    };
    return imageMap[name] ?? 'assets/truck_type/dropdeck.png'; // Default fallback
  }

  final List<String> _truckTypes = [
    'Flatbed',
    'Drop deck',
    'Extendable drop dock',
    'Hot shot',
    'Sandbox',
    'Bus',
    'City Bus',
    'Cargo Vans',
    'Dry van',
    'Reefer',
    'Tanker',
    'Curtain sided',
    'Pneumatic tanker',
    'Conestoga',
    'Double decker',
    'Hopper',
    'End dump',
    'Box Truck',
    'Auto hauler',
    'Power truck',
    'Cement truck',
    'Dump truck',
    'Straight Truck',
    'Heavy Haul',
    'Container Trailer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ..._truckTypes.map((truckType) => _buildTruckTypeItem(truckType)),
                  const SizedBox(height: 100), // Space for fixed button
                ],
              ),
            ),
          ),
          // Fixed button at bottom
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppSnackbar.showSuccess(
                    context,
                    'Selected ${_selectedTypes.length} truck type(s)',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A574),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckTypeItem(String name) {
    final isSelected = _selectedTypes.contains(name);
    final imagePath = _getTruckTypeImagePath(name);
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTypes.remove(name);
          } else {
            _selectedTypes.add(name);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedTypes.add(name);
                  } else {
                    _selectedTypes.remove(name);
                  }
                });
              },
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFFD4A574);
                  }
                  return Colors.transparent;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Truck type image on the right
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback icon if image fails to load
                  return const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

