-----------------------------------------------------------
-- USERS
-----------------------------------------------------------
INSERT INTO users (id, email, password_hash, name, avatar_url, role, disabled)
VALUES
(gen_random_uuid(), 'user1@example.com', '$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C', 'Alice', NULL, 'user', FALSE),
(gen_random_uuid(), 'user2@example.com', '$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C', 'Bob', NULL, 'user', FALSE),
(gen_random_uuid(), 'user3@example.com', '$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C', 'Charlie', NULL, 'user', FALSE)
(gen_random_uuid(), 'admin@example.com', '12345', 'Admin', NULL, 'admin', FALSE)
(gen_random_uuid(), 'rootuser@example.com', '12345', 'User', NULL, 'user', FALSE)
ON CONFLICT (email) DO NOTHING;


-----------------------------------------------------------
-- USER SETTINGS
-----------------------------------------------------------
INSERT INTO user_settings (user_id, dark_mode) 
SELECT id, FALSE FROM users;


-----------------------------------------------------------
-- MODULE CHA (category)
-----------------------------------------------------------
INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT gen_random_uuid(), u.id, NULL, 'IELTS', 'Main IELTS vocabulary', TRUE, 'system'
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT gen_random_uuid(), u.id, NULL, 'TOEIC', 'TOEIC vocabulary collection', TRUE, 'system'
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT gen_random_uuid(), u.id, NULL, 'Daily Life', 'Everyday words', FALSE, 'system'
FROM users u LIMIT 1;

INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT gen_random_uuid(), u.id, NULL, 'Travel', 'Travel related vocabulary', TRUE, 'system'
FROM users u LIMIT 1;


-----------------------------------------------------------
-- MODULE CON (belong to parent modules)
-----------------------------------------------------------
-- IELTS children
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'IELTS – Health', 'Health topic vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='IELTS';

INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'IELTS – Environment', 'Environment vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='IELTS';

-- TOEIC children
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'TOEIC – Office', 'Office vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='TOEIC';

INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'TOEIC – Business', 'Business vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='TOEIC';

-- Daily Life children
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'Daily – Home', 'Household items', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='Daily Life';

INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'Daily – Food', 'Common foods', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='Daily Life';

-- Travel children
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'Travel – Airport', 'Airport vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='Travel';

INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT gen_random_uuid(), u.id, p.id, 'Travel – Hotel', 'Hotel vocabulary', 'system'
FROM users u CROSS JOIN modules p WHERE p.name='Travel';

-----------------------------------------------------------
-- MODULE CHA: TỪ VỰNG LẬP TRÌNH CƠ BẢN
-----------------------------------------------------------
INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    NULL,
    'Basic programming',
    'Basic programming vocabulary',
    TRUE,
    'system'
FROM users u
WHERE u.role = 'admin'
LIMIT 1;


-----------------------------------------------------------
-- MODULE CON: TỪ VỰNG LẬP TRÌNH CƠ BẢN
-----------------------------------------------------------

-- Nhập môn lập trình
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Introduction to programming',
    'Introduction to programming',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Basic programming';

-- Cơ sở dữ liệu
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Database fundamentals',
    'Database fundamentals vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Basic programming';

-- Hệ điều hành
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Operating system',
    'Operating system vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Basic programming';

-- Hướng đối tượng
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Object-oriented programming',
    'Object-oriented programming vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Basic programming';


-----------------------------------------------------------
-- MODULE CHA: TỪ VỰNG CHUYÊN NGÀNH PHẦN MỀM
-----------------------------------------------------------
INSERT INTO modules (id, owner_id, parent_id, name, description, is_public, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    NULL,
    'Software engineering',
    'Software engineering vocabulary',
    TRUE,
    'system'
FROM users u
WHERE u.role = 'admin'
LIMIT 1;


-----------------------------------------------------------
-- MODULE CON: TỪ VỰNG CHUYÊN NGÀNH PHẦN MỀM
-----------------------------------------------------------

-- Pervasive Computing
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Pervasive Computing',
    'Pervasive computing vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Software engineering';

-- Mobile Computing
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Mobile Computing',
    'Mobile computing vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Software engineering';

-- Distributed Computing
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Distributed Computing',
    'Distributed systems vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Software engineering';

-- Cloud Computing
INSERT INTO modules (id, owner_id, parent_id, name, description, module_type)
SELECT
    gen_random_uuid(),
    u.id,
    p.id,
    'Cloud Computing',
    'Cloud computing vocabulary',
    'system'
FROM users u
CROSS JOIN modules p
WHERE u.role = 'admin'
  AND p.name = 'Software engineering';


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
-- NHẬP MÔN LẬP TRÌNH (≈ 25 từ)
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'algorithm','thuật toán','noun','/ˈælɡərɪðəm/','Algorithms solve problems step by step.'),
(gen_random_uuid(),'variable','biến','noun','/ˈveəriəbl/','Variables store data.'),
(gen_random_uuid(),'constant','hằng số','noun','/ˈkɒnstənt/','Constants do not change.'),
(gen_random_uuid(),'function','hàm','noun','/ˈfʌŋkʃən/','Functions group logic.'),
(gen_random_uuid(),'parameter','tham số','noun','/pəˈræmɪtə/','Parameters pass values.'),
(gen_random_uuid(),'return value','giá trị trả về','noun','/rɪˈtɜːn/','Functions return values.'),
(gen_random_uuid(),'loop','vòng lặp','noun','/luːp/','Loops repeat instructions.'),
(gen_random_uuid(),'condition','điều kiện','noun','/kənˈdɪʃən/','Conditions control flow.'),
(gen_random_uuid(),'if statement','câu lệnh if','noun','/ɪf ˈsteɪtmənt/','If statements branch logic.'),
(gen_random_uuid(),'compiler','trình biên dịch','noun','/kəmˈpaɪlə/','Compilers translate code.'),
(gen_random_uuid(),'interpreter','trình thông dịch','noun','/ɪnˈtɜːprɪtə/','Interpreters execute code directly.'),
(gen_random_uuid(),'syntax','cú pháp','noun','/ˈsɪntæks/','Syntax defines structure.'),
(gen_random_uuid(),'runtime','thời gian chạy','noun','/ˈrʌntaɪm/','Errors may appear at runtime.'),
(gen_random_uuid(),'debug','gỡ lỗi','verb','/diːˈbʌɡ/','Debug to find bugs.'),
(gen_random_uuid(),'bug','lỗi','noun','/bʌɡ/','Bugs cause failures.'),
(gen_random_uuid(),'input','dữ liệu vào','noun','/ˈɪnpʊt/','Programs accept input.'),
(gen_random_uuid(),'output','kết quả','noun','/ˈaʊtpʊt/','Programs produce output.'),
(gen_random_uuid(),'data type','kiểu dữ liệu','noun','/ˈdeɪtə taɪp/','Data types define storage.'),
(gen_random_uuid(),'integer','số nguyên','noun','/ˈɪntɪdʒə/','Integers store whole numbers.'),
(gen_random_uuid(),'string','chuỗi','noun','/strɪŋ/','Strings store text.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'algorithm','variable','constant','function','parameter','return value','loop',
 'condition','if statement','compiler','interpreter','syntax','runtime','debug','bug',
 'input','output','data type','integer','string'
)
WHERE m.name = 'Introduction to programming';

-----------------------------------------------------------
-- CƠ SỞ DỮ LIỆU (≈ 25 từ)
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'database','cơ sở dữ liệu','noun','/ˈdeɪtəbeɪs/','Databases store information.'),
(gen_random_uuid(),'table','bảng','noun','/ˈteɪbəl/','Tables contain records.'),
(gen_random_uuid(),'row','hàng','noun','/rəʊ/','Each row is a record.'),
(gen_random_uuid(),'column','cột','noun','/ˈkɒləm/','Columns define attributes.'),
(gen_random_uuid(),'primary key','khóa chính','noun','/ˈpraɪməri kiː/','Primary keys identify rows.'),
(gen_random_uuid(),'foreign key','khóa ngoại','noun','/ˈfɒrən kiː/','Foreign keys link tables.'),
(gen_random_uuid(),'query','truy vấn','noun','/ˈkwɪəri/','Queries retrieve data.'),
(gen_random_uuid(),'index','chỉ mục','noun','/ˈɪndeks/','Indexes improve performance.'),
(gen_random_uuid(),'join','kết nối bảng','noun','/dʒɔɪn/','Joins combine tables.'),
(gen_random_uuid(),'normalization','chuẩn hóa','noun','/ˌnɔːməlaɪˈzeɪʃən/','Normalization reduces redundancy.'),
(gen_random_uuid(),'transaction','giao dịch','noun','/trænˈzækʃən/','Transactions ensure consistency.'),
(gen_random_uuid(),'commit','xác nhận','verb','/kəˈmɪt/','Commit saves changes.'),
(gen_random_uuid(),'rollback','hoàn tác','verb','/ˈrəʊlbæk/','Rollback cancels changes.'),
(gen_random_uuid(),'schema','lược đồ','noun','/ˈskiːmə/','Schemas define structure.'),
(gen_random_uuid(),'constraint','ràng buộc','noun','/kənˈstreɪnt/','Constraints enforce rules.'),
(gen_random_uuid(),'view','khung nhìn','noun','/vjuː/','Views simplify queries.'),
(gen_random_uuid(),'stored procedure','thủ tục lưu trữ','noun','/stɔːd prəˈsiːdʒə/','Procedures run on DB.'),
(gen_random_uuid(),'trigger','kích hoạt','noun','/ˈtrɪɡə/','Triggers run automatically.'),
(gen_random_uuid(),'backup','sao lưu','noun','/ˈbækʌp/','Backups prevent data loss.'),
(gen_random_uuid(),'replication','sao chép','noun','/ˌreplɪˈkeɪʃən/','Replication improves availability.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'database','table','row','column','primary key','foreign key','query','index','join',
 'normalization','transaction','commit','rollback','schema','constraint','view',
 'stored procedure','trigger','backup','replication'
)
WHERE m.name = 'Database fundamentals';


-----------------------------------------------------------
-- HỆ ĐIỀU HÀNH (Operating Systems)
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'operating system','hệ điều hành','noun','/ˈɒpəreɪtɪŋ ˈsɪstəm/','The operating system manages hardware.'),
(gen_random_uuid(),'process','tiến trình','noun','/ˈprəʊses/','Each process has its own address space.'),
(gen_random_uuid(),'thread','luồng','noun','/θred/','Threads share memory.'),
(gen_random_uuid(),'kernel','nhân hệ điều hành','noun','/ˈkɜːnəl/','The kernel controls system resources.'),
(gen_random_uuid(),'memory management','quản lý bộ nhớ','noun','/ˈmeməri ˈmænɪdʒmənt/','Memory management prevents leaks.'),
(gen_random_uuid(),'virtual memory','bộ nhớ ảo','noun','/ˈvɜːtʃuəl ˈmeməri/','Virtual memory extends RAM.'),
(gen_random_uuid(),'scheduler','bộ lập lịch','noun','/ˈʃedjuːlə/','The scheduler allocates CPU time.'),
(gen_random_uuid(),'context switch','chuyển ngữ cảnh','noun','/ˈkɒntekst swɪtʃ/','Context switching has overhead.'),
(gen_random_uuid(),'deadlock','bế tắc','noun','/ˈdedlɒk/','Deadlock stops system progress.'),
(gen_random_uuid(),'semaphore','semaphore','noun','/ˈseməfɔː/','Semaphores synchronize threads.'),
(gen_random_uuid(),'mutex','khóa mutex','noun','/ˈmjuːteks/','Mutex ensures mutual exclusion.'),
(gen_random_uuid(),'interrupt','ngắt','noun','/ˌɪntəˈrʌpt/','Interrupts handle hardware events.'),
(gen_random_uuid(),'system call','lời gọi hệ thống','noun','/ˈsɪstəm kɔːl/','System calls access kernel services.'),
(gen_random_uuid(),'I/O','vào ra','noun','/ˌaɪˈəʊ/','I/O operations are slow.'),
(gen_random_uuid(),'device driver','trình điều khiển','noun','/dɪˈvaɪs ˈdraɪvə/','Drivers control hardware.'),
(gen_random_uuid(),'multitasking','đa nhiệm','noun','/ˌmʌltɪˈtɑːskɪŋ/','Multitasking runs multiple programs.'),
(gen_random_uuid(),'resource allocation','cấp phát tài nguyên','noun','/rɪˈzɔːs æləˈkeɪʃən/','Resources must be allocated fairly.'),
(gen_random_uuid(),'bootloader','trình khởi động','noun','/ˈbuːtləʊdə/','Bootloader starts the OS.'),
(gen_random_uuid(),'paging','phân trang','noun','/ˈpeɪdʒɪŋ/','Paging supports virtual memory.'),
(gen_random_uuid(),'swap','hoán đổi','noun','/swɒp/','Swap uses disk as memory.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'operating system','process','thread','kernel','memory management','virtual memory',
 'scheduler','context switch','deadlock','semaphore','mutex','interrupt','system call',
 'I/O','device driver','multitasking','resource allocation','bootloader','paging','swap'
)
WHERE m.name = 'Operating system';

-----------------------------------------------------------
-- HƯỚNG ĐỐI TƯỢNG (OOP)
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'object-oriented programming','lập trình hướng đối tượng','noun','/ˈɒbdʒɪkt ˈɔːrɪentɪd/','OOP organizes code by objects.'),
(gen_random_uuid(),'class','lớp','noun','/klɑːs/','Classes define objects.'),
(gen_random_uuid(),'object','đối tượng','noun','/ˈɒbdʒɪkt/','Objects have state and behavior.'),
(gen_random_uuid(),'attribute','thuộc tính','noun','/ˈætrɪbjuːt/','Attributes store data.'),
(gen_random_uuid(),'method','phương thức','noun','/ˈmeθəd/','Methods define behavior.'),
(gen_random_uuid(),'encapsulation','đóng gói','noun','/ɪnˌkæpsjuˈleɪʃən/','Encapsulation hides details.'),
(gen_random_uuid(),'inheritance','kế thừa','noun','/ɪnˈherɪtəns/','Inheritance promotes reuse.'),
(gen_random_uuid(),'polymorphism','đa hình','noun','/ˌpɒlɪˈmɔːfɪzəm/','Polymorphism enables flexibility.'),
(gen_random_uuid(),'abstraction','trừu tượng','noun','/æbˈstrækʃən/','Abstraction simplifies complexity.'),
(gen_random_uuid(),'interface','giao diện','noun','/ˈɪntəfeɪs/','Interfaces define contracts.'),
(gen_random_uuid(),'implementation','cài đặt','noun','/ˌɪmplɪmenˈteɪʃən/','Implementation provides logic.'),
(gen_random_uuid(),'constructor','hàm khởi tạo','noun','/kənˈstrʌktə/','Constructors initialize objects.'),
(gen_random_uuid(),'destructor','hàm hủy','noun','/dɪˈstrʌktə/','Destructors clean resources.'),
(gen_random_uuid(),'overloading','nạp chồng','noun','/ˌəʊvəˈləʊdɪŋ/','Overloading changes parameters.'),
(gen_random_uuid(),'overriding','ghi đè','noun','/ˌəʊvəˈraɪdɪŋ/','Overriding changes behavior.'),
(gen_random_uuid(),'composition','thành phần','noun','/ˌkɒmpəˈzɪʃən/','Composition builds complex objects.'),
(gen_random_uuid(),'association','liên kết','noun','/əˌsəʊsɪˈeɪʃən/','Association links classes.'),
(gen_random_uuid(),'dependency','phụ thuộc','noun','/dɪˈpendənsi/','Dependencies increase coupling.'),
(gen_random_uuid(),'UML','UML','noun','/ˌjuːemˈel/','UML models OOP systems.'),
(gen_random_uuid(),'design pattern','mẫu thiết kế','noun','/dɪˈzaɪn ˈpætən/','Design patterns solve common problems.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'object-oriented programming','class','object','attribute','method','encapsulation',
 'inheritance','polymorphism','abstraction','interface','implementation','constructor',
 'destructor','overloading','overriding','composition','association','dependency','UML',
 'design pattern'
)
WHERE m.name = 'Object-oriented programming';

-----------------------------------------------------------
-- PERVASIVE COMPUTING
-----------------------------------------------------------
INSERT INTO words VALUES
(gen_random_uuid(),'pervasive computing','tính toán phổ biến','noun','/pəˈveɪsɪv/','Pervasive computing is everywhere.'),
(gen_random_uuid(),'ubiquitous computing','tính toán mọi nơi','noun','/juːˈbɪkwɪtəs/','Ubiquitous systems blend into life.'),
(gen_random_uuid(),'context-aware','nhận biết ngữ cảnh','adj','/ˈkɒntekst əˈweə/','Context-aware apps adapt behavior.'),
(gen_random_uuid(),'sensor','cảm biến','noun','/ˈsensə/','Sensors collect data.'),
(gen_random_uuid(),'actuator','bộ chấp hành','noun','/ˈæktʃuːeɪtə/','Actuators perform actions.'),
(gen_random_uuid(),'smart environment','môi trường thông minh','noun','/smɑːt/','Smart environments react automatically.'),
(gen_random_uuid(),'adaptation','thích nghi','noun','/ˌædæpˈteɪʃən/','Systems adapt dynamically.'),
(gen_random_uuid(),'location awareness','nhận biết vị trí','noun','/ləʊˈkeɪʃən/','Apps use location awareness.'),
(gen_random_uuid(),'ambient intelligence','trí tuệ môi trường','noun','/ˈæmbiənt/','Ambient intelligence is invisible.'),
(gen_random_uuid(),'wearable device','thiết bị đeo','noun','/ˈweərəbl/','Wearables collect health data.'),
(gen_random_uuid(),'IoT','Internet of Things','noun','/ˌaɪəʊˈtiː/','IoT connects devices.'),
(gen_random_uuid(),'privacy','quyền riêng tư','noun','/ˈprɪvəsi/','Privacy is critical.'),
(gen_random_uuid(),'context modeling','mô hình ngữ cảnh','noun','/ˈmɒdəlɪŋ/','Context modeling improves accuracy.'),
(gen_random_uuid(),'real-time','thời gian thực','adj','/rɪəl taɪm/','Real-time response is required.'),
(gen_random_uuid(),'human-computer interaction','tương tác người máy','noun','/ˌɪntəˈrækʃən/','HCI studies usability.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id FROM modules m JOIN words w
ON w.text_en IN (
 'pervasive computing','ubiquitous computing','context-aware','sensor','actuator',
 'smart environment','adaptation','location awareness','ambient intelligence',
 'wearable device','IoT','privacy','context modeling','real-time',
 'human-computer interaction'
)
WHERE m.name = 'Pervasive Computing';

-----------------------------------------------------------
-- MOBILE COMPUTING
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'mobile computing','tính toán di động','noun','/ˈməʊbaɪl kəmˈpjuːtɪŋ/','Mobile computing enables mobility.'),
(gen_random_uuid(),'mobile device','thiết bị di động','noun','/ˈməʊbaɪl dɪˈvaɪs/','Mobile devices are portable.'),
(gen_random_uuid(),'wireless network','mạng không dây','noun','/ˈwaɪələs ˈnetwɜːk/','Wireless networks support mobility.'),
(gen_random_uuid(),'latency','độ trễ','noun','/ˈleɪtənsi/','High latency affects performance.'),
(gen_random_uuid(),'bandwidth','băng thông','noun','/ˈbændwɪdθ/','Bandwidth limits data transfer.'),
(gen_random_uuid(),'handoff','chuyển vùng','noun','/ˈhændɒf/','Handoff occurs during movement.'),
(gen_random_uuid(),'mobility management','quản lý di động','noun','/məʊˈbɪlɪti ˈmænɪdʒmənt/','Mobility management tracks users.'),
(gen_random_uuid(),'location-based service','dịch vụ theo vị trí','noun','/ləʊˈkeɪʃən/','Location-based services personalize apps.'),
(gen_random_uuid(),'energy efficiency','hiệu quả năng lượng','noun','/ˈenədʒi ɪˈfɪʃənsi/','Energy efficiency saves battery.'),
(gen_random_uuid(),'battery consumption','tiêu thụ pin','noun','/ˈbætəri kənˈsʌmpʃən/','Apps should reduce battery usage.'),
(gen_random_uuid(),'offline mode','chế độ ngoại tuyến','noun','/ˌɒfˈlaɪn/','Offline mode improves usability.'),
(gen_random_uuid(),'synchronization','đồng bộ hóa','noun','/ˌsɪŋkrənaɪˈzeɪʃən/','Data synchronization keeps consistency.'),
(gen_random_uuid(),'push notification','thông báo đẩy','noun','/pʊʃ ˌnəʊtɪfɪˈkeɪʃən/','Push notifications engage users.'),
(gen_random_uuid(),'responsive design','thiết kế đáp ứng','noun','/rɪˈspɒnsɪv/','Responsive design adapts screens.'),
(gen_random_uuid(),'sensor fusion','kết hợp cảm biến','noun','/ˈsensə ˈfjuːʒən/','Sensor fusion improves accuracy.'),
(gen_random_uuid(),'context awareness','nhận biết ngữ cảnh','noun','/ˈkɒntekst/','Context awareness improves UX.'),
(gen_random_uuid(),'mobile OS','hệ điều hành di động','noun','/ˈməʊbaɪl/','Mobile OS manages hardware.'),
(gen_random_uuid(),'network roaming','chuyển mạng','noun','/ˈrəʊmɪŋ/','Roaming enables connectivity.'),
(gen_random_uuid(),'data caching','lưu đệm dữ liệu','noun','/ˈkeɪʃɪŋ/','Caching improves performance.'),
(gen_random_uuid(),'edge computing','điện toán biên','noun','/edʒ/','Edge computing reduces latency.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'mobile computing','mobile device','wireless network','latency','bandwidth','handoff',
 'mobility management','location-based service','energy efficiency','battery consumption',
 'offline mode','synchronization','push notification','responsive design','sensor fusion',
 'context awareness','mobile OS','network roaming','data caching','edge computing'
)
WHERE m.name = 'Mobile Computing';

-----------------------------------------------------------
-- DISTRIBUTED COMPUTING
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'distributed system','hệ thống phân tán','noun','/dɪˈstrɪbjʊtɪd/','Distributed systems share resources.'),
(gen_random_uuid(),'node','nút','noun','/nəʊd/','Each node runs independently.'),
(gen_random_uuid(),'cluster','cụm','noun','/ˈklʌstə/','Clusters increase capacity.'),
(gen_random_uuid(),'replication','sao chép','noun','/ˌreplɪˈkeɪʃən/','Replication improves availability.'),
(gen_random_uuid(),'fault tolerance','chịu lỗi','noun','/fɔːlt ˈtɒlərəns/','Fault tolerance handles failures.'),
(gen_random_uuid(),'consistency','tính nhất quán','noun','/kənˈsɪstənsi/','Consistency ensures correctness.'),
(gen_random_uuid(),'availability','tính sẵn sàng','noun','/əˌveɪləˈbɪlɪti/','Availability keeps services online.'),
(gen_random_uuid(),'partition tolerance','chịu phân mảnh','noun','/pɑːˈtɪʃən/','Partition tolerance handles splits.'),
(gen_random_uuid(),'CAP theorem','định lý CAP','noun','/kæp/','CAP theorem explains trade-offs.'),
(gen_random_uuid(),'consensus','đồng thuận','noun','/kənˈsensəs/','Consensus synchronizes nodes.'),
(gen_random_uuid(),'leader election','bầu chọn leader','noun','/ˈliːdə/','Leader election coordinates nodes.'),
(gen_random_uuid(),'distributed lock','khóa phân tán','noun','/lɒk/','Distributed locks avoid conflicts.'),
(gen_random_uuid(),'message passing','truyền thông điệp','noun','/ˈmesɪdʒ/','Message passing connects nodes.'),
(gen_random_uuid(),'RPC','gọi thủ tục từ xa','noun','/ˌɑːrpiːˈsiː/','RPC simplifies communication.'),
(gen_random_uuid(),'eventual consistency','nhất quán cuối','noun','/ɪˈventʃuəl/','Eventual consistency relaxes rules.'),
(gen_random_uuid(),'load balancing','cân bằng tải','noun','/ˈbəʊlənsiŋ/','Load balancing distributes requests.'),
(gen_random_uuid(),'distributed database','CSDL phân tán','noun','/ˈdeɪtəbeɪs/','Distributed DB scales horizontally.'),
(gen_random_uuid(),'sharding','phân mảnh dữ liệu','noun','/ˈʃɑːdɪŋ/','Sharding splits data.'),
(gen_random_uuid(),'network partition','phân tách mạng','noun','/ˈnetwɜːk/','Network partitions cause failures.'),
(gen_random_uuid(),'high availability','tính sẵn sàng cao','noun','/ˈeɪvəɪləˌbɪlɪti/','HA minimizes downtime.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'distributed system','node','cluster','replication','fault tolerance','consistency',
 'availability','partition tolerance','CAP theorem','consensus','leader election',
 'distributed lock','message passing','RPC','eventual consistency','load balancing',
 'distributed database','sharding','network partition','high availability'
)
WHERE m.name = 'Distributed Computing';

-----------------------------------------------------------
-- CLOUD COMPUTING
-----------------------------------------------------------
INSERT INTO words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence) VALUES
(gen_random_uuid(),'cloud computing','điện toán đám mây','noun','/klaʊd/','Cloud computing provides scalability.'),
(gen_random_uuid(),'cloud service','dịch vụ đám mây','noun','/ˈsɜːvɪs/','Cloud services are on-demand.'),
(gen_random_uuid(),'virtual machine','máy ảo','noun','/ˈvɜːtʃuəl/','VMs isolate applications.'),
(gen_random_uuid(),'container','container','noun','/kənˈteɪnə/','Containers package software.'),
(gen_random_uuid(),'orchestration','điều phối','noun','/ˌɔːkɪˈstreɪʃən/','Orchestration manages containers.'),
(gen_random_uuid(),'scalability','khả năng mở rộng','noun','/ˌskeɪləˈbɪlɪti/','Scalability handles growth.'),
(gen_random_uuid(),'elasticity','tính đàn hồi','noun','/ɪˌlæˈstɪsɪti/','Elasticity adapts resources.'),
(gen_random_uuid(),'pay-as-you-go','trả theo dùng','noun','/peɪ/','Pay-as-you-go reduces cost.'),
(gen_random_uuid(),'IaaS','hạ tầng như dịch vụ','noun','/ˌaɪɑːæs/','IaaS provides infrastructure.'),
(gen_random_uuid(),'PaaS','nền tảng như dịch vụ','noun','/ˌpiːæs/','PaaS supports development.'),
(gen_random_uuid(),'SaaS','phần mềm như dịch vụ','noun','/ˌsæs/','SaaS delivers applications.'),
(gen_random_uuid(),'cloud storage','lưu trữ đám mây','noun','/ˈstɔːrɪdʒ/','Cloud storage stores data.'),
(gen_random_uuid(),'load balancer','bộ cân bằng tải','noun','/ˈləʊd/','Load balancers distribute traffic.'),
(gen_random_uuid(),'auto scaling','tự động mở rộng','noun','/ˈɔːtəʊ/','Auto scaling adjusts capacity.'),
(gen_random_uuid(),'availability zone','vùng sẵn sàng','noun','/əˌveɪləˈbɪlɪti/','AZ improves resilience.'),
(gen_random_uuid(),'backup','sao lưu','noun','/ˈbækʌp/','Backups prevent data loss.'),
(gen_random_uuid(),'disaster recovery','khôi phục thảm họa','noun','/dɪˈzɑːstə/','DR ensures continuity.'),
(gen_random_uuid(),'cloud security','bảo mật đám mây','noun','/sɪˈkjʊərɪti/','Cloud security protects assets.'),
(gen_random_uuid(),'multi-tenancy','đa thuê','noun','/ˈtenənsi/','Multi-tenancy shares resources.'),
(gen_random_uuid(),'serverless','không máy chủ','adj','/ˈsɜːvələs/','Serverless hides infrastructure.');

INSERT INTO module_words (module_id, word_id)
SELECT m.id, w.id
FROM modules m
JOIN words w ON w.text_en IN (
 'cloud computing','cloud service','virtual machine','container','orchestration',
 'scalability','elasticity','pay-as-you-go','IaaS','PaaS','SaaS','cloud storage',
 'load balancer','auto scaling','availability zone','backup','disaster recovery',
 'cloud security','multi-tenancy','serverless'
)
WHERE m.name = 'Cloud Computing';


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
