import 'package:flutter/material.dart';

class CharacterDetailView extends StatelessWidget {
  final Map<String, dynamic> character;

  const CharacterDetailView({
    super.key,
    required this.character,
  });

  Widget buildDetailItem(String title, dynamic value) {
    final displayValue = value == null || value.toString().isEmpty
        ? 'Unknown'
        : value.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(displayValue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = character['originalTitle'] ?? 'Unknown';

    final String image = character['cover'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FC),
      appBar: AppBar(
        title: const Text('books Detail'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          image,
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const CircleAvatar(
                              radius: 65,
                              backgroundColor: Color(0xFFD7C5BC),
                              child: Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.brown,
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const CircleAvatar(
                        radius: 65,
                        backgroundColor: Color(0xFFD7C5BC),
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.brown,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      character['hogwartsHouse'] ?? 'Unknown House',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Character Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const Divider(height: 24),
                    buildDetailItem(
                      'Title',
                      character['title'],
                    ),
                    buildDetailItem(
                      'original title',
                      character['originalTitle'],
                    ),
                    buildDetailItem(
                      'releasedate',
                      character['releaseDate'],
                    ),
                    buildDetailItem(
                      'deskripsi',
                      character['description'],
                    ),
                    buildDetailItem(
                      'halaman',
                      character['pages'],
                    ),
                    buildDetailItem(
                      'jumlah',
                      character['index'],
                    ),
                    buildDetailItem(
                      'Eye Colour',
                      character['eyeColour'],
                    ),
                    buildDetailItem(
                      'Hair Colour',
                      character['hairColour'],
                    ),
                    buildDetailItem(
                      'Ancestry',
                      character['ancestry'],
                    ),
                    buildDetailItem(
                      'Species',
                      character['species'],
                    ),
                    buildDetailItem(
                      'Wizard',
                      character['wizard'],
                    ),
                    buildDetailItem(
                      'Alive',
                      character['alive'],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
