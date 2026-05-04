-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "appointment_status" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(20) NOT NULL,

    CONSTRAINT "pk_appointment_status" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "appointments" (
    "id" SERIAL NOT NULL,
    "service_id" INTEGER NOT NULL,
    "staff_id" INTEGER NOT NULL,
    "owner_pet_id" INTEGER NOT NULL,
    "appointment_status_id" INTEGER NOT NULL,
    "start_time" TIMESTAMPTZ(6) NOT NULL,
    "end_time" TIMESTAMPTZ(6) NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_appointments" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auth_users" (
    "id" SERIAL NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,

    CONSTRAINT "pk_auth_users" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "breeds" (
    "id" SERIAL NOT NULL,
    "species_id" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "pk_breeds" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,

    CONSTRAINT "pk_categories" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "document_type" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "pk_document_type" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "form_contact_info" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(30) NOT NULL,

    CONSTRAINT "pk_form_contact_info" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "form_message_status" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(20) NOT NULL,

    CONSTRAINT "pk_form_message_status" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "form_messages" (
    "id" SERIAL NOT NULL,
    "form_message_status_id" INTEGER NOT NULL,
    "form_contact_info_id" INTEGER NOT NULL,
    "assigned_staff_id" INTEGER,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pk_form_messages" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_record_files" (
    "id" SERIAL NOT NULL,
    "medical_record_id" INTEGER NOT NULL,
    "file_url" TEXT NOT NULL,
    "file_type" VARCHAR(50) NOT NULL,
    "uploaded_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pk_medical_record_files" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "medical_records" (
    "id" SERIAL NOT NULL,
    "appointment_id" INTEGER NOT NULL,
    "staff_id" INTEGER NOT NULL,
    "diagnosis" TEXT NOT NULL,
    "treatment" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_medical_records" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" SERIAL NOT NULL,
    "message" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_read" BOOLEAN DEFAULT false,
    "read_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_notifications" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications_staff" (
    "id" SERIAL NOT NULL,
    "notification_id" INTEGER NOT NULL,
    "staff_id" INTEGER NOT NULL,

    CONSTRAINT "pk_notifications_staff" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "owners" (
    "id" SERIAL NOT NULL,
    "personal_data_id" INTEGER NOT NULL,
    "profile_image_id" INTEGER,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "pk_owners" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "owners_pets" (
    "id" SERIAL NOT NULL,
    "owner_id" INTEGER NOT NULL,
    "pet_id" INTEGER NOT NULL,
    "start_date" DATE NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "pk_owners_pets" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personal_data" (
    "id" SERIAL NOT NULL,
    "document_type_id" INTEGER NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "document_number" VARCHAR(20) NOT NULL,
    "birth_date" DATE NOT NULL,
    "sex" VARCHAR(10) NOT NULL,
    "phone_number" VARCHAR(30) NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),

    CONSTRAINT "pk_personal_data" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pets" (
    "id" SERIAL NOT NULL,
    "species_id" INTEGER NOT NULL,
    "breed_id" INTEGER,
    "profile_image_id" INTEGER,
    "name" VARCHAR(50) NOT NULL,
    "weight" DECIMAL(6,2) NOT NULL,
    "sex" VARCHAR(10) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "pk_pets" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile_images" (
    "id" SERIAL NOT NULL,
    "url" VARCHAR(255) NOT NULL,
    "type" VARCHAR(30) NOT NULL,
    "is_default" BOOLEAN NOT NULL,

    CONSTRAINT "pk_profile_images" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(150) NOT NULL,

    CONSTRAINT "pk_roles" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "services" (
    "id" SERIAL NOT NULL,
    "category_id" INTEGER NOT NULL,
    "name" VARCHAR(150) NOT NULL,

    CONSTRAINT "pk_services" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "species" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "pk_species" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff" (
    "id" SERIAL NOT NULL,
    "personal_data_id" INTEGER NOT NULL,
    "role_id" INTEGER NOT NULL,
    "auth_user_id" INTEGER,
    "profile_image_id" INTEGER,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6),
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "pk_staff" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "uq_appointment_status_name" ON "appointment_status"("name");

-- CreateIndex
CREATE INDEX "idx_appointments_owner_pet_id" ON "appointments"("owner_pet_id");

-- CreateIndex
CREATE INDEX "idx_appointments_staff_id" ON "appointments"("staff_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_auth_users_email" ON "auth_users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "uq_breeds_species_name" ON "breeds"("species_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_categories_name" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_document_type_name" ON "document_type"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_form_message_status_name" ON "form_message_status"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_medical_records_appointment" ON "medical_records"("appointment_id");

-- CreateIndex
CREATE INDEX "idx_medical_records_appointment_id" ON "medical_records"("appointment_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_notifications_staff_notification_staff" ON "notifications_staff"("notification_id", "staff_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_owner_personal_data" ON "owners"("personal_data_id");

-- CreateIndex
CREATE UNIQUE INDEX "unique_primary_owner_per_pet" ON "owners_pets"("pet_id") WHERE (is_primary = true);

-- CreateIndex
CREATE INDEX "idx_owners_pets_owner_id" ON "owners_pets"("owner_id");

-- CreateIndex
CREATE INDEX "idx_owners_pets_pet_id" ON "owners_pets"("pet_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_owners_pets_owner_pet" ON "owners_pets"("owner_id", "pet_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_personal_data_document" ON "personal_data"("document_type_id", "document_number");

-- CreateIndex
CREATE INDEX "idx_pets_breed_id" ON "pets"("breed_id");

-- CreateIndex
CREATE INDEX "idx_pets_species_id" ON "pets"("species_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_profile_images_url" ON "profile_images"("url");

-- CreateIndex
CREATE UNIQUE INDEX "unique_default_per_type" ON "profile_images"("type") WHERE (is_default = true);

-- CreateIndex
CREATE UNIQUE INDEX "uq_roles_name" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_services_category_name" ON "services"("category_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_species_name" ON "species"("name");

-- CreateIndex
CREATE UNIQUE INDEX "uq_staff_personal_data" ON "staff"("personal_data_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_staff_auth_user" ON "staff"("auth_user_id");

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "fk_appointments_appointment_status" FOREIGN KEY ("appointment_status_id") REFERENCES "appointment_status"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "fk_appointments_owner_pet" FOREIGN KEY ("owner_pet_id") REFERENCES "owners_pets"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "fk_appointments_services" FOREIGN KEY ("service_id") REFERENCES "services"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "appointments" ADD CONSTRAINT "fk_appointments_staff" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "breeds" ADD CONSTRAINT "fk_breeds_species" FOREIGN KEY ("species_id") REFERENCES "species"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "form_messages" ADD CONSTRAINT "fk_form_messages_assigned_staff" FOREIGN KEY ("assigned_staff_id") REFERENCES "staff"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "form_messages" ADD CONSTRAINT "fk_form_messages_form_contact_info" FOREIGN KEY ("form_contact_info_id") REFERENCES "form_contact_info"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "form_messages" ADD CONSTRAINT "fk_form_messages_form_message_status" FOREIGN KEY ("form_message_status_id") REFERENCES "form_message_status"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "medical_record_files" ADD CONSTRAINT "fk_medical_record_files_medical_record" FOREIGN KEY ("medical_record_id") REFERENCES "medical_records"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "fk_medical_records_appointment" FOREIGN KEY ("appointment_id") REFERENCES "appointments"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "medical_records" ADD CONSTRAINT "fk_medical_records_staff" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "notifications_staff" ADD CONSTRAINT "fk_notifications_staff_notification" FOREIGN KEY ("notification_id") REFERENCES "notifications"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "notifications_staff" ADD CONSTRAINT "fk_notifications_staff_staff" FOREIGN KEY ("staff_id") REFERENCES "staff"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "owners" ADD CONSTRAINT "fk_owners_personal_data" FOREIGN KEY ("personal_data_id") REFERENCES "personal_data"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "owners" ADD CONSTRAINT "fk_owners_profile_image" FOREIGN KEY ("profile_image_id") REFERENCES "profile_images"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "owners_pets" ADD CONSTRAINT "fk_owners_pets_owner" FOREIGN KEY ("owner_id") REFERENCES "owners"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "owners_pets" ADD CONSTRAINT "fk_owners_pets_pet" FOREIGN KEY ("pet_id") REFERENCES "pets"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personal_data" ADD CONSTRAINT "fk_personal_data_document_type" FOREIGN KEY ("document_type_id") REFERENCES "document_type"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "pets" ADD CONSTRAINT "fk_pets_breed" FOREIGN KEY ("breed_id") REFERENCES "breeds"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "pets" ADD CONSTRAINT "fk_pets_profile_image" FOREIGN KEY ("profile_image_id") REFERENCES "profile_images"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "pets" ADD CONSTRAINT "fk_pets_species" FOREIGN KEY ("species_id") REFERENCES "species"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "services" ADD CONSTRAINT "fk_services_category" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "fk_staff_auth_user" FOREIGN KEY ("auth_user_id") REFERENCES "auth_users"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "fk_staff_personal_data" FOREIGN KEY ("personal_data_id") REFERENCES "personal_data"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "fk_staff_profile_image" FOREIGN KEY ("profile_image_id") REFERENCES "profile_images"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "staff" ADD CONSTRAINT "fk_staff_role" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE NO ACTION;

