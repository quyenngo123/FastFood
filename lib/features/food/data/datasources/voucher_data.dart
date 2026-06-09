class VoucherData {
  static final List<Map<String, dynamic>> vouchers = [
    {
      "id": "v001",
      "code": "WELCOME50",
      "description": "Giảm 50k cho đơn hàng đầu tiên",
      "discountAmount": 50000.0,
      "minOrderAmount": 150000.0,
      "expiryDate": "2024-12-31T23:59:59"
    },
    {
      "id": "v002",
      "code": "FREESHIP",
      "description": "Miễn phí vận chuyển cho đơn từ 200k",
      "discountAmount": 30000.0,
      "minOrderAmount": 200000.0,
      "expiryDate": "2024-12-31T23:59:59"
    },
    {
      "id": "v003",
      "code": "FASTFOOD10",
      "description": "Giảm 10% tổng hóa đơn",
      "discountAmount": 20000.0,
      "minOrderAmount": 100000.0,
      "expiryDate": "2024-11-30T23:59:59"
    }
  ];
}
