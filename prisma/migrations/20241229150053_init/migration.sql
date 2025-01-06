-- CreateEnum
CREATE TYPE "messagetype" AS ENUM ('Text', 'Image', 'Video');

-- CreateEnum
CREATE TYPE "roletype" AS ENUM ('Host', 'Co-host', 'Attendee');

-- CreateEnum
CREATE TYPE "statustype" AS ENUM ('Active', 'Inactive', 'Pending');

-- CreateTable
CREATE TABLE "account" (
    "id" BIGSERIAL NOT NULL,
    "username" VARCHAR(500) NOT NULL,
    "first_name" VARCHAR(500) NOT NULL,
    "last_name" VARCHAR(500) NOT NULL,
    "email" VARCHAR(500) NOT NULL,
    "password" VARCHAR(500) NOT NULL,
    "avatar_url" VARCHAR(500),
    "bio" VARCHAR(500),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accountsetting" (
    "id" BIGSERIAL NOT NULL,
    "account_id" BIGINT NOT NULL,
    "type" VARCHAR(100) NOT NULL,
    "value" JSON NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "accountsetting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chat" (
    "id" BIGSERIAL NOT NULL,
    "room_id" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meetingroom" (
    "id" BIGSERIAL NOT NULL,
    "created_by" BIGINT NOT NULL,
    "name" VARCHAR(500) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "meetingroom_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "message" (
    "id" BIGSERIAL NOT NULL,
    "type" "messagetype" NOT NULL,
    "value" JSON NOT NULL,
    "chat_id" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ(6),

    CONSTRAINT "message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "participant" (
    "id" BIGSERIAL NOT NULL,
    "account_id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "role" "roletype" NOT NULL,
    "joined_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "statustype" NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "participant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roomsetting" (
    "id" BIGSERIAL NOT NULL,
    "type" VARCHAR(100) NOT NULL,
    "value" JSON NOT NULL,
    "room_id" BIGINT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roomsetting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "thingtodiscuss" (
    "id" BIGSERIAL NOT NULL,
    "is_checked" BOOLEAN NOT NULL DEFAULT false,
    "room_id" BIGINT NOT NULL,
    "content" VARCHAR(500) NOT NULL,
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "thingtodiscuss_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "accountsetting" ADD CONSTRAINT "account_setting_account_id_fk" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "chat" ADD CONSTRAINT "chat_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "meetingroom"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "meetingroom" ADD CONSTRAINT "meeting_room_created_by_fk" FOREIGN KEY ("created_by") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_chat_id_fk" FOREIGN KEY ("chat_id") REFERENCES "chat"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "participant" ADD CONSTRAINT "participant_account_id_fk" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "participant" ADD CONSTRAINT "participant_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "meetingroom"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "roomsetting" ADD CONSTRAINT "room_setting_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "meetingroom"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "thingtodiscuss" ADD CONSTRAINT "thing_to_discuss_room_id_fk" FOREIGN KEY ("room_id") REFERENCES "meetingroom"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
