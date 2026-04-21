enum SyncStatus { localOnly, pendingSync, synced, syncError }

abstract class SyncEntity {
  abstract String id;
  abstract DateTime createdAt;
  abstract DateTime updatedAt;
  abstract SyncStatus syncStatus;
  abstract String? createdBy;
  abstract String? updatedBy;
  abstract bool isDeleted;
}
