import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/api_service.dart';
import 'court_detail_screen.dart';

class CourtsScreen extends StatefulWidget {
  const CourtsScreen({super.key});

  @override
  State<CourtsScreen> createState() => _CourtsScreenState();
}

class _CourtsScreenState extends State<CourtsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Court>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _courtsFuture = _apiService.getCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Courts'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Court>>(
        future: _courtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _courtsFuture = _apiService.getCourts()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final courts = snapshot.data ?? [];
          if (courts.isEmpty) {
            return const Center(child: Text('No courts available'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourtDetailScreen(court: court),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                court.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (court.isIndoor)
                              Chip(
                                label: const Text('Indoor'),
                                backgroundColor: Colors.blue.shade100,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.sports_tennis, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text('Surface: ${court.surface}'),
                            const SizedBox(width: 16),
                            if (court.prices.isNotEmpty) ...[
                              Icon(Icons.attach_money, size: 16, color: Colors.grey.shade600),
                              Text('From \$${court.prices.first.price.toStringAsFixed(2)}/hr'),
                            ],
                          ],
                        ),
                        if (court.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            court.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
