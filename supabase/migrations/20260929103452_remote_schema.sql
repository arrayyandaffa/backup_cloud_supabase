


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


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."jenis_kelamin" AS ENUM (
    'laki-laki',
    'perempuan'
);


ALTER TYPE "public"."jenis_kelamin" OWNER TO "postgres";


CREATE TYPE "public"."jenjang_prodi" AS ENUM (
    'S1',
    'D3',
    'D4'
);


ALTER TYPE "public"."jenjang_prodi" OWNER TO "postgres";


CREATE TYPE "public"."mode_battle" AS ENUM (
    'solo',
    '1v1',
    'grup'
);


ALTER TYPE "public"."mode_battle" OWNER TO "postgres";


CREATE TYPE "public"."status_battle" AS ENUM (
    'waiting',
    'ongoing',
    'finished',
    'cancelled'
);


ALTER TYPE "public"."status_battle" OWNER TO "postgres";


CREATE TYPE "public"."status_konten" AS ENUM (
    'draft',
    'published'
);


ALTER TYPE "public"."status_konten" OWNER TO "postgres";


CREATE TYPE "public"."status_pengerjaan" AS ENUM (
    'berjalan',
    'selesai',
    'dibatalkan'
);


ALTER TYPE "public"."status_pengerjaan" OWNER TO "postgres";


CREATE TYPE "public"."status_soal" AS ENUM (
    'draft',
    'review',
    'published'
);


ALTER TYPE "public"."status_soal" OWNER TO "postgres";


CREATE TYPE "public"."status_tryout" AS ENUM (
    'draft',
    'active',
    'completed'
);


ALTER TYPE "public"."status_tryout" OWNER TO "postgres";


CREATE TYPE "public"."sumber_tipe_transaksi" AS ENUM (
    'pengerjaan',
    'battle',
    'avatar',
    'reward',
    'lainnya'
);


ALTER TYPE "public"."sumber_tipe_transaksi" OWNER TO "postgres";


CREATE TYPE "public"."tingkat_kesulitan" AS ENUM (
    'mudah',
    'sedang',
    'sulit'
);


ALTER TYPE "public"."tingkat_kesulitan" OWNER TO "postgres";


CREATE TYPE "public"."tipe_pengerjaan" AS ENUM (
    'latihan_bebas',
    'try_out'
);


ALTER TYPE "public"."tipe_pengerjaan" OWNER TO "postgres";


CREATE TYPE "public"."tipe_soal" AS ENUM (
    'pilihan_ganda',
    'isian_singkat',
    'benar_salah'
);


ALTER TYPE "public"."tipe_soal" OWNER TO "postgres";


CREATE TYPE "public"."user_role" AS ENUM (
    'siswa',
    'admin_editor',
    'admin'
);


ALTER TYPE "public"."user_role" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."admin_editor" (
    "user_id" "uuid" NOT NULL,
    "nama_lengkap" "text" NOT NULL
);


ALTER TABLE "public"."admin_editor" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."avatar" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nama" "text" NOT NULL,
    "gambar" character varying NOT NULL,
    "harga_point" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."avatar" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."badge" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nama_badge" "text" NOT NULL,
    "deskripsi" "text",
    "icon" character varying NOT NULL,
    "syarat_text" "text"
);


ALTER TABLE "public"."badge" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."battle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "subtes_id" "uuid" NOT NULL,
    "mode" "public"."mode_battle" NOT NULL,
    "join_code" "text",
    "status" "public"."status_battle" DEFAULT 'waiting'::"public"."status_battle" NOT NULL,
    "jumlah_soal" integer DEFAULT 10 NOT NULL,
    "dibuat_oleh" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "started_at" timestamp with time zone,
    "ended_at" timestamp with time zone
);


ALTER TABLE "public"."battle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."battle_daftar_soal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "battle_id" "uuid" NOT NULL,
    "soal_id" "uuid" NOT NULL,
    "urutan" integer NOT NULL
);


ALTER TABLE "public"."battle_daftar_soal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."battle_jawaban" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "battle_peserta_id" "uuid" NOT NULL,
    "battle_daftar_soal_id" "uuid" NOT NULL,
    "opsi_dipilih_id" "uuid",
    "is_correct" boolean DEFAULT false NOT NULL,
    "waktu_jawab_ms" integer DEFAULT 0 NOT NULL,
    "answered_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "skor" numeric DEFAULT 0
);


ALTER TABLE "public"."battle_jawaban" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."battle_peserta" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "battle_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "total_skor" numeric DEFAULT 0,
    "rank" integer,
    "joined_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."battle_peserta" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cache" (
    "key" character varying(255) NOT NULL,
    "value" "text" NOT NULL,
    "expiration" integer NOT NULL
);


ALTER TABLE "public"."cache" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cache_locks" (
    "key" character varying(255) NOT NULL,
    "owner" character varying(255) NOT NULL,
    "expiration" integer NOT NULL
);


ALTER TABLE "public"."cache_locks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."failed_jobs" (
    "id" bigint NOT NULL,
    "uuid" character varying(255) NOT NULL,
    "connection" "text" NOT NULL,
    "queue" "text" NOT NULL,
    "payload" "text" NOT NULL,
    "exception" "text" NOT NULL,
    "failed_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE "public"."failed_jobs" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."failed_jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."failed_jobs_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."failed_jobs_id_seq" OWNED BY "public"."failed_jobs"."id";



CREATE TABLE IF NOT EXISTS "public"."ice_breaking_content" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "konten_teks" "text" NOT NULL,
    "konten_gambar" character varying,
    "jawaban" "text" NOT NULL,
    "dibuat_oleh" "uuid",
    "status" "public"."status_konten" DEFAULT 'draft'::"public"."status_konten" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."ice_breaking_content" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."jawaban_pengerjaan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pengerjaan_id" "uuid" NOT NULL,
    "pengerjaan_subtes_id" "uuid",
    "soal_id" "uuid" NOT NULL,
    "opsi_dipilih_id" "uuid",
    "jawaban_isian" "text",
    "is_correct" boolean DEFAULT false NOT NULL,
    "skor" numeric DEFAULT 0,
    "waktu_menjawab" timestamp with time zone DEFAULT "now"() NOT NULL,
    "opsi_dipilih_ids" "uuid"[]
);


ALTER TABLE "public"."jawaban_pengerjaan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."job_batches" (
    "id" character varying(255) NOT NULL,
    "name" character varying(255) NOT NULL,
    "total_jobs" integer NOT NULL,
    "pending_jobs" integer NOT NULL,
    "failed_jobs" integer NOT NULL,
    "failed_job_ids" "text" NOT NULL,
    "options" "text",
    "cancelled_at" integer,
    "created_at" integer NOT NULL,
    "finished_at" integer
);


ALTER TABLE "public"."job_batches" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."jobs" (
    "id" bigint NOT NULL,
    "queue" character varying(255) NOT NULL,
    "payload" "text" NOT NULL,
    "attempts" smallint NOT NULL,
    "reserved_at" integer,
    "available_at" integer NOT NULL,
    "created_at" integer NOT NULL
);


ALTER TABLE "public"."jobs" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."jobs_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."jobs_id_seq" OWNED BY "public"."jobs"."id";



CREATE TABLE IF NOT EXISTS "public"."migrations" (
    "id" integer NOT NULL,
    "migration" character varying(255) NOT NULL,
    "batch" integer NOT NULL
);


ALTER TABLE "public"."migrations" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."migrations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."migrations_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."migrations_id_seq" OWNED BY "public"."migrations"."id";



CREATE TABLE IF NOT EXISTS "public"."opsi_jawaban" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "soal_id" "uuid" NOT NULL,
    "label" character varying NOT NULL,
    "teks_opsi" "text" NOT NULL,
    "gambar_opsi" "text",
    "is_kunci" boolean DEFAULT false NOT NULL,
    "urutan" integer NOT NULL
);


ALTER TABLE "public"."opsi_jawaban" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."password_reset_tokens" (
    "email" character varying(255) NOT NULL,
    "token" character varying(255) NOT NULL,
    "created_at" timestamp(0) without time zone
);


ALTER TABLE "public"."password_reset_tokens" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pengerjaan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "tipe" "public"."tipe_pengerjaan" NOT NULL,
    "status" "public"."status_pengerjaan" DEFAULT 'berjalan'::"public"."status_pengerjaan" NOT NULL,
    "subtes_id" "uuid",
    "jumlah_soal_dipilih" integer,
    "ice_breaking_aktif" boolean DEFAULT false,
    "try_out_id" "uuid",
    "started_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "finished_at" timestamp with time zone,
    "total_skor" numeric DEFAULT 0
);


ALTER TABLE "public"."pengerjaan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pengerjaan_subtes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pengerjaan_id" "uuid" NOT NULL,
    "try_out_subtes_id" "uuid",
    "waktu_mulai" timestamp with time zone,
    "waktu_selesai" timestamp with time zone,
    "skor_subtes" numeric DEFAULT 0
);


ALTER TABLE "public"."pengerjaan_subtes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."point_transactions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "jumlah" integer NOT NULL,
    "sumber_tipe" "public"."sumber_tipe_transaksi" NOT NULL,
    "pengerjaan_id" "uuid",
    "battle_id" "uuid",
    "avatar_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."point_transactions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."program_studi" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "universitas_id" "uuid" NOT NULL,
    "nama_prodi" "text" NOT NULL,
    "kode_prodi" character varying(20) NOT NULL,
    "jenjang" "public"."jenjang_prodi" NOT NULL,
    "is_aktif" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."program_studi" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sessions" (
    "id" character varying(255) NOT NULL,
    "user_id" "uuid",
    "ip_address" character varying(45),
    "user_agent" "text",
    "payload" "text" NOT NULL,
    "last_activity" integer NOT NULL
);


ALTER TABLE "public"."sessions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."siswa" (
    "user_id" "uuid" NOT NULL,
    "nama_lengkap" "text" NOT NULL,
    "kelas" "text",
    "jenis_kelamin" "public"."jenis_kelamin",
    "xp" integer DEFAULT 0 NOT NULL,
    "point" integer DEFAULT 0 NOT NULL,
    "streak_saat_ini" integer DEFAULT 0 NOT NULL,
    "avatar_aktif_id" "uuid",
    "universitas_tujuan_id" "uuid",
    "prodi_tujuan_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."siswa" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."siswa_avatar" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "avatar_id" "uuid" NOT NULL,
    "dibeli_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."siswa_avatar" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."siswa_badge" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "badge_id" "uuid" NOT NULL,
    "diperoleh_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."siswa_badge" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."soal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "kode_soal" character varying(100) NOT NULL,
    "subtes_id" "uuid" NOT NULL,
    "editor_id" "uuid",
    "tipe" "public"."tipe_soal" NOT NULL,
    "teks_soal" "text" NOT NULL,
    "gambar_soal" "text",
    "kunci_jawaban" "text",
    "hint" "text",
    "pembahasan" "text" NOT NULL,
    "tingkat_kesulitan" "public"."tingkat_kesulitan" NOT NULL,
    "status" "public"."status_soal" DEFAULT 'draft'::"public"."status_soal" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "soal_isian_wajib_kunci" CHECK ((("tipe" <> 'isian_singkat'::"public"."tipe_soal") OR ("kunci_jawaban" IS NOT NULL))),
    CONSTRAINT "soal_opsi_tanpa_kunci_teks" CHECK ((("tipe" = 'isian_singkat'::"public"."tipe_soal") OR ("kunci_jawaban" IS NULL)))
);


ALTER TABLE "public"."soal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."subtes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nama_subtes" "text" NOT NULL,
    "deskripsi" "text",
    "urutan" integer NOT NULL,
    "waktu_default_menit" numeric(4,1) NOT NULL,
    "kode_subtes" character varying,
    "jumlah_soal" integer NOT NULL,
    CONSTRAINT "subtes_jumlah_soal_positif" CHECK (("jumlah_soal" > 0))
);


ALTER TABLE "public"."subtes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."try_out" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "judul" "text" NOT NULL,
    "peraturan" "text",
    "status" "public"."status_tryout" DEFAULT 'draft'::"public"."status_tryout" NOT NULL,
    "dibuat_oleh" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."try_out" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."try_out_soal" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "try_out_subtes_id" "uuid" NOT NULL,
    "soal_id" "uuid" NOT NULL,
    "urutan" integer NOT NULL
);


ALTER TABLE "public"."try_out_soal" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."try_out_subtes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "try_out_id" "uuid" NOT NULL,
    "subtes_id" "uuid" NOT NULL,
    "urutan" integer NOT NULL,
    "jumlah_soal" integer NOT NULL,
    "waktu_menit" numeric(4,1) NOT NULL
);


ALTER TABLE "public"."try_out_subtes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."universitas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nama_universitas" "text" NOT NULL,
    "kode_ptn" character varying(10) NOT NULL,
    "singkatan" character varying(20) NOT NULL,
    "is_aktif" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."universitas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "email" "text" NOT NULL,
    "password" "text" NOT NULL,
    "role" "public"."user_role" DEFAULT 'siswa'::"public"."user_role" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "email_verified_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "remember_token" character varying,
    "name" character varying(50)
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."xp_transactions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "jumlah" integer NOT NULL,
    "sumber_tipe" "public"."sumber_tipe_transaksi" NOT NULL,
    "pengerjaan_id" "uuid",
    "battle_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."xp_transactions" OWNER TO "postgres";


ALTER TABLE ONLY "public"."failed_jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."failed_jobs_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."jobs_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."migrations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."migrations_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."admin_editor"
    ADD CONSTRAINT "admin_editor_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."avatar"
    ADD CONSTRAINT "avatar_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."badge"
    ADD CONSTRAINT "badge_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."battle_daftar_soal"
    ADD CONSTRAINT "battle_daftar_soal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."battle_jawaban"
    ADD CONSTRAINT "battle_jawaban_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."battle"
    ADD CONSTRAINT "battle_join_code_key" UNIQUE ("join_code");



ALTER TABLE ONLY "public"."battle_peserta"
    ADD CONSTRAINT "battle_peserta_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."battle"
    ADD CONSTRAINT "battle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cache_locks"
    ADD CONSTRAINT "cache_locks_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."cache"
    ADD CONSTRAINT "cache_pkey" PRIMARY KEY ("key");



ALTER TABLE ONLY "public"."failed_jobs"
    ADD CONSTRAINT "failed_jobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."failed_jobs"
    ADD CONSTRAINT "failed_jobs_uuid_unique" UNIQUE ("uuid");



ALTER TABLE ONLY "public"."ice_breaking_content"
    ADD CONSTRAINT "ice_breaking_content_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jawaban_pengerjaan"
    ADD CONSTRAINT "jawaban_pengerjaan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."job_batches"
    ADD CONSTRAINT "job_batches_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jobs"
    ADD CONSTRAINT "jobs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."migrations"
    ADD CONSTRAINT "migrations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."opsi_jawaban"
    ADD CONSTRAINT "opsi_jawaban_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."password_reset_tokens"
    ADD CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("email");



ALTER TABLE ONLY "public"."pengerjaan"
    ADD CONSTRAINT "pengerjaan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pengerjaan_subtes"
    ADD CONSTRAINT "pengerjaan_subtes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."program_studi"
    ADD CONSTRAINT "program_studi_id_universitas_key" UNIQUE ("id", "universitas_id");



ALTER TABLE ONLY "public"."program_studi"
    ADD CONSTRAINT "program_studi_kode_prodi_key" UNIQUE ("kode_prodi");



ALTER TABLE ONLY "public"."program_studi"
    ADD CONSTRAINT "program_studi_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sessions"
    ADD CONSTRAINT "sessions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."siswa_avatar"
    ADD CONSTRAINT "siswa_avatar_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."siswa_badge"
    ADD CONSTRAINT "siswa_badge_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."siswa"
    ADD CONSTRAINT "siswa_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."soal"
    ADD CONSTRAINT "soal_kode_soal_key" UNIQUE ("kode_soal");



ALTER TABLE ONLY "public"."soal"
    ADD CONSTRAINT "soal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."subtes"
    ADD CONSTRAINT "subtes_kode_subtes_key" UNIQUE ("kode_subtes");



ALTER TABLE ONLY "public"."subtes"
    ADD CONSTRAINT "subtes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."try_out"
    ADD CONSTRAINT "try_out_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."try_out_soal"
    ADD CONSTRAINT "try_out_soal_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."try_out_subtes"
    ADD CONSTRAINT "try_out_subtes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."universitas"
    ADD CONSTRAINT "universitas_kode_ptn_key" UNIQUE ("kode_ptn");



ALTER TABLE ONLY "public"."universitas"
    ADD CONSTRAINT "universitas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_pkey" PRIMARY KEY ("id");



CREATE INDEX "jobs_queue_index" ON "public"."jobs" USING "btree" ("queue");



CREATE UNIQUE INDEX "pengerjaan_try_out_sekali" ON "public"."pengerjaan" USING "btree" ("try_out_id", "user_id") WHERE ("try_out_id" IS NOT NULL);



CREATE UNIQUE INDEX "program_studi_nama_unik" ON "public"."program_studi" USING "btree" ("universitas_id", "jenjang", "lower"("nama_prodi"));



CREATE INDEX "sessions_last_activity_index" ON "public"."sessions" USING "btree" ("last_activity");



CREATE INDEX "sessions_user_id_index" ON "public"."sessions" USING "btree" ("user_id");



CREATE INDEX "siswa_prodi_tujuan_idx" ON "public"."siswa" USING "btree" ("prodi_tujuan_id");



CREATE UNIQUE INDEX "universitas_nama_unik" ON "public"."universitas" USING "btree" ("lower"("nama_universitas"));



ALTER TABLE ONLY "public"."admin_editor"
    ADD CONSTRAINT "admin_editor_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."battle_daftar_soal"
    ADD CONSTRAINT "battle_daftar_soal_battle_id_fkey" FOREIGN KEY ("battle_id") REFERENCES "public"."battle"("id");



ALTER TABLE ONLY "public"."battle_daftar_soal"
    ADD CONSTRAINT "battle_daftar_soal_soal_id_fkey" FOREIGN KEY ("soal_id") REFERENCES "public"."soal"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."battle"
    ADD CONSTRAINT "battle_dibuat_oleh_fkey" FOREIGN KEY ("dibuat_oleh") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."battle_jawaban"
    ADD CONSTRAINT "battle_jawaban_battle_daftar_soal_id_fkey" FOREIGN KEY ("battle_daftar_soal_id") REFERENCES "public"."battle_daftar_soal"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."battle_jawaban"
    ADD CONSTRAINT "battle_jawaban_battle_peserta_id_fkey" FOREIGN KEY ("battle_peserta_id") REFERENCES "public"."battle_peserta"("id");



ALTER TABLE ONLY "public"."battle_jawaban"
    ADD CONSTRAINT "battle_jawaban_opsi_dipilih_id_fkey" FOREIGN KEY ("opsi_dipilih_id") REFERENCES "public"."opsi_jawaban"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."battle_peserta"
    ADD CONSTRAINT "battle_peserta_battle_id_fkey" FOREIGN KEY ("battle_id") REFERENCES "public"."battle"("id");



ALTER TABLE ONLY "public"."battle_peserta"
    ADD CONSTRAINT "battle_peserta_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE ONLY "public"."battle"
    ADD CONSTRAINT "battle_subtes_id_fkey" FOREIGN KEY ("subtes_id") REFERENCES "public"."subtes"("id");



ALTER TABLE ONLY "public"."ice_breaking_content"
    ADD CONSTRAINT "ice_breaking_content_dibuat_oleh_fkey" FOREIGN KEY ("dibuat_oleh") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."jawaban_pengerjaan"
    ADD CONSTRAINT "jawaban_pengerjaan_opsi_dipilih_id_fkey" FOREIGN KEY ("opsi_dipilih_id") REFERENCES "public"."opsi_jawaban"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."jawaban_pengerjaan"
    ADD CONSTRAINT "jawaban_pengerjaan_pengerjaan_id_fkey" FOREIGN KEY ("pengerjaan_id") REFERENCES "public"."pengerjaan"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."jawaban_pengerjaan"
    ADD CONSTRAINT "jawaban_pengerjaan_pengerjaan_subtes_id_fkey" FOREIGN KEY ("pengerjaan_subtes_id") REFERENCES "public"."pengerjaan_subtes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."jawaban_pengerjaan"
    ADD CONSTRAINT "jawaban_pengerjaan_soal_id_fkey" FOREIGN KEY ("soal_id") REFERENCES "public"."soal"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."opsi_jawaban"
    ADD CONSTRAINT "opsi_jawaban_soal_id_fkey" FOREIGN KEY ("soal_id") REFERENCES "public"."soal"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."pengerjaan"
    ADD CONSTRAINT "pengerjaan_subtes_id_fkey" FOREIGN KEY ("subtes_id") REFERENCES "public"."subtes"("id");



ALTER TABLE ONLY "public"."pengerjaan_subtes"
    ADD CONSTRAINT "pengerjaan_subtes_pengerjaan_id_fkey" FOREIGN KEY ("pengerjaan_id") REFERENCES "public"."pengerjaan"("id");



ALTER TABLE ONLY "public"."pengerjaan_subtes"
    ADD CONSTRAINT "pengerjaan_subtes_try_out_subtes_id_fkey" FOREIGN KEY ("try_out_subtes_id") REFERENCES "public"."try_out_subtes"("id");



ALTER TABLE ONLY "public"."pengerjaan"
    ADD CONSTRAINT "pengerjaan_try_out_id_fkey" FOREIGN KEY ("try_out_id") REFERENCES "public"."try_out"("id");



ALTER TABLE ONLY "public"."pengerjaan"
    ADD CONSTRAINT "pengerjaan_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_avatar_id_fkey" FOREIGN KEY ("avatar_id") REFERENCES "public"."avatar"("id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_battle_id_fkey" FOREIGN KEY ("battle_id") REFERENCES "public"."battle"("id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_pengerjaan_id_fkey" FOREIGN KEY ("pengerjaan_id") REFERENCES "public"."pengerjaan"("id");



ALTER TABLE ONLY "public"."point_transactions"
    ADD CONSTRAINT "point_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE ONLY "public"."program_studi"
    ADD CONSTRAINT "program_studi_universitas_id_fkey" FOREIGN KEY ("universitas_id") REFERENCES "public"."universitas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."siswa"
    ADD CONSTRAINT "siswa_avatar_aktif_id_fkey" FOREIGN KEY ("avatar_aktif_id") REFERENCES "public"."avatar"("id");



ALTER TABLE ONLY "public"."siswa_avatar"
    ADD CONSTRAINT "siswa_avatar_avatar_id_fkey" FOREIGN KEY ("avatar_id") REFERENCES "public"."avatar"("id");



ALTER TABLE ONLY "public"."siswa_avatar"
    ADD CONSTRAINT "siswa_avatar_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE ONLY "public"."siswa_badge"
    ADD CONSTRAINT "siswa_badge_badge_id_fkey" FOREIGN KEY ("badge_id") REFERENCES "public"."badge"("id");



ALTER TABLE ONLY "public"."siswa_badge"
    ADD CONSTRAINT "siswa_badge_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE ONLY "public"."siswa"
    ADD CONSTRAINT "siswa_tujuan_fkey" FOREIGN KEY ("prodi_tujuan_id", "universitas_tujuan_id") REFERENCES "public"."program_studi"("id", "universitas_id") MATCH FULL ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."siswa"
    ADD CONSTRAINT "siswa_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."soal"
    ADD CONSTRAINT "soal_editor_id_fkey" FOREIGN KEY ("editor_id") REFERENCES "public"."admin_editor"("user_id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."soal"
    ADD CONSTRAINT "soal_subtes_id_fkey" FOREIGN KEY ("subtes_id") REFERENCES "public"."subtes"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."try_out"
    ADD CONSTRAINT "try_out_dibuat_oleh_fkey" FOREIGN KEY ("dibuat_oleh") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."try_out_soal"
    ADD CONSTRAINT "try_out_soal_soal_id_fkey" FOREIGN KEY ("soal_id") REFERENCES "public"."soal"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."try_out_soal"
    ADD CONSTRAINT "try_out_soal_try_out_subtes_id_fkey" FOREIGN KEY ("try_out_subtes_id") REFERENCES "public"."try_out_subtes"("id");



ALTER TABLE ONLY "public"."try_out_subtes"
    ADD CONSTRAINT "try_out_subtes_subtes_id_fkey" FOREIGN KEY ("subtes_id") REFERENCES "public"."subtes"("id");



ALTER TABLE ONLY "public"."try_out_subtes"
    ADD CONSTRAINT "try_out_subtes_try_out_id_fkey" FOREIGN KEY ("try_out_id") REFERENCES "public"."try_out"("id");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_battle_id_fkey" FOREIGN KEY ("battle_id") REFERENCES "public"."battle"("id");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_pengerjaan_id_fkey" FOREIGN KEY ("pengerjaan_id") REFERENCES "public"."pengerjaan"("id");



ALTER TABLE ONLY "public"."xp_transactions"
    ADD CONSTRAINT "xp_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."siswa"("user_id");



ALTER TABLE "public"."admin_editor" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."soal" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";





































































































































































GRANT ALL ON TABLE "public"."admin_editor" TO "anon";
GRANT ALL ON TABLE "public"."admin_editor" TO "authenticated";
GRANT ALL ON TABLE "public"."admin_editor" TO "service_role";



GRANT ALL ON TABLE "public"."avatar" TO "anon";
GRANT ALL ON TABLE "public"."avatar" TO "authenticated";
GRANT ALL ON TABLE "public"."avatar" TO "service_role";



GRANT ALL ON TABLE "public"."badge" TO "anon";
GRANT ALL ON TABLE "public"."badge" TO "authenticated";
GRANT ALL ON TABLE "public"."badge" TO "service_role";



GRANT ALL ON TABLE "public"."battle" TO "anon";
GRANT ALL ON TABLE "public"."battle" TO "authenticated";
GRANT ALL ON TABLE "public"."battle" TO "service_role";



GRANT ALL ON TABLE "public"."battle_daftar_soal" TO "anon";
GRANT ALL ON TABLE "public"."battle_daftar_soal" TO "authenticated";
GRANT ALL ON TABLE "public"."battle_daftar_soal" TO "service_role";



GRANT ALL ON TABLE "public"."battle_jawaban" TO "anon";
GRANT ALL ON TABLE "public"."battle_jawaban" TO "authenticated";
GRANT ALL ON TABLE "public"."battle_jawaban" TO "service_role";



GRANT ALL ON TABLE "public"."battle_peserta" TO "anon";
GRANT ALL ON TABLE "public"."battle_peserta" TO "authenticated";
GRANT ALL ON TABLE "public"."battle_peserta" TO "service_role";



GRANT ALL ON TABLE "public"."cache" TO "anon";
GRANT ALL ON TABLE "public"."cache" TO "authenticated";
GRANT ALL ON TABLE "public"."cache" TO "service_role";



GRANT ALL ON TABLE "public"."cache_locks" TO "anon";
GRANT ALL ON TABLE "public"."cache_locks" TO "authenticated";
GRANT ALL ON TABLE "public"."cache_locks" TO "service_role";



GRANT ALL ON TABLE "public"."failed_jobs" TO "anon";
GRANT ALL ON TABLE "public"."failed_jobs" TO "authenticated";
GRANT ALL ON TABLE "public"."failed_jobs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."failed_jobs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."failed_jobs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."failed_jobs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."ice_breaking_content" TO "anon";
GRANT ALL ON TABLE "public"."ice_breaking_content" TO "authenticated";
GRANT ALL ON TABLE "public"."ice_breaking_content" TO "service_role";



GRANT ALL ON TABLE "public"."jawaban_pengerjaan" TO "anon";
GRANT ALL ON TABLE "public"."jawaban_pengerjaan" TO "authenticated";
GRANT ALL ON TABLE "public"."jawaban_pengerjaan" TO "service_role";



GRANT ALL ON TABLE "public"."job_batches" TO "anon";
GRANT ALL ON TABLE "public"."job_batches" TO "authenticated";
GRANT ALL ON TABLE "public"."job_batches" TO "service_role";



GRANT ALL ON TABLE "public"."jobs" TO "anon";
GRANT ALL ON TABLE "public"."jobs" TO "authenticated";
GRANT ALL ON TABLE "public"."jobs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."jobs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."jobs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."jobs_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."migrations" TO "anon";
GRANT ALL ON TABLE "public"."migrations" TO "authenticated";
GRANT ALL ON TABLE "public"."migrations" TO "service_role";



GRANT ALL ON SEQUENCE "public"."migrations_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."migrations_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."migrations_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."opsi_jawaban" TO "anon";
GRANT ALL ON TABLE "public"."opsi_jawaban" TO "authenticated";
GRANT ALL ON TABLE "public"."opsi_jawaban" TO "service_role";



GRANT ALL ON TABLE "public"."password_reset_tokens" TO "anon";
GRANT ALL ON TABLE "public"."password_reset_tokens" TO "authenticated";
GRANT ALL ON TABLE "public"."password_reset_tokens" TO "service_role";



GRANT ALL ON TABLE "public"."pengerjaan" TO "anon";
GRANT ALL ON TABLE "public"."pengerjaan" TO "authenticated";
GRANT ALL ON TABLE "public"."pengerjaan" TO "service_role";



GRANT ALL ON TABLE "public"."pengerjaan_subtes" TO "anon";
GRANT ALL ON TABLE "public"."pengerjaan_subtes" TO "authenticated";
GRANT ALL ON TABLE "public"."pengerjaan_subtes" TO "service_role";



GRANT ALL ON TABLE "public"."point_transactions" TO "anon";
GRANT ALL ON TABLE "public"."point_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."point_transactions" TO "service_role";



GRANT ALL ON TABLE "public"."program_studi" TO "anon";
GRANT ALL ON TABLE "public"."program_studi" TO "authenticated";
GRANT ALL ON TABLE "public"."program_studi" TO "service_role";



GRANT ALL ON TABLE "public"."sessions" TO "anon";
GRANT ALL ON TABLE "public"."sessions" TO "authenticated";
GRANT ALL ON TABLE "public"."sessions" TO "service_role";



GRANT ALL ON TABLE "public"."siswa" TO "anon";
GRANT ALL ON TABLE "public"."siswa" TO "authenticated";
GRANT ALL ON TABLE "public"."siswa" TO "service_role";



GRANT ALL ON TABLE "public"."siswa_avatar" TO "anon";
GRANT ALL ON TABLE "public"."siswa_avatar" TO "authenticated";
GRANT ALL ON TABLE "public"."siswa_avatar" TO "service_role";



GRANT ALL ON TABLE "public"."siswa_badge" TO "anon";
GRANT ALL ON TABLE "public"."siswa_badge" TO "authenticated";
GRANT ALL ON TABLE "public"."siswa_badge" TO "service_role";



GRANT ALL ON TABLE "public"."soal" TO "anon";
GRANT ALL ON TABLE "public"."soal" TO "authenticated";
GRANT ALL ON TABLE "public"."soal" TO "service_role";



GRANT ALL ON TABLE "public"."subtes" TO "anon";
GRANT ALL ON TABLE "public"."subtes" TO "authenticated";
GRANT ALL ON TABLE "public"."subtes" TO "service_role";



GRANT ALL ON TABLE "public"."try_out" TO "anon";
GRANT ALL ON TABLE "public"."try_out" TO "authenticated";
GRANT ALL ON TABLE "public"."try_out" TO "service_role";



GRANT ALL ON TABLE "public"."try_out_soal" TO "anon";
GRANT ALL ON TABLE "public"."try_out_soal" TO "authenticated";
GRANT ALL ON TABLE "public"."try_out_soal" TO "service_role";



GRANT ALL ON TABLE "public"."try_out_subtes" TO "anon";
GRANT ALL ON TABLE "public"."try_out_subtes" TO "authenticated";
GRANT ALL ON TABLE "public"."try_out_subtes" TO "service_role";



GRANT ALL ON TABLE "public"."universitas" TO "anon";
GRANT ALL ON TABLE "public"."universitas" TO "authenticated";
GRANT ALL ON TABLE "public"."universitas" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."xp_transactions" TO "anon";
GRANT ALL ON TABLE "public"."xp_transactions" TO "authenticated";
GRANT ALL ON TABLE "public"."xp_transactions" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































drop extension if exists "pg_net";


