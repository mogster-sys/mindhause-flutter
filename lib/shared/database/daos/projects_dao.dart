import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/projects_table.dart';
import '../tables/goals_table.dart';

part 'projects_dao.g.dart';

@DriftAccessor(tables: [Projects, Goals])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  // Watch all active projects
  Stream<List<Project>> watchActiveProjects() {
    return (select(projects)
          ..where((t) => t.archived.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  // Watch all projects including archived
  Stream<List<Project>> watchAllProjects() {
    return (select(projects)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch();
  }

  // Get project by ID
  Future<Project?> getProjectById(String id) {
    return (select(projects)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Create project
  Future<void> createProject(ProjectsCompanion project) {
    return into(projects).insert(project);
  }

  // Update project
  Future<bool> updateProject(ProjectsCompanion project) {
    return (update(projects)..where((t) => t.id.equals(project.id.value)))
        .write(project)
        .then((rows) => rows > 0);
  }

  // Archive project
  Future<void> archiveProject(String id) {
    return (update(projects)..where((t) => t.id.equals(id)))
        .write(const ProjectsCompanion(archived: Value(true)));
  }

  // Delete project
  Future<void> deleteProject(String id) {
    return (delete(projects)..where((t) => t.id.equals(id))).go();
  }

  // --- Goals ---

  Stream<List<Goal>> watchActiveGoals() {
    return (select(goals)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm(expression: t.targetDate)]))
        .watch();
  }

  Future<void> createGoal(GoalsCompanion goal) {
    return into(goals).insert(goal);
  }

  Future<void> updateGoal(GoalsCompanion goal) {
    return (update(goals)..where((t) => t.id.equals(goal.id.value)))
        .write(goal);
  }

  Future<void> deleteGoal(String id) {
    return (delete(goals)..where((t) => t.id.equals(id))).go();
  }
}
