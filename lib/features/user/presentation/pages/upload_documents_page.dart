import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../common/widgets/app_snackbar.dart';

/// Upload Documents page
class UploadDocumentsPage extends StatefulWidget {
  const UploadDocumentsPage({super.key});

  @override
  State<UploadDocumentsPage> createState() => _UploadDocumentsPageState();
}

class _UploadDocumentsPageState extends State<UploadDocumentsPage> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedFolder;
  String? _selectedDocumentType;
  File? _selectedFile;

  final List<String> _folders = [
    'Insurance',
    'Loads',
    'Permits',
    'Other',
  ];

  final List<String> _documentTypes = [
    'Driver License',
    'DOT Certificate',
    'Insurance',
    'MC Certificate',
    'Receipts',
    'Voided Cheque/NOA',
  ];

  Future<void> _pickImageFromGallery() async {
    try {
      // Request photo library permission
      PermissionStatus status;
      if (await Permission.photos.isRestricted) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.photos.request();
      }

      if (!status.isGranted) {
        AppSnackbar.showError(
          context,
          'Photo library permission is required. Please enable it in app settings.',
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
        });
        AppSnackbar.showSuccess(context, 'File selected successfully');
      }
    } catch (e) {
      String errorMessage = 'Failed to pick image';
      if (e.toString().contains('permission') || e.toString().contains('Permission')) {
        errorMessage = 'Storage permission denied. Please enable storage access in settings.';
      } else if (e.toString().contains('platform') || e.toString().contains('PlatformException')) {
        errorMessage = 'Gallery not available on this device.';
      } else {
        errorMessage = 'Failed to pick image: ${e.toString()}';
      }
      AppSnackbar.showError(context, errorMessage);
    }
  }

  Future<void> _takePhoto() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        AppSnackbar.showError(
          context,
          'Camera permission is required to take photos. Please enable it in app settings.',
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
        });
        AppSnackbar.showSuccess(context, 'Photo captured successfully');
      }
    } catch (e) {
      String errorMessage = 'Failed to take photo';
      if (e.toString().contains('permission') || e.toString().contains('Permission')) {
        errorMessage = 'Camera permission denied. Please enable camera access in settings.';
      } else if (e.toString().contains('platform') || e.toString().contains('PlatformException')) {
        errorMessage = 'Camera not available on this device.';
      } else {
        errorMessage = 'Failed to take photo: ${e.toString()}';
      }
      AppSnackbar.showError(context, errorMessage);
    }
  }

  void _handleUpload() {
    if (_selectedFile == null) {
      AppSnackbar.showError(context, 'Please select a file to upload');
      return;
    }

    // TODO: Implement actual upload logic
    AppSnackbar.showSuccess(context, 'Document uploaded successfully');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Upload Documents',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload Documents',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            // Choose Folder Dropdown
            const Text(
              'Choose Folder (Optional)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedFolder,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                ),
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: _folders.map((folder) {
                  return DropdownMenuItem(
                    value: folder,
                    child: Text(folder),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFolder = value;
                  });
                },
                hint: const Text(
                  'Select folder',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Documents Type Dropdown
            const Text(
              'Documents Type (Optional)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedDocumentType,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                ),
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white, fontSize: 16),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: _documentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value;
                  });
                },
                hint: const Text(
                  'Select document type',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Upload File Section
            const Text(
              'Upload File (Images/Pdf)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            // Photo Library Button
            InkWell(
              onTap: _pickImageFromGallery,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select file from Photo Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Or Divider
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[800])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 24),
            // Camera Button
            InkWell(
              onTap: _takePhoto,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Open Camera & Take Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFFD4A574)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
            // Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A574),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

