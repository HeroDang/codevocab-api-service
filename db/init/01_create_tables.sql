-- Enable UUID extension (nếu PostgreSQL chưa bật)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-----------------------------------------------------------
-- 1. USERS
-----------------------------------------------------------
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT,
    avatar_url TEXT,
    disabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 2. USER SETTINGS
-----------------------------------------------------------
CREATE TABLE user_settings (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    dark_mode BOOLEAN DEFAULT FALSE,
    preferred_language TEXT DEFAULT 'en'
);

-----------------------------------------------------------
-- 3. MODULES  (Dictionary, Learning, Marketplace)
-----------------------------------------------------------
CREATE TABLE modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Là module của user nào
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,

    -- Module cha (category)
    parent_id UUID REFERENCES modules(id) ON DELETE CASCADE,

    -- Thông tin module
    name TEXT NOT NULL,
    description TEXT,

    -- Flag cho Marketplace
    is_public BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 4. WORDS (updated with IPA)
-----------------------------------------------------------
CREATE TABLE words (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    text_en TEXT NOT NULL,
    meaning_vi TEXT,
    part_of_speech TEXT,
    ipa TEXT,                     -- NEW: IPA pronunciation
    example_sentence TEXT,
    audio_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 5. MODULE_WORDS
-----------------------------------------------------------
CREATE TABLE module_words (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES modules(id) ON DELETE CASCADE,
    word_id UUID REFERENCES words(id) ON DELETE CASCADE
);

-----------------------------------------------------------
-- 6. WORD PRONUNCIATION
-----------------------------------------------------------
CREATE TABLE word_pronunciation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    word_id UUID REFERENCES words(id),
    score INT,
    recorded_audio_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 7. WORD COMMENTS (Flashcard Comment)
-----------------------------------------------------------
CREATE TABLE word_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    word_id UUID REFERENCES words(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 8. MODULE SHARES (Share module to user)
-----------------------------------------------------------
CREATE TABLE module_shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES modules(id) ON DELETE CASCADE,
    from_user UUID REFERENCES users(id),
    to_user UUID REFERENCES users(id),
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 9. GROUPS
-----------------------------------------------------------
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 10. GROUP MEMBERS
-----------------------------------------------------------
CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    joined_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 11. GROUP POSTS
-----------------------------------------------------------
CREATE TABLE group_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID REFERENCES groups(id),
    user_id UUID REFERENCES users(id),
    content TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 12. GROUP POST MODULES (module attached to post)
-----------------------------------------------------------
CREATE TABLE group_post_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES group_posts(id) ON DELETE CASCADE,
    module_id UUID REFERENCES modules(id)
);

-----------------------------------------------------------
-- 13. FLASHCARD RESULTS
-----------------------------------------------------------
CREATE TABLE flashcard_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    module_id UUID REFERENCES modules(id),
    correct_count INT,
    wrong_count INT,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 14. QUIZ RESULTS
-----------------------------------------------------------
CREATE TABLE quiz_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    module_id UUID REFERENCES modules(id),
    score INT,
    total_questions INT,
    created_at TIMESTAMP DEFAULT NOW()
);

-----------------------------------------------------------
-- 15. QUIZ ANSWERS
-----------------------------------------------------------
CREATE TABLE quiz_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_result_id UUID REFERENCES quiz_results(id) ON DELETE CASCADE,
    word_id UUID REFERENCES words(id),
    user_answer TEXT,
    correct_answer TEXT,
    is_correct BOOLEAN
);
