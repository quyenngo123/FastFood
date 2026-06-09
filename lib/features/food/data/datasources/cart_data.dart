class CartData {
  static final List<Map<String, dynamic>> carts = [
    {
      "userId": "u001", // Giỏ hàng của Nguyễn Văn An
      "items": [
        {
          "productId": "p001",
          "name": "Burger Bò Phô Mai",
          "image": "assets/images/categories/burger.png",
          "quantity": 2,
          "price": 59000
        },
        {
          "productId": "p031",
          "name": "Khoai Tây Chiên Phô Mai",
          "image": "assets/images/categories/an_vat.png",
          "quantity": 1,
          "price": 35000
        }
      ],
      "updatedAt": "2024-06-08T10:00:00"
    },
    {
      "userId": "u002", // Giỏ hàng của Trần Thị Bình
      "items": [
        {
          "productId": "p005",
          "name": "Pizza Pepperoni",
          "image": "assets/images/categories/pizza.png",
          "quantity": 1,
          "price": 120000
        }
      ],
      "updatedAt": "2024-06-08T11:30:00"
    }
  ];
}