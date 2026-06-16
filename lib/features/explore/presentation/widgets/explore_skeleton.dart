import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExploreSkeleton extends StatelessWidget {
  const ExploreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            _buildHeaderSkeleton(),
            const SizedBox(height: 10),
            _buildCategorySkeleton(),
            const SizedBox(height: 20),
            _buildSectionHeaderSkeleton(),
            _buildHorizontalListSkeleton(),
            const SizedBox(height: 20),
            _buildSectionHeaderSkeleton(),
            _buildGridSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 20,
        width: 200,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildCategorySkeleton() {
    return SizedBox(
      height: 230,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
        ),
        itemCount: 8,
        itemBuilder: (context, index) => Column(
          children: [
            Container(height: 62, width: 62, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            const SizedBox(height: 6),
            Container(height: 12, width: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeaderSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(height: 20, width: 150, color: Colors.white),
          Container(height: 15, width: 70, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildHorizontalListSkeleton() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
