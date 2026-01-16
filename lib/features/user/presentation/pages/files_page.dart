import 'package:flutter/material.dart';
import '../../../../core/utils/page_route_utils.dart';
import '../../../../common/widgets/app_skeleton.dart';
import 'upload_documents_page.dart';
import 'account_page.dart';

/// Files/Documents page
class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  bool _isLoading = false;
  bool _isGridView = false; // false = list view, true = grid view
  int _currentIndex = 1; // Documents tab is selected

  // Sample data - replace with actual data from BLoC/Repository
  final List<Map<String, dynamic>> _recentFiles = [
    {
      'name': 'Rate Confirmation',
      'folder': 'Loads',
      'size': '2MB',
      'date': 'Jan 10, 2026 9:45 PM',
    },
    {
      'name': 'BOL',
      'folder': 'Loads',
      'size': '2MB',
      'date': 'Jan 10, 2026 9:45 PM',
    },
  ];

  final List<Map<String, dynamic>> _folders = [
    {'name': 'Loads', 'items': 1, 'size': '1 KB'},
    {'name': 'Insurance', 'items': 3, 'size': '204 KB'},
    {'name': 'Permits', 'items': 6, 'size': '2.4 GB'},
    {'name': 'Other', 'items': 1, 'size': '1 KB'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Files',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                createBlackPageRoute(const UploadDocumentsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: _isLoading
          ? const AppSkeleton(isFullPage: true)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Files Horizontal Scroll
                  const Text(
                    'Recent Files',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recentFiles.length,
                      itemBuilder: (context, index) {
                        final file = _recentFiles[index];
                        return _buildFileCard(file);
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Folders Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Folders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 20),
                            onPressed: () {
                              // TODO: Create new folder
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _isGridView ? Icons.view_list : Icons.grid_view,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isGridView = !_isGridView;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._folders.map((folder) => _buildFolderItem(folder)),
                  const SizedBox(height: 32),
                  // Recent Files List Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Files',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isGridView ? Icons.view_list : Icons.grid_view,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isGridView = !_isGridView;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._recentFiles.map((file) => _buildRecentFileItem(file)),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            createBlackPageRoute(const UploadDocumentsPage()),
          );
        },
        backgroundColor: const Color(0xFFD4A574),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate to different tabs
            if (index == 0) {
              // Home - TODO: Navigate to home page
            } else if (index == 1) {
              // Documents - already on this page
            } else if (index == 2) {
              // Create
              Navigator.of(context).push(
                createBlackPageRoute(const UploadDocumentsPage()),
              );
            } else if (index == 3) {
              // Loads - TODO: Navigate to loads page
            } else if (index == 4) {
              // Settings - Navigate to account page
              Navigator.of(context).pushReplacement(
                createBlackPageRoute(const AccountPage()),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[900],
          selectedItemColor: const Color(0xFFD4A574),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'Documents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Loads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(Map<String, dynamic> file) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Icon(
                Icons.image,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      file['size'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  file['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  file['date'] as String,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(Map<String, dynamic> folder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.folder, color: Colors.amber, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${folder['items']} items - ${folder['size']}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Show folder options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFileItem(Map<String, dynamic> file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['folder'] as String,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  file['name'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${file['size']} - ${file['date']}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Show file options
            },
          ),
        ],
      ),
    );
  }
}

