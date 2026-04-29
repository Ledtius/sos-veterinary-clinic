-- document_type
INSERT INTO document_type (name) VALUES ('CC');

INSERT INTO document_type (name) VALUES ('Passport');

SELECT * FROM document_type;

--roles
INSERT INTO
    ROLES (NAME)
VALUES ('Admin'),
    ('Veterinarian'),
    ('Receptionist');

SELECT * FROM roles;

--auth_users
INSERT INTO
    auth_users (email, password_hash)
VALUES (
        'admin@sosvet.com',
        'hashed_password_1'
    );

INSERT INTO
    auth_users (email, password_hash)
VALUES (
        'vet1@sosvet.com',
        'hashed_password_2'
    );

INSERT INTO
    auth_users (email, password_hash)
VALUES (
        'receptionist1@sosvet.com',
        'hashed_password_3'
    );

SELECT * FROM auth_users;

--species
INSERT INTO species (name) VALUES ('Dog'), ('Cat');

SELECT * FROM species;

--categories
INSERT INTO
    categories (name)
VALUES ('General Consultation'),
    ('Surgery'),
    ('Vaccination');

SELECT * FROM categories;

--services
INSERT INTO
    services (category_id, name)
VALUES (1, 'Basic Checkup'),
    (1, 'Emergency Consultation'),
    (2, 'Sterilization'),
    (3, 'Radies Vaccine');

SELECT * FROM services;

--appointment_status
INSERT INTO
    appointment_status (name)
VALUES ('Pending'),
    ('In Process'),
    ('Completed');

SELECT * FROM appointment_status;

--form_message_status
INSERT INTO
    form_message_status (name)
VALUES ('Unread'),
    ('Viewed'),
    ('Responded');

SELECT * FROM form_message_status;

--profile_images
INSERT INTO
    profile_images (url, type, is_default)
VALUES (
        'default_staff.png',
        'Staff',
        true
    ),
    (
        'default_owner.png',
        'Owner',
        true
    ),
    (
        'default_pet.png',
        'Pet',
        true
    );

SELECT * FROM profile_images;

--staff

SELECT * FROM STAFF;

INSERT INTO
    STAFF (
        PERSONAL_DATA_ID,
        ROLE_ID,
        AUTH_USER_ID,
        PROFILE_IMAGE_ID
    )
VALUES (3, 3, 2, 1);

--personal_data

SELECT * FROM PERSONAL_DATA;

INSERT INTO
    PERSONAL_DATA (
        DOCUMENT_TYPE_ID,
        FIRST_NAME,
        LAST_NAME,
        DOCUMENT_NUMBER,
        BIRTH_DATE,
        SEX,
        PHONE_NUMBER,
        ADDRESS
    )
VALUES (
        1,
        'Carlos',
        'Lopez',
        '123456789',
        '1990-05-10',
        'Male',
        '3001234567',
        'Street 1'
    ),
    (
        1,
        'Maria',
        'Gomez',
        '987654321',
        '1985-08-22',
        'Female',
        '3007654321',
        'Street 2'
    ),
    (
        1,
        'Juan',
        'Perez',
        '456123789',
        '1992-03-15',
        'Male',
        '3011111111',
        'Street 3'
    );

-- owners
SELECT * FROM owners;

INSERT INTO
    owners (
        personal_data_id,
        profile_image_id
    )
VALUES (1, 2),
    (2, 2);

-- breeds

SELECT * FROM breeds;

INSERT INTO
    BREEDS (species_id, NAME)
VALUES (1, 'Labrador'),
    (1, 'Bulldog'),
    (2, 'Persian');

-- pets

SELECT * FROM pets;

INSERT INTO
    PETS (
        SPECIES_ID,
        BREED_ID,
        PROFILE_IMAGE_ID,
        NAME,
        WEIGHT,
        SEX,
        DESCRIPTION
    )
VALUES (
        1,
        1,
        3,
        'Max',
        25.5,
        'Male',
        'Friendly dog'
    ),
    (
        2,
        3,
        3,
        'Michi',
        4.2,
        'Female',
        'Calm cat'
    );

-- owners_pets

SELECT * FROM OWNERS_PETS;

INSERT INTO
    OWNERS_PETS (
        OWNER_ID,
        PET_ID,
        START_DATE,
        IS_PRIMARY
    )
VALUES (1, 1, '2023-01-01', TRUE),
    (2, 2, '2023-02-01', TRUE);

--appointment
SELECT * FROM appointments;

INSERT INTO
    APPOINTMENTS (
        SERVICE_ID,
        STAFF_ID,
        OWNER_PET_ID,
        APPOINTMENT_STATUS_ID,
        START_TIME,
        END_TIME,
        NOTES
    )
VALUES (
        1,
        1,
        1,
        1,
        NOW() - INTERVAL '20 minutes',
        NOW() + INTERVAL '10 minutes',
        'Routine check'
    ),
    (
        4,
        1,
        2,
        2,
        NOW() + INTERVAL '10 minutes',
        NOW() + INTERVAL '15 minutes',
        'Vaccination'
    );

-- medical_records

SELECT * FROM MEDICAL_RECORDS;

INSERT INTO
    MEDICAL_RECORDS (
        APPOINTMENT_ID,
        STAFF_ID,
        DIAGNOSIS,
        TREATMENT,
        NOTES
    )
VALUES (
        1,
        1,
        'Healthy',
        'No treatment',
        'All good'
    ),
    (
        2,
        1,
        'Vaccinated',
        'Rabies vaccine applied',
        'Next in 1 year'
    );

--form_contact_info

INSERT INTO
    FORM_CONTACT_INFO (NAME, EMAIL, PHONE)
VALUES (
        'Pedro Ruiz',
        'pedro@gmail.com',
        '300999999'
    );

SELECT * FROM FORM_CONTACT_INFO;

-- form_messages

SELECT * FROM FORM_messages;

INSERT INTO
    FORM_MESSAGES (
        FORM_MESSAGE_STATUS_ID,
        FORM_CONTACT_INFO_ID,
        CONTENT
    )
VALUES (
        1,
        1,
        'I want to schedule an appointment'
    );