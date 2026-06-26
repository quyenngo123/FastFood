import 'package:intl/intl.dart';

class StringUtils {
  static String removeDiacritics(String str) {
    if (str.isEmpty) return str;
    const withDia = 'àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵđ'
        'ÀÁẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬÈÉẺẼẸÊẾỀỂỄỆÌÍỈĨỊÒÓỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÙÚỦŨỤƯỨỪỬỮỰỲÝỶỸỴĐ';
    const withoutDia = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiioooooooooooooooooouuuuuuuuuuuyyyyyd'
        'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';
    String result = str;
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result;
  }

  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(price).replaceAll(',', '.');
  }

  /// Tính điểm ưu tiên cho tìm kiếm theo Tên món ăn:
  /// 1. Ưu tiên từ khóa đứng đầu tên món ăn (khớp nguyên từ/cụm từ).
  /// 2. Tiếp theo là từ khóa xuất hiện nguyên vẹn trong tên (không cần đứng đầu).
  /// 3. Không tìm theo kiểu từ khóa là một phần của từ (VD: "ran" không khớp "trân").
  static int getSearchScore(String name, String query) {
    if (query.isEmpty) return 0;
    
    final nName = removeDiacritics(name).toLowerCase();
    final nQuery = removeDiacritics(query).toLowerCase();
    final escapedQuery = RegExp.escape(nQuery);

    // Regex khớp nguyên cụm từ ở ngay đầu chuỗi (^ và \b)
    final startPattern = RegExp('^$escapedQuery\\b');
    // Regex khớp nguyên cụm từ ở bất kỳ đâu (\b ở cả 2 đầu)
    final wholeWordPattern = RegExp('\\b$escapedQuery\\b');

    // 1. Kiểm tra ưu tiên 1: Khớp nguyên vẹn ở đầu (Ví dụ: tìm "mi" -> khớp "Mì Ý")
    if (startPattern.hasMatch(nName)) return 100;

    // 2. Kiểm tra ưu tiên 2: Khớp nguyên vẹn ở vị trí khác (Ví dụ: tìm "ran" -> khớp "Gà Rán")
    if (wholeWordPattern.hasMatch(nName)) return 80;

    return 0;
  }
}
