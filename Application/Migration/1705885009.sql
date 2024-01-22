ALTER TABLE comments DROP CONSTRAINT comments_ref_post_id;
ALTER TABLE comments DROP CONSTRAINT comments_ref_user_id;
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE;
ALTER TABLE comments ADD CONSTRAINT comments_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
