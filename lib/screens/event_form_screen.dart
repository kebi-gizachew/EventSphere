import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/events_bloc.dart';
import '../blocs/events/events_event.dart';
import '../models/event_model.dart';
import '../themes/app_colors.dart';
import '../utils/constants.dart';
import '../utils/event_metadata_generator.dart';
class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key, this.event});

  final EventModel? event;

  bool get isEditing => event != null;

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _organizerController;
  late final TextEditingController _locationController;
  late EventCategory _category;
  late bool _isUpcoming;
  late DateTime _eventDate;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleController = TextEditingController(text: e?.title ?? '');
    _organizerController =
        TextEditingController(text: e?.organizerId.toString() ?? '1');
    _locationController =
        TextEditingController(text: e?.location ?? 'Austin Convention Center');
    _category = e?.category ?? EventCategory.technology;
    _isUpcoming = e?.isUpcoming ?? true;
    _eventDate = e?.eventDate ?? EventMetadataGenerator.dateForId(1);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _organizerController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final organizerId = int.tryParse(_organizerController.text.trim()) ?? 1;
    final model = EventModel(
      id: widget.event?.id ?? 0,
      title: _titleController.text.trim(),
      organizerId: organizerId,
      completed: !_isUpcoming,
      category: _category,
      eventDate: _eventDate,
      location: _locationController.text.trim(),
      isFavorite: widget.event?.isFavorite ?? false,
    );

    final bloc = context.read<EventsBloc>();
    if (widget.isEditing) {
      bloc.add(EventUpdated(model));
    } else {
      bloc.add(EventAdded(model));
    }
    Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _eventDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _eventDate.hour,
          _eventDate.minute,
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? AppStrings.editEvent : AppStrings.addEvent,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter an event title';
                  }
                  if (v.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EventCategory>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: EventCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizerController,
                decoration: const InputDecoration(labelText: 'Organizer ID'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Organizer ID is required';
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'Enter a valid numeric ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Event Date'),
                subtitle: Text(EventMetadataGenerator.formattedDate(_eventDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Upcoming event'),
                subtitle: Text(_isUpcoming ? 'Not completed' : 'Completed'),
                value: _isUpcoming,
                onChanged: (v) => setState(() => _isUpcoming = v),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: Text(
                  widget.isEditing ? AppStrings.update : AppStrings.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}