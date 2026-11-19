import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import '../services/auth_service.dart';
import 'login_view.dart';
import 'favorite_spells_view.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  List<dynamic> spells = [];
  bool isLoading = true;
  String? errorMessage;

  final Box favoritesBox = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    fetchSpells();
  }

  Future<void> fetchSpells() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://potterapi-fedeperin.vercel.app/en/spells',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          spells = data;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        throw Exception('Gagal mengambil data mantra');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  bool isFavorite(dynamic spell) {
    final spellName = spell['spell']?.toString() ?? '';
    return favoritesBox.containsKey(spellName);
  }

  Future<void> toggleFavorite(dynamic spell) async {
    final spellName = spell['spell']?.toString() ?? '';
    final spellUse = spell['use']?.toString() ?? 'Tidak ada keterangan';

    if (spellName.isEmpty) return;

    if (isFavorite(spell)) {
      await favoritesBox.delete(spellName);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$spellName dihapus dari favorit'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      await favoritesBox.put(spellName, {
        'spell': spellName,
        'use': spellUse,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$spellName ditambahkan ke favorit'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {});
  }

  Future<void> handleLogout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoriteSpellsView(),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Favorite Spells',
            icon: const Icon(Icons.favorite),
            onPressed: openFavorites,
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          fetchSpells();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : spells.isEmpty
                  ? const Center(
                      child: Text('Data mantra tidak ditemukan'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: spells.length,
                      itemBuilder: (context, index) {
                        final spell = spells[index];
                        final favorite = isFavorite(spell);

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
                              spell['spell']?.toString() ?? 'Unknown Spell',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              spell['use']?.toString() ??
                                  'Tidak ada keterangan',
                            ),
                            trailing: IconButton(
                              onPressed: () => toggleFavorite(spell),
                              icon: Icon(
                                favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favorite ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
