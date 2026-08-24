/// Versioned SQLite schema for SecureChat X local state.
///
/// The schema stores identifiers, metadata and encrypted blobs only. It must
/// never be interpreted as permission to persist plaintext private keys,
/// recovery phrases, session secrets or message plaintext.
final class SecureChatSqliteSchema {
  const SecureChatSqliteSchema._();

  static const int version = 1;

  static const List<String> createStatements = <String>[
    '''
    CREATE TABLE users (
      id TEXT PRIMARY KEY NOT NULL,
      display_name TEXT NOT NULL,
      identity_public_key BLOB,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE devices (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT NOT NULL,
      label TEXT NOT NULL,
      device_public_key BLOB,
      status TEXT NOT NULL CHECK (status IN ('active', 'revoked', 'pending')),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      last_seen_at INTEGER,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE contacts (
      id TEXT PRIMARY KEY NOT NULL,
      user_id TEXT,
      display_name TEXT NOT NULL,
      identity_public_key BLOB,
      trust_state TEXT NOT NULL CHECK (trust_state IN ('unknown', 'verified', 'changed', 'blocked', 'quarantined')),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
    )
    ''',
    '''
    CREATE TABLE conversations (
      id TEXT PRIMARY KEY NOT NULL,
      kind TEXT NOT NULL CHECK (kind IN ('direct', 'group', 'community')),
      title TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      last_message_at INTEGER
    )
    ''',
    '''
    CREATE TABLE conversation_members (
      conversation_id TEXT NOT NULL,
      member_id TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'member',
      joined_at INTEGER NOT NULL,
      left_at INTEGER,
      PRIMARY KEY (conversation_id, member_id),
      FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
      FOREIGN KEY (member_id) REFERENCES contacts(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE messages (
      id TEXT PRIMARY KEY NOT NULL,
      conversation_id TEXT NOT NULL,
      sender_id TEXT,
      content_ciphertext BLOB,
      content_type TEXT NOT NULL,
      state TEXT NOT NULL CHECK (state IN ('created', 'encrypted', 'queued', 'sent', 'server_ack', 'delivered', 'read', 'failed', 'expired', 'deleted')),
      reply_to_id TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      expires_at INTEGER,
      FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
      FOREIGN KEY (sender_id) REFERENCES contacts(id) ON DELETE SET NULL,
      FOREIGN KEY (reply_to_id) REFERENCES messages(id) ON DELETE SET NULL
    )
    ''',
    '''
    CREATE TABLE message_recipients (
      message_id TEXT NOT NULL,
      recipient_id TEXT NOT NULL,
      state TEXT NOT NULL CHECK (state IN ('queued', 'sent', 'delivered', 'read', 'failed')),
      updated_at INTEGER NOT NULL,
      PRIMARY KEY (message_id, recipient_id),
      FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
      FOREIGN KEY (recipient_id) REFERENCES contacts(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE attachments (
      id TEXT PRIMARY KEY NOT NULL,
      message_id TEXT,
      file_name TEXT NOT NULL,
      mime_type TEXT NOT NULL,
      byte_length INTEGER NOT NULL CHECK (byte_length >= 0),
      content_sha256 BLOB,
      encrypted_key BLOB,
      local_path TEXT,
      state TEXT NOT NULL CHECK (state IN ('pending', 'encrypted', 'queued', 'transferring', 'available', 'failed', 'expired', 'deleted')),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE attachment_chunks (
      attachment_id TEXT NOT NULL,
      chunk_index INTEGER NOT NULL CHECK (chunk_index >= 0),
      byte_length INTEGER NOT NULL CHECK (byte_length >= 0),
      content_sha256 BLOB,
      state TEXT NOT NULL CHECK (state IN ('pending', 'complete', 'failed')),
      PRIMARY KEY (attachment_id, chunk_index),
      FOREIGN KEY (attachment_id) REFERENCES attachments(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE sessions (
      id TEXT PRIMARY KEY NOT NULL,
      device_id TEXT NOT NULL,
      peer_device_id TEXT NOT NULL,
      state_ciphertext BLOB,
      protocol_version INTEGER NOT NULL,
      status TEXT NOT NULL CHECK (status IN ('pending', 'active', 'reset', 'revoked', 'failed')),
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE prekeys (
      id TEXT PRIMARY KEY NOT NULL,
      device_id TEXT NOT NULL,
      kind TEXT NOT NULL CHECK (kind IN ('signed', 'one_time')),
      public_key BLOB NOT NULL,
      private_key_ciphertext BLOB,
      signature BLOB,
      consumed_at INTEGER,
      created_at INTEGER NOT NULL,
      FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE groups (
      id TEXT PRIMARY KEY NOT NULL,
      conversation_id TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      description TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE group_members (
      group_id TEXT NOT NULL,
      contact_id TEXT NOT NULL,
      role TEXT NOT NULL CHECK (role IN ('member', 'admin', 'owner')),
      joined_at INTEGER NOT NULL,
      left_at INTEGER,
      PRIMARY KEY (group_id, contact_id),
      FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
      FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE community_state (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      joined INTEGER NOT NULL CHECK (joined IN (0, 1)),
      suppressed_until INTEGER,
      updated_at INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE calls (
      id TEXT PRIMARY KEY NOT NULL,
      conversation_id TEXT,
      kind TEXT NOT NULL CHECK (kind IN ('voice', 'video')),
      state TEXT NOT NULL CHECK (state IN ('inviting', 'ringing', 'connecting', 'connected', 'reconnecting', 'ended', 'failed')),
      started_at INTEGER,
      ended_at INTEGER,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL
    )
    ''',
    '''
    CREATE TABLE call_events (
      id TEXT PRIMARY KEY NOT NULL,
      call_id TEXT NOT NULL,
      event_type TEXT NOT NULL,
      event_ciphertext BLOB,
      created_at INTEGER NOT NULL,
      FOREIGN KEY (call_id) REFERENCES calls(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE delivery_receipts (
      message_id TEXT NOT NULL,
      contact_id TEXT NOT NULL,
      delivered_at INTEGER NOT NULL,
      PRIMARY KEY (message_id, contact_id),
      FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
      FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE read_receipts (
      message_id TEXT NOT NULL,
      contact_id TEXT NOT NULL,
      read_at INTEGER NOT NULL,
      PRIMARY KEY (message_id, contact_id),
      FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
      FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE drafts (
      id TEXT PRIMARY KEY NOT NULL,
      conversation_id TEXT NOT NULL UNIQUE,
      text_ciphertext BLOB,
      updated_at INTEGER NOT NULL,
      FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
    )
    ''',
    '''
    CREATE TABLE app_settings (
      key TEXT PRIMARY KEY NOT NULL,
      value_ciphertext BLOB,
      updated_at INTEGER NOT NULL
    )
    ''',
    '''
    CREATE TABLE security_events (
      id TEXT PRIMARY KEY NOT NULL,
      event_type TEXT NOT NULL,
      severity TEXT NOT NULL CHECK (severity IN ('info', 'warning', 'critical')),
      subject_id TEXT,
      details_ciphertext BLOB,
      created_at INTEGER NOT NULL
    )
    ''',
  ];

  static const List<String> createIndexes = <String>[
    'CREATE INDEX idx_devices_user_status ON devices(user_id, status)',
    'CREATE INDEX idx_contacts_trust_updated ON contacts(trust_state, updated_at DESC)',
    'CREATE INDEX idx_conversations_last_message ON conversations(last_message_at DESC)',
    'CREATE INDEX idx_members_member ON conversation_members(member_id, conversation_id)',
    'CREATE INDEX idx_messages_conversation_created ON messages(conversation_id, created_at DESC, id DESC)',
    'CREATE INDEX idx_messages_state_created ON messages(state, created_at ASC)',
    'CREATE INDEX idx_messages_expiry ON messages(expires_at)',
    'CREATE INDEX idx_recipients_state_updated ON message_recipients(state, updated_at ASC)',
    'CREATE INDEX idx_attachments_message ON attachments(message_id, created_at ASC)',
    'CREATE INDEX idx_attachments_state_updated ON attachments(state, updated_at ASC)',
    'CREATE INDEX idx_sessions_devices ON sessions(device_id, peer_device_id, status)',
    'CREATE INDEX idx_prekeys_device_kind_consumed ON prekeys(device_id, kind, consumed_at)',
    'CREATE INDEX idx_group_members_contact ON group_members(contact_id, group_id)',
    'CREATE INDEX idx_calls_conversation_created ON calls(conversation_id, created_at DESC)',
    'CREATE INDEX idx_call_events_call_created ON call_events(call_id, created_at ASC)',
    'CREATE INDEX idx_security_events_created ON security_events(created_at DESC, id DESC)',
  ];

  static Future<void> create(DatabaseExecutorLike db) async {
    for (final String statement in createStatements) {
      await db.execute(statement);
    }
    for (final String statement in createIndexes) {
      await db.execute(statement);
    }
  }
}

/// Minimal executor contract used by the schema runner.
/// It avoids coupling the schema definition to the sqflite package API.
abstract interface class DatabaseExecutorLike {
  Future<void> execute(String sql, [List<Object?>? arguments]);
}
