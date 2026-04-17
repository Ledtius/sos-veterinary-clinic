## Core People

CREATE TABLE document_type(
  id SERIAL,
  name VARCHAR(100) NOT NULL,
  CONSTRAINT pk_document_type PRIMARY KEY (id),
  CONSTRAINT uq_document_type_name UNIQUE (name)
);

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
    CONSTRAINT fk_personal_data_document_type FOREIGN KEY (document_type_id) REFERENCES document_type (id),
    CONSTRAINT uq_personal_data_document_number UNIQUE (document_number),
    CONSTRAINT chk_personal_data_sex CHECK (
        sex IN ('Male', 'Female', 'Other')
    ) CONSTRAINT uq_personal_data_document UNIQUE (
        document_type_id,
        document_number
    )
);

CREATE TABLE owners (
    id SERIAL,
    personal_data_id INT NOT NULL,
    profile_image_id INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_owners PRIMARY KEY (id),
    CONSTRAINT fk_uq_owners_personal_data FOREIGN KEY (personal_data_id) REFERENCES personal_data (id),
    CONSTRAINT uq_owner_personal_data UNIQUE (personal_data_id)
);

CREATE TABLE staff (
    id SERIAL,
    personal_data_id INT NOT NULL,
    role_id INT NOT NULL,
    auth_user_id INT NOT NULL,
    profile_image_id INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    CONSTRAINT pk_staff PRIMARY KEY (id),
    CONSTRAINT fk_staff_personal_data FOREIGN KEY (personal_data_id) REFERENCES personal_data (id),
    CONSTRAINT uq_staff_personal_data UNIQUE (personal_data_id),
    CONSTRAINT fk_staff_role FOREIGN KEY (role_id) REFERENCES roles (id),
    CONSTRAINT fk_staff_auth_user FOREIGN KEY (auth_user_id) REFERENCES auth_users (id),
    CONSTRAINT uq_staff_auth_user UNIQUE (auth_user_id),
    CONSTRAINT fk_staff_profile_image FOREIGN KEY (profile_image_id) REFERENCES profile_images (id)
);

CREATE TABLE auth_users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

## Pets

CREATE TABLE species(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE breeds (
    id SERIAL PRIMARY KEY,
    species_id INT NOT NULL REFERENCES species (id),
    name VARCHAR(100) NOT NULL,
    UNIQUE (species_id, name)
);

CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    species_id INT NOT NULL REFERENCES species (id),
    breed_id INT REFERENCES breeds (id),
    profile_image_id INT NOT NULL REFERENCES profile_images (id),
    name VARCHAR(50) NOT NULL,
    weight NUMERIC(6, 2) NOT NULL,
    sex VARCHAR(10) NOT NULL CHECK (sex IN ('Male', 'Female')),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

CREATE TABLE owners_pets (
    id SERIAL PRIMARY KEY,
    owner_id INT NOT NULL REFERENCES owners (id),
    pet_id INT NOT NULL REFERENCES pets (id),
    start_date DATE NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    UNIQUE (owner_id, pet_id)
);

CREATE UNIQUE INDEX unique_primary_owner_per_pet ON owners_pets (pet_id)
WHERE
    is_primary = true;

## Media

CREATE TABLE profile_images (
  id SERIAL PRIMARY KEY,
  url VARCHAR(255) NOT NULL UNIQUE,
  type VARCHAR(30) NOT NULL CHECK(type IN ('Staff', 'Pet', 'Owner')),
  is_default BOOLEAN NOT NULL
);

CREATE UNIQUE INDEX unique_default_per_type ON profile_images(type) WHERE is_default = true;

## Appointments

CREATE TABLE appointments (
  id SERIAL PRIMARY KEY,
  service_id INT NOT NULL REFERENCES services(id),
  staff_id INT NOT NULL REFERENCES staff(id),
  owner_pet_id INT NOT NULL REFERENCES owners_pets(id),
  appointment_status_id INT NOT NULL REFERENCES appointment_status(id),
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  CHECK (end_time > start_time),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

CREATE TABLE appointment_status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL CHECK (
        name IN (
            'Pending',
            'In Progress',
            'Completed'
        )
    ) UNIQUE
);

CREATE TABLE medical_records (
    id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL REFERENCES appointments (id) UNIQUE,
    staff_id INT NOT NULL REFERENCES staff (id),
    diagnosis TEXT NOT NULL,
    treatment TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

## Services
CREATE TABLE services(
  id SERIAL PRIMARY KEY, 
  category_id INT NOT NULL REFERENCES categories(id),
  name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

## Notifications

CREATE TABLE notifications(
  id SERIAL  PRIMARY KEY,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE notifications_staff (
    id SERIAL PRIMARY KEY,
    notification_id INT NOT NULL REFERENCES notifications (id),
    staff_id INT NOT NULL REFERENCES staff (id),
    UNIQUE (notification_id, staff_id)
);

## Contact/Forms

CREATE TABLE form_contact_info(
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(30) NOT NULL
);

CREATE TABLE form_messages (
    id SERIAL PRIMARY KEY,
    form_message_status_id INT NOT NULL REFERENCES form_message_status (id),
    form_contact_info_id INT NOT NULL REFERENCES form_contact_info (id),
    assigned_staff_id INT NOT NULL REFERENCES staff (id),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE form_message_status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL CHECK (
        name IN (
            'Unread',
            'Viewed',
            'Responded'
        )
    ) UNIQUE
);