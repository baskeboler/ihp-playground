ALTER TABLE comments DROP COLUMN user_id;
ALTER TABLE comments ADD COLUMN author TEXT NOT NULL;
