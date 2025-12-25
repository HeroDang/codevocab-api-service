--
-- PostgreSQL database cluster dump
--

-- Started on 2025-12-25 15:01:09 UTC


SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--


--
-- User Configurations
--









--
-- Databases
--

--
-- Database "template1" dump
--


--
-- PostgreSQL database dump
--


-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-25 15:01:09 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-12-25 15:01:09 UTC

--
-- PostgreSQL database dump complete
--


--
-- Database "appdb" dump
--

--
-- PostgreSQL database dump
--


-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-25 15:01:09 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3627 (class 1262 OID 16384)
-- Name: appdb; Type: DATABASE; Schema: -; Owner: postgres
--





SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16385)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 16622)
-- Name: flashcard_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flashcard_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    module_id uuid,
    correct_count integer,
    wrong_count integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.flashcard_results OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16570)
-- Name: group_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    user_id uuid,
    joined_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.group_members OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16606)
-- Name: group_post_modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_post_modules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id uuid,
    module_id uuid
);


ALTER TABLE public.group_post_modules OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16587)
-- Name: group_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    group_id uuid,
    user_id uuid,
    content text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.group_posts OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16556)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    owner_id uuid,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33062)
-- Name: module_deletes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module_deletes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    module_id uuid,
    user_id uuid,
    deleted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.module_deletes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16531)
-- Name: module_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module_shares (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    module_id uuid,
    from_user uuid,
    to_user uuid,
    status text DEFAULT 'pending'::text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.module_shares OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16477)
-- Name: module_words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module_words (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    module_id uuid,
    word_id uuid
);


ALTER TABLE public.module_words OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16448)
-- Name: modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_id uuid,
    parent_id uuid,
    name text NOT NULL,
    description text,
    is_public boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    module_type character varying(20),
    deleted_at timestamp without time zone
);


ALTER TABLE public.modules OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16656)
-- Name: quiz_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quiz_result_id uuid,
    word_id uuid,
    user_answer text,
    correct_answer text,
    is_correct boolean
);


ALTER TABLE public.quiz_answers OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16639)
-- Name: quiz_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    module_id uuid,
    score integer,
    total_questions integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.quiz_results OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16434)
-- Name: user_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_settings (
    user_id uuid NOT NULL,
    dark_mode boolean DEFAULT false,
    preferred_language text DEFAULT 'en'::text
);


ALTER TABLE public.user_settings OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16422)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    name text,
    avatar_url text,
    disabled boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    role character varying(20) DEFAULT 'user'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16512)
-- Name: word_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.word_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    word_id uuid,
    comment text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.word_comments OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33079)
-- Name: word_deletes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.word_deletes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    word_id uuid,
    user_id uuid,
    deleted_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.word_deletes OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16493)
-- Name: word_pronunciation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.word_pronunciation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    word_id uuid,
    score integer,
    recorded_audio_url text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.word_pronunciation OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16468)
-- Name: words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.words (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text_en text NOT NULL,
    meaning_vi text,
    part_of_speech text,
    ipa text,
    example_sentence text,
    audio_url text,
    created_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE public.words OWNER TO postgres;

--
-- TOC entry 3617 (class 0 OID 16622)
-- Dependencies: 227
-- Data for Name: flashcard_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flashcard_results (id, user_id, module_id, correct_count, wrong_count, created_at) FROM stdin;
84f8621d-9932-4448-a0f6-899864eda28f	d67e55da-a59f-4c8e-90c9-e43331fe95b5	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	10	3	2025-12-06 07:23:12.546498
3da84270-bc1d-43b7-8d1b-bd07a8a07f8b	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	10	3	2025-12-06 07:23:12.546498
71aa2767-9ca9-45ad-ada0-09d3e6d75a43	c4dca63e-f5c0-4777-8e0c-7fd5c0207b12	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	10	3	2025-12-06 07:23:12.546498
\.


--
-- TOC entry 3614 (class 0 OID 16570)
-- Dependencies: 224
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_members (id, group_id, user_id, joined_at) FROM stdin;
c0a81ab2-7f4b-4822-a410-09d1b44fc2d8	4a1a9a0c-c023-4d06-9e18-42c8502baae5	d67e55da-a59f-4c8e-90c9-e43331fe95b5	2025-12-06 07:23:12.538071
cdf4e003-c578-449e-9250-97f6b119f7cd	4a1a9a0c-c023-4d06-9e18-42c8502baae5	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	2025-12-06 07:23:12.538071
e5df4167-303b-403b-a2c5-89b6f14fc279	4a1a9a0c-c023-4d06-9e18-42c8502baae5	c4dca63e-f5c0-4777-8e0c-7fd5c0207b12	2025-12-06 07:23:12.538071
\.


--
-- TOC entry 3616 (class 0 OID 16606)
-- Dependencies: 226
-- Data for Name: group_post_modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_post_modules (id, post_id, module_id) FROM stdin;
020a9d5d-ae8b-4048-ba2a-7b7d5e210c74	3bdb850e-db51-4029-a23d-76a8f7392bcd	c0c7f648-d1d7-4363-8a0f-1842fe16d54e
\.


--
-- TOC entry 3615 (class 0 OID 16587)
-- Dependencies: 225
-- Data for Name: group_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_posts (id, group_id, user_id, content, created_at) FROM stdin;
3bdb850e-db51-4029-a23d-76a8f7392bcd	4a1a9a0c-c023-4d06-9e18-42c8502baae5	d67e55da-a59f-4c8e-90c9-e43331fe95b5	Check out this useful module!	2025-12-06 07:23:12.540848
\.


--
-- TOC entry 3613 (class 0 OID 16556)
-- Dependencies: 223
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, owner_id, created_at) FROM stdin;
4a1a9a0c-c023-4d06-9e18-42c8502baae5	English Learners	d67e55da-a59f-4c8e-90c9-e43331fe95b5	2025-12-06 07:23:12.536068
\.


--
-- TOC entry 3620 (class 0 OID 33062)
-- Dependencies: 230
-- Data for Name: module_deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module_deletes (id, module_id, user_id, deleted_at) FROM stdin;
b9c816f1-b818-47ac-acdf-a8d0aefae939	ed541d88-3e8c-45e4-a10f-4f2509605465	7731f70e-0475-42a4-8e2e-22542510ea14	2025-12-25 01:36:03.686593
\.


--
-- TOC entry 3612 (class 0 OID 16531)
-- Dependencies: 222
-- Data for Name: module_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module_shares (id, module_id, from_user, to_user, status, created_at) FROM stdin;
adc46907-a8e5-47b8-aad9-60957b11585e	b030d5d5-63cc-493b-a991-0d6e0bc968e0	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	7731f70e-0475-42a4-8e2e-22542510ea14	accepted	2025-12-23 14:05:47.750338
6a9d4351-8a4b-48d3-a802-755a9dc6c626	f9aca3c8-5b0f-4cd3-b6b3-0f6a2bdc0190	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	7731f70e-0475-42a4-8e2e-22542510ea14	accepted	2025-12-23 14:06:53.663078
266cc94b-dc0b-4565-ac35-410a65b081c3	2cd83825-331c-43f5-a320-c6577e55fb26	7731f70e-0475-42a4-8e2e-22542510ea14	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	pending	2025-12-25 07:23:36.739751
8ab91198-8b05-4e1e-826d-9a33dfa65027	7ee11f45-0498-43e2-9ef7-4d85194d6238	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	7731f70e-0475-42a4-8e2e-22542510ea14	pending	2025-12-25 07:24:21.321565
29dfcd45-fe3e-42f3-927d-ad1bb6b8a220	d4fc29b8-aad4-40c2-ab31-493751f66772	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	7731f70e-0475-42a4-8e2e-22542510ea14	accepted	2025-12-24 17:36:29.060411
\.


--
-- TOC entry 3609 (class 0 OID 16477)
-- Dependencies: 219
-- Data for Name: module_words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module_words (id, module_id, word_id) FROM stdin;
57c86e96-494c-43f1-811e-b032caa733ef	35c68566-ca38-4d6e-86aa-55115a514835	66c68fc9-32a8-4eff-ac06-656d97a1e642
560836d9-7182-4775-a5d5-62ea70637057	778a6f12-4ba6-4411-be39-140615f5885a	94e28fae-7ad4-491a-95e0-b7513836888b
de0c01ae-9f22-47b8-bc4e-4e1e91959af8	e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc
99f6aff7-48b7-4577-8f6b-c273dea1364e	5bac030d-d908-4fa0-9ab7-826d8b38039c	d8d08a0b-3450-4e30-a2dd-ea9421b7909a
6830f5ee-a366-4c4f-bd73-67d57e1922a4	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	40fc2eb0-1e46-4ae3-9c1e-b507f6cf5041
396262cf-f16e-466c-82e2-df40743c70fd	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	d8d08a0b-3450-4e30-a2dd-ea9421b7909a
a08c3eaa-d2e9-4e42-86b3-eb7c46f21ed5	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	373e50cf-a792-4872-a4b5-12a410e12124
6055b5ff-9e08-41c9-b8f5-dc1de8f58369	2cd83825-331c-43f5-a320-c6577e55fb26	56e178b6-1c62-4487-9897-699609a90d38
0ef80960-c55e-4970-aea8-e1ea9958d395	8325b95b-cbfa-4350-98c8-4df6060cc22d	a2a11fac-65d3-4a38-92a9-c53cd0991237
e49594bd-30c1-4986-9918-3fed3b5a4c08	78204820-1e87-4411-a164-b0ba24f3e526	c8de6806-ca8d-4630-bd49-01166bac8883
af4e80d6-6596-4d7b-83a1-a652cff3c674	35c68566-ca38-4d6e-86aa-55115a514835	7e3f2a0d-fc7c-4bf1-8d32-b898f612ee12
07f231d0-7936-4607-935d-bd2090d8f4e0	ed541d88-3e8c-45e4-a10f-4f2509605465	22d80225-0aa3-4688-9827-fc772ddbd024
e99b8611-6b75-42b3-92cf-374526f4f824	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc
d36fd464-fe9f-4c47-b6a9-06d9777adb3b	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	18dde600-99c8-447d-9295-cd5f23a2694e
513b2477-0127-4492-a462-65f78e3a0b88	5bac030d-d908-4fa0-9ab7-826d8b38039c	373e50cf-a792-4872-a4b5-12a410e12124
a10a2645-e747-4d69-a98a-50a8755f52bb	b030d5d5-63cc-493b-a991-0d6e0bc968e0	66c68fc9-32a8-4eff-ac06-656d97a1e642
446288d7-7de1-4339-beee-3b36de2bc880	0b74fa4e-beb0-4eb7-a148-333cb5b5835b	eae1b14f-c3ba-491c-b0b4-5fe230173049
b47d7ed8-e082-4e06-8e5c-e6fbf68ba004	2cd83825-331c-43f5-a320-c6577e55fb26	8e8ccb04-dac8-410b-be57-7d64735dae5d
27d947c6-075d-421c-b09e-09548f2928f1	0b74fa4e-beb0-4eb7-a148-333cb5b5835b	40fc2eb0-1e46-4ae3-9c1e-b507f6cf5041
1e82d571-3d7e-46b9-a5dd-75c82aea34d3	e645565a-de74-4b2c-8de8-7416965917eb	8e371030-5ea8-4da5-9b4d-f99507debb0b
452954b8-0eb5-4bb3-8012-54477c4c4a8f	51093613-eea0-464d-8b65-da59523045ff	117d0d2e-f357-4001-825c-a2a08aba7e1c
0e00c229-5a86-4810-9603-5c0765dbbd74	ed541d88-3e8c-45e4-a10f-4f2509605465	9a4e5991-0fcf-4268-bcbd-0a846a911a67
01c6e61b-58e6-4dc5-80f7-36b65728a7fe	78204820-1e87-4411-a164-b0ba24f3e526	18dde600-99c8-447d-9295-cd5f23a2694e
65079286-7e1d-4f72-a0f1-effa225b6da2	8325b95b-cbfa-4350-98c8-4df6060cc22d	94e28fae-7ad4-491a-95e0-b7513836888b
e6cbeea9-8382-4424-bf42-bee3d2660db6	e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	117d0d2e-f357-4001-825c-a2a08aba7e1c
ef689523-9141-4513-841c-b7e59f2737d3	ed541d88-3e8c-45e4-a10f-4f2509605465	64c99693-e39d-4122-96f8-7de4c3454423
ba2c4a68-7e91-4721-b400-a6d00b852bb7	2cd83825-331c-43f5-a320-c6577e55fb26	0086752d-3a4f-41f9-ab17-543eaaf9396e
179b10b5-b65c-48d7-a759-255e6062b21f	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	22d80225-0aa3-4688-9827-fc772ddbd024
2ba73668-046a-4b9b-a743-f697c83a976f	6c0b8648-408c-4025-b3db-73d8f20c731d	62940d47-1867-41c5-a2b3-04365b9998da
9677052c-1023-4bd2-950b-a775a2d86d32	e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	7aef4a90-31a7-4274-a8a4-a87009b233d6
97edd335-9e0e-408b-ac11-158abb7ab88b	380fb7c0-07ee-42db-b0a0-9b31b8d7fe19	94e28fae-7ad4-491a-95e0-b7513836888b
a2a742a5-7b6e-40e6-97d3-ffe2960c6baf	0b8a1ae4-30d7-46f5-b2c3-ca287873aa67	0086752d-3a4f-41f9-ab17-543eaaf9396e
bf4aea4d-62d8-4cec-9148-b3b96b0e7e51	f9aca3c8-5b0f-4cd3-b6b3-0f6a2bdc0190	e3712645-6427-4587-8899-2d3ca2028486
22132668-bc66-4da3-93eb-27332f6292f7	3e2fd496-4ccb-4b80-be78-4a8c31fb5918	d8d08a0b-3450-4e30-a2dd-ea9421b7909a
ca654826-de84-49ae-b321-b3ab6a7ede4a	0b74fa4e-beb0-4eb7-a148-333cb5b5835b	9fee3fe8-6788-4784-9316-b8433b89ffb6
821a6459-ad62-4a4a-90d0-53385a6f6695	e645565a-de74-4b2c-8de8-7416965917eb	6f638a4e-ecd8-42dd-a246-7cf9636088de
49ba9535-eee9-4e52-982a-104c9cb6997e	e645565a-de74-4b2c-8de8-7416965917eb	f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc
b6758b72-ed89-4ae0-b07f-09a9f164a9aa	2cd83825-331c-43f5-a320-c6577e55fb26	117d0d2e-f357-4001-825c-a2a08aba7e1c
a7b742fe-3a1b-425f-a376-08cf18823201	380fb7c0-07ee-42db-b0a0-9b31b8d7fe19	9fee3fe8-6788-4784-9316-b8433b89ffb6
d77d0002-dc38-4587-b69e-1285f50bd8d2	7ee11f45-0498-43e2-9ef7-4d85194d6238	117d0d2e-f357-4001-825c-a2a08aba7e1c
5d605852-d020-4b6f-8362-6d905054c523	db420a03-674e-4f09-8f26-55eb462c4e51	9a4e5991-0fcf-4268-bcbd-0a846a911a67
6419dc80-1d05-4550-aed9-2f83aeee765a	e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	7e3f2a0d-fc7c-4bf1-8d32-b898f612ee12
7f8710dd-8626-46de-ac46-8091bf334758	f9aca3c8-5b0f-4cd3-b6b3-0f6a2bdc0190	a38eb1a3-349f-49c4-af47-5848871209c2
ba2b0a05-8a4c-4030-8c16-c35d28dc7fa0	f9aca3c8-5b0f-4cd3-b6b3-0f6a2bdc0190	eae1b14f-c3ba-491c-b0b4-5fe230173049
1eff5113-b421-4c73-9efb-78474dfbf775	8325b95b-cbfa-4350-98c8-4df6060cc22d	7aef4a90-31a7-4274-a8a4-a87009b233d6
fdcc574f-f699-48d6-8edb-572bd18e2403	b030d5d5-63cc-493b-a991-0d6e0bc968e0	373e50cf-a792-4872-a4b5-12a410e12124
bd5caf41-57ea-40d9-82ab-a7ac4d677e4e	b030d5d5-63cc-493b-a991-0d6e0bc968e0	8e8ccb04-dac8-410b-be57-7d64735dae5d
16b2d33b-0eef-495d-bd25-109d9b376f30	b030d5d5-63cc-493b-a991-0d6e0bc968e0	8e371030-5ea8-4da5-9b4d-f99507debb0b
25f2238f-6597-496b-8589-534690a5d252	e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	eae1b14f-c3ba-491c-b0b4-5fe230173049
1a6048e6-f420-465c-bf79-915658599558	d4fc29b8-aad4-40c2-ab31-493751f66772	56e178b6-1c62-4487-9897-699609a90d38
1fb74e88-12ff-4c3a-9e78-db24e7b97ef2	abd52e8f-a713-4587-9959-0164c7f1a4f5	4bc8a18c-0f31-45af-bbc0-0b27c7006ed0
454db881-0e4b-424f-b4e8-e43372986fb9	abd52e8f-a713-4587-9959-0164c7f1a4f5	7f3446e7-1ff0-479f-a976-fe9a977cafb0
374e072d-3d19-493f-a547-71a0a88c7420	abd52e8f-a713-4587-9959-0164c7f1a4f5	d08873d4-fb42-4e89-98d5-589d062c7881
8cfdd603-29c2-43c6-bcc6-0df68c14db6c	abd52e8f-a713-4587-9959-0164c7f1a4f5	29e18afa-b115-40a0-be32-a89e77811aa3
39e9d401-0f59-4573-86a6-7bc5eb5841f7	abd52e8f-a713-4587-9959-0164c7f1a4f5	3a6f2da2-9b71-44e2-9c85-0b66ddf8b3ce
2f189548-9cd8-42a5-b3e3-4aaa9bd3f045	abd52e8f-a713-4587-9959-0164c7f1a4f5	7d25b06d-8fd2-4da0-bb31-cc6c3cff4752
155e5bcb-5202-4378-af32-0e6ef6e6f635	abd52e8f-a713-4587-9959-0164c7f1a4f5	60d66b21-c4a2-4b1a-b19f-23c50a8152c5
217dd627-5ccd-4e73-8c6a-44310bd9b3cf	abd52e8f-a713-4587-9959-0164c7f1a4f5	6dba5a74-f117-4093-b673-29a35194cb04
0b3707e8-8799-454f-9732-dfb3362b3637	abd52e8f-a713-4587-9959-0164c7f1a4f5	1e683d9a-dd9c-46ce-8487-2a867547b602
9ec47e0b-5431-4a0d-996b-55ee824f8795	abd52e8f-a713-4587-9959-0164c7f1a4f5	0abdbdc4-4d32-42da-b95a-69bb5fae37ab
f1df6154-8941-465d-b65f-3fe3bc3bedf6	abd52e8f-a713-4587-9959-0164c7f1a4f5	10d308d7-1b26-4bc7-a1a0-d7e6ec49bf1a
310486ab-f1d1-4210-81e5-a0079bb753d5	abd52e8f-a713-4587-9959-0164c7f1a4f5	64cf0ea7-b9c5-4a3e-b6ee-cf085e23684a
766f0f97-c6c1-46df-9b9e-4a7e6d2b061a	abd52e8f-a713-4587-9959-0164c7f1a4f5	d7ff0dcf-6c93-47a5-8878-a07de1f1d982
840902ae-c144-42ed-a669-6f04bd0252cf	abd52e8f-a713-4587-9959-0164c7f1a4f5	a6305b44-96d4-4c53-bad8-ce49b48460a6
87da8b41-daf4-44ad-818b-d50c4cc44215	abd52e8f-a713-4587-9959-0164c7f1a4f5	f9577205-23ee-4aaa-a691-f9b2e59e2190
8cc57487-e19a-4572-84b8-9b0910c46970	abd52e8f-a713-4587-9959-0164c7f1a4f5	cdd4925a-ae2f-47bf-8146-f0babe3204fe
3df5662f-df2f-4236-aaba-7bc0490500cb	abd52e8f-a713-4587-9959-0164c7f1a4f5	0ccf5466-4bf6-4343-9d6b-93040173eb5c
2e5cbbac-87a8-4b03-a532-a9ee66c81d3f	abd52e8f-a713-4587-9959-0164c7f1a4f5	4a0008ff-ad25-4233-9ea2-fdfbd2e3fdcd
3392f358-22f7-47f2-95e3-665adb248a73	abd52e8f-a713-4587-9959-0164c7f1a4f5	057f848a-93a0-4b49-aee6-13e1bf24df21
b5da1cd4-9b80-4720-ba37-025c9673403a	abd52e8f-a713-4587-9959-0164c7f1a4f5	1da88510-319b-447e-8f54-a0bac3ae1f51
a8aee145-e249-4429-9d82-8233887b2f12	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	fe230979-270c-468a-a788-b141976fa696
d1ee081d-8381-4cf9-9eac-900f31134f58	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	6b54eb8f-b6f1-470f-9cf2-acfdf03582c4
a050cd06-8b1b-48c8-9525-85eea75d646b	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	42e4c536-3933-4ea2-a04b-604fb73fa276
5c402067-f997-47dc-abcb-656cf80ec0a8	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	49f6bed8-037e-4778-9319-10dfe3ed310f
43a84d40-a929-4446-896b-8a9c24bab520	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	e100936b-23af-44e5-835c-ca6f3ff35a74
39221561-5481-49b8-8e05-74471f9b3b21	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	527c2da8-6ac9-4e49-87a0-a515973c3bd7
b7223abb-0896-4b39-9385-17e0b59b5d08	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	49c04cca-f283-4b19-8123-7021f6c0e657
8cdb1121-1092-4f0d-9799-10fab49dc83e	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	9a5ddca0-74ef-4798-8100-caa745ea5376
104db62d-8d3e-452b-8717-961e23228186	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	52a31ad8-f2e3-43e5-91c4-a6b8dbe6d6b4
1ed87de4-e927-42c8-8bc8-0fd4ac2924c2	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	a57739c0-e8fd-43dd-b038-69a58ad78a90
db062a93-d2f3-4f74-99c5-1af9221ac251	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	0c784076-f531-431d-bc86-5d25f32f77e3
24ac1e27-b3a9-429d-b3d2-8d6069a43da4	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	6104e4e6-db2a-42e7-b5b7-ed0996eb964c
d87998e7-d460-47f1-8c01-046684e8cdf2	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	01775dac-ece8-4955-8e32-0a866877d6d4
2f1ebfb3-5ced-49ea-9f31-fa27ae25609d	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	412a12ec-d4de-494d-9eb4-0e0e7a989a59
b5f48be6-bbaa-4b45-afa3-53c7f0fb4150	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	661e3907-0fcd-40cf-8f50-a24a5672356c
00708e5b-4b15-408f-9b5e-91e5daad4af3	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	c9174b9e-380f-40f9-9529-89dbb399c0eb
f473abbd-c2e1-4848-8022-e5d71fd34b16	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	52814298-650d-48fa-82d6-21b6355b2792
11af6858-20a3-4812-bd70-4c8dfcc14428	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	cb1dd41f-fed8-4638-a63e-0911db442623
8f99656e-2f7d-4e6f-ba0f-e09e1204dbe3	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	b8e4a3b7-1c2d-415f-bec3-674198ccfe87
81cd133c-c95b-4272-898b-401e7ccca991	e00a71ac-7405-4b5c-b88e-cd9f4901cb24	dbdcdbc7-bab0-4e33-808d-08e60a94a061
c5556d8e-1fb7-4d69-b049-e38d310772da	02f340b8-d634-442d-91ce-dbe800ca0d79	778cf06d-de68-4458-9d13-c296eff6cba1
0adb022a-9051-49a6-9924-adcddec23f3c	02f340b8-d634-442d-91ce-dbe800ca0d79	e0bd7426-79e8-435c-8f7b-0d506a643bc6
53c50342-f900-4e52-a7da-5571e0cb010b	02f340b8-d634-442d-91ce-dbe800ca0d79	9e78759f-dd9d-469d-9fb9-887a959d1820
836291f6-9d2b-4aa7-aa44-fbae9ec262e9	02f340b8-d634-442d-91ce-dbe800ca0d79	5ea2559a-60fc-49ea-bb60-0e74a925081f
c671bca0-586b-4f1b-a805-a6432e7d7231	02f340b8-d634-442d-91ce-dbe800ca0d79	91dee1c6-80a1-4ecb-9096-d16d4b3a4509
1c6df785-93e5-4772-affe-80f254f7d5ca	02f340b8-d634-442d-91ce-dbe800ca0d79	fb077cd2-72e9-4ee7-9c65-0863ad8e48f1
8165f85a-3e43-4e2d-b7c0-ef4b3befa0aa	02f340b8-d634-442d-91ce-dbe800ca0d79	9c12ae78-6c17-4811-a07c-4ab270244b96
e362c807-76c1-413e-9c02-27f22ba5d316	02f340b8-d634-442d-91ce-dbe800ca0d79	8bb1de39-7a22-4396-a1d1-0364fead9513
2bcae818-0358-463a-b1e0-c1576d136b85	02f340b8-d634-442d-91ce-dbe800ca0d79	b17f2e78-1579-4c68-a315-2578a2ca8090
0cb27272-48c7-4e55-bb43-10e59b7f38e6	02f340b8-d634-442d-91ce-dbe800ca0d79	ae86cc6e-19aa-41e4-9169-758bc10d8e2c
9f02b4b3-053d-4842-9d41-aaedf0820c0b	02f340b8-d634-442d-91ce-dbe800ca0d79	6bdcd9d9-e0a3-4635-8ad9-a9052c00b964
cacf076f-9091-44ec-a67f-5238db7a37f8	02f340b8-d634-442d-91ce-dbe800ca0d79	9f67a95b-12d2-4787-85bd-14923545ca39
c9714a28-b6f3-4bf4-8fd6-f68000e115c3	02f340b8-d634-442d-91ce-dbe800ca0d79	8b1f2543-3040-4b74-b2a2-684459e640e9
a48fc609-7bb1-43d2-98ec-c8e74375c574	02f340b8-d634-442d-91ce-dbe800ca0d79	0ac94f88-d67a-4e63-8f8a-9b798b7d1b5b
b56c3723-b7f6-47e6-86db-06c1ae2fd00e	02f340b8-d634-442d-91ce-dbe800ca0d79	10391d24-a800-466a-9d39-a01649d96fcc
1c056c57-d216-484e-b342-c26417645397	02f340b8-d634-442d-91ce-dbe800ca0d79	679d403f-d32e-4729-a42a-ea2b42cf3102
3e82a617-3816-43e1-8be3-cebb791a6ba3	02f340b8-d634-442d-91ce-dbe800ca0d79	acad8413-93a4-41b5-8e52-34132a9d4138
9cf8202b-f39f-466e-bf20-1fa0adcfe611	02f340b8-d634-442d-91ce-dbe800ca0d79	9131fdbf-a686-4664-8669-ff1f2f9a1565
a99b3826-5831-4337-9013-5973a4594c39	02f340b8-d634-442d-91ce-dbe800ca0d79	74a2ee88-34d2-47bb-bacb-cb04a54b8e33
bab50fbc-7f3d-42d7-8725-8af86ac0f002	02f340b8-d634-442d-91ce-dbe800ca0d79	5515496c-aa59-404c-a86b-8394373b61d2
7b2952ff-f8be-4dd5-87b7-ef78e2c8245a	6cf607f1-8148-4e0e-9546-e2c676d839d1	ff969145-e1c3-46e6-9b0a-d0b6289e0cfc
fb3e8304-e354-4653-873b-9eb132a78090	6cf607f1-8148-4e0e-9546-e2c676d839d1	f4b4f53c-5347-4a01-94d4-f3b716372ca3
e6d62460-9054-4f8d-b0b1-5c1f2e70169a	6cf607f1-8148-4e0e-9546-e2c676d839d1	b1531496-dfdc-4575-97b1-45db69ab5c33
8d9711df-44b8-4366-b853-8b55c98f4337	6cf607f1-8148-4e0e-9546-e2c676d839d1	7d30579b-74f1-4c1e-8e38-baf767d1f211
a9c5a21a-310c-43c1-af4a-0926f5d7d20c	6cf607f1-8148-4e0e-9546-e2c676d839d1	028740a5-295b-4dca-8a95-9001de7abe91
59d4526c-a0e8-499c-a3b8-157675570b07	6cf607f1-8148-4e0e-9546-e2c676d839d1	a0008742-b48a-4db5-9211-e1be19ddd5de
9509a3cc-dfce-4c5c-b204-afd9cb19db23	6cf607f1-8148-4e0e-9546-e2c676d839d1	e4fced24-8052-41fd-a42f-d453b5d85b35
3aa24922-6561-427b-87cd-0281b5e1b30a	6cf607f1-8148-4e0e-9546-e2c676d839d1	65b4ac8b-2480-45bd-9825-8e5c647fcc54
cec3ac80-deba-4671-b374-880c495de28d	6cf607f1-8148-4e0e-9546-e2c676d839d1	1c663021-aec2-4f20-8ba1-dbeaef18cd32
9e605e14-53e2-4dce-8ece-ac0b5c6159db	6cf607f1-8148-4e0e-9546-e2c676d839d1	0dc98045-b8a6-40da-9043-94c61eb4212d
d2daf313-04b8-4684-9f70-7bcec1fa5a33	6cf607f1-8148-4e0e-9546-e2c676d839d1	4d603dde-a59c-40d4-925d-799ac695119b
58d0c739-1de3-4b70-9cae-4d55f30befda	6cf607f1-8148-4e0e-9546-e2c676d839d1	2cd67c30-0ee0-43c2-b3fa-26c6e3ccf0fb
c63ce729-a4cb-42aa-8838-8ad4bd582f48	6cf607f1-8148-4e0e-9546-e2c676d839d1	7137d836-3def-4638-8999-234bfcc6e257
2dc619df-6440-4b1a-89c2-618fdd442a78	6cf607f1-8148-4e0e-9546-e2c676d839d1	2f14c165-975a-4db0-9abb-e907d8aba5c2
ce6c35c5-4720-4448-9ba6-eeaf455a9171	6cf607f1-8148-4e0e-9546-e2c676d839d1	bd708408-74b9-4092-93a4-6d9ba8676a49
dcf94705-7315-41c4-bd2a-54c5e67c9d39	6cf607f1-8148-4e0e-9546-e2c676d839d1	7e049e94-966a-43c2-8e97-de82cf810055
b274c991-f0d2-4d8c-bc77-40aee42b3f86	6cf607f1-8148-4e0e-9546-e2c676d839d1	9e1fc3af-dce4-4b5b-8e87-a4564f3ddbcf
67fa15f2-6294-4e91-bc29-c804d4ee5aa8	6cf607f1-8148-4e0e-9546-e2c676d839d1	565537fa-7dda-4ae3-a6ad-f0c53fa21b5f
be35cd37-b556-48e6-9bae-83bca744b0bc	6cf607f1-8148-4e0e-9546-e2c676d839d1	6581ea7e-1b89-4900-a832-dc2539d193a8
3918367e-f4d2-467b-9cd2-f9efcd3bb801	6cf607f1-8148-4e0e-9546-e2c676d839d1	6f087500-e53a-444a-96d1-92d8a5cb7689
c0758cc0-757b-470f-a42e-1dd110cb83a3	0ddce009-d455-4a99-880a-cc2889fe48ef	7206d475-6e49-47c4-a9f4-67365fcb4a4d
eab553c7-fb21-4436-bfb8-5409acaa4bdf	0ddce009-d455-4a99-880a-cc2889fe48ef	5bbbdfa8-abbc-44c4-910b-a5933bde7511
caf3c8a1-6a9b-4440-b50b-ef3cf702c2ed	0ddce009-d455-4a99-880a-cc2889fe48ef	05e5943e-340d-41b1-84c5-f2be9d44fbce
2dd02a56-0f7a-4637-806c-76dd4f1e991f	0ddce009-d455-4a99-880a-cc2889fe48ef	54bb9598-c336-49a0-b413-83fb45724912
02024d6c-9daa-4324-b0de-2fcfe7e662a5	0ddce009-d455-4a99-880a-cc2889fe48ef	bec5be95-8b47-4947-b972-cf386424272a
0d2347ab-8a25-4741-9dbf-c57dce08885c	0ddce009-d455-4a99-880a-cc2889fe48ef	34c01f89-b691-417b-813a-90c7152b68dd
d65068f6-8961-470a-bf57-4d5057751407	0ddce009-d455-4a99-880a-cc2889fe48ef	56fa3e39-803a-4d8b-85f3-f025ff970a11
4fc22b5c-188d-4e03-b9c9-b14c26fc1555	0ddce009-d455-4a99-880a-cc2889fe48ef	9b05d048-943a-41bf-b48d-6d00b545d467
c6c20715-fc95-48d9-b41e-0b176a422ba8	0ddce009-d455-4a99-880a-cc2889fe48ef	a58bf2c5-f0e1-4d3e-a306-f56baf87bdab
2c56b1e0-5bac-4e7d-bfcf-7619b1e826ae	0ddce009-d455-4a99-880a-cc2889fe48ef	165abb7c-1cb4-4f02-9f44-6766e02e950b
8d2cda07-f0fb-4c5c-af4d-93985aa2a132	0ddce009-d455-4a99-880a-cc2889fe48ef	06384cdd-e6d1-4603-bc16-8346a06ae6c4
647e14ce-ab36-4bd5-a84c-e7287059852f	0ddce009-d455-4a99-880a-cc2889fe48ef	10ac41a7-1ca3-4166-b8c2-c4cdf1e6693e
c5caa074-0b2b-4602-acae-8d8ff4d1d29d	0ddce009-d455-4a99-880a-cc2889fe48ef	90a2b57e-e2ef-4356-ac11-5efbf0b786b9
ad6874a1-d1bf-44d8-9190-913d47a20587	0ddce009-d455-4a99-880a-cc2889fe48ef	5556e000-5e58-4cad-8184-efde9e15b665
0d581423-1bb1-41e6-bf6e-2fb81ba0057e	0ddce009-d455-4a99-880a-cc2889fe48ef	e2447a60-1f7f-47c9-bbf6-1e6ea1171edc
86719c9a-5cc3-4db0-aede-8c127599436c	b8cb61f2-0bef-4c92-a61a-a33d36267a07	848cfbbe-1d5a-4fcc-8c66-926f7e9e6573
d0a1c66b-efb0-4379-9026-7a02cdda4ccd	b8cb61f2-0bef-4c92-a61a-a33d36267a07	01e5b1f0-1d0d-4bcb-91b9-e9054858c674
3d88d841-e029-47eb-8450-701b88d9c31a	b8cb61f2-0bef-4c92-a61a-a33d36267a07	5b3e13cd-96e9-44d5-af6f-5f44e7333147
be0ed490-d6f2-4d92-b3d8-d456740238bf	b8cb61f2-0bef-4c92-a61a-a33d36267a07	d0253a91-81a1-4055-ae41-f0c4173127b7
deb6b5e6-4b82-40e8-8d84-ddd33cd2ea32	b8cb61f2-0bef-4c92-a61a-a33d36267a07	a225be07-e924-42d3-a178-40556bdc2df5
98149139-7dfb-4906-b082-c1988a884dda	b8cb61f2-0bef-4c92-a61a-a33d36267a07	b5cce6ce-a1c3-4274-abdb-6e531516bf73
7540057b-fcf2-4d7d-b1ec-c751b71e0357	b8cb61f2-0bef-4c92-a61a-a33d36267a07	4a2b7ad2-19fc-4883-88d3-f0e51bb9daf3
a06ed20c-1717-404c-a8dd-84d616cd647c	b8cb61f2-0bef-4c92-a61a-a33d36267a07	5b8f4f4f-927a-4af8-af75-abd89d12eb27
d74c8105-6e4c-4623-8cef-ed93bb30a3f9	b8cb61f2-0bef-4c92-a61a-a33d36267a07	4a6442d0-52ef-4b29-9bda-707aba8f3df8
b09987cb-7eeb-4de7-ba0d-a67712c11cbb	b8cb61f2-0bef-4c92-a61a-a33d36267a07	75d52305-5775-45d2-ba9e-4af3b467e426
9c41b158-a2ff-4736-adba-ff6863e55b47	b8cb61f2-0bef-4c92-a61a-a33d36267a07	43363b25-869f-411d-aec3-c3c32861bb55
8e38e945-66e8-4b85-800e-284a23d0160f	b8cb61f2-0bef-4c92-a61a-a33d36267a07	8f596acf-2a3f-4f56-b172-9ab998a2566c
df6e8e6a-b799-4523-8ed1-5fe8f3844014	b8cb61f2-0bef-4c92-a61a-a33d36267a07	0691c710-70ca-4a04-b248-812326b8d33a
4f6d4884-e260-4a47-b308-299ca84061c2	b8cb61f2-0bef-4c92-a61a-a33d36267a07	f1d82563-157d-4d62-a4d5-efc9549dd089
2b0b023a-003c-499a-b636-fca3e1c495dd	b8cb61f2-0bef-4c92-a61a-a33d36267a07	a3a037e7-0ddc-45c1-864b-56e4a69c69fa
fce92323-b422-42d9-a0ae-cd60e0ddc9d2	b8cb61f2-0bef-4c92-a61a-a33d36267a07	c501e991-a221-42ab-a9bf-9e475f2c9092
375ea8fd-aa39-42e1-a28b-159b04bc294d	b8cb61f2-0bef-4c92-a61a-a33d36267a07	4776805d-d8b7-42a6-95d0-9d9d8d8bc595
a652b74f-7210-438d-9c5b-f985389bd1a6	b8cb61f2-0bef-4c92-a61a-a33d36267a07	cf784479-ea67-4207-8dbc-6a67ba168ce3
9a0fc863-d15b-4b59-89b7-c9106f39287f	b8cb61f2-0bef-4c92-a61a-a33d36267a07	4f7d99dc-b37a-4332-9429-163702133575
05095224-11dc-4f79-adb6-9372e691af07	b8cb61f2-0bef-4c92-a61a-a33d36267a07	e557a1a1-5530-441e-9811-6227a0931404
ed13150d-92af-485f-95b7-84f418e076db	372d6714-d819-4e24-b10a-ab33016034b3	dbdcdbc7-bab0-4e33-808d-08e60a94a061
6cf80f8b-776c-4571-9d13-e02f64baf857	372d6714-d819-4e24-b10a-ab33016034b3	89841209-f0c4-467b-a6b0-f52ca915b152
34c17b86-9c12-4977-abcd-eda9cbc72dd0	372d6714-d819-4e24-b10a-ab33016034b3	7220d1ff-6220-41a7-9b0c-d42c6b8da917
cf3a2ecc-8eab-455c-83f1-76a94a6d3214	372d6714-d819-4e24-b10a-ab33016034b3	7b7563bc-55f9-49b2-be4f-0bb934914bff
51434ded-e793-410b-87d0-c66c823cfa8b	372d6714-d819-4e24-b10a-ab33016034b3	92c75fc8-3a82-45e6-9581-3eac4d6b2445
4121e41e-505f-4f43-a959-69617340514a	372d6714-d819-4e24-b10a-ab33016034b3	dfb0ebec-f3bb-4cfd-8bad-1d996f596d96
c60da4a6-13a0-4339-b705-5948bee7517e	372d6714-d819-4e24-b10a-ab33016034b3	e392bf4d-5733-4d49-9ef2-6b5d6eb486ff
7017c349-6a62-4a6c-9cb3-6c070db58d6c	372d6714-d819-4e24-b10a-ab33016034b3	43669802-e52f-4470-8b1e-941555ad3980
e7ce1198-5b45-43bc-bae3-c336a64dc80f	372d6714-d819-4e24-b10a-ab33016034b3	ea5149de-c57b-498b-931d-70f3c58e44d7
4ce41d36-bf8a-4247-a438-19eec383ae76	372d6714-d819-4e24-b10a-ab33016034b3	83a89302-e143-49e0-a5b8-60daae6fc0fb
2b212491-e440-49ed-902f-8127efbfd73b	372d6714-d819-4e24-b10a-ab33016034b3	d5b41d0e-2475-467b-8eb6-987ff294931d
655670e4-d14c-4cc0-9613-eccc20ea3733	372d6714-d819-4e24-b10a-ab33016034b3	a537887a-0655-4c6c-9f22-5f44020f4e35
aacb7edf-b440-48fe-84d8-05cda9bd5dac	372d6714-d819-4e24-b10a-ab33016034b3	4dd5c86d-9aff-4198-9342-da2e4be65442
fd977960-0581-4515-b691-6ce653e52a8f	372d6714-d819-4e24-b10a-ab33016034b3	012cf88a-1472-47b8-a809-3711c79fe325
99c983d0-6b13-4bba-89e7-2ef04b5dacca	372d6714-d819-4e24-b10a-ab33016034b3	82a08064-4d4b-4aef-ad75-0803b68fb379
2cc6fee0-09f3-441d-a1dd-34f5f3702ec3	372d6714-d819-4e24-b10a-ab33016034b3	1d3c0cfa-d7e0-4d05-b165-5e6f3328395e
d9a1c4df-008d-4fb1-8dc8-bea89308ef16	372d6714-d819-4e24-b10a-ab33016034b3	1f279ee3-652b-4202-bc19-b52549bdf735
7107f6c4-d405-4c51-887d-8388762d472a	372d6714-d819-4e24-b10a-ab33016034b3	2f2d3f7c-bab3-4c36-a18b-84b12e11cb86
6d3834d1-366d-4bb3-b5bb-3bb56a9cad34	372d6714-d819-4e24-b10a-ab33016034b3	f727caa1-a549-4686-8e93-9bb5137cebba
642313df-4209-4a2f-938c-0b88383a91d0	372d6714-d819-4e24-b10a-ab33016034b3	ba3816ba-1db2-4968-8e22-7f72d7d2d59b
fd8b80af-2c0e-47f0-a28e-ccb8544bca01	9c9f20a7-001a-4256-ad32-778f165c70d9	b8e4a3b7-1c2d-415f-bec3-674198ccfe87
4ebaf003-34ba-429c-9d1f-ab22e34cba27	9c9f20a7-001a-4256-ad32-778f165c70d9	8583cc8f-c120-4326-908c-d2dba560f94b
e5c9e722-ea1f-4425-b436-086e6429c2ce	9c9f20a7-001a-4256-ad32-778f165c70d9	a59be27e-71eb-4a6e-875b-9c17f22179c0
3c87232c-8cf2-461f-8906-bfa497fd7a55	9c9f20a7-001a-4256-ad32-778f165c70d9	af45f596-f8e4-48b9-b6b4-1496496c2ee6
7d3ae5e3-d359-4236-aca9-cffd15487dcf	9c9f20a7-001a-4256-ad32-778f165c70d9	d0609dc4-024e-433c-b051-e86466ccab75
390360d6-e662-4db8-ad03-6d084e4cb06b	9c9f20a7-001a-4256-ad32-778f165c70d9	963f9cbe-1592-4524-b5f6-4c412f501464
df5022dc-a317-4183-a198-fac20e519941	9c9f20a7-001a-4256-ad32-778f165c70d9	d0905b41-4b38-4306-b426-85ce3efe9c1f
9daaab1f-ee4b-437b-9243-50843775c84a	9c9f20a7-001a-4256-ad32-778f165c70d9	7e69932c-800f-4340-afca-58ac5b278741
f07bfbbf-38a9-4d71-862d-e8ac6f8ce5fa	9c9f20a7-001a-4256-ad32-778f165c70d9	a843978e-c3f3-45c5-90cf-40bd821b6618
79dae01d-b501-47ba-b765-fc5293f0caf6	9c9f20a7-001a-4256-ad32-778f165c70d9	1dd81e0c-ff1c-48d7-abbb-dea82138afcc
93189ffd-b32b-4093-a26d-808650d956fb	9c9f20a7-001a-4256-ad32-778f165c70d9	d9b581a9-a8bf-49f1-86c9-deab9a437870
a8a206a1-dc0f-40a3-adda-f5039b8ad2b8	9c9f20a7-001a-4256-ad32-778f165c70d9	c8d84311-84af-4c54-bffc-33a290736fd2
ad3f10d4-d5fe-41b9-b2e7-0ebd7bc695dd	9c9f20a7-001a-4256-ad32-778f165c70d9	74928d24-beba-4fda-b47d-c68d11767fcf
cbaeef55-792f-4545-b512-4750202e72d5	9c9f20a7-001a-4256-ad32-778f165c70d9	a4678eb0-a3c2-4d86-b1a9-b9810762d8c3
80b50f0a-b619-4018-833c-5bded970cfef	9c9f20a7-001a-4256-ad32-778f165c70d9	d9ad403b-29e3-47bb-8f8b-7159f773e48a
9144b1ef-cd09-4809-bd2b-5379f3d2bda7	9c9f20a7-001a-4256-ad32-778f165c70d9	98281884-47f8-45e0-9714-62b03b56f997
af970be9-d0f7-4a5e-bc97-c1888aab09f6	9c9f20a7-001a-4256-ad32-778f165c70d9	b448a186-bc65-402b-b181-a36f61a3c0e1
dccc3e84-e1d9-484e-b1cc-0518609b19a9	9c9f20a7-001a-4256-ad32-778f165c70d9	df1c0200-c3fb-4882-bd05-dad6511845b3
e3d788dd-db7e-4a4c-886d-d3434fbe1d1c	9c9f20a7-001a-4256-ad32-778f165c70d9	31affd1f-0dfe-4e75-aa02-33abaae3c081
37b15c8b-eade-47eb-b060-8d56b5e25925	9c9f20a7-001a-4256-ad32-778f165c70d9	9426cc57-ca63-4f23-b123-e116fd642191
735bb7da-fb4d-4b58-9d4a-50f5c0d8630c	9c9f20a7-001a-4256-ad32-778f165c70d9	a9d78d83-aa97-4c1b-9f72-375cf8b0f124
0a328c59-54dd-4c02-857e-d973c4417c5a	de2500b5-d993-437c-86fb-bff46bbd3e00	f6d83d4d-ff53-4a5c-afd8-3cc923dbe48b
8e1f3069-6606-4756-b6a8-457a2959ff01	de2500b5-d993-437c-86fb-bff46bbd3e00	2de3194d-7722-41e2-b1cb-7170e2dbc02d
7530142c-d962-4f31-9f9a-2eef8c22e1b6	de2500b5-d993-437c-86fb-bff46bbd3e00	9464a63f-b7e0-48f1-b5a5-8a467d25850d
09b9c730-03e4-440e-aa57-e1ed5e0281df	de2500b5-d993-437c-86fb-bff46bbd3e00	4a7934fc-d6f1-4d10-b642-40dde4939cf2
b4fa0317-0610-402a-95dc-0678f138f1c3	96a747b7-5f15-43df-af97-12b249929a4d	6462037f-5ace-43f7-b00a-5442b9afda3b
0637c545-d552-4927-af5b-107e9cb09b5a	96a747b7-5f15-43df-af97-12b249929a4d	81d87f6f-636e-4548-814c-2121ad1efad9
d6839f3e-b77b-4592-8494-3ba716e8d831	96a747b7-5f15-43df-af97-12b249929a4d	7e0f4dc2-e90e-4b72-81ce-4a4271789188
66ba93f4-b6ba-489b-b3f2-e2b1d5e46d7a	96a747b7-5f15-43df-af97-12b249929a4d	6ce2e436-3dea-4f2f-a846-20cf2a1889b9
4db5dbff-292d-48db-929a-9686a458d2fb	96a747b7-5f15-43df-af97-12b249929a4d	b173309d-a69c-463f-89ff-0cf0a0af9fe4
47a0142c-4fcc-4ccb-a263-79027e5d9d7b	96a747b7-5f15-43df-af97-12b249929a4d	e6c46fc7-940e-43d8-812e-2df48871be19
494d2a32-5e1b-44b1-b446-f2bc024804e0	96a747b7-5f15-43df-af97-12b249929a4d	1697182b-92b7-4f6b-8dd3-c94a8ef9a754
d75701d6-efb1-4b2e-9609-0a98a288fe9b	96a747b7-5f15-43df-af97-12b249929a4d	62b6a876-21ad-4c1e-9580-5372c8e386e1
ba87de7d-0a6a-4d6e-ab20-e9252099abc6	96a747b7-5f15-43df-af97-12b249929a4d	465b334a-7d3a-4cce-9503-9bad45e29208
e9c5d061-232e-4c28-b9f3-28de87db20e0	96a747b7-5f15-43df-af97-12b249929a4d	f9f1a468-b088-45f4-888e-a3f173662ae6
d708ad81-75f0-49c2-9dc8-9fe77dd902f6	96a747b7-5f15-43df-af97-12b249929a4d	8703a13c-d590-4dbf-84e8-732e1738f910
0cc964e6-5df3-49d9-a3b3-7e21fe555ec2	96a747b7-5f15-43df-af97-12b249929a4d	b7ed670d-6936-41ac-882f-949703f9a3a4
5a0363a1-7759-44ea-8cf9-0fd158d2cb13	96a747b7-5f15-43df-af97-12b249929a4d	b0c5c73f-b058-4c55-b48b-c197b5af91ee
68f6fe9a-f43d-4236-ba38-6164ff9b4840	96a747b7-5f15-43df-af97-12b249929a4d	0edbf522-ad34-4c7f-ab3e-1627f6f9ec3d
caaae6c4-60bd-409c-a4bb-a0a14286d5c3	96a747b7-5f15-43df-af97-12b249929a4d	059fe1cc-c035-4667-8035-2858fbe6a15c
593f7703-6543-493b-a23d-d4c6bde9b337	778a6f12-4ba6-4411-be39-140615f5885a	0019774e-a19f-4960-ab85-67f601d804f9
1a76f3cf-2fbb-48e5-988f-bbf293c39b8c	7ee11f45-0498-43e2-9ef7-4d85194d6238	2568e78d-3b44-4d64-81e9-44aef4517145
034573d4-0191-46c4-9c52-3234ad901c29	7ee11f45-0498-43e2-9ef7-4d85194d6238	bd2fe6da-8656-4684-8bb6-a6eaf5d82d59
49d7b2dc-7a9a-466e-95d2-ace9aedaaed4	83e3b0a1-7f4e-49ef-bea9-e156dbd8c217	9e1fc3af-dce4-4b5b-8e87-a4564f3ddbcf
76f8f59e-2456-420e-9f20-a2e48ebef7db	83e3b0a1-7f4e-49ef-bea9-e156dbd8c217	8703a13c-d590-4dbf-84e8-732e1738f910
02617747-bc2e-4e48-9523-2cdd39ab30cb	83e3b0a1-7f4e-49ef-bea9-e156dbd8c217	412a12ec-d4de-494d-9eb4-0e0e7a989a59
362ac4da-eb34-4a2e-831e-c3890c1feb3b	83e3b0a1-7f4e-49ef-bea9-e156dbd8c217	8583cc8f-c120-4326-908c-d2dba560f94b
ab3c59b7-ce19-46c2-8cc4-f00b26710d1a	9a9edeba-921d-4caa-bfb3-a4ad2ec7957b	23322f8e-fef4-4382-861f-7560dea5fe76
480f9516-f1a4-4316-a712-e56085bb0dd9	9a9edeba-921d-4caa-bfb3-a4ad2ec7957b	21e5fc60-6dfd-4e57-bbcb-636fce122b7c
b65cc924-230d-479d-8c55-3c1738a0fa60	5cb33453-ddec-484b-b75b-f7293345c325	9e1fc3af-dce4-4b5b-8e87-a4564f3ddbcf
fa9969af-080a-473d-8b94-bb3674880e6f	5cb33453-ddec-484b-b75b-f7293345c325	8703a13c-d590-4dbf-84e8-732e1738f910
69724f44-30ca-4c37-b834-02645e704254	5cb33453-ddec-484b-b75b-f7293345c325	412a12ec-d4de-494d-9eb4-0e0e7a989a59
\.


--
-- TOC entry 3607 (class 0 OID 16448)
-- Dependencies: 217
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modules (id, owner_id, parent_id, name, description, is_public, created_at, module_type, deleted_at) FROM stdin;
7ee11f45-0498-43e2-9ef7-4d85194d6238	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Environment 2	Environment vocabulary	f	2025-12-06 07:23:12.517501	personal	\N
b030d5d5-63cc-493b-a991-0d6e0bc968e0	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Environment 3	Environment vocabulary	f	2025-12-06 07:23:12.517501	personal	\N
380fb7c0-07ee-42db-b0a0-9b31b8d7fe19	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Business	Business vocabulary	t	2025-12-06 07:23:12.521267	personal	\N
49c26e52-a961-4d20-9168-014d2953eb1a	c8c32c24-a320-4798-9fb6-3716016b757f	\N	Travel	Travel related vocabulary	t	2025-12-06 07:23:12.51386	system	\N
5bac030d-d908-4fa0-9ab7-826d8b38039c	c8c32c24-a320-4798-9fb6-3716016b757f	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Office	Office vocabulary	t	2025-12-06 07:23:12.519796	system	\N
778a6f12-4ba6-4411-be39-140615f5885a	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Business	Business vocabulary	f	2025-12-06 07:23:12.521267	personal	\N
0b8a1ae4-30d7-46f5-b2c3-ca287873aa67	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Office	Office vocabulary	t	2025-12-06 07:23:12.519796	personal	\N
35c68566-ca38-4d6e-86aa-55115a514835	19c5fcb3-6798-4c7a-bc93-aa09f0573c02	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Office	Office vocabulary	t	2025-12-06 07:23:12.519796	personal	\N
8325b95b-cbfa-4350-98c8-4df6060cc22d	19c5fcb3-6798-4c7a-bc93-aa09f0573c02	ffd5fc68-91ab-4b79-a19c-374d07f178c9	TOEIC – Business	Business vocabulary	f	2025-12-06 07:23:12.521267	personal	\N
ed541d88-3e8c-45e4-a10f-4f2509605465	7731f70e-0475-42a4-8e2e-22542510ea14	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Health	Health topic vocabulary	f	2025-12-06 07:23:12.515384	personal	\N
c7aaa3ab-77da-4d90-931e-b824ad9acd1a	c8c32c24-a320-4798-9fb6-3716016b757f	\N	IELTS	Main IELTS vocabulary	t	2025-12-06 07:23:12.508108	system	\N
ffd5fc68-91ab-4b79-a19c-374d07f178c9	c8c32c24-a320-4798-9fb6-3716016b757f	\N	TOEIC	TOEIC vocabulary collection	t	2025-12-06 07:23:12.51044	system	\N
e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	c8c32c24-a320-4798-9fb6-3716016b757f	\N	Daily Life	Everyday words	f	2025-12-06 07:23:12.512205	system	\N
2cd83825-331c-43f5-a320-c6577e55fb26	7731f70e-0475-42a4-8e2e-22542510ea14	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Health	Health topic vocabulary	t	2025-12-06 07:23:12.515384	personal	\N
c0c7f648-d1d7-4363-8a0f-1842fe16d54e	7731f70e-0475-42a4-8e2e-22542510ea14	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Health	Health topic vocabulary	f	2025-12-06 07:23:12.515384	personal	\N
3e2fd496-4ccb-4b80-be78-4a8c31fb5918	19c5fcb3-6798-4c7a-bc93-aa09f0573c02	c7aaa3ab-77da-4d90-931e-b824ad9acd1a	IELTS – Environment 1	Environment vocabulary	f	2025-12-06 07:23:12.517501	personal	\N
0ddce009-d455-4a99-880a-cc2889fe48ef	c8c32c24-a320-4798-9fb6-3716016b757f	5c334e04-f4f2-4d9e-a8c8-2b58c92b39d1	Pervasive Computing	Pervasive computing vocabulary	f	2025-12-14 06:32:49.714159	system	\N
b8cb61f2-0bef-4c92-a61a-a33d36267a07	c8c32c24-a320-4798-9fb6-3716016b757f	5c334e04-f4f2-4d9e-a8c8-2b58c92b39d1	Mobile Computing	Mobile computing vocabulary	f	2025-12-14 06:32:49.714159	system	\N
372d6714-d819-4e24-b10a-ab33016034b3	c8c32c24-a320-4798-9fb6-3716016b757f	5c334e04-f4f2-4d9e-a8c8-2b58c92b39d1	Distributed Computing	Distributed systems vocabulary	f	2025-12-14 06:32:49.714159	system	\N
02f340b8-d634-442d-91ce-dbe800ca0d79	c8c32c24-a320-4798-9fb6-3716016b757f	7f105d0d-bbd1-4a8d-9c6e-7fc14ed29712	Operating system	Operating system vocabulary	f	2025-12-14 06:32:49.714159	system	\N
abd52e8f-a713-4587-9959-0164c7f1a4f5	c8c32c24-a320-4798-9fb6-3716016b757f	7f105d0d-bbd1-4a8d-9c6e-7fc14ed29712	Introduction to programming	Introduction to programming	f	2025-12-14 06:32:49.714159	system	\N
e00a71ac-7405-4b5c-b88e-cd9f4901cb24	c8c32c24-a320-4798-9fb6-3716016b757f	7f105d0d-bbd1-4a8d-9c6e-7fc14ed29712	Database fundamentals	Database fundamentals vocabulary	f	2025-12-14 06:32:49.714159	system	\N
0b74fa4e-beb0-4eb7-a148-333cb5b5835b	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Hotel - update 02	Hotel vocabulary	t	2025-12-06 07:23:12.527149	personal	\N
149b99b6-d9c3-432c-89a8-16d1df2f7301	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Hotel 01	Hotel vocabulary	t	2025-12-06 07:23:12.527149	personal	\N
e4ea77db-a6a5-40a3-9d8e-24c4cd81e387	19c5fcb3-6798-4c7a-bc93-aa09f0573c02	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Airport	Airport vocabulary	f	2025-12-06 07:23:12.525757	personal	\N
d4fc29b8-aad4-40c2-ab31-493751f66772	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Food	Common foods	t	2025-12-06 07:23:12.524329	personal	\N
aa914db9-8d98-4bae-80e4-32d6401fb5e2	7731f70e-0475-42a4-8e2e-22542510ea14	\N	string	string	f	2025-12-25 00:50:11.055442	personal	\N
96a747b7-5f15-43df-af97-12b249929a4d	7731f70e-0475-42a4-8e2e-22542510ea14	\N	Pervasive Computing	\N	t	2025-12-25 01:18:28.439677	personal	\N
de2500b5-d993-437c-86fb-bff46bbd3e00	7731f70e-0475-42a4-8e2e-22542510ea14	\N	IELTS – Environmentttt	\N	t	2025-12-25 01:00:20.747949	personal	\N
3270c71e-dee1-4f23-b112-612394636a4c	c8c32c24-a320-4798-9fb6-3716016b757f	49c26e52-a961-4d20-9168-014d2953eb1a	string	string	f	2025-12-25 05:46:28.881308	system	\N
83e3b0a1-7f4e-49ef-bea9-e156dbd8c217	c8c32c24-a320-4798-9fb6-3716016b757f	49c26e52-a961-4d20-9168-014d2953eb1a	tessst	aaaa	t	2025-12-25 05:47:10.988305	system	\N
51093613-eea0-464d-8b65-da59523045ff	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Airport	Airport vocabulary	f	2025-12-06 07:23:12.525757	personal	\N
6c0b8648-408c-4025-b3db-73d8f20c731d	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Home	Household items	f	2025-12-06 07:23:12.52291	personal	\N
78204820-1e87-4411-a164-b0ba24f3e526	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Airport	Airport vocabulary	f	2025-12-06 07:23:12.525757	personal	\N
7b4e1cb0-a1ad-4c14-9f2a-412e2c648137	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Home	Household items	f	2025-12-06 07:23:12.52291	personal	\N
cf0b024f-0705-4c71-bc48-3f24fd8c6262	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Home	Household items	f	2025-12-06 07:23:12.52291	personal	\N
db420a03-674e-4f09-8f26-55eb462c4e51	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	49c26e52-a961-4d20-9168-014d2953eb1a	Travel – Hotel	Hotel vocabulary	f	2025-12-06 07:23:12.527149	personal	\N
e645565a-de74-4b2c-8de8-7416965917eb	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Food	Common foods	f	2025-12-06 07:23:12.524329	personal	\N
f9aca3c8-5b0f-4cd3-b6b3-0f6a2bdc0190	9150dfe1-0758-4716-9d0e-99fc0fbe3a63	e297d423-edcc-4f30-ba24-bbd1ae2ff8a4	Daily – Food	Common foods	f	2025-12-06 07:23:12.524329	personal	\N
9a9edeba-921d-4caa-bfb3-a4ad2ec7957b	7731f70e-0475-42a4-8e2e-22542510ea14	\N	Copy TOEIC – Office	Office vocabulary	t	2025-12-25 08:38:41.922032	personal	\N
5cb33453-ddec-484b-b75b-f7293345c325	c8c32c24-a320-4798-9fb6-3716016b757f	49c26e52-a961-4d20-9168-014d2953eb1a	Tesst 25.12	Mo taaaa	t	2025-12-25 08:43:30.504465	system	\N
6cf607f1-8148-4e0e-9546-e2c676d839d1	c8c32c24-a320-4798-9fb6-3716016b757f	7f105d0d-bbd1-4a8d-9c6e-7fc14ed29712	Object-oriented programming	Object-oriented programming vocabulary	t	2025-12-14 06:32:49.714159	system	\N
9c9f20a7-001a-4256-ad32-778f165c70d9	c8c32c24-a320-4798-9fb6-3716016b757f	5c334e04-f4f2-4d9e-a8c8-2b58c92b39d1	Cloud Computing	Cloud computing vocabulary	t	2025-12-14 06:32:49.714159	system	\N
5c334e04-f4f2-4d9e-a8c8-2b58c92b39d1	c8c32c24-a320-4798-9fb6-3716016b757f	\N	Software engineering	Software engineering vocabulary	f	2025-12-14 06:32:49.714159	system	\N
7f105d0d-bbd1-4a8d-9c6e-7fc14ed29712	c8c32c24-a320-4798-9fb6-3716016b757f	\N	Basic programming	Basic programming vocabulary	f	2025-12-14 06:32:49.714159	system	\N
\.


--
-- TOC entry 3619 (class 0 OID 16656)
-- Dependencies: 229
-- Data for Name: quiz_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_answers (id, quiz_result_id, word_id, user_answer, correct_answer, is_correct) FROM stdin;
7405ada2-1584-4480-a3a3-6c616fe20cfb	b996b947-8ede-4f19-863a-61b2a30fac85	8e8ccb04-dac8-410b-be57-7d64735dae5d	lợi ích	lợi ích	t
ccdef5c0-d17c-4a13-a1d4-3f04b75ae0ca	b996b947-8ede-4f19-863a-61b2a30fac85	a38eb1a3-349f-49c4-af47-5848871209c2	bệnh tật	bệnh tật	t
78fae0ce-5203-4228-82f8-45b3d101423f	b996b947-8ede-4f19-863a-61b2a30fac85	a2a11fac-65d3-4a38-92a9-c53cd0991237	điều trị	điều trị	t
c17d018d-5422-428a-b8ed-85fcf56e4a27	b996b947-8ede-4f19-863a-61b2a30fac85	ec2a7e58-020f-43ef-a099-2cf8f90eca7e	ô nhiễm	ô nhiễm	t
a41dcec6-6eab-42c0-8e03-5d9128066654	b996b947-8ede-4f19-863a-61b2a30fac85	0086752d-3a4f-41f9-ab17-543eaaf9396e	bảo tồn	bảo tồn	t
139151f6-f800-413c-b702-7f1fefa40597	b996b947-8ede-4f19-863a-61b2a30fac85	e3712645-6427-4587-8899-2d3ca2028486	văn phòng	văn phòng	t
af9399e7-f85e-4855-bd94-4299891a6423	b996b947-8ede-4f19-863a-61b2a30fac85	6f638a4e-ecd8-42dd-a246-7cf9636088de	cuộc họp	cuộc họp	t
602daa1f-46bf-4bcc-892a-2a46773aa244	b996b947-8ede-4f19-863a-61b2a30fac85	18dde600-99c8-447d-9295-cd5f23a2694e	hợp đồng	hợp đồng	t
8d29a392-de8b-4212-9e45-b990b471849c	b996b947-8ede-4f19-863a-61b2a30fac85	9fee3fe8-6788-4784-9316-b8433b89ffb6	nhà bếp	nhà bếp	t
b35f1186-8dc7-48af-850a-95ec49c023fb	b996b947-8ede-4f19-863a-61b2a30fac85	f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc	phòng ngủ	phòng ngủ	t
\.


--
-- TOC entry 3618 (class 0 OID 16639)
-- Dependencies: 228
-- Data for Name: quiz_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_results (id, user_id, module_id, score, total_questions, created_at) FROM stdin;
b996b947-8ede-4f19-863a-61b2a30fac85	d67e55da-a59f-4c8e-90c9-e43331fe95b5	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	8	10	2025-12-06 07:23:12.548761
422c25f8-24ed-4875-ac45-0f55a2fe9d8b	144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	c0c7f648-d1d7-4363-8a0f-1842fe16d54e	8	10	2025-12-06 07:23:12.548761
\.


--
-- TOC entry 3606 (class 0 OID 16434)
-- Dependencies: 216
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_settings (user_id, dark_mode, preferred_language) FROM stdin;
d67e55da-a59f-4c8e-90c9-e43331fe95b5	f	en
144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	f	en
c4dca63e-f5c0-4777-8e0c-7fd5c0207b12	f	en
\.


--
-- TOC entry 3605 (class 0 OID 16422)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, name, avatar_url, disabled, created_at, role) FROM stdin;
144bbfc5-3a12-48d5-ad23-3a26afa0a4c8	user2@example.com	$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C	Bob	\N	f	2025-12-06 07:23:12.502918	user
c4dca63e-f5c0-4777-8e0c-7fd5c0207b12	user3@example.com	$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C	Charlie	\N	f	2025-12-06 07:23:12.502918	user
d67e55da-a59f-4c8e-90c9-e43331fe95b5	user1@example.com	$2b$12$FRZfuHKl60ZUxdM4Cu2RZecOy4PvRdzpJtUQcb3NilzkghheCQX7C	Alice	\N	f	2025-12-06 07:23:12.502918	user
25cccb69-9e10-4806-bc52-83fb7a78fa94	usertest1@example.com	$2b$12$0Zfu3ic/fdABdzV9znoAnecu24WlLMykddYNk/dCYdtaaXHgTT11q	Test 1	\N	f	2025-12-07 04:26:28.308999	user
19c5fcb3-6798-4c7a-bc93-aa09f0573c02	usertest2@example.com	$2b$12$kAhEaLaudgxlxCrlp8dgeuR.W9y7Ekgcaw7nWfCgXAsTESJhJTmbK	Test 2 auto login	\N	f	2025-12-07 04:30:34.833558	user
c8c32c24-a320-4798-9fb6-3716016b757f	admin@example.com	12345	Admin	\N	f	2025-12-06 09:34:31.992489	admin
b583d995-c026-4d2a-923a-d9f5d47400ea	usertest3@example.com	$2b$12$Jsq216V9YUX1sxPcNM2jBuwW2bVdpz5Uk7CjTDSPXTCR94xCW8RwW	User Test Auto Login 3	\N	f	2025-12-07 06:22:44.857801	user
7731f70e-0475-42a4-8e2e-22542510ea14	test@gmail.com	$2b$12$iL6Bz3LqsNEzS5vQBIYK4eQpl6W6s0Z5SfRQXipoDTe2JC3mAryze	gou		f	2025-12-21 08:37:56.54583	user
846bab44-2dce-43a5-8a9b-bb9bd2822125	test1@gmail.com	$2b$12$T9VyASSecCw9OrJEl2WmjeuGXx/26wepHhjLhpzplNtTcLTw5i87q	gou1		f	2025-12-22 11:42:32.426658	user
9150dfe1-0758-4716-9d0e-99fc0fbe3a63	rootuser@example.com	12345	Root User	\N	f	2025-12-06 09:34:31.992489	user
114f661f-f97f-490c-9bb2-33de5018191f	22520102@gm.uit.edu.vn	$2b$12$x0Ni2S6LPtKw2E.JwMlwcuPTW9RakNoJL43jfOy6QQ8ZaIIAGTqem	Bao Bao		f	2025-12-25 08:10:55.937357	user
291334bd-8f49-480f-98fb-ceb5be3f5be4	hung@gmail.com	$2b$12$QzbhrURl71af5jdz4CAi3.vITyT9SUu0QOquWRTzecjZLYxakCjSe	hung		f	2025-12-25 08:30:51.233023	user
\.


--
-- TOC entry 3611 (class 0 OID 16512)
-- Dependencies: 221
-- Data for Name: word_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.word_comments (id, user_id, word_id, comment, created_at) FROM stdin;
cf5ee5fc-18f2-4982-9e65-c4b02547b231	d67e55da-a59f-4c8e-90c9-e43331fe95b5	8e8ccb04-dac8-410b-be57-7d64735dae5d	This word is difficult.	2025-12-06 07:23:12.554113
be361be0-3851-42bd-8c5c-d9b51543dad4	d67e55da-a59f-4c8e-90c9-e43331fe95b5	a38eb1a3-349f-49c4-af47-5848871209c2	This word is difficult.	2025-12-06 07:23:12.554113
d5d9051c-1a72-425a-aeb1-318f7d4aa59a	d67e55da-a59f-4c8e-90c9-e43331fe95b5	a2a11fac-65d3-4a38-92a9-c53cd0991237	This word is difficult.	2025-12-06 07:23:12.554113
74268866-1573-4f4b-bd36-af8f1a0ac0fd	d67e55da-a59f-4c8e-90c9-e43331fe95b5	ec2a7e58-020f-43ef-a099-2cf8f90eca7e	This word is difficult.	2025-12-06 07:23:12.554113
a46c7c55-a081-47e8-9d56-6fa95d3ae439	d67e55da-a59f-4c8e-90c9-e43331fe95b5	0086752d-3a4f-41f9-ab17-543eaaf9396e	This word is difficult.	2025-12-06 07:23:12.554113
\.


--
-- TOC entry 3621 (class 0 OID 33079)
-- Dependencies: 231
-- Data for Name: word_deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.word_deletes (id, word_id, user_id, deleted_at) FROM stdin;
56133d73-0560-4d31-97be-8f21e3ff0170	64c99693-e39d-4122-96f8-7de4c3454423	7731f70e-0475-42a4-8e2e-22542510ea14	2025-12-24 15:57:34.764076
8a62bf90-26a8-4167-a97a-c847c4d4d97c	2568e78d-3b44-4d64-81e9-44aef4517145	c8c32c24-a320-4798-9fb6-3716016b757f	2025-12-25 02:25:06.450419
9ec62b22-9f59-4bf0-8397-47858bb19130	bd2fe6da-8656-4684-8bb6-a6eaf5d82d59	c8c32c24-a320-4798-9fb6-3716016b757f	2025-12-25 02:31:35.720062
\.


--
-- TOC entry 3610 (class 0 OID 16493)
-- Dependencies: 220
-- Data for Name: word_pronunciation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.word_pronunciation (id, user_id, word_id, score, recorded_audio_url, created_at) FROM stdin;
8001b928-9d4c-4a63-9758-8bcc43c10714	d67e55da-a59f-4c8e-90c9-e43331fe95b5	8e8ccb04-dac8-410b-be57-7d64735dae5d	73	\N	2025-12-06 07:23:12.556935
9c9dda5c-198d-44a0-8a9d-a471b6810848	d67e55da-a59f-4c8e-90c9-e43331fe95b5	a38eb1a3-349f-49c4-af47-5848871209c2	46	\N	2025-12-06 07:23:12.556935
5661b469-7d5c-4049-9593-8b0dd609982f	d67e55da-a59f-4c8e-90c9-e43331fe95b5	a2a11fac-65d3-4a38-92a9-c53cd0991237	2	\N	2025-12-06 07:23:12.556935
c4104d92-5388-4de1-bd4c-d5b9e813973c	d67e55da-a59f-4c8e-90c9-e43331fe95b5	ec2a7e58-020f-43ef-a099-2cf8f90eca7e	56	\N	2025-12-06 07:23:12.556935
521e32d5-cf54-4cee-88de-d0450abf7281	d67e55da-a59f-4c8e-90c9-e43331fe95b5	0086752d-3a4f-41f9-ab17-543eaaf9396e	30	\N	2025-12-06 07:23:12.556935
c6df8c22-c856-4e05-a690-02f9ecf78265	d67e55da-a59f-4c8e-90c9-e43331fe95b5	e3712645-6427-4587-8899-2d3ca2028486	81	\N	2025-12-06 07:23:12.556935
4d7417d5-5608-486b-8326-e4cc35bb9646	d67e55da-a59f-4c8e-90c9-e43331fe95b5	6f638a4e-ecd8-42dd-a246-7cf9636088de	9	\N	2025-12-06 07:23:12.556935
74a15071-fbeb-46dd-bbfd-5ec446f66806	d67e55da-a59f-4c8e-90c9-e43331fe95b5	18dde600-99c8-447d-9295-cd5f23a2694e	95	\N	2025-12-06 07:23:12.556935
4570fa37-f9ed-4fec-8dc9-55c2210a79c0	d67e55da-a59f-4c8e-90c9-e43331fe95b5	9fee3fe8-6788-4784-9316-b8433b89ffb6	50	\N	2025-12-06 07:23:12.556935
43e5e392-58b6-4e06-96e2-31c794b54d1b	d67e55da-a59f-4c8e-90c9-e43331fe95b5	f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc	66	\N	2025-12-06 07:23:12.556935
\.


--
-- TOC entry 3608 (class 0 OID 16468)
-- Dependencies: 218
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.words (id, text_en, meaning_vi, part_of_speech, ipa, example_sentence, audio_url, created_at, deleted_at) FROM stdin;
8e8ccb04-dac8-410b-be57-7d64735dae5d	benefit	lợi ích	noun	/ˈbenɪfɪt/	Exercise has many health benefits.	\N	2025-12-06 07:23:12.529171	\N
a38eb1a3-349f-49c4-af47-5848871209c2	disease	bệnh tật	noun	/dɪˈziːz/	He suffers from a rare disease.	\N	2025-12-06 07:23:12.529171	\N
a2a11fac-65d3-4a38-92a9-c53cd0991237	treatment	điều trị	noun	/ˈtriːtmənt/	The treatment lasted for three months.	\N	2025-12-06 07:23:12.529171	\N
ec2a7e58-020f-43ef-a099-2cf8f90eca7e	pollution	ô nhiễm	noun	/pəˈluːʃən/	Air pollution is increasing.	\N	2025-12-06 07:23:12.529171	\N
0086752d-3a4f-41f9-ab17-543eaaf9396e	conservation	bảo tồn	noun	/ˌkɒnsəˈveɪʃən/	Animal conservation is important.	\N	2025-12-06 07:23:12.529171	\N
e3712645-6427-4587-8899-2d3ca2028486	office	văn phòng	noun	/ˈɒfɪs/	She works in a small office.	\N	2025-12-06 07:23:12.529171	\N
6f638a4e-ecd8-42dd-a246-7cf9636088de	meeting	cuộc họp	noun	/ˈmiːtɪŋ/	The meeting starts at 9 AM.	\N	2025-12-06 07:23:12.529171	\N
18dde600-99c8-447d-9295-cd5f23a2694e	contract	hợp đồng	noun	/ˈkɒntrækt/	He signed a new contract.	\N	2025-12-06 07:23:12.529171	\N
9fee3fe8-6788-4784-9316-b8433b89ffb6	kitchen	nhà bếp	noun	/ˈkɪtʃɪn/	The kitchen is very clean.	\N	2025-12-06 07:23:12.529171	\N
f649e286-0d1e-4b8a-8cfa-e5f68e2f45bc	bedroom	phòng ngủ	noun	/ˈbedruːm/	This bedroom is comfortable.	\N	2025-12-06 07:23:12.529171	\N
262aec7e-90a5-481d-8bbf-de94fc3aca2c	apple	quả táo	noun	/ˈæpəl/	She eats an apple every day.	\N	2025-12-06 07:23:12.529171	\N
7aef4a90-31a7-4274-a8a4-a87009b233d6	rice	gạo	noun	/raɪs/	Vietnamese people eat rice daily.	\N	2025-12-06 07:23:12.529171	\N
11e865bc-9271-4ea7-aac0-f22e56374acf	passport	hộ chiếu	noun	/ˈpɑːspɔːt/	Do you have your passport?	\N	2025-12-06 07:23:12.529171	\N
c8de6806-ca8d-4630-bd49-01166bac8883	reservation	đặt phòng	noun	/ˌrezəˈveɪʃən/	I have a hotel reservation.	\N	2025-12-06 07:23:12.529171	\N
56e178b6-1c62-4487-9897-699609a90d38	flight	chuyến bay	noun	/flaɪt/	The flight was delayed.	\N	2025-12-06 07:23:12.529171	\N
d9bc368b-ba3d-4b97-a6ff-0f3d5cadc13c	global warming	nóng lên toàn cầu	noun	/ˌɡləʊbəl ˈwɔːmɪŋ/	Global warming affects everyone.	\N	2025-12-06 07:23:12.529171	\N
22d80225-0aa3-4688-9827-fc772ddbd024	business	doanh nghiệp	noun	/ˈbɪznɪs/	She owns a small business.	\N	2025-12-06 07:23:12.529171	\N
94e28fae-7ad4-491a-95e0-b7513836888b	salary	lương	noun	/ˈsæləri/	His salary increased this year.	\N	2025-12-06 07:23:12.529171	\N
373e50cf-a792-4872-a4b5-12a410e12124	dishwasher	máy rửa chén	noun	/ˈdɪʃˌwɒʃər/	My house has a dishwasher.	\N	2025-12-06 07:23:12.529171	\N
d8d08a0b-3450-4e30-a2dd-ea9421b7909a	microwave	lò vi sóng	noun	/ˈmaɪkrəweɪv/	Heat it in the microwave.	\N	2025-12-06 07:23:12.529171	\N
8e371030-5ea8-4da5-9b4d-f99507debb0b	chicken	thịt gà	noun	/ˈtʃɪkɪn/	She cooks chicken soup.	\N	2025-12-06 07:23:12.529171	\N
66c68fc9-32a8-4eff-ac06-656d97a1e642	airport	sân bay	noun	/ˈeəpɔːt/	The airport is crowded.	\N	2025-12-06 07:23:12.529171	\N
117d0d2e-f357-4001-825c-a2a08aba7e1c	boarding pass	thẻ lên máy bay	noun	/ˈbɔːdɪŋ pɑːs/	Show your boarding pass please.	\N	2025-12-06 07:23:12.529171	\N
62940d47-1867-41c5-a2b3-04365b9998da	check-in	làm thủ tục	verb	/tʃek ɪn/	You need to check-in early.	\N	2025-12-06 07:23:12.529171	\N
7e3f2a0d-fc7c-4bf1-8d32-b898f612ee12	hotel	khách sạn	noun	/həʊˈtel/	Our hotel has a pool.	\N	2025-12-06 07:23:12.529171	\N
370fd3a3-2511-4ded-be6e-62807050a4aa	reception	lễ tân	noun	/rɪˈsepʃən/	Go to the reception desk.	\N	2025-12-06 07:23:12.529171	\N
40fc2eb0-1e46-4ae3-9c1e-b507f6cf5041	key card	thẻ phòng	noun	/ˈkiː kɑːd/	Your key card is ready.	\N	2025-12-06 07:23:12.529171	\N
4bc8a18c-0f31-45af-bbc0-0b27c7006ed0	algorithm	thuật toán	noun	/ˈælɡərɪðəm/	Algorithms solve problems step by step.	\N	2025-12-14 06:59:07.653643	\N
7f3446e7-1ff0-479f-a976-fe9a977cafb0	variable	biến	noun	/ˈveəriəbl/	Variables store data.	\N	2025-12-14 06:59:07.653643	\N
d08873d4-fb42-4e89-98d5-589d062c7881	constant	hằng số	noun	/ˈkɒnstənt/	Constants do not change.	\N	2025-12-14 06:59:07.653643	\N
29e18afa-b115-40a0-be32-a89e77811aa3	function	hàm	noun	/ˈfʌŋkʃən/	Functions group logic.	\N	2025-12-14 06:59:07.653643	\N
3a6f2da2-9b71-44e2-9c85-0b66ddf8b3ce	parameter	tham số	noun	/pəˈræmɪtə/	Parameters pass values.	\N	2025-12-14 06:59:07.653643	\N
7d25b06d-8fd2-4da0-bb31-cc6c3cff4752	return value	giá trị trả về	noun	/rɪˈtɜːn/	Functions return values.	\N	2025-12-14 06:59:07.653643	\N
60d66b21-c4a2-4b1a-b19f-23c50a8152c5	loop	vòng lặp	noun	/luːp/	Loops repeat instructions.	\N	2025-12-14 06:59:07.653643	\N
6dba5a74-f117-4093-b673-29a35194cb04	condition	điều kiện	noun	/kənˈdɪʃən/	Conditions control flow.	\N	2025-12-14 06:59:07.653643	\N
1e683d9a-dd9c-46ce-8487-2a867547b602	if statement	câu lệnh if	noun	/ɪf ˈsteɪtmənt/	If statements branch logic.	\N	2025-12-14 06:59:07.653643	\N
0abdbdc4-4d32-42da-b95a-69bb5fae37ab	compiler	trình biên dịch	noun	/kəmˈpaɪlə/	Compilers translate code.	\N	2025-12-14 06:59:07.653643	\N
10d308d7-1b26-4bc7-a1a0-d7e6ec49bf1a	interpreter	trình thông dịch	noun	/ɪnˈtɜːprɪtə/	Interpreters execute code directly.	\N	2025-12-14 06:59:07.653643	\N
64cf0ea7-b9c5-4a3e-b6ee-cf085e23684a	syntax	cú pháp	noun	/ˈsɪntæks/	Syntax defines structure.	\N	2025-12-14 06:59:07.653643	\N
d7ff0dcf-6c93-47a5-8878-a07de1f1d982	runtime	thời gian chạy	noun	/ˈrʌntaɪm/	Errors may appear at runtime.	\N	2025-12-14 06:59:07.653643	\N
a6305b44-96d4-4c53-bad8-ce49b48460a6	debug	gỡ lỗi	verb	/diːˈbʌɡ/	Debug to find bugs.	\N	2025-12-14 06:59:07.653643	\N
f9577205-23ee-4aaa-a691-f9b2e59e2190	bug	lỗi	noun	/bʌɡ/	Bugs cause failures.	\N	2025-12-14 06:59:07.653643	\N
cdd4925a-ae2f-47bf-8146-f0babe3204fe	input	dữ liệu vào	noun	/ˈɪnpʊt/	Programs accept input.	\N	2025-12-14 06:59:07.653643	\N
0ccf5466-4bf6-4343-9d6b-93040173eb5c	output	kết quả	noun	/ˈaʊtpʊt/	Programs produce output.	\N	2025-12-14 06:59:07.653643	\N
4a0008ff-ad25-4233-9ea2-fdfbd2e3fdcd	data type	kiểu dữ liệu	noun	/ˈdeɪtə taɪp/	Data types define storage.	\N	2025-12-14 06:59:07.653643	\N
057f848a-93a0-4b49-aee6-13e1bf24df21	integer	số nguyên	noun	/ˈɪntɪdʒə/	Integers store whole numbers.	\N	2025-12-14 06:59:07.653643	\N
1da88510-319b-447e-8f54-a0bac3ae1f51	string	chuỗi	noun	/strɪŋ/	Strings store text.	\N	2025-12-14 06:59:07.653643	\N
fe230979-270c-468a-a788-b141976fa696	database	cơ sở dữ liệu	noun	/ˈdeɪtəbeɪs/	Databases store information.	\N	2025-12-14 07:02:51.944061	\N
6b54eb8f-b6f1-470f-9cf2-acfdf03582c4	table	bảng	noun	/ˈteɪbəl/	Tables contain records.	\N	2025-12-14 07:02:51.944061	\N
42e4c536-3933-4ea2-a04b-604fb73fa276	row	hàng	noun	/rəʊ/	Each row is a record.	\N	2025-12-14 07:02:51.944061	\N
49f6bed8-037e-4778-9319-10dfe3ed310f	column	cột	noun	/ˈkɒləm/	Columns define attributes.	\N	2025-12-14 07:02:51.944061	\N
e100936b-23af-44e5-835c-ca6f3ff35a74	primary key	khóa chính	noun	/ˈpraɪməri kiː/	Primary keys identify rows.	\N	2025-12-14 07:02:51.944061	\N
527c2da8-6ac9-4e49-87a0-a515973c3bd7	foreign key	khóa ngoại	noun	/ˈfɒrən kiː/	Foreign keys link tables.	\N	2025-12-14 07:02:51.944061	\N
49c04cca-f283-4b19-8123-7021f6c0e657	query	truy vấn	noun	/ˈkwɪəri/	Queries retrieve data.	\N	2025-12-14 07:02:51.944061	\N
9a5ddca0-74ef-4798-8100-caa745ea5376	index	chỉ mục	noun	/ˈɪndeks/	Indexes improve performance.	\N	2025-12-14 07:02:51.944061	\N
52a31ad8-f2e3-43e5-91c4-a6b8dbe6d6b4	join	kết nối bảng	noun	/dʒɔɪn/	Joins combine tables.	\N	2025-12-14 07:02:51.944061	\N
a57739c0-e8fd-43dd-b038-69a58ad78a90	normalization	chuẩn hóa	noun	/ˌnɔːməlaɪˈzeɪʃən/	Normalization reduces redundancy.	\N	2025-12-14 07:02:51.944061	\N
0c784076-f531-431d-bc86-5d25f32f77e3	transaction	giao dịch	noun	/trænˈzækʃən/	Transactions ensure consistency.	\N	2025-12-14 07:02:51.944061	\N
6104e4e6-db2a-42e7-b5b7-ed0996eb964c	commit	xác nhận	verb	/kəˈmɪt/	Commit saves changes.	\N	2025-12-14 07:02:51.944061	\N
01775dac-ece8-4955-8e32-0a866877d6d4	rollback	hoàn tác	verb	/ˈrəʊlbæk/	Rollback cancels changes.	\N	2025-12-14 07:02:51.944061	\N
412a12ec-d4de-494d-9eb4-0e0e7a989a59	schema	lược đồ	noun	/ˈskiːmə/	Schemas define structure.	\N	2025-12-14 07:02:51.944061	\N
661e3907-0fcd-40cf-8f50-a24a5672356c	constraint	ràng buộc	noun	/kənˈstreɪnt/	Constraints enforce rules.	\N	2025-12-14 07:02:51.944061	\N
eae1b14f-c3ba-491c-b0b4-5fe230173049	fitness	thể dục edit	noun	/ˈfɪtnəs/	Fitness is important for good health.	\N	2025-12-06 07:23:12.529171	\N
64c99693-e39d-4122-96f8-7de4c3454423	luggage	hành lý	noun	/ˈlʌgɪdʒ/	Your luggage is overweight.	\N	2025-12-06 07:23:12.529171	2025-12-24 15:57:34.770484
c9174b9e-380f-40f9-9529-89dbb399c0eb	view	khung nhìn	noun	/vjuː/	Views simplify queries.	\N	2025-12-14 07:02:51.944061	\N
52814298-650d-48fa-82d6-21b6355b2792	stored procedure	thủ tục lưu trữ	noun	/stɔːd prəˈsiːdʒə/	Procedures run on DB.	\N	2025-12-14 07:02:51.944061	\N
cb1dd41f-fed8-4638-a63e-0911db442623	trigger	kích hoạt	noun	/ˈtrɪɡə/	Triggers run automatically.	\N	2025-12-14 07:02:51.944061	\N
b8e4a3b7-1c2d-415f-bec3-674198ccfe87	backup	sao lưu	noun	/ˈbækʌp/	Backups prevent data loss.	\N	2025-12-14 07:02:51.944061	\N
dbdcdbc7-bab0-4e33-808d-08e60a94a061	replication	sao chép	noun	/ˌreplɪˈkeɪʃən/	Replication improves availability.	\N	2025-12-14 07:02:51.944061	\N
778cf06d-de68-4458-9d13-c296eff6cba1	operating system	hệ điều hành	noun	/ˈɒpəreɪtɪŋ ˈsɪstəm/	The operating system manages hardware.	\N	2025-12-14 07:04:56.883553	\N
e0bd7426-79e8-435c-8f7b-0d506a643bc6	process	tiến trình	noun	/ˈprəʊses/	Each process has its own address space.	\N	2025-12-14 07:04:56.883553	\N
9e78759f-dd9d-469d-9fb9-887a959d1820	thread	luồng	noun	/θred/	Threads share memory.	\N	2025-12-14 07:04:56.883553	\N
5ea2559a-60fc-49ea-bb60-0e74a925081f	kernel	nhân hệ điều hành	noun	/ˈkɜːnəl/	The kernel controls system resources.	\N	2025-12-14 07:04:56.883553	\N
91dee1c6-80a1-4ecb-9096-d16d4b3a4509	memory management	quản lý bộ nhớ	noun	/ˈmeməri ˈmænɪdʒmənt/	Memory management prevents leaks.	\N	2025-12-14 07:04:56.883553	\N
fb077cd2-72e9-4ee7-9c65-0863ad8e48f1	virtual memory	bộ nhớ ảo	noun	/ˈvɜːtʃuəl ˈmeməri/	Virtual memory extends RAM.	\N	2025-12-14 07:04:56.883553	\N
9c12ae78-6c17-4811-a07c-4ab270244b96	scheduler	bộ lập lịch	noun	/ˈʃedjuːlə/	The scheduler allocates CPU time.	\N	2025-12-14 07:04:56.883553	\N
8bb1de39-7a22-4396-a1d1-0364fead9513	context switch	chuyển ngữ cảnh	noun	/ˈkɒntekst swɪtʃ/	Context switching has overhead.	\N	2025-12-14 07:04:56.883553	\N
b17f2e78-1579-4c68-a315-2578a2ca8090	deadlock	bế tắc	noun	/ˈdedlɒk/	Deadlock stops system progress.	\N	2025-12-14 07:04:56.883553	\N
ae86cc6e-19aa-41e4-9169-758bc10d8e2c	semaphore	semaphore	noun	/ˈseməfɔː/	Semaphores synchronize threads.	\N	2025-12-14 07:04:56.883553	\N
6bdcd9d9-e0a3-4635-8ad9-a9052c00b964	mutex	khóa mutex	noun	/ˈmjuːteks/	Mutex ensures mutual exclusion.	\N	2025-12-14 07:04:56.883553	\N
9f67a95b-12d2-4787-85bd-14923545ca39	interrupt	ngắt	noun	/ˌɪntəˈrʌpt/	Interrupts handle hardware events.	\N	2025-12-14 07:04:56.883553	\N
8b1f2543-3040-4b74-b2a2-684459e640e9	system call	lời gọi hệ thống	noun	/ˈsɪstəm kɔːl/	System calls access kernel services.	\N	2025-12-14 07:04:56.883553	\N
0ac94f88-d67a-4e63-8f8a-9b798b7d1b5b	I/O	vào ra	noun	/ˌaɪˈəʊ/	I/O operations are slow.	\N	2025-12-14 07:04:56.883553	\N
10391d24-a800-466a-9d39-a01649d96fcc	device driver	trình điều khiển	noun	/dɪˈvaɪs ˈdraɪvə/	Drivers control hardware.	\N	2025-12-14 07:04:56.883553	\N
679d403f-d32e-4729-a42a-ea2b42cf3102	multitasking	đa nhiệm	noun	/ˌmʌltɪˈtɑːskɪŋ/	Multitasking runs multiple programs.	\N	2025-12-14 07:04:56.883553	\N
acad8413-93a4-41b5-8e52-34132a9d4138	resource allocation	cấp phát tài nguyên	noun	/rɪˈzɔːs æləˈkeɪʃən/	Resources must be allocated fairly.	\N	2025-12-14 07:04:56.883553	\N
9131fdbf-a686-4664-8669-ff1f2f9a1565	bootloader	trình khởi động	noun	/ˈbuːtləʊdə/	Bootloader starts the OS.	\N	2025-12-14 07:04:56.883553	\N
74a2ee88-34d2-47bb-bacb-cb04a54b8e33	paging	phân trang	noun	/ˈpeɪdʒɪŋ/	Paging supports virtual memory.	\N	2025-12-14 07:04:56.883553	\N
5515496c-aa59-404c-a86b-8394373b61d2	swap	hoán đổi	noun	/swɒp/	Swap uses disk as memory.	\N	2025-12-14 07:04:56.883553	\N
ff969145-e1c3-46e6-9b0a-d0b6289e0cfc	object-oriented programming	lập trình hướng đối tượng	noun	/ˈɒbdʒɪkt ˈɔːrɪentɪd/	OOP organizes code by objects.	\N	2025-12-14 07:22:52.304174	\N
f4b4f53c-5347-4a01-94d4-f3b716372ca3	class	lớp	noun	/klɑːs/	Classes define objects.	\N	2025-12-14 07:22:52.304174	\N
b1531496-dfdc-4575-97b1-45db69ab5c33	object	đối tượng	noun	/ˈɒbdʒɪkt/	Objects have state and behavior.	\N	2025-12-14 07:22:52.304174	\N
7d30579b-74f1-4c1e-8e38-baf767d1f211	attribute	thuộc tính	noun	/ˈætrɪbjuːt/	Attributes store data.	\N	2025-12-14 07:22:52.304174	\N
028740a5-295b-4dca-8a95-9001de7abe91	method	phương thức	noun	/ˈmeθəd/	Methods define behavior.	\N	2025-12-14 07:22:52.304174	\N
a0008742-b48a-4db5-9211-e1be19ddd5de	encapsulation	đóng gói	noun	/ɪnˌkæpsjuˈleɪʃən/	Encapsulation hides details.	\N	2025-12-14 07:22:52.304174	\N
e4fced24-8052-41fd-a42f-d453b5d85b35	inheritance	kế thừa	noun	/ɪnˈherɪtəns/	Inheritance promotes reuse.	\N	2025-12-14 07:22:52.304174	\N
65b4ac8b-2480-45bd-9825-8e5c647fcc54	polymorphism	đa hình	noun	/ˌpɒlɪˈmɔːfɪzəm/	Polymorphism enables flexibility.	\N	2025-12-14 07:22:52.304174	\N
1c663021-aec2-4f20-8ba1-dbeaef18cd32	abstraction	trừu tượng	noun	/æbˈstrækʃən/	Abstraction simplifies complexity.	\N	2025-12-14 07:22:52.304174	\N
0dc98045-b8a6-40da-9043-94c61eb4212d	interface	giao diện	noun	/ˈɪntəfeɪs/	Interfaces define contracts.	\N	2025-12-14 07:22:52.304174	\N
4d603dde-a59c-40d4-925d-799ac695119b	implementation	cài đặt	noun	/ˌɪmplɪmenˈteɪʃən/	Implementation provides logic.	\N	2025-12-14 07:22:52.304174	\N
2cd67c30-0ee0-43c2-b3fa-26c6e3ccf0fb	constructor	hàm khởi tạo	noun	/kənˈstrʌktə/	Constructors initialize objects.	\N	2025-12-14 07:22:52.304174	\N
7137d836-3def-4638-8999-234bfcc6e257	destructor	hàm hủy	noun	/dɪˈstrʌktə/	Destructors clean resources.	\N	2025-12-14 07:22:52.304174	\N
2f14c165-975a-4db0-9abb-e907d8aba5c2	overloading	nạp chồng	noun	/ˌəʊvəˈləʊdɪŋ/	Overloading changes parameters.	\N	2025-12-14 07:22:52.304174	\N
bd708408-74b9-4092-93a4-6d9ba8676a49	overriding	ghi đè	noun	/ˌəʊvəˈraɪdɪŋ/	Overriding changes behavior.	\N	2025-12-14 07:22:52.304174	\N
7e049e94-966a-43c2-8e97-de82cf810055	composition	thành phần	noun	/ˌkɒmpəˈzɪʃən/	Composition builds complex objects.	\N	2025-12-14 07:22:52.304174	\N
565537fa-7dda-4ae3-a6ad-f0c53fa21b5f	dependency	phụ thuộc	noun	/dɪˈpendənsi/	Dependencies increase coupling.	\N	2025-12-14 07:22:52.304174	\N
6581ea7e-1b89-4900-a832-dc2539d193a8	UML	UML	noun	/ˌjuːemˈel/	UML models OOP systems.	\N	2025-12-14 07:22:52.304174	\N
6f087500-e53a-444a-96d1-92d8a5cb7689	design pattern	mẫu thiết kế	noun	/dɪˈzaɪn ˈpætən/	Design patterns solve common problems.	\N	2025-12-14 07:22:52.304174	\N
7206d475-6e49-47c4-a9f4-67365fcb4a4d	pervasive computing	tính toán phổ biến	noun	/pəˈveɪsɪv/	Pervasive computing is everywhere.	\N	2025-12-14 07:23:52.771549	\N
5bbbdfa8-abbc-44c4-910b-a5933bde7511	ubiquitous computing	tính toán mọi nơi	noun	/juːˈbɪkwɪtəs/	Ubiquitous systems blend into life.	\N	2025-12-14 07:23:52.771549	\N
05e5943e-340d-41b1-84c5-f2be9d44fbce	context-aware	nhận biết ngữ cảnh	adj	/ˈkɒntekst əˈweə/	Context-aware apps adapt behavior.	\N	2025-12-14 07:23:52.771549	\N
54bb9598-c336-49a0-b413-83fb45724912	sensor	cảm biến	noun	/ˈsensə/	Sensors collect data.	\N	2025-12-14 07:23:52.771549	\N
bec5be95-8b47-4947-b972-cf386424272a	actuator	bộ chấp hành	noun	/ˈæktʃuːeɪtə/	Actuators perform actions.	\N	2025-12-14 07:23:52.771549	\N
34c01f89-b691-417b-813a-90c7152b68dd	smart environment	môi trường thông minh	noun	/smɑːt/	Smart environments react automatically.	\N	2025-12-14 07:23:52.771549	\N
56fa3e39-803a-4d8b-85f3-f025ff970a11	adaptation	thích nghi	noun	/ˌædæpˈteɪʃən/	Systems adapt dynamically.	\N	2025-12-14 07:23:52.771549	\N
9b05d048-943a-41bf-b48d-6d00b545d467	location awareness	nhận biết vị trí	noun	/ləʊˈkeɪʃən/	Apps use location awareness.	\N	2025-12-14 07:23:52.771549	\N
a58bf2c5-f0e1-4d3e-a306-f56baf87bdab	ambient intelligence	trí tuệ môi trường	noun	/ˈæmbiənt/	Ambient intelligence is invisible.	\N	2025-12-14 07:23:52.771549	\N
165abb7c-1cb4-4f02-9f44-6766e02e950b	wearable device	thiết bị đeo	noun	/ˈweərəbl/	Wearables collect health data.	\N	2025-12-14 07:23:52.771549	\N
06384cdd-e6d1-4603-bc16-8346a06ae6c4	IoT	Internet of Things	noun	/ˌaɪəʊˈtiː/	IoT connects devices.	\N	2025-12-14 07:23:52.771549	\N
10ac41a7-1ca3-4166-b8c2-c4cdf1e6693e	privacy	quyền riêng tư	noun	/ˈprɪvəsi/	Privacy is critical.	\N	2025-12-14 07:23:52.771549	\N
90a2b57e-e2ef-4356-ac11-5efbf0b786b9	context modeling	mô hình ngữ cảnh	noun	/ˈmɒdəlɪŋ/	Context modeling improves accuracy.	\N	2025-12-14 07:23:52.771549	\N
5556e000-5e58-4cad-8184-efde9e15b665	real-time	thời gian thực	adj	/rɪəl taɪm/	Real-time response is required.	\N	2025-12-14 07:23:52.771549	\N
e2447a60-1f7f-47c9-bbf6-1e6ea1171edc	human-computer interaction	tương tác người máy	noun	/ˌɪntəˈrækʃən/	HCI studies usability.	\N	2025-12-14 07:23:52.771549	\N
848cfbbe-1d5a-4fcc-8c66-926f7e9e6573	mobile computing	tính toán di động	noun	/ˈməʊbaɪl kəmˈpjuːtɪŋ/	Mobile computing enables mobility.	\N	2025-12-14 07:24:57.380355	\N
01e5b1f0-1d0d-4bcb-91b9-e9054858c674	mobile device	thiết bị di động	noun	/ˈməʊbaɪl dɪˈvaɪs/	Mobile devices are portable.	\N	2025-12-14 07:24:57.380355	\N
5b3e13cd-96e9-44d5-af6f-5f44e7333147	wireless network	mạng không dây	noun	/ˈwaɪələs ˈnetwɜːk/	Wireless networks support mobility.	\N	2025-12-14 07:24:57.380355	\N
d0253a91-81a1-4055-ae41-f0c4173127b7	latency	độ trễ	noun	/ˈleɪtənsi/	High latency affects performance.	\N	2025-12-14 07:24:57.380355	\N
a225be07-e924-42d3-a178-40556bdc2df5	bandwidth	băng thông	noun	/ˈbændwɪdθ/	Bandwidth limits data transfer.	\N	2025-12-14 07:24:57.380355	\N
b5cce6ce-a1c3-4274-abdb-6e531516bf73	handoff	chuyển vùng	noun	/ˈhændɒf/	Handoff occurs during movement.	\N	2025-12-14 07:24:57.380355	\N
4a2b7ad2-19fc-4883-88d3-f0e51bb9daf3	mobility management	quản lý di động	noun	/məʊˈbɪlɪti ˈmænɪdʒmənt/	Mobility management tracks users.	\N	2025-12-14 07:24:57.380355	\N
5b8f4f4f-927a-4af8-af75-abd89d12eb27	location-based service	dịch vụ theo vị trí	noun	/ləʊˈkeɪʃən/	Location-based services personalize apps.	\N	2025-12-14 07:24:57.380355	\N
4a6442d0-52ef-4b29-9bda-707aba8f3df8	energy efficiency	hiệu quả năng lượng	noun	/ˈenədʒi ɪˈfɪʃənsi/	Energy efficiency saves battery.	\N	2025-12-14 07:24:57.380355	\N
75d52305-5775-45d2-ba9e-4af3b467e426	battery consumption	tiêu thụ pin	noun	/ˈbætəri kənˈsʌmpʃən/	Apps should reduce battery usage.	\N	2025-12-14 07:24:57.380355	\N
43363b25-869f-411d-aec3-c3c32861bb55	offline mode	chế độ ngoại tuyến	noun	/ˌɒfˈlaɪn/	Offline mode improves usability.	\N	2025-12-14 07:24:57.380355	\N
8f596acf-2a3f-4f56-b172-9ab998a2566c	synchronization	đồng bộ hóa	noun	/ˌsɪŋkrənaɪˈzeɪʃən/	Data synchronization keeps consistency.	\N	2025-12-14 07:24:57.380355	\N
0691c710-70ca-4a04-b248-812326b8d33a	push notification	thông báo đẩy	noun	/pʊʃ ˌnəʊtɪfɪˈkeɪʃən/	Push notifications engage users.	\N	2025-12-14 07:24:57.380355	\N
f1d82563-157d-4d62-a4d5-efc9549dd089	responsive design	thiết kế đáp ứng	noun	/rɪˈspɒnsɪv/	Responsive design adapts screens.	\N	2025-12-14 07:24:57.380355	\N
a3a037e7-0ddc-45c1-864b-56e4a69c69fa	sensor fusion	kết hợp cảm biến	noun	/ˈsensə ˈfjuːʒən/	Sensor fusion improves accuracy.	\N	2025-12-14 07:24:57.380355	\N
c501e991-a221-42ab-a9bf-9e475f2c9092	context awareness	nhận biết ngữ cảnh	noun	/ˈkɒntekst/	Context awareness improves UX.	\N	2025-12-14 07:24:57.380355	\N
4776805d-d8b7-42a6-95d0-9d9d8d8bc595	mobile OS	hệ điều hành di động	noun	/ˈməʊbaɪl/	Mobile OS manages hardware.	\N	2025-12-14 07:24:57.380355	\N
cf784479-ea67-4207-8dbc-6a67ba168ce3	network roaming	chuyển mạng	noun	/ˈrəʊmɪŋ/	Roaming enables connectivity.	\N	2025-12-14 07:24:57.380355	\N
4f7d99dc-b37a-4332-9429-163702133575	data caching	lưu đệm dữ liệu	noun	/ˈkeɪʃɪŋ/	Caching improves performance.	\N	2025-12-14 07:24:57.380355	\N
e557a1a1-5530-441e-9811-6227a0931404	edge computing	điện toán biên	noun	/edʒ/	Edge computing reduces latency.	\N	2025-12-14 07:24:57.380355	\N
89841209-f0c4-467b-a6b0-f52ca915b152	distributed system	hệ thống phân tán	noun	/dɪˈstrɪbjʊtɪd/	Distributed systems share resources.	\N	2025-12-14 07:25:46.194514	\N
7220d1ff-6220-41a7-9b0c-d42c6b8da917	node	nút	noun	/nəʊd/	Each node runs independently.	\N	2025-12-14 07:25:46.194514	\N
7b7563bc-55f9-49b2-be4f-0bb934914bff	cluster	cụm	noun	/ˈklʌstə/	Clusters increase capacity.	\N	2025-12-14 07:25:46.194514	\N
92c75fc8-3a82-45e6-9581-3eac4d6b2445	replication	sao chép	noun	/ˌreplɪˈkeɪʃən/	Replication improves availability.	\N	2025-12-14 07:25:46.194514	\N
dfb0ebec-f3bb-4cfd-8bad-1d996f596d96	fault tolerance	chịu lỗi	noun	/fɔːlt ˈtɒlərəns/	Fault tolerance handles failures.	\N	2025-12-14 07:25:46.194514	\N
e392bf4d-5733-4d49-9ef2-6b5d6eb486ff	consistency	tính nhất quán	noun	/kənˈsɪstənsi/	Consistency ensures correctness.	\N	2025-12-14 07:25:46.194514	\N
43669802-e52f-4470-8b1e-941555ad3980	availability	tính sẵn sàng	noun	/əˌveɪləˈbɪlɪti/	Availability keeps services online.	\N	2025-12-14 07:25:46.194514	\N
ea5149de-c57b-498b-931d-70f3c58e44d7	partition tolerance	chịu phân mảnh	noun	/pɑːˈtɪʃən/	Partition tolerance handles splits.	\N	2025-12-14 07:25:46.194514	\N
83a89302-e143-49e0-a5b8-60daae6fc0fb	CAP theorem	định lý CAP	noun	/kæp/	CAP theorem explains trade-offs.	\N	2025-12-14 07:25:46.194514	\N
d5b41d0e-2475-467b-8eb6-987ff294931d	consensus	đồng thuận	noun	/kənˈsensəs/	Consensus synchronizes nodes.	\N	2025-12-14 07:25:46.194514	\N
a537887a-0655-4c6c-9f22-5f44020f4e35	leader election	bầu chọn leader	noun	/ˈliːdə/	Leader election coordinates nodes.	\N	2025-12-14 07:25:46.194514	\N
4dd5c86d-9aff-4198-9342-da2e4be65442	distributed lock	khóa phân tán	noun	/lɒk/	Distributed locks avoid conflicts.	\N	2025-12-14 07:25:46.194514	\N
012cf88a-1472-47b8-a809-3711c79fe325	message passing	truyền thông điệp	noun	/ˈmesɪdʒ/	Message passing connects nodes.	\N	2025-12-14 07:25:46.194514	\N
82a08064-4d4b-4aef-ad75-0803b68fb379	RPC	gọi thủ tục từ xa	noun	/ˌɑːrpiːˈsiː/	RPC simplifies communication.	\N	2025-12-14 07:25:46.194514	\N
1d3c0cfa-d7e0-4d05-b165-5e6f3328395e	eventual consistency	nhất quán cuối	noun	/ɪˈventʃuəl/	Eventual consistency relaxes rules.	\N	2025-12-14 07:25:46.194514	\N
1f279ee3-652b-4202-bc19-b52549bdf735	load balancing	cân bằng tải	noun	/ˈbəʊlənsiŋ/	Load balancing distributes requests.	\N	2025-12-14 07:25:46.194514	\N
2f2d3f7c-bab3-4c36-a18b-84b12e11cb86	distributed database	CSDL phân tán	noun	/ˈdeɪtəbeɪs/	Distributed DB scales horizontally.	\N	2025-12-14 07:25:46.194514	\N
903f1ea8-7287-44b6-8268-7713b02a1ea5	sharding	phân mảnh dữ liệu	noun	/ˈʃɑːdɪŋ/	Sharding splits data.	\N	2025-12-14 07:25:46.194514	\N
f727caa1-a549-4686-8e93-9bb5137cebba	network partition	phân tách mạng	noun	/ˈnetwɜːk/	Network partitions cause failures.	\N	2025-12-14 07:25:46.194514	\N
ba3816ba-1db2-4968-8e22-7f72d7d2d59b	high availability	tính sẵn sàng cao	noun	/ˈeɪvəɪləˌbɪlɪti/	HA minimizes downtime.	\N	2025-12-14 07:25:46.194514	\N
8583cc8f-c120-4326-908c-d2dba560f94b	cloud computing	điện toán đám mây	noun	/klaʊd/	Cloud computing provides scalability.	\N	2025-12-14 07:26:29.57732	\N
a59be27e-71eb-4a6e-875b-9c17f22179c0	cloud service	dịch vụ đám mây	noun	/ˈsɜːvɪs/	Cloud services are on-demand.	\N	2025-12-14 07:26:29.57732	\N
af45f596-f8e4-48b9-b6b4-1496496c2ee6	virtual machine	máy ảo	noun	/ˈvɜːtʃuəl/	VMs isolate applications.	\N	2025-12-14 07:26:29.57732	\N
d0609dc4-024e-433c-b051-e86466ccab75	container	container	noun	/kənˈteɪnə/	Containers package software.	\N	2025-12-14 07:26:29.57732	\N
963f9cbe-1592-4524-b5f6-4c412f501464	orchestration	điều phối	noun	/ˌɔːkɪˈstreɪʃən/	Orchestration manages containers.	\N	2025-12-14 07:26:29.57732	\N
d0905b41-4b38-4306-b426-85ce3efe9c1f	scalability	khả năng mở rộng	noun	/ˌskeɪləˈbɪlɪti/	Scalability handles growth.	\N	2025-12-14 07:26:29.57732	\N
7e69932c-800f-4340-afca-58ac5b278741	elasticity	tính đàn hồi	noun	/ɪˌlæˈstɪsɪti/	Elasticity adapts resources.	\N	2025-12-14 07:26:29.57732	\N
a843978e-c3f3-45c5-90cf-40bd821b6618	pay-as-you-go	trả theo dùng	noun	/peɪ/	Pay-as-you-go reduces cost.	\N	2025-12-14 07:26:29.57732	\N
1dd81e0c-ff1c-48d7-abbb-dea82138afcc	IaaS	hạ tầng như dịch vụ	noun	/ˌaɪɑːæs/	IaaS provides infrastructure.	\N	2025-12-14 07:26:29.57732	\N
d9b581a9-a8bf-49f1-86c9-deab9a437870	PaaS	nền tảng như dịch vụ	noun	/ˌpiːæs/	PaaS supports development.	\N	2025-12-14 07:26:29.57732	\N
c8d84311-84af-4c54-bffc-33a290736fd2	SaaS	phần mềm như dịch vụ	noun	/ˌsæs/	SaaS delivers applications.	\N	2025-12-14 07:26:29.57732	\N
74928d24-beba-4fda-b47d-c68d11767fcf	cloud storage	lưu trữ đám mây	noun	/ˈstɔːrɪdʒ/	Cloud storage stores data.	\N	2025-12-14 07:26:29.57732	\N
a4678eb0-a3c2-4d86-b1a9-b9810762d8c3	load balancer	bộ cân bằng tải	noun	/ˈləʊd/	Load balancers distribute traffic.	\N	2025-12-14 07:26:29.57732	\N
d9ad403b-29e3-47bb-8f8b-7159f773e48a	auto scaling	tự động mở rộng	noun	/ˈɔːtəʊ/	Auto scaling adjusts capacity.	\N	2025-12-14 07:26:29.57732	\N
98281884-47f8-45e0-9714-62b03b56f997	availability zone	vùng sẵn sàng	noun	/əˌveɪləˈbɪlɪti/	AZ improves resilience.	\N	2025-12-14 07:26:29.57732	\N
b448a186-bc65-402b-b181-a36f61a3c0e1	backup	sao lưu	noun	/ˈbækʌp/	Backups prevent data loss.	\N	2025-12-14 07:26:29.57732	\N
df1c0200-c3fb-4882-bd05-dad6511845b3	disaster recovery	khôi phục thảm họa	noun	/dɪˈzɑːstə/	DR ensures continuity.	\N	2025-12-14 07:26:29.57732	\N
31affd1f-0dfe-4e75-aa02-33abaae3c081	cloud security	bảo mật đám mây	noun	/sɪˈkjʊərɪti/	Cloud security protects assets.	\N	2025-12-14 07:26:29.57732	\N
9426cc57-ca63-4f23-b123-e116fd642191	multi-tenancy	đa thuê	noun	/ˈtenənsi/	Multi-tenancy shares resources.	\N	2025-12-14 07:26:29.57732	\N
a9d78d83-aa97-4c1b-9f72-375cf8b0f124	serverless	không máy chủ	adj	/ˈsɜːvələs/	Serverless hides infrastructure.	\N	2025-12-14 07:26:29.57732	\N
9a4e5991-0fcf-4268-bcbd-0a846a911a67	banana	quả chuối edit	noun	/bəˈnɑːnə/	I like banana smoothies.	\N	2025-12-06 07:23:12.529171	\N
f6d83d4d-ff53-4a5c-afd8-3cc923dbe48b	airport	sân bay	noun	/ˈeəpɔːt/	The airport is crowded.	\N	2025-12-25 01:00:20.899332	\N
2de3194d-7722-41e2-b1cb-7170e2dbc02d	benefit	lợi ích	noun	/ˈbenɪfɪt/	Exercise has many health benefits.	\N	2025-12-25 01:00:20.899332	\N
9464a63f-b7e0-48f1-b5a5-8a467d25850d	chicken	thịt gà	noun	/ˈtʃɪkɪn/	She cooks chicken soup.	\N	2025-12-25 01:00:20.899332	\N
4a7934fc-d6f1-4d10-b642-40dde4939cf2	dishwasher	máy rửa chén	noun	/ˈdɪʃˌwɒʃər/	My house has a dishwasher.	\N	2025-12-25 01:00:20.899332	\N
6462037f-5ace-43f7-b00a-5442b9afda3b	actuator	bộ chấp hành	noun	/ˈæktʃuːeɪtə/	Actuators perform actions.	\N	2025-12-25 01:18:28.573653	\N
81d87f6f-636e-4548-814c-2121ad1efad9	adaptation	thích nghi	noun	/ˌædæpˈteɪʃən/	Systems adapt dynamically.	\N	2025-12-25 01:18:28.573653	\N
7e0f4dc2-e90e-4b72-81ce-4a4271789188	ambient intelligence	trí tuệ môi trường	noun	/ˈæmbiənt/	Ambient intelligence is invisible.	\N	2025-12-25 01:18:28.573653	\N
6ce2e436-3dea-4f2f-a846-20cf2a1889b9	context-aware	nhận biết ngữ cảnh	adj	/ˈkɒntekst əˈweə/	Context-aware apps adapt behavior.	\N	2025-12-25 01:18:28.573653	\N
b173309d-a69c-463f-89ff-0cf0a0af9fe4	context modeling	mô hình ngữ cảnh	noun	/ˈmɒdəlɪŋ/	Context modeling improves accuracy.	\N	2025-12-25 01:18:28.573653	\N
e6c46fc7-940e-43d8-812e-2df48871be19	human-computer interaction	tương tác người máy	noun	/ˌɪntəˈrækʃən/	HCI studies usability.	\N	2025-12-25 01:18:28.573653	\N
1697182b-92b7-4f6b-8dd3-c94a8ef9a754	IoT	Internet of Things	noun	/ˌaɪəʊˈtiː/	IoT connects devices.	\N	2025-12-25 01:18:28.573653	\N
62b6a876-21ad-4c1e-9580-5372c8e386e1	location awareness	nhận biết vị trí	noun	/ləʊˈkeɪʃən/	Apps use location awareness.	\N	2025-12-25 01:18:28.573653	\N
465b334a-7d3a-4cce-9503-9bad45e29208	pervasive computing	tính toán phổ biến	noun	/pəˈveɪsɪv/	Pervasive computing is everywhere.	\N	2025-12-25 01:18:28.573653	\N
f9f1a468-b088-45f4-888e-a3f173662ae6	privacy	quyền riêng tư	noun	/ˈprɪvəsi/	Privacy is critical.	\N	2025-12-25 01:18:28.573653	\N
8703a13c-d590-4dbf-84e8-732e1738f910	real-time	thời gian thực	adj	/rɪəl taɪm/	Real-time response is required.	\N	2025-12-25 01:18:28.573653	\N
b7ed670d-6936-41ac-882f-949703f9a3a4	sensor	cảm biến	noun	/ˈsensə/	Sensors collect data.	\N	2025-12-25 01:18:28.573653	\N
b0c5c73f-b058-4c55-b48b-c197b5af91ee	smart environment	môi trường thông minh	noun	/smɑːt/	Smart environments react automatically.	\N	2025-12-25 01:18:28.573653	\N
0edbf522-ad34-4c7f-ab3e-1627f6f9ec3d	ubiquitous computing	tính toán mọi nơi	noun	/juːˈbɪkwɪtəs/	Ubiquitous systems blend into life.	\N	2025-12-25 01:18:28.573653	\N
059fe1cc-c035-4667-8035-2858fbe6a15c	wearable device	thiết bị đeo	noun	/ˈweərəbl/	Wearables collect health data.	\N	2025-12-25 01:18:28.573653	\N
0019774e-a19f-4960-ab85-67f601d804f9	real-time	Ttttttt	aaa	/rɪəl taɪm/	aaaaaaaa	\N	2025-12-25 02:15:37.744189	\N
2568e78d-3b44-4d64-81e9-44aef4517145	association	aaaa	Naaa	/əˌsəʊsɪˈeɪʃən/	aaaa	\N	2025-12-25 02:19:56.156548	2025-12-25 02:25:06.45952
bd2fe6da-8656-4684-8bb6-a6eaf5d82d59	aaaaaa	aaa	aaa	aaa	aaa	\N	2025-12-25 02:25:26.681114	2025-12-25 02:31:35.723371
9e1fc3af-dce4-4b5b-8e87-a4564f3ddbcf	association	liên kết	noun	/əˌsəʊsɪˈeɪʃən/	Association links classes.	\N	2025-12-14 07:22:52.304174	\N
23322f8e-fef4-4382-861f-7560dea5fe76	airport	sân bay	noun	/ˈeəpɔːt/	The airport is crowded.	\N	2025-12-25 08:38:42.15232	\N
21e5fc60-6dfd-4e57-bbcb-636fce122b7c	hotel	khách sạn	noun	/həʊˈtel/	Our hotel has a pool.	\N	2025-12-25 08:38:42.15232	\N
\.


--
-- TOC entry 3425 (class 2606 OID 16628)
-- Name: flashcard_results flashcard_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flashcard_results
    ADD CONSTRAINT flashcard_results_pkey PRIMARY KEY (id);


--
-- TOC entry 3419 (class 2606 OID 16576)
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);


--
-- TOC entry 3423 (class 2606 OID 16611)
-- Name: group_post_modules group_post_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_post_modules
    ADD CONSTRAINT group_post_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 3421 (class 2606 OID 16595)
-- Name: group_posts group_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_posts
    ADD CONSTRAINT group_posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3417 (class 2606 OID 16564)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3431 (class 2606 OID 33068)
-- Name: module_deletes module_deletes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_deletes
    ADD CONSTRAINT module_deletes_pkey PRIMARY KEY (id);


--
-- TOC entry 3415 (class 2606 OID 16540)
-- Name: module_shares module_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_shares
    ADD CONSTRAINT module_shares_pkey PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 16482)
-- Name: module_words module_words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_words
    ADD CONSTRAINT module_words_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 16457)
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 16663)
-- Name: quiz_answers quiz_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_answers
    ADD CONSTRAINT quiz_answers_pkey PRIMARY KEY (id);


--
-- TOC entry 3427 (class 2606 OID 16645)
-- Name: quiz_results quiz_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 16442)
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3399 (class 2606 OID 16433)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3401 (class 2606 OID 16431)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3413 (class 2606 OID 16520)
-- Name: word_comments word_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_comments
    ADD CONSTRAINT word_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 3433 (class 2606 OID 33085)
-- Name: word_deletes word_deletes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_deletes
    ADD CONSTRAINT word_deletes_pkey PRIMARY KEY (id);


--
-- TOC entry 3411 (class 2606 OID 16501)
-- Name: word_pronunciation word_pronunciation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_pronunciation
    ADD CONSTRAINT word_pronunciation_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 16476)
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- TOC entry 3453 (class 2606 OID 16634)
-- Name: flashcard_results flashcard_results_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flashcard_results
    ADD CONSTRAINT flashcard_results_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- TOC entry 3454 (class 2606 OID 16629)
-- Name: flashcard_results flashcard_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flashcard_results
    ADD CONSTRAINT flashcard_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3447 (class 2606 OID 16577)
-- Name: group_members group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 3448 (class 2606 OID 16582)
-- Name: group_members group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3451 (class 2606 OID 16617)
-- Name: group_post_modules group_post_modules_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_post_modules
    ADD CONSTRAINT group_post_modules_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- TOC entry 3452 (class 2606 OID 16612)
-- Name: group_post_modules group_post_modules_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_post_modules
    ADD CONSTRAINT group_post_modules_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.group_posts(id) ON DELETE CASCADE;


--
-- TOC entry 3449 (class 2606 OID 16596)
-- Name: group_posts group_posts_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_posts
    ADD CONSTRAINT group_posts_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- TOC entry 3450 (class 2606 OID 16601)
-- Name: group_posts group_posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_posts
    ADD CONSTRAINT group_posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3446 (class 2606 OID 16565)
-- Name: groups groups_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- TOC entry 3459 (class 2606 OID 33069)
-- Name: module_deletes module_deletes_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_deletes
    ADD CONSTRAINT module_deletes_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 3460 (class 2606 OID 33074)
-- Name: module_deletes module_deletes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_deletes
    ADD CONSTRAINT module_deletes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3443 (class 2606 OID 16546)
-- Name: module_shares module_shares_from_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_shares
    ADD CONSTRAINT module_shares_from_user_fkey FOREIGN KEY (from_user) REFERENCES public.users(id);


--
-- TOC entry 3444 (class 2606 OID 16541)
-- Name: module_shares module_shares_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_shares
    ADD CONSTRAINT module_shares_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 3445 (class 2606 OID 16551)
-- Name: module_shares module_shares_to_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_shares
    ADD CONSTRAINT module_shares_to_user_fkey FOREIGN KEY (to_user) REFERENCES public.users(id);


--
-- TOC entry 3437 (class 2606 OID 16483)
-- Name: module_words module_words_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_words
    ADD CONSTRAINT module_words_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 3438 (class 2606 OID 16488)
-- Name: module_words module_words_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module_words
    ADD CONSTRAINT module_words_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(id) ON DELETE CASCADE;


--
-- TOC entry 3435 (class 2606 OID 16458)
-- Name: modules modules_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3436 (class 2606 OID 16463)
-- Name: modules modules_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.modules(id) ON DELETE CASCADE;


--
-- TOC entry 3457 (class 2606 OID 16664)
-- Name: quiz_answers quiz_answers_quiz_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_answers
    ADD CONSTRAINT quiz_answers_quiz_result_id_fkey FOREIGN KEY (quiz_result_id) REFERENCES public.quiz_results(id) ON DELETE CASCADE;


--
-- TOC entry 3458 (class 2606 OID 16669)
-- Name: quiz_answers quiz_answers_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_answers
    ADD CONSTRAINT quiz_answers_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(id);


--
-- TOC entry 3455 (class 2606 OID 16651)
-- Name: quiz_results quiz_results_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- TOC entry 3456 (class 2606 OID 16646)
-- Name: quiz_results quiz_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3434 (class 2606 OID 16443)
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3441 (class 2606 OID 16521)
-- Name: word_comments word_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_comments
    ADD CONSTRAINT word_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3442 (class 2606 OID 16526)
-- Name: word_comments word_comments_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_comments
    ADD CONSTRAINT word_comments_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(id);


--
-- TOC entry 3461 (class 2606 OID 33091)
-- Name: word_deletes word_deletes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_deletes
    ADD CONSTRAINT word_deletes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3462 (class 2606 OID 33086)
-- Name: word_deletes word_deletes_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_deletes
    ADD CONSTRAINT word_deletes_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(id) ON DELETE CASCADE;


--
-- TOC entry 3439 (class 2606 OID 16502)
-- Name: word_pronunciation word_pronunciation_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_pronunciation
    ADD CONSTRAINT word_pronunciation_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3440 (class 2606 OID 16507)
-- Name: word_pronunciation word_pronunciation_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.word_pronunciation
    ADD CONSTRAINT word_pronunciation_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(id);


-- Completed on 2025-12-25 15:01:10 UTC

--
-- PostgreSQL database dump complete
--


--
-- Database "postgres" dump
--


--
-- PostgreSQL database dump
--


-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.14

-- Started on 2025-12-25 15:01:10 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2025-12-25 15:01:10 UTC

--
-- PostgreSQL database dump complete
--


-- Completed on 2025-12-25 15:01:10 UTC

--
-- PostgreSQL database cluster dump complete
--

