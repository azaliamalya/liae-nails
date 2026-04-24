import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nail.dart';

class NailService {
  final String baseUrl =
      "https://69e97fd355d62f34797a91a4.mockapi.io/api/v1/nails";

  Future<List<Nail>> getNails(String token) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        // 🔥 FILTER DATA API
        final filtered = data
            .map((e) => Nail.fromJson(e))
            .where((nail) =>
                nail.image.startsWith("http") && // hanya gambar valid
                nail.name.startsWith("LIAÉ"))    // hanya data asli kamu
            .toList();

        // 🔥 kalau API kosong / tidak sesuai → pakai lokal
        if (filtered.isNotEmpty) {
          return filtered;
        } else {
          return _localData();
        }
      } else {
        return _localData();
      }
    } catch (e) {
      return _localData();
    }
  }

  // =========================
  // 🔥 DATA LOKAL (BACKUP)
  // =========================
  List<Nail> _localData() {
    return [
      Nail(
        id: "1",
        name: "LIAÉ Soft Glam Nails ",
        image: "https://i.imgur.com/3kKHua1.png",
        description: 'Soft Glam Nails adalah pilihan sempurna buat kamu yang suka tampilan elegan tapi tetap simpel. Desain ini menggabungkan warna-warna nude, pink lembut, atau milky white dengan sentuhan glossy yang halus, menciptakan kesan bersih dan classy. Biasanya dihiasi detail tipis seperti glitter lembut, chrome ringan, atau aksen garis minimalis yang bikin kuku terlihat mewah tanpa berlebihan.',
        price: 85000,
      ),
      Nail(
        id: "2",
        name: "LIAÉ Sweet Pastel Nails ",
        image: "https://i.imgur.com/sZ43Gft.png",
        description: 'Sweet Pastel Nails menghadirkan tampilan kuku yang manis, lembut, dan penuh warna ceria. Menggunakan perpaduan warna pastel seperti baby pink, lilac, mint green, baby blue, dan peach, desain ini memberikan kesan fresh dan playful. Biasanya dipadukan dengan detail lucu seperti bunga kecil, heart, swirl, atau gradasi warna yang halus, membuat kuku terlihat lebih hidup dan aesthetic.',
        price: 75000,
      ),
      Nail(
        id: "3",
        name: "LIAÉ Bold & Edgy Nails ",
        image: "https://i.imgur.com/9OP9Re7.png",
        description: 'Bold & Edgy Nails menampilkan gaya kuku yang berani, tegas, dan penuh karakter. Biasanya menggunakan warna-warna kuat seperti hitam, merah tua, neon, atau metallic, dipadukan dengan desain yang standout seperti flame, abstract lines, chrome, atau aksen stud dan glitter yang mencolok.',
        price: 95000,
      ),
            Nail(
        id: "4",
        name: "LIAÉ Crystal Nude Glam Nails ",
        image: "https://i.imgur.com/3KXJQ7E.png",
        description: 'Crystal Nude Glam Nails menghadirkan perpaduan aesthetic antara kelembutan nude tones dan kilauan crystal yang memantulkan cahaya secara halus. Look ini menggambarkan kesan soft luxury—tidak terlalu mencolok, tapi tetap terasa mahal dan berkelas.',
        price: 120000,
      ),
            Nail(
        id: "5",
        name: "LIAÉ Clean Glow Nails ",
        image: "https://i.imgur.com/y6QqJnq.png",
        description: 'Clean Glow Nails adalah gaya kuku yang menonjolkan keindahan alami dengan tampilan yang bersih, sehat, dan berkilau lembut. Desain ini biasanya menggunakan warna-warna nude, milky, atau transparan dengan sentuhan glossy yang memberikan efek “glow from within”. Cocok untuk kamu yang suka tampilan simpel tapi tetap elegan, Clean Glow Nails memberikan kesan rapi, fresh, dan effortless beauty di setiap penampilan.',
        price: 75000,
      ),
            Nail(
        id: "6",
        name: "LIAÉ Soft Peach Nails ",
        image: "https://i.imgur.com/D0FvQ4u.png",
        description: 'Soft Peach Nails adalah gaya kuku dengan warna peach lembut (perpaduan oranye dan pink pastel) yang memberikan kesan hangat, manis, dan segar. Warna ini tidak terlalu mencolok, tapi cukup untuk memberi sentuhan warna yang hidup pada tampilan kuku.',
        price: 70000,
      ),
            Nail(
        id: "7",
        name: "LIAÉ Candy Pop Nails ",
        image: "https://i.imgur.com/mzXO8Hq.png",
        description: 'Candy Pop Nails adalah gaya kuku dengan warna-warna cerah, playful, dan penuh energi yang terinspirasi dari tampilan permen dan dunia yang fun. Biasanya menggunakan kombinasi warna pastel hingga neon, kadang ditambah elemen lucu seperti swirl, dot, atau bahkan aksen 3D yang unik.',
        price: 85000,
      ),
            Nail(
        id: "8",
        name: "LIAÉ Kawaii Charm Nails ",
        image: "https://i.imgur.com/VdpVxc8.png",
        description: 'Kawaii Charm Nails menghadirkan tampilan kuku yang playful, dreamy, dan ultra-cute, seperti dunia imajinasi yang dituangkan langsung ke dalam kuku. Setiap detailnya terasa hidup—mulai dari warna pastel yang lembut hingga hiasan 3D yang menciptakan efek "miniature fantasy".',
        price: 100000,
      ),
            Nail(
        id: "9",
        name: "LIAÉ Luxe Gold Veil Nails ",
        image: "https://i.imgur.com/RTbM7Je.png",
        description: 'Luxe Gold Veil Nails menghadirkan tampilan yang halus, berkelas, dan understated luxury—seperti kilau emas tipis yang menyelimuti kuku secara lembut. Efek “veil”-nya memberikan tampilan seolah cahaya emas menyatu dengan base kuku, bukan sekadar hiasan di atasnya.',
        price: 90000,
      ),
            Nail(
        id: "10",
        name: "LIAÉ Velvet Nails ",
        image: "https://i.imgur.com/InDXbt5.png",
        description: 'Velvet Nails adalah gaya kuku dengan efek berkilau halus seperti kain beludru (velvet) yang berubah-ubah saat terkena cahaya. Efek ini biasanya dibuat dengan magnetic gel (cat eye) yang menciptakan dimensi lembut dan refleksi yang terlihat “hidup”.',
        price: 95000,
    ),
    ];
  }
}

