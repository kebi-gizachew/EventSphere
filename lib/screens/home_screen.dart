import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/events_bloc.dart';
import '../themes/app_theme.dart';
import '../blocs/events/events_event.dart';
import '../blocs/events/events_state.dart';
import '../models/event_model.dart';
import '../themes/app_colors.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/category_chip.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/search_bar_widget.dart';
import 'event_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(const EventsFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToForm({EventModel? event}) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EventFormScreen(event: event)),
    );
  }

  Future<void> _confirmDelete(EventModel event) async {
    final confirmed = await DeleteEventDialog.show(context, event.title);
    if (confirmed && mounted) {
      context.read<EventsBloc>().add(EventDeleted(event.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listenWhen: (prev, curr) =>
          prev.successMessage != curr.successMessage ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.successMessage != null) {
          SnackbarHelper.showSuccess(context, state.successMessage!);
          context.read<EventsBloc>().add(const EventsMessageCleared());
        }
        if (state.errorMessage != null &&
            state.status == EventsStatus.error) {
          SnackbarHelper.showError(context, state.errorMessage!);
        } else if (state.errorMessage != null && state.isSubmitting == false) {
          SnackbarHelper.showError(context, state.errorMessage!);
          context.read<EventsBloc>().add(const EventsMessageCleared());
        }
      },
      child: AnimatedTheme(
        data: _isDarkMode ? AppTheme.dark : AppTheme.light,
        duration: const Duration(milliseconds: 300),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.appName),
              actions: [
                IconButton(
                  onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                  icon: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: EventSearchBar(
                    controller: _searchController,
                    onChanged: (q) =>
                        context.read<EventsBloc>().add(EventSearchChanged(q)),
                    onClear: () {
                      _searchController.clear();
                      context
                          .read<EventsBloc>()
                          .add(const EventSearchChanged(''));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: const _CategoryFilterRow(),
                ),
                Expanded(child: _buildBody(context)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _navigateToForm(),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (state.status == EventsStatus.loading && !state.isRefreshing) {
          return const LoadingOverlay();
        }

        if (state.status == EventsStatus.error && state.events.isEmpty) {
          return _ErrorView(message: state.errorMessage ?? 'Unknown error');
        }

        final events = state.displayEvents;

        if (state.status == EventsStatus.empty) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const EmptyStateWidget(
                    title: AppStrings.noEventsTitle,
                    subtitle: AppStrings.noEventsSubtitle,
                  ),
                ),
              ],
            ),
          );
        }

        if (events.isEmpty && state.hasFilter) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: const EmptyStateWidget(
                    title: AppStrings.noResultsTitle,
                    subtitle: AppStrings.noResultsSubtitle,
                    isSearch: true,
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    event: event,
                    onEdit: () => _navigateToForm(event: event),
                    onDelete: () => _confirmDelete(event),
                    onFavoriteToggle: () => context
                        .read<EventsBloc>()
                        .add(EventFavoriteToggled(event.id)),
                  );
                },
              ),
            ),
            if (state.isSubmitting)
              Container(
                color: Colors.black26,
                child: const LoadingOverlay(message: 'Processing…'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    context.read<EventsBloc>().add(const EventsRefreshed());
    await context.read<EventsBloc>().stream.firstWhere(
          (s) => !s.isRefreshing,
        );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow();
@override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      buildWhen: (p, c) => p.selectedCategory != c.selectedCategory,
      builder: (context, state) {
        return SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _AllFilterChip(
                selected: state.selectedCategory == null,
                onTap: () => context
                    .read<EventsBloc>()
                    .add(const EventCategoryFilterChanged(null)),
              ),
              ...EventCategory.values.map((cat) {
                final selected = state.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CategoryChip(
                    category: cat,
                    compact: true,
                    selected: selected,
                    onTap: () => context.read<EventsBloc>().add(
                          EventCategoryFilterChanged(
                            selected ? null : cat,
                          ),
                        ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: 20),
            Text(
              'Connection Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightMuted),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<EventsBloc>().add(const EventsFetched()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllFilterChip extends StatelessWidget {
  const _AllFilterChip({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'All',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}