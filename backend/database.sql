-- Base
CREATE TABLE document_type (
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_document_type PRIMARY KEY (id),
    CONSTRAINT uq_document_type_name UNIQUE (name)
);

CREATE TABLE roles (
    id SERIAL,
    name VARCHAR(150) NOT NULL,
    CONSTRAINT pk_roles PRIMARY KEY (id),
    CONSTRAINT uq_roles_name UNIQUE (name)
);

CREATE TABLE auth_users (
    id SERIAL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    CONSTRAINT pk_auth_users PRIMARY KEY (id),
    CONSTRAINT uq_auth_users_email UNIQUE (email)
);

CREATE TABLE species (
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_species PRIMARY KEY (id),
    CONSTRAINT uq_species_name UNIQUE (name)
);

CREATE TABLE categories (
    id SERIAL,
    name VARCHAR(150) NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (id),
    CONSTRAINT uq_categories_name UNIQUE (name)
);

CREATE TABLE profile_images (
    id SERIAL,
    url VARCHAR(255) NOT NULL,
    type VARCHAR(30) NOT NULL,
    is_default BOOLEAN NOT NULL,
    CONSTRAINT pk_profile_images PRIMARY KEY (id),
    CONSTRAINT uq_profile_images_url UNIQUE (url),
    CONSTRAINT chk_profile_images_type CHECK (
        type IN ('Staff', 'Pet', 'Owner')
    )
);

CREATE UNIQUE INDEX unique_default_per_type ON profile_images(type) WHERE is_default = true;

CREATE TABLE appointment_status (
    id SERIAL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT pk_appointment_status PRIMARY KEY (id),
    CONSTRAINT chk_appointment_status_name CHECK (
        name IN (
            'Pending',
            'In Process',
            'Completed'
        )
    ),
    CONSTRAINT uq_appointment_status_name UNIQUE (name)
);

CREATE TABLE form_message_status (
    id SERIAL,
    name VARCHAR(20) NOT NULL,
    CONSTRAINT pk_form_message_status PRIMARY KEY (id),
    CONSTRAINT chk_form_message_status_name CHECK (
        name IN (
            'Unread',
            'Viewed',
            'Responded'
        )
    ),
    CONSTRAINT uq_form_message_status_name UNIQUE (name)
);

-- One dependency

CREATE TABLE personal_data (
    id SERIAL,
    document_type_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    sex VARCHAR(10) NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_personal_data PRIMARY KEY (id),
    CONSTRAINT fk_personal_data_document_type FOREIGN KEY (document_type_id) REFERENCES document_type (id) ON DELETE RESTRICT,
    CONSTRAINT chk_personal_data_sex CHECK (
        sex IN ('Male', 'Female', 'Other')
    ),
    CONSTRAINT uq_personal_data_document UNIQUE (
        document_type_id,
        document_number
    )
);

CREATE TABLE breeds (
    id SERIAL,
    species_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_breeds PRIMARY KEY (id),
    CONSTRAINT fk_breeds_species FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE RESTRICT,
    CONSTRAINT uq_breeds_species_name UNIQUE (species_id, name)
);

CREATE TABLE services (
    id SERIAL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    CONSTRAINT pk_services PRIMARY KEY (id),
    CONSTRAINT fk_services_category FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE RESTRICT,
    CONSTRAINT uq_services_category_name UNIQUE (category_id, name)
);

CREATE TABLE form_contact_info (
    id SERIAL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    CONSTRAINT pk_form_contact_info PRIMARY KEY (id)
);

-- Core entities

CREATE TABLE owners (
    id SERIAL,
    personal_data_id INT NOT NULL,
    profile_image_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_owners PRIMARY KEY (id),
    CONSTRAINT fk_owners_personal_data FOREIGN KEY (personal_data_id) REFERENCES personal_data (id) ON DELETE RESTRICT,
    CONSTRAINT fk_owners_profile_image FOREIGN KEY (profile_image_id) REFERENCES profile_images (id) ON DELETE SET NULL,
    CONSTRAINT uq_owner_personal_data UNIQUE (personal_data_id)
);

ALTER TABLE owners
ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

CREATE TABLE staff (
    id SERIAL,
    personal_data_id INT NOT NULL,
    role_id INT NOT NULL,
    auth_user_id INT,
    profile_image_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_staff PRIMARY KEY (id),
    CONSTRAINT fk_staff_personal_data FOREIGN KEY (personal_data_id) REFERENCES personal_data (id) ON DELETE RESTRICT,
    CONSTRAINT fk_staff_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT,
    CONSTRAINT fk_staff_auth_user FOREIGN KEY (auth_user_id) REFERENCES auth_users (id) ON DELETE SET NULL,
    CONSTRAINT fk_staff_profile_image FOREIGN KEY (profile_image_id) REFERENCES profile_images (id) ON DELETE SET NULL,
    CONSTRAINT uq_staff_personal_data UNIQUE (personal_data_id),
    CONSTRAINT uq_staff_auth_user UNIQUE (auth_user_id)
);

ALTER TABLE staff ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

CREATE TABLE pets (
    id SERIAL,
    species_id INT NOT NULL,
    breed_id INT NULL,
    profile_image_id INT,
    name VARCHAR(50) NOT NULL,
    weight NUMERIC(6, 2) NOT NULL,
    sex VARCHAR(10) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_pets PRIMARY KEY (id),
    CONSTRAINT fk_pets_species FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE RESTRICT,
    CONSTRAINT fk_pets_breed FOREIGN KEY (breed_id) REFERENCES breeds (id) ON DELETE SET NULL,
    CONSTRAINT fk_pets_profile_image FOREIGN KEY (profile_image_id) REFERENCES profile_images (id) ON DELETE SET NULL,
    CONSTRAINT chk_pets_sex CHECK (
        sex IN ('Male', 'Female', 'Other')
    )
);

ALTER TABLE pets ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

CREATE INDEX idx_pets_breed_id ON pets (breed_id);

CREATE INDEX idx_pets_species_id ON pets (species_id);

-- Notifications Base

CREATE TABLE notifications (
    id SERIAL,
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    CONSTRAINT pk_notifications PRIMARY KEY (id)
);

-- M:N tables

CREATE TABLE owners_pets (
    id SERIAL,
    owner_id INT NOT NULL,
    pet_id INT NOT NULL,
    start_date DATE NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT pk_owners_pets PRIMARY KEY (id),
    CONSTRAINT fk_owners_pets_owner FOREIGN KEY (owner_id) REFERENCES owners (id) ON DELETE CASCADE,
    CONSTRAINT fk_owners_pets_pet FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
    CONSTRAINT uq_owners_pets_owner_pet UNIQUE (owner_id, pet_id)
);

CREATE UNIQUE INDEX unique_primary_owner_per_pet ON owners_pets (pet_id)
WHERE
    is_primary = true;

CREATE INDEX idx_owners_pets_owner_id ON owners_pets (owner_id);

CREATE INDEX idx_owners_pets_pet_id ON owners_pets (pet_id);

CREATE TABLE notifications_staff (
    id SERIAL,
    notification_id INT NOT NULL,
    staff_id INT NOT NULL,
    CONSTRAINT pk_notifications_staff PRIMARY KEY (id),
    CONSTRAINT fk_notifications_staff_notification FOREIGN KEY (notification_id) REFERENCES notifications (id) ON DELETE CASCADE,
    CONSTRAINT fk_notifications_staff_staff FOREIGN KEY (staff_id) REFERENCES staff (id) ON DELETE CASCADE,
    CONSTRAINT uq_notifications_staff_notification_staff UNIQUE (notification_id, staff_id)
);

-- Business logic

CREATE TABLE appointments (
    id SERIAL,
    service_id INT NOT NULL,
    staff_id INT NOT NULL,
    owner_pet_id INT NOT NULL,
    appointment_status_id INT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_appointments PRIMARY KEY (id),
    CONSTRAINT fk_appointments_services FOREIGN KEY (service_id) REFERENCES services (id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_staff FOREIGN KEY (staff_id) REFERENCES staff (id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_owner_pet FOREIGN KEY (owner_pet_id) REFERENCES owners_pets (id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_appointment_status FOREIGN KEY (appointment_status_id) REFERENCES appointment_status (id) ON DELETE RESTRICT,
    CONSTRAINT chk_appointments_end_time_gt_start_time CHECK (end_time > start_time)
);

CREATE INDEX idx_appointments_owner_pet_id ON appointments (owner_pet_id);

CREATE INDEX idx_appointments_staff_id ON appointments (staff_id);

CREATE TABLE medical_records (
    id SERIAL,
    appointment_id INT NOT NULL,
    staff_id INT NOT NULL,
    diagnosis TEXT NOT NULL,
    treatment TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_medical_records PRIMARY KEY (id),
    CONSTRAINT fk_medical_records_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id) ON DELETE CASCADE,
    CONSTRAINT uq_medical_records_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_medical_records_staff FOREIGN KEY (staff_id) REFERENCES staff (id) ON DELETE RESTRICT
);

CREATE INDEX idx_medical_records_appointment_id ON medical_records (appointment_id);

CREATE TABLE medical_record_files (
    id SERIAL,
    medical_record_id INT NOT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT pk_medical_record_files PRIMARY KEY (id),
    CONSTRAINT fk_medical_record_files_medical_record FOREIGN KEY (medical_record_id) REFERENCES medical_records (id) ON DELETE CASCADE
);

-- Forms

CREATE TABLE form_messages (
    id SERIAL,
    form_message_status_id INT NOT NULL,
    form_contact_info_id INT NOT NULL,
    assigned_staff_id INT,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_form_messages PRIMARY KEY (id),
    CONSTRAINT fk_form_messages_form_message_status FOREIGN KEY (form_message_status_id) REFERENCES form_message_status (id) ON DELETE RESTRICT,
    CONSTRAINT fk_form_messages_form_contact_info FOREIGN KEY (form_contact_info_id) REFERENCES form_contact_info (id) ON DELETE RESTRICT,
    CONSTRAINT fk_form_messages_assigned_staff FOREIGN KEY (assigned_staff_id) REFERENCES staff (id) ON DELETE SET NULL
);