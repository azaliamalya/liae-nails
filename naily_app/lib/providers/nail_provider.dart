import 'package:flutter/material.dart';
import '../models/nail.dart';
import '../services/nail_service.dart';

class NailProvider extends ChangeNotifier {
  List<Nail> nails = [];
  bool isLoading = false;
  String error = "";

  // ✅ FAVORITE LIST
  List<String> favorites = [];

  // ✅ AMBIL LIST FAVORITE
  List<Nail> get favoriteNails =>
      nails.where((n) => favorites.contains(n.id)).toList();

  // ✅ FETCH DATA API
  Future<void> fetchNails(String token) async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      nails = await NailService().getNails(token);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
    Future<void> fetchNails(String token) async {
  isLoading = true;
  notifyListeners();

  await Future.delayed(const Duration(seconds: 2)); // 🔥 tambah ini

  // lanjut fetch data
}
}

  // ❤️ TOGGLE FAVORITE
  void toggleFavorite(String id) {
    final index = nails.indexWhere((nail) => nail.id == id);

    if (index != -1) {
      if (favorites.contains(id)) {
        favorites.remove(id);
        nails[index].isFavorite = false;
      } else {
        favorites.add(id);
        nails[index].isFavorite = true;
      }
      notifyListeners();
    }
  }

  // ✅ CEK FAVORITE
  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  // 🔥 TAMBAH NAIL DARI GALERI
  void addCustomNail(String imagePath) {
    final newNail = Nail(
      id: DateTime.now().toString(),
      name: "My Nail",
      description: '.... "miniature fantasy".',
      price: 100000,
      image: imagePath,
      isFavorite: false,
    );

    nails.insert(0, newNail);
    notifyListeners();
  }

  // ❌ OPTIONAL: HAPUS NAIL
  void deleteNail(String id) {
    nails.removeWhere((n) => n.id == id);
    favorites.remove(id);
    notifyListeners();
  }
}