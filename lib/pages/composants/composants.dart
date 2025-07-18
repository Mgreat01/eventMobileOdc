import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:odc_mobile_template/pages/otp/otpController.dart';

import '../../MonApplication.dart';
import '../../business/models/article/event.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/loginControl.dart';


class navBar extends ConsumerWidget {
  const navBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControlProvider);
    final user = loginState.user;

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F4FF), Color(0xFFEDE7F6)], // tons blanc/violet clair
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.purple.shade100.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purple.shade200, width: 1),
            ),
            child: const Text(
              'EventSpot',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                letterSpacing: 1.5,
              ),
            ),
          ),
          leading: user != null
              ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Tooltip(
              message: "Déconnexion",
              child: CircleAvatar(
                backgroundColor: Colors.purple.withOpacity(0.15),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.purple),
                  onPressed: () async {
                    await ref.read(loginControlProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/public/intro');
                    }
                  },
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Tooltip(
                message: user == null ? "Connexion" : "Recherche",
                child: CircleAvatar(
                  backgroundColor: Colors.purple.withOpacity(0.15),
                  child: IconButton(
                    icon: user == null
                        ? const Icon(Icons.login, color: Colors.purple)
                        : const Icon(FontAwesomeIcons.search, color: Colors.purple),
                    onPressed: () {
                      if (user == null) {
                        context.go('/public/intro');
                      } else {
                        context.go('/app/home');
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BottomBar1 extends ConsumerWidget {
  final int selectedIndex;

  const BottomBar1({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index, WidgetRef ref) {
    final loginState = ref.watch(loginControlProvider);
    final user = loginState.user;

    switch (index) {
      case 0:
        if (user == null) {
          context.go('/public/intro');
        } else {
          context.go('/app/home');
        }
        break;
      case 1:
        context.go('/app/HomeEvent');
        break;
      case 2:
        if (user == null) {
          context.go('/public/intro');
        } else {
          context.go('/app/home');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const gradientStart = Color(0xFF7B61FF);
    const gradientEnd = Color(0xFF9674FF);

    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientStart, gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(context, ref,
                      icon: FontAwesomeIcons.calendarDays,
                      label: 'Événements',
                      index: 0),
                  const SizedBox(width: 60),
                  _buildNavIcon(context, ref,
                      icon: FontAwesomeIcons.user,
                      label: 'Profil',
                      index: 2),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: GestureDetector(
              onTap: () => _onItemTapped(context, 1, ref),
              child: Container(
                height: 70,
                width: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [gradientStart, gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  FontAwesomeIcons.house,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, WidgetRef ref,
      {required IconData icon, required String label, required int index}) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index, ref),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSelected ? 26 : 22,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


class CarteEvent extends ConsumerWidget {
  final Event event;

  const CarteEvent(this.event, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaUrl = event.media?.url;
    final imageUrl = mediaUrl != null
        ? (kIsWeb
        ? 'http://localhost:8000/$mediaUrl'
        : 'http://10.252.252.44:8000/$mediaUrl')
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
      shadowColor: Colors.deepOrange.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image avec coins arrondis
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    color: Colors.black26, size: 80),
              ),
            )
                : Container(
              height: 220,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image_not_supported,
                    color: Colors.black26, size: 80),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  event.title ?? 'Titre inconnu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),


                Text(
                  event.description ?? 'Pas de description disponible.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),

                // Cycle
                Row(
                  children: [
                    const Icon(Icons.loop, color: Colors.deepPurpleAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Cycle : ${event.cycle ?? 'Inconnu'}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Catégories
                if (event.categories != null && event.categories!.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 6.0,
                    children: event.categories!
                        .map((cat) => Chip(
                      label: Text(cat.title ?? 'Catégorie'),
                      backgroundColor: Colors.deepPurpleAccent,
                      labelStyle: const TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class CarteEvenementHorizontal extends StatelessWidget {
  final Event event;

  const CarteEvenementHorizontal({super.key, required this.event});

  @override
  Widget build(BuildContext context) {

    final mediaUrl = event.media?.url;
    final imageUrl = mediaUrl != null
        ? (kIsWeb
        ? 'http://10.252.252.44:8000/$mediaUrl'
        : 'http://10.252.252.44:8000/$mediaUrl')
        : null;


    print(imageUrl);
    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    color: Colors.black26, size: 80),
              ),
            )
                : Container(
              height: 120,
              width: double.infinity,
              color: Colors.deepPurple.shade100,
              child: const Icon(FontAwesomeIcons.image, color: Colors.white70, size: 40),
            ),
          ),
          const SizedBox(height: 8),

          // Titre
          Text(
            event.title ?? "Sans titre",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Date et lieu
          Row(
            children: [
              const Icon(FontAwesomeIcons.calendarAlt, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                event.cycle ?? "Date inconnue",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          Row(
            children: [
              const Icon(FontAwesomeIcons.mapMarkerAlt, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  event.title ?? "Lieu inconnu",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}