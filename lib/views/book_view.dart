import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';
import 'login_view.dart';
import 'book_detail_view.dart';
import 'spells_view.dart';

class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  List<dynamic> characters = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://potterapi-fedeperin.vercel.app/en/books?',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          characters = data;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        throw Exception('Gagal mengambil data karakter');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
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

  void openSpells() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SpellsView(),
      ),
    );
  }

  void openCharacterDetail(dynamic character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterDetailView(
          character: Map<String, dynamic>.from(character),
        ),
      ),
    );
  }

  Widget characterCover(dynamic character) {
    final coverUrl = character['cover']?.toString() ?? '';

    if (coverUrl.isEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundColor: Colors.brown.shade100,
        child: const Icon(
          Icons.person,
          color: Colors.brown,
          size: 35,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        coverUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return CircleAvatar(
            radius: 32,
            backgroundColor: Colors.brown.shade100,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.brown,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return CircleAvatar(
            radius: 32,
            backgroundColor: Colors.brown.shade100,
            child: const Icon(
              Icons.person,
              color: Colors.brown,
              size: 35,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FC),
      appBar: AppBar(
        title: const Text('Harry Potter books'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Spells',
            icon: const Icon(Icons.auto_awesome),
            onPressed: openSpells,
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
                          fetchCharacters();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : characters.isEmpty
                  ? const Center(
                      child: Text('Data karakter tidak ditemukan'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final character = characters[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: characterCover(character),
                            title: Text(
                              character['title'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'releasedate: ${character['releaseDate'] ?? 'Unknown'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            onTap: () {
                              openCharacterDetail(character);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
