import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:odc_mobile_template/pages/singleEvent/singleEventCtrl.dart';

import '../auth/loginControl.dart';

class SingleEventPage extends ConsumerStatefulWidget {
  final int? eventId;
  const SingleEventPage({super.key, required this.eventId});

  @override
  ConsumerState<SingleEventPage> createState() => _SingleEventPageState();
}

class _SingleEventPageState extends ConsumerState<SingleEventPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(singleEventControllerProvider.notifier).loadEventById(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(singleEventControllerProvider);
    final event = state.event;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/app/events'),
        ),
        title: const Text("Détails", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (event?.isFavorite ?? false)
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.deepPurpleAccent),
              onPressed: () {},
            ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : event == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "Événement introuvable",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/app/events'),
              child: const Text('Retour aux événements'),
            ),
          ],
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: event.media?.url != null
                  ? Image.network(
                event.media!.url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
                  : Container(
                color: Colors.deepPurple.shade100,
                child: const Center(
                  child: Icon(
                    Icons.event,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et organisateur
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title ?? "Titre non disponible",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (event.createdBy?.name != null)
                              Row(
                                children: [
                                  Icon(Icons.person_outline,
                                      size: 18,
                                      color: theme.colorScheme.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    event.createdBy!.name ??
                                        "Organisateur non disponible",
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (event.isSubscribed)
                        const Chip(
                          label: Text('Inscrit'),
                          backgroundColor: Colors.deepPurpleAccent,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Date et heure
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.event,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.dateTimeStart != null)
                                Text(
                                  _formatDate(event.dateTimeStart!),
                                  style: theme.textTheme.titleMedium,
                                ),
                              if (event.dateTimeEnd != null)
                                Text(
                                  _formatDate(event.dateTimeEnd!),
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    "Description",
                    style: theme.textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: event.isFavorite ? Colors.red.shade100 : Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      icon: Icon(
                        event.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: event.isFavorite ? Colors.red : Colors.black54,
                      ),
                      label: Text(event.isFavorite ? "Retirer des favoris" : "Ajouter aux favoris"),
                      onPressed: () async {
                        var loginState = ref.watch(loginControlProvider);
                        ref.read(singleEventControllerProvider.notifier).favorite(event.id, loginState.user?.token??"");
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    event.description ?? "Description non disponible",
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Cycle et catégories
                  if (event.cycle != null)
                    _buildInfoRow(
                      icon: Icons.loop,
                      label: "Cycle",
                      value: event.cycle!,
                    ),

                  if ((event.categories?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 16),
                    Text(
                      "Catégories",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: event.categories!
                          .map((cat) => Chip(
                        label: Text(cat.title ?? ''),
                        backgroundColor: Colors.deepPurple.shade50,
                        side: BorderSide.none,
                      ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            var loginState = ref.watch(loginControlProvider);
            ref.read(singleEventControllerProvider.notifier).subscribe(event!.id, loginState.user?.token??"");
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("S'inscrire à l'événement"),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("EEEE d MMMM y 'à' HH:mm", "fr_FR").format(date);
    } catch (_) {
      return dateStr;
    }
  }
}