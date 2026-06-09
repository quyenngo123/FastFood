import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController(viewportFraction: 1);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('promos')
          .orderBy('priority')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const SizedBox();
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const SizedBox();

        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 5), (_) {
          if (_currentPage < docs.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          if (_controller.hasClients) {
            _controller.animateToPage(_currentPage,
                duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
          }
        });

        return Column(
          children: [
            SizedBox(
              height: 200, // Chiều cao phù hợp cho ảnh full
              width: double.infinity,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final promo = docs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      clipBehavior: Clip.antiAlias, // Bo góc toàn bộ nội dung
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // 1. Ảnh nền Full Container
                          Positioned.fill(
                            child: Image.network(
                              promo['image'] ?? '',
                              fit: BoxFit.cover, // Phủ kín toàn bộ
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[300]),
                            ),
                          ),

                          // 2. Lớp Gradient phủ để text dễ đọc hơn
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withOpacity(0.7), // Tối bên trái (nơi đặt text)
                                    Colors.black.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 3. Nội dung text đè lên ảnh
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (promo['tag'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      promo['tag'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  promo['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  promo['subtitle'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                    elevation: 0,
                                  ),
                                  child: const Text('MUA NGAY', 
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
            // Thanh chỉ báo (Indicators)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(docs.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: _currentPage == index ? 18 : 6,
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
