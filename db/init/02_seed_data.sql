-----------------------------------------------------------
-- USERS
-----------------------------------------------------------
INSERT INTO users (id, email, password_hash, name) VALUES
(gen_random_uuid(), 'user1@example.com', 'hash1', 'Alice'),
(gen_random_uuid(), 'user2@example.com', 'hash2', 'Bob'),
(gen_random_uuid(), 'user3@example.com', 'hash3', 'Charlie');


-----------------------------------------------------------
-- USER SETTINGS
-----------------------------------------------------------
INSERT INTO user_settings (user_id, dark_mode) 
SELECT id, FALSE FROM users;


-----------------------------------------------------------
-- MODULE CHA (category)
-----------------------------------------------------------
INSERT INTO modules (id, owner_id, parent_id, name, description, is_public)
SELECT gen_random_uuid(), u.id, NULL, 'IELTS', 'Main IELTS vocabulary', TRUE
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public)
SELECT gen_random_uuid(), u.id, NULL, 'TOEIC', 'TOEIC vocabulary collection', TRUE
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public)
SELECT gen_random_uuid(), u.id, NULL, 'Daily Life', 'Everyday words', FALSE
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public)
SELECT gen_random_uuid(), u.id, NULL, 'Travel', 'Travel related vocabulary', TRUE
FROM users u LIMIT 1;


-----------------------------------------------------------
-- MODULE CON (belong to parent modules)
-----------------------------------------------------------
-- IELTS children
INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'IELTS – Health', 'Health topic vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='IELTS';

INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'IELTS – Environment', 'Environment vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='IELTS';

-- TOEIC children
INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'TOEIC – Office', 'Office vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='TOEIC';

INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'TOEIC – Business', 'Business vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='TOEIC';

-- Daily Life children
INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'Daily – Home', 'Household items'
FROM users u CROSS JOIN modules p WHERE p.name='Daily Life';

INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'Daily – Food', 'Common foods'
FROM users u CROSS JOIN modules p WHERE p.name='Daily Life';

-- Travel children
INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'Travel – Airport', 'Airport vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='Travel';

INSERT INTO modules (id, owner_id, parent_id, name, description)
SELECT gen_random_uuid(), u.id, p.id, 'Travel – Hotel', 'Hotel vocabulary'
FROM users u CROSS JOIN modules p WHERE p.name='Travel';


-----------------------------------------------------------
-- WORDS WITH IPA
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'benefit','lợi ích','noun','/ˈbenɪfɪt/','Exercise has many health benefits.'),
(gen_random_uuid(),'disease','bệnh tật','noun','/dɪˈziːz/','He suffers from a rare disease.'),
(gen_random_uuid(),'treatment','điều trị','noun','/ˈtriːtmənt/','The treatment lasted for three months.'),
(gen_random_uuid(),'pollution','ô nhiễm','noun','/pəˈluːʃən/','Air pollution is increasing.'),
(gen_random_uuid(),'conservation','bảo tồn','noun','/ˌkɒnsəˈveɪʃən/','Animal conservation is important.'),

(gen_random_uuid(),'office','văn phòng','noun','/ˈɒfɪs/','She works in a small office.'),
(gen_random_uuid(),'meeting','cuộc họp','noun','/ˈmiːtɪŋ/','The meeting starts at 9 AM.'),
(gen_random_uuid(),'contract','hợp đồng','noun','/ˈkɒntrækt/','He signed a new contract.'),

(gen_random_uuid(),'kitchen','nhà bếp','noun','/ˈkɪtʃɪn/','The kitchen is very clean.'),
(gen_random_uuid(),'bedroom','phòng ngủ','noun','/ˈbedruːm/','This bedroom is comfortable.'),

(gen_random_uuid(),'apple','quả táo','noun','/ˈæpəl/','She eats an apple every day.'),
(gen_random_uuid(),'rice','gạo','noun','/raɪs/','Vietnamese people eat rice daily.'),

(gen_random_uuid(),'passport','hộ chiếu','noun','/ˈpɑːspɔːt/','Do you have your passport?'),
(gen_random_uuid(),'luggage','hành lý','noun','/ˈlʌgɪdʒ/','Your luggage is overweight.'),
(gen_random_uuid(),'reservation','đặt phòng','noun','/ˌrezəˈveɪʃən/','I have a hotel reservation.'),
(gen_random_uuid(),'flight','chuyến bay','noun','/flaɪt/','The flight was delayed.'),

(gen_random_uuid(),'fitness','thể dục','noun','/ˈfɪtnəs/','Fitness is important for good health.'),
(gen_random_uuid(),'global warming','nóng lên toàn cầu','noun','/ˌɡləʊbəl ˈwɔːmɪŋ/','Global warming affects everyone.'),

(gen_random_uuid(),'business','doanh nghiệp','noun','/ˈbɪznɪs/','She owns a small business.'),
(gen_random_uuid(),'salary','lương','noun','/ˈsæləri/','His salary increased this year.'),

(gen_random_uuid(),'dishwasher','máy rửa chén','noun','/ˈdɪʃˌwɒʃər/','My house has a dishwasher.'),
(gen_random_uuid(),'microwave','lò vi sóng','noun','/ˈmaɪkrəweɪv/','Heat it in the microwave.'),

(gen_random_uuid(),'banana','quả chuối','noun','/bəˈnɑːnə/','I like banana smoothies.'),
(gen_random_uuid(),'chicken','thịt gà','noun','/ˈtʃɪkɪn/','She cooks chicken soup.'),

(gen_random_uuid(),'airport','sân bay','noun','/ˈeəpɔːt/','The airport is crowded.'),
(gen_random_uuid(),'boarding pass','thẻ lên máy bay','noun','/ˈbɔːdɪŋ pɑːs/','Show your boarding pass please.'),
(gen_random_uuid(),'check-in','làm thủ tục','verb','/tʃek ɪn/','You need to check-in early.'),

(gen_random_uuid(),'hotel','khách sạn','noun','/həʊˈtel/','Our hotel has a pool.'),
(gen_random_uuid(),'reception','lễ tân','noun','/rɪˈsepʃən/','Go to the reception desk.'),
(gen_random_uuid(),'key card','thẻ phòng','noun','/ˈkiː kɑːd/','Your key card is ready.');


-----------------------------------------------------------
-- MAP WORDS vào module con NGẪU NHIÊN (50 từ)
-----------------------------------------------------------
INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM words w
JOIN modules m ON m.parent_id IS NOT NULL
ORDER BY RANDOM()
LIMIT 50;


-----------------------------------------------------------
-- GROUP SAMPLE
-----------------------------------------------------------
INSERT INTO groups (id, name, owner_id)
SELECT gen_random_uuid(), 'English Learners', u.id FROM users u LIMIT 1;

INSERT INTO group_members (group_id, user_id)
SELECT g.id, u.id FROM groups g CROSS JOIN users u;


-----------------------------------------------------------
-- GROUP POSTS + MODULE SHARE
-----------------------------------------------------------
INSERT INTO group_posts (id, group_id, user_id, content)
SELECT gen_random_uuid(), g.id, u.id, 'Check out this useful module!'
FROM groups g CROSS JOIN users u LIMIT 1;

INSERT INTO group_post_modules (post_id, module_id)
SELECT p.id, m.id
FROM group_posts p CROSS JOIN modules m
WHERE m.parent_id IS NOT NULL
LIMIT 1;


-----------------------------------------------------------
-- FLASHCARD RESULTS
-----------------------------------------------------------
INSERT INTO flashcard_results (user_id, module_id, correct_count, wrong_count)
SELECT u.id, m.id, 10, 3
FROM users u CROSS JOIN modules m
WHERE m.parent_id IS NOT NULL
LIMIT 3;


-----------------------------------------------------------
-- QUIZ RESULTS + ANSWERS
-----------------------------------------------------------
INSERT INTO quiz_results (id, user_id, module_id, score, total_questions)
SELECT gen_random_uuid(), u.id, m.id, 8, 10
FROM users u CROSS JOIN modules m
WHERE m.parent_id IS NOT NULL
LIMIT 2;

INSERT INTO quiz_answers (quiz_result_id, word_id, user_answer, correct_answer, is_correct)
SELECT q.id, w.id, w.meaning_vi, w.meaning_vi, TRUE
FROM quiz_results q CROSS JOIN words w
LIMIT 10;


-----------------------------------------------------------
-- WORD COMMENTS
-----------------------------------------------------------
INSERT INTO word_comments (user_id, word_id, comment)
SELECT u.id, w.id, 'This word is difficult.'
FROM users u CROSS JOIN words w
LIMIT 5;


-----------------------------------------------------------
-- WORD PRONUNCIATION
-----------------------------------------------------------
INSERT INTO word_pronunciation (user_id, word_id, score)
SELECT u.id, w.id, FLOOR(RANDOM()*100)
FROM users u CROSS JOIN words w
LIMIT 10;
