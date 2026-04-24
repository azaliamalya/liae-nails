import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/nail_provider.dart';
import '../models/nail.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final String token;

  const FavoriteScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NailProvider>();
    final width = MediaQuery.of(context).size.width;

    final favoriteNails = provider.nails
        .where((nail) => provider.favorites.contains(nail.id))
        .toList();

    final isMobile = width < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : favoriteNails.isEmpty
                  ? const Center(
                      child: Text(
                        "No favorites yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: isMobile
                          ? _buildList(favoriteNails, provider, context)
                          : _buildGrid(favoriteNails, provider, context),
                    ),
        ),
      ),
    );
  }

  // =========================
  // 📱 LIST (MOBILE)
  // =========================
  Widget _buildList(
      List<Nail> nails, NailProvider provider, BuildContext context) {
    return ListView.builder(
      itemCount: nails.length,
      itemBuilder: (_, i) {
        return _cardHorizontal(nails[i], provider, context);
      },
    );
  }

  // =========================
  // 💻 GRID (WEB)
  // =========================
  Widget _buildGrid(
      List<Nail> nails, NailProvider provider, BuildContext context) {
    return GridView.builder(
      itemCount: nails.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, i) {
        return _cardVertical(nails[i], provider, context);
      },
    );
  }

  // =========================
  // 💅 CARD MOBILE
  // =========================
  Widget _cardHorizontal(
      Nail nail, NailProvider provider, BuildContext context) {
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: _buildImage(nail.image, 100, 100),
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
                    const SizedBox(height: 5),
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
              icon: const Icon(Icons.favorite, color: Colors.pink),
              onPressed: () => provider.toggleFavorite(nail.id),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // 💎 CARD WEB
  // =========================
  Widget _cardVertical(
      Nail nail, NailProvider provider, BuildContext context) {
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
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
              child: _buildImage(nail.image, double.infinity, 160),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nail.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    nail.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const Spacer(),

            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.pink),
                onPressed: () => provider.toggleFavorite(nail.id),
              ),
            )
          ],
        ),
      ),
    );
  }

  // =========================
  // 🖼️ IMAGE
  // =========================
  Widget _buildImage(String path, double width, double height) {
    if (path.isNotEmpty && path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.pink.shade100,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.pink.shade100,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.pink.shade100,
        child: const Icon(Icons.image),
      );
    }
  }
}