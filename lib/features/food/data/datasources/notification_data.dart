class NotificationData {
  static final List<Map<String, dynamic>> notifications = [
    {
      "id": "noti001",
      "userId": "u001",
      "type": "order_status",
      "title": "Đơn hàng đã được giao! 🎉",
      "body": "Đơn hàng #o001 của bạn đã được giao thành công. Cảm ơn bạn đã tin tưởng!",
      "image": "assets/images/categories/burger.png",
      "data": {
        "orderId": "o001",
        "screen": "order_detail"
      },
      "isRead": true,
      "createdAt": "2024-06-01T09:05:00"
    },
    {
      "id": "noti002",
      "userId": "u001",
      "type": "promotion",
      "title": "🔥 Flash Sale – Giảm 40% Burger hôm nay!",
      "body": "Chỉ trong hôm nay! Tất cả Burger giảm 40%. Đặt ngay kẻo hết!",
      "image": "assets/images/categories/burger.png",
      "data": {
        "categoryId": "burger",
        "screen": "category"
      },
      "isRead": false,
      "createdAt": "2024-06-08T08:00:00"
    },
    {
      "id": "noti003",
      "userId": "u001",
      "type": "voucher",
      "title": "🎁 Voucher tặng sinh nhật cho bạn!",
      "body": "Chúc mừng sinh nhật! Bạn nhận được voucher giảm 50K cho đơn từ 150K.",
      "image": "",
      "data": {
        "voucherCode": "BDAY50K",
        "screen": "voucher"
      },
      "isRead": false,
      "createdAt": "2024-06-07T00:00:00"
    },
    {
      "id": "noti004",
      "userId": "u001",
      "type": "review_reminder",
      "title": "⭐ Đánh giá món ăn của bạn",
      "body": "Bạn đã thưởng thức Burger Bò Phô Mai chưa? Chia sẻ cảm nhận để nhận 50 điểm thưởng!",
      "image": "assets/images/categories/burger.png",
      "data": {
        "productId": "p001",
        "screen": "review"
      },
      "isRead": true,
      "createdAt": "2024-06-02T10:00:00"
    },
    {
      "id": "noti005",
      "userId": "u002",
      "type": "order_status",
      "title": "🍕 Đơn hàng đang được chuẩn bị",
      "body": "Đơn hàng #o002 đang được chuẩn bị. Dự kiến giao trong 30–45 phút.",
      "image": "assets/images/categories/pizza.png",
      "data": {
        "orderId": "o002",
        "screen": "order_detail"
      },
      "isRead": false,
      "createdAt": "2024-06-08T12:20:00"
    },
    {
      "id": "noti006",
      "userId": "u002",
      "type": "order_status",
      "title": "🛵 Shipper đang trên đường giao",
      "body": "Shipper Nguyễn Hùng đang giao đơn #o002 đến bạn. Vui lòng chú ý điện thoại!",
      "image": "",
      "data": {
        "orderId": "o002",
        "screen": "order_tracking"
      },
      "isRead": false,
      "createdAt": "2024-06-08T12:50:00"
    },
    {
      "id": "noti007",
      "userId": "u002",
      "type": "promotion",
      "title": "🧋 Mua 2 Trà Sữa tặng 1 – Hôm nay thôi!",
      "body": "Mua bất kỳ 2 ly trà sữa, nhận ngay 1 ly miễn phí. Áp dụng đến 22h hôm nay.",
      "image": "assets/images/categories/do_uong.png",
      "data": {
        "categoryId": "do_uong",
        "screen": "category"
      },
      "isRead": true,
      "createdAt": "2024-06-06T09:00:00"
    },
    {
      "id": "noti008",
      "userId": "u003",
      "type": "order_status",
      "title": "✅ Đơn hàng giao thành công",
      "body": "Đơn hàng #o003 đã giao thành công. Chúc bạn ngon miệng!",
      "image": "",
      "data": {
        "orderId": "o003",
        "screen": "order_detail"
      },
      "isRead": true,
      "createdAt": "2024-06-07T19:48:00"
    },
    {
      "id": "noti009",
      "userId": "u003",
      "type": "loyalty",
      "title": "🏆 Bạn đã tích luỹ 2100 điểm!",
      "body": "Chúc mừng! Bạn đã đạt hạng Vàng. Tận hưởng ưu đãi miễn phí giao hàng mọi đơn hàng.",
      "image": "",
      "data": {
        "screen": "loyalty"
      },
      "isRead": false,
      "createdAt": "2024-06-07T20:00:00"
    },
    {
      "id": "noti010",
      "userId": "u003",
      "type": "new_product",
      "title": "🆕 Món mới – Kimbap Bò Bulgogi đã có mặt!",
      "body": "Kimbap Bò Bulgogi – Hương vị Hàn Quốc chính gốc vừa ra mắt. Thử ngay và nhận ưu đãi 15%!",
      "image": "assets/images/categories/kimbap.png",
      "data": {
        "productId": "p017",
        "screen": "product_detail"
      },
      "isRead": false,
      "createdAt": "2024-06-08T07:00:00"
    }
  ];
}