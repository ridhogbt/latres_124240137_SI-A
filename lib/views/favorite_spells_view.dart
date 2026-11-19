import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteSpellsView extends StatefulWidget {
  const FavoriteSpellsView({super.key});

  @override
  State<FavoriteSpellsView> createState() => _FavoriteSpellsViewState();
}

class _FavoriteSpellsViewState extends State<FavoriteSpellsView> {
  final Box favoritesBox = Hive.box('favorites');

  Future<void> removeFavorite(String spellName) async {
    await favoritesBox.delete(spellName);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$spellName dihapus dari favorit'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteNames = favoritesBox.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spells'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: favoriteNames.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada mantra favorit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoriteNames.length,
              itemBuilder: (context, index) {
                final spellName = favoriteNames[index].toString();

                final spell = Map<String, dynamic>.from(
                  favoritesBox.get(spellName) as Map,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown.shade100,
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.brown,
                      ),
                    ),
                    title: Text(
                      spell['spell'] ?? spellName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      spell['use'] ?? 'Tidak ada keterangan',
                    ),
                    trailing: IconButton(
                      tooltip: 'Hapus favorit',
                      onPressed: () => removeFavorite(spellName),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
