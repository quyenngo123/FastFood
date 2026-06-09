class OrderData {
  static final List<Map<String, dynamic>> orders = [
    {
      "id": "o001",
      "userId": "u001",
      "userName": "Nguyễn Văn An",
      "status": "delivered",
      "items": [
        {
          "productId": "p001",
          "name": "Burger Bò Phô Mai",
          "quantity": 2,
          "price": 59000
        },
        {
          "productId": "p031",
          "name": "Khoai Tây Chiên Phô Mai",
          "quantity": 1,
          "price": 35000
        },
        {
          "productId": "p023",
          "name": "Cà Phê Sữa Đá",
          "quantity": 2,
          "price": 30000
        }
      ],
      "subtotal": 213000,
      "shippingFee": 15000,
      "discount": 30000,
      "total": 198000,
      "paymentMethod": "momo",
      "address": "123 Lê Lợi, Quận 1, TP.HCM",
      "note": "Ít đá cà phê",
      "createdAt": "2024-06-01T08:30:00",
      "deliveredAt": "2024-06-01T09:05:00"
    },
    {
      "id": "o002",
      "userId": "u002",
      "userName": "Trần Thị Bình",
      "status": "preparing",
      "items": [
        {
          "productId": "p005",
          "name": "Pizza Pepperoni",
          "quantity": 1,
          "price": 120000
        },
        {
          "productId": "p021",
          "name": "Trà Sữa Trân Châu",
          "quantity": 2,
          "price": 45000
        }
      ],
      "subtotal": 210000,
      "shippingFee": 20000,
      "discount": 0,
      "total": 230000,
      "paymentMethod": "cash",
      "address": "45 Nguyễn Huệ, Quận 1, TP.HCM",
      "note": "",
      "createdAt": "2024-06-08T12:15:00",
      "deliveredAt": null
    },
    {
      "id": "o003",
      "userId": "u003",
      "userName": "Lê Minh Cường",
      "status": "delivered",
      "items": [
        {
          "productId": "c001",
          "name": "Combo Burger Cơ Bản",
          "quantity": 2,
          "price": 89000
        },
        {
          "productId": "p025",
          "name": "Lẩu Thái Hải Sản",
          "quantity": 1,
          "price": 280000
        }
      ],
      "subtotal": 458000,
      "shippingFee": 0,
      "discount": 45000,
      "total": 413000,
      "paymentMethod": "zalopay",
      "address": "78 Hai Bà Trưng, Quận 3, TP.HCM",
      "note": "Gọi trước 5 phút khi tới",
      "createdAt": "2024-06-07T19:00:00",
      "deliveredAt": "2024-06-07T19:48:00"
    }
  ];
}