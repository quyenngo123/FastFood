import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';
import '../../../food/presentation/bloc/cart_event.dart';
import '../../../food/domain/entities/cart_item_entity.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController(viewportFraction: 1);
  int _currentPage = 0;
  Timer? _timer;
  List<QueryDocumentSnapshot> _cachedBanners = [];
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer(int count) {
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_controller.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= count) {
          nextPage = 0;
        }
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  // Helper function to extract data from Firestore (handling nested imageUrl map)
  Map<String, dynamic> _getPromoData(Map<String, dynamic> data) {
    final imageUrlData = data['imageUrl'];
    String imgUrl = '';
    String title = data['title'] ?? '';
    String subtitle = data['subtitle'] ?? '';

    if (imageUrlData is Map<String, dynamic>) {
      imgUrl = imageUrlData['image'] as String? ?? '';
      title = imageUrlData['title'] as String? ?? title;
      subtitle = imageUrlData['subtitle'] as String? ?? subtitle;
    } else if (imageUrlData is String) {
      imgUrl = imageUrlData;
    }

    // Fallback to top-level 'image' if exists
    if (imgUrl.isEmpty && data['image'] is String) {
      imgUrl = data['image'];
    }

    return {
      'image': imgUrl,
      'title': title,
      'subtitle': subtitle,
      'price': (data['price'] ?? 0).toDouble(),
      'tag': data['tag'],
    };
  }

  void _addToCart(BuildContext context, Map<String, dynamic> promo, String docId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final productId = promo['productId'] ?? docId;
      final double price = promo['price'] ?? 0.0;

      if (price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sản phẩm "${promo['title']}" chưa có giá bán.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      context.read<CartBloc>().add(AddToCartEvent(
        userId: authState.user.uid,
        item: CartItemEntity(
          productId: productId,
          name: promo['title'] ?? 'Sản phẩm',
          image: promo['image'] ?? '',
          price: price,
          quantity: 1,
        ),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm vào giỏ hàng'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const SizedBox();

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          final activeBanners = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final isActive = data['isActive'];
            return isActive == null || isActive == true || isActive == 'true';
          }).toList();

          if (activeBanners.length != _cachedBanners.length) {
            _cachedBanners = activeBanners;
            if (_currentPage >= _cachedBanners.length) {
              _currentPage = 0;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _startTimer(_cachedBanners.length);
              }
            });
          }
        }

        if (_cachedBanners.isEmpty) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
          }
          return const SizedBox();
        }

        return Column(
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  if (mounted) {
                    setState(() {
                      _currentPage = index;
                    });
                    _startTimer(_cachedBanners.length);
                  }
                },
                itemCount: _cachedBanners.length,
                itemBuilder: (context, index) {
                  final doc = _cachedBanners[index];
                  final promo = _getPromoData(doc.data() as Map<String, dynamic>);
                  final String imageUrl = promo['image'];
                  final String title = promo['title'];
                  final String subtitle = promo['subtitle'];
                  final double price = promo['price'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[200]),
                            )
                                : Container(color: Colors.grey[200]),
                          ),
                          // Dark gradient overlay for readability
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withOpacity(0.85),
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (promo['tag'] != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      promo['tag'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                if (price > 0)
                                  Text(
                                    _currencyFormat.format(price),
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  onPressed: () => _addToCart(context, promo, doc.id),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                    elevation: 0,
                                    minimumSize: const Size(110, 36),
                                  ),
                                  child: const Text(
                                    'MUA NGAY',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      backgroundColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cachedBanners.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 20 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.orange : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
