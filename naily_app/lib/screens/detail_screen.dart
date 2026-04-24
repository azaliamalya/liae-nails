import 'package:flutter/material.dart';
import '../models/nail.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Nail nail;

  const DetailScreen({super.key, required this.nail});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {

  // =========================
  // 💰 FORMAT HARGA
  // =========================
  String formatPrice(int price) {
    return "Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ".",
    )}";
  }

  // =========================
  // 📲 WHATSAPP
  // =========================
  Future<void> _openWhatsApp(Nail nail) async {
    const phone = "6281214505270"; // ganti nomor kamu

    final message =
        "Halo, saya ingin booking ${nail.name} dengan harga ${formatPrice(nail.price)}";

    final url = Uri.parse(
      "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
    );

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka WhatsApp")),
      );
    }
  }

  // =========================
  // 🎬 ANIMATION
  // =========================
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _slideAnim = Tween(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // =========================
  // 💬 POPUP
  // =========================
  void _showBookingPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Confirm Booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text("Book ${widget.nail.name}?"),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openWhatsApp(widget.nail);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // 🖥️ UI
  // =========================
  @override
  Widget build(BuildContext context) {
    final nail = widget.nail;
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(nail.name),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF9ECF),
              Color(0xFFFFC1E3),
              Color(0xFFFFE4F2),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: isMobile
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        _imageSection(nail),
                        const SizedBox(height: 20),
                        _detailSection(nail),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      Expanded(child: _imageSection(nail)),
                      const SizedBox(width: 20),
                      Expanded(child: _detailSection(nail)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // =========================
  // 🖼️ IMAGE FIX CEPAT
  // =========================
  Widget _imageSection(Nail nail) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        nail.image,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,

        // 🔥 LOADING FIX
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;

          return Container(
            height: 300,
            color: Colors.pink.shade100,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },

        // 🔥 ERROR FIX
        errorBuilder: (_, __, ___) => Container(
          height: 300,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, size: 80),
        ),
      ),
    );
  }

  // =========================
  // 📄 DETAIL
  // =========================
  Widget _detailSection(Nail nail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nail.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              SizedBox(width: 5),
              Text("4.9 (120 reviews)"),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            formatPrice(nail.price),
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            nail.description,
            style: const TextStyle(height: 1.5),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _showBookingPopup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}