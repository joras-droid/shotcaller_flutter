import 'package:flutter/material.dart';

/// Page skeleton loader widget
/// Shows shimmer effect for loading states
class AppSkeleton extends StatelessWidget {
  final bool isFullPage;

  const AppSkeleton({
    super.key,
    this.isFullPage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFullPage) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildSkeletonBox(height: 40, width: 200),
              const SizedBox(height: 24),
              _buildSkeletonBox(height: 20, width: double.infinity),
              const SizedBox(height: 16),
              _buildSkeletonBox(height: 20, width: double.infinity),
              const SizedBox(height: 16),
              _buildSkeletonBox(height: 20, width: double.infinity),
              const SizedBox(height: 32),
              _buildSkeletonBox(height: 100, width: double.infinity),
              const SizedBox(height: 16),
              _buildSkeletonBox(height: 100, width: double.infinity),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSkeletonBox(height: 60, width: 60),
          const SizedBox(height: 16),
          _buildSkeletonBox(height: 20, width: 150),
          const SizedBox(height: 8),
          _buildSkeletonBox(height: 16, width: 100),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
