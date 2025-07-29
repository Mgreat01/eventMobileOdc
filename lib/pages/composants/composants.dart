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

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: const Text(
        'EventSpot',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
      leading: user != null
          ? IconButton(
        icon: const Icon(Icons.logout, color: Colors.black54),
        onPressed: () async {
          await ref.read(loginControlProvider.notifier).logout();
          if (context.mounted) {
            context.go('/public/intro');
          }
        },
      )
          : null,
      actions: [
        IconButton(
          icon: Icon(
            user == null ? Icons.login : Icons.search,
            color: Colors.black54,
          ),
          onPressed: () {
            if (user == null) {
              context.go('/public/intro');
            } else {
              context.go('/app/home');
            }
          },
        ),
      ],
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
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavIcon(
            context,
            ref,
            icon: Icons.event,
            label: 'Événements',
            index: 0,
          ),
          const SizedBox(width: 40),
          _buildNavIcon(
            context,
            ref,
            icon: Icons.person,
            label: 'Profil',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(
      BuildContext context,
      WidgetRef ref, {
        required IconData icon,
        required String label,
        required int index,
      }) {
    final isSelected = selectedIndex == index;

    return SizedBox(
      height: 56, // hauteur fixe adaptée à un BottomAppBar
      child: GestureDetector(
        onTap: () => _onItemTapped(context, index, ref),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.deepPurple : Colors.grey,
              size: 24,
            ),
            SizedBox(height: 2), // petit espacement pour éviter l'overflow
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
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

    return GestureDetector(
      onTap: () {
        context.go('/events/${event.id}');
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important pour éviter l'overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[100],
                    child: const Icon(Icons.broken_image,
                        color: Colors.black26, size: 60),
                  ),
                )
                    : Container(
                  height: 180,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.black26, size: 60),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? 'Titre inconnu',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description ?? 'Pas de description disponible.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.loop, color: Colors.grey[500], size: 18),
                        const SizedBox(width: 6),
                        Flexible( // Utilisez Flexible pour le texte long
                          child: Text(
                            "Cycle : ${event.cycle ?? 'Inconnu'}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (event.categories != null && event.categories!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 6.0,
                          children: event.categories!
                              .map((cat) => Chip(
                            label: Text(
                              cat.title ?? 'Catégorie',
                              overflow: TextOverflow.ellipsis,
                            ),
                            backgroundColor: Colors.grey[100],
                            labelStyle: const TextStyle(color: Colors.black87),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

    return SizedBox(
      width: 240,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.broken_image,
                        color: Colors.black26, size: 40),
                  ),
                )
                    : Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(FontAwesomeIcons.image,
                        color: Colors.black26, size: 32),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title ?? "Sans titre",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.calendarAlt,
                    text: event.cycle ?? "Date inconnue",
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.mapMarkerAlt,
                    text: event.title ?? "Lieu inconnu",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}