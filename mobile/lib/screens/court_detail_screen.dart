import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/court.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

class CourtDetailScreen extends StatefulWidget {
  final Court court;

  const CourtDetailScreen({super.key, required this.court});

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final booking = await _apiService.createBooking(
        courtId: widget.court.id,
        guestName: _nameController.text,
        guestEmail: _emailController.text,
        guestPhone: _phoneController.text,
        bookingDate: _selectedDate!,
        startTime: _startTime!.format(context),
        endTime: _endTime!.format(context),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.court.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Court Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sports_tennis, size: 32),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.court.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text('${widget.court.surface} • ${widget.court.isIndoor ? "Indoor" : "Outdoor"}'),
                          ],
                        ),
                      ],
                    ),
                    if (widget.court.description != null) ...[
                      const SizedBox(height: 12),
                      Text(widget.court.description!),
                    ],
                    const SizedBox(height: 16),
                    const Text('Prices:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.court.prices.map((price) {
                        return Chip(
                          label: Text('\$${price.price.toStringAsFixed(2)} ${price.priceType}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Book This Court',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v?.isEmpty == true) return 'Required';
                      if (!v!.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  // Date Selection
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _selectDate,
                  ),
                  const Divider(),
                  // Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_startTime == null
                              ? 'Start Time'
                              : _startTime!.format(context)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () => _selectTime(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_endTime == null
                              ? 'End Time'
                              : _endTime!.format(context)),
                          trailing: const Icon(Icons.access_time),
                          onTap: () => _selectTime(false),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitBooking,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
