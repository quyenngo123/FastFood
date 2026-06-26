import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Điều khoản & Chính sách', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Điều khoản dịch vụ', 
              'Bằng cách sử dụng ứng dụng Fast Food, bạn đồng ý tuân thủ các điều khoản này. Chúng tôi cung cấp nền tảng kết nối người dùng với các dịch vụ ăn uống nhanh chóng.'),
            _buildSection('2. Chính sách bảo mật', 
              'Chúng tôi cam kết bảo mật thông tin cá nhân của bạn. Dữ liệu như địa chỉ, số điện thoại chỉ được dùng cho mục đích giao hàng và nâng cao trải nghiệm người dùng.'),
            _buildSection('3. Quy trình đặt hàng', 
              'Đơn hàng sau khi đặt sẽ được xác nhận ngay lập tức. Bạn có thể theo dõi trạng thái đơn hàng trong mục Lịch sử đơn hàng.'),
            _buildSection('4. Chính sách thanh toán', 
              'Hệ thống hỗ trợ thanh toán khi nhận hàng (COD) và các ví điện tử liên kết. Mọi giao dịch đều được mã hóa bảo mật.'),
            const SizedBox(height: 30),
            const Center(
              child: Text('Phiên bản 1.0.0 © 2024 Fast Food Team',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 10),
          Text(content, 
            style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
