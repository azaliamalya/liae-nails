import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/nail_provider.dart';
import '../models/nail.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = "";
  String selectedCategory = "All";
  Timer? _debounce;

  final categories = ["All", "Soft Glam", "Pastel", "Bold"];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NailProvider>().fetchNails(widget.token);
    });
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        search = value.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  String formatPrice(int price) {
    return "Rp ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ".",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NailProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF9ECF),
              Color(0xFFFFC1E3),
              Color(0xFFFFE4F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearch(),
              _buildBanner(),
              const SizedBox(height: 15),
              _buildCategory(),
              const SizedBox(height: 10),

              Expanded(
                child: provider.isLoading
                    ? _buildShimmer()
                    : _buildList(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔍 SEARCH
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: "Search nail...",
            prefixIcon: Icon(Icons.search, color: Colors.pink),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }

  // 🔥 BANNER
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6FA5), Color(0xFFFF9ECF)],
          ),
        ),
        child: const Center(
          child: Text(
            "New Collection Drop",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 🏷️ CATEGORY
  Widget _buildCategory() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final selected = cat == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = cat);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.pink : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 📋 LIST
  Widget _buildList(NailProvider provider) {
    final filtered = provider.nails.where((nail) {
      final matchSearch = nail.name.toLowerCase().contains(search);

      final matchCategory = selectedCategory == "All" ||
          nail.name.toLowerCase().contains(selectedCategory.toLowerCase());

      return matchSearch && matchCategory;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "No nails found",
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final nail = filtered[i];

        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 250 + (i * 40)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (_, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _card(nail, provider),
        );
      },
    );
  }

  // 💅 CARD
  Widget _card(Nail nail, NailProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(nail: nail),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: _buildImage(nail.image),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nail.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      formatPrice(nail.price),
                      style: const TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      nail.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            IconButton(
              icon: Icon(
                provider.isFavorite(nail.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.pink,
              ),
              onPressed: () {
                provider.toggleFavorite(nail.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🖼️ IMAGE (SUPER FIX)
  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          width: 90,
          height: 90,
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          width: 90,
          height: 90,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else {
      return Image.asset(
        path,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
    }
  }

  // ✨ SHIMMER
  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}