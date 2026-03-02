import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../data/project_providers.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(activeProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_outlined,
                      size: 64, color: MindHauseTheme.warmStone),
                  const SizedBox(height: 16),
                  Text(
                    'No projects yet.\nTap + to create one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: MindHauseTheme.slateBlue),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return _ProjectCard(
                project: project,
                onTap: () => _showProjectDetail(context, ref, project),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProject(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateProject(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MindHauseTheme.warmStone,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('New Project',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: MindHauseTheme.inkDark)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Project name',
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Description (optional)',
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final now = DateTime.now();
                  await ref.read(projectsDaoProvider).createProject(
                        ProjectsCompanion.insert(
                          id: const Uuid().v4(),
                          name: name,
                          description:
                              Value(descController.text.trim()),
                          createdAt: now,
                        ),
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Project'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectDetail(
      BuildContext context, WidgetRef ref, Project project) {
    final tasksStream =
        ref.read(itemsDaoProvider).watchItemsByProject(project.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MindHauseTheme.warmStone,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(project.color.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(project.name,
                        style: Theme.of(ctx)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'archive') {
                        await ref
                            .read(projectsDaoProvider)
                            .archiveProject(project.id);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } else if (action == 'delete') {
                        await ref
                            .read(projectsDaoProvider)
                            .deleteProject(project.id);
                        if (ctx.mounted) Navigator.pop(ctx);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'archive', child: Text('Archive')),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(project.description,
                    style: TextStyle(color: MindHauseTheme.slateBlue)),
              ],
              if (project.room != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(MindHauseTheme.roomIcon(project.room!),
                        size: 16, color: MindHauseTheme.slateBlue),
                    const SizedBox(width: 6),
                    Text(project.room!,
                        style:
                            TextStyle(color: MindHauseTheme.slateBlue)),
                  ],
                ),
              ],
              const Divider(height: 32),
              const Text('Tasks',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<Item>>(
                  stream: tasksStream,
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final tasks = snapshot.data!;
                    if (tasks.isEmpty) {
                      return Center(
                        child: Text('No tasks in this project',
                            style:
                                TextStyle(color: MindHauseTheme.slateBlue)),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: tasks.length,
                      itemBuilder: (_, i) {
                        final t = tasks[i];
                        return ListTile(
                          leading: Icon(
                            t.status == 'done'
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: t.status == 'done'
                                ? MindHauseTheme.deepOlive
                                : MindHauseTheme.slateBlue,
                          ),
                          title: Text(t.title),
                          subtitle: t.dueDate != null
                              ? Text(t.dueDate.toString().substring(0, 10))
                              : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            context.push('/task/${t.id}');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final projectColor =
        Color(int.parse(project.color.replaceFirst('#', '0xFF')));

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: projectColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    if (project.description.isNotEmpty)
                      Text(project.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: MindHauseTheme.slateBlue)),
                  ],
                ),
              ),
              if (project.room != null) ...[
                Icon(MindHauseTheme.roomIcon(project.room!),
                    size: 20, color: MindHauseTheme.slateBlue),
              ],
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: MindHauseTheme.warmStone),
            ],
          ),
        ),
      ),
    );
  }
}
