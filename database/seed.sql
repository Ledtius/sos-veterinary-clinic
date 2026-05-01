INSERT INTO
	DOCUMENT_TYPE (NAME)
VALUES
	('CC'),
	('Passport');

INSERT INTO
	ROLES (NAME)
VALUES
	('Admin'),
	('Veterinarian'),
	('Receptionist');

INSERT INTO
	AUTH_USERS (EMAIL, PASSWORD_HASH)
VALUES
	('admin@sosvet.com', 'hash1'),
	('vet1@sosvet.com', 'hash2'),
	('vet2@sosvet.com', 'hash3'),
	('reception@sosvet.com', 'hash4');

INSERT INTO
	SPECIES (NAME)
VALUES
	('Dog'),
	('Cat');

INSERT INTO
	CATEGORIES (NAME)
VALUES
	('General Consultation'),
	('Surgery'),
	('Vaccination');

SELECT
	*
FROM
	CATEGORIES;

INSERT INTO
	SERVICES (CATEGORY_ID, NAME)
VALUES
	(1, 'Basic Checkup'),
	(1, 'Emergency Consultation'),
	(2, 'Sterilization'),
	(3, 'Rabies Vaccine');

INSERT INTO
	APPOINTMENT_STATUS (NAME)
VALUES
	('Pending'),
	('In Process'),
	('Completed');

INSERT INTO
	FORM_MESSAGE_STATUS (NAME)
VALUES
	('Unread'),
	('Viewed'),
	('Responded');

INSERT INTO
	PROFILE_IMAGES (URL, TYPE, IS_DEFAULT)
VALUES
	('default_staff.png', 'Staff', TRUE),
	('default_owner.png', 'Owner', TRUE),
	('default_pet.png', 'Pet', TRUE);

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
VALUES
	(
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
		'Ana',
		'Torres',
		'1122334455',
		'1988-04-12',
		'Female',
		'3002223344',
		'Street 3'
	),
	(
		1,
		'Luis',
		'Ramirez',
		'9988776655',
		'1995-11-30',
		'Male',
		'3005556677',
		'Street 4'
	);

INSERT INTO
	OWNERS (PERSONAL_DATA_ID, PROFILE_IMAGE_ID)
VALUES
	(1, 2),
	(2, 2);

INSERT INTO
	STAFF (
		PERSONAL_DATA_ID,
		ROLE_ID,
		AUTH_USER_ID,
		PROFILE_IMAGE_ID
	)
VALUES
	(3, 2, 2, 1), -- Ana vet
	(4, 3, 4, 1);

-- Luis receptionist
INSERT INTO
	BREEDS (SPECIES_ID, NAME)
VALUES
	(1, 'Labrador'),
	(1, 'Bulldog'),
	(2, 'Persian');

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
VALUES
	(1, 1, 3, 'Max', 25.5, 'Male', 'Friendly dog'),
	(1, 2, 3, 'Rocky', 18.3, 'Male', 'Energetic'),
	(2, 3, 3, 'Luna', 3.8, 'Female', 'Calm'),
	(2, 3, 3, 'Simba', 4.5, 'Male', 'Playful');

INSERT INTO
	OWNERS_PETS (OWNER_ID, PET_ID, START_DATE, IS_PRIMARY)
VALUES
	(1, 1, '2023-01-01', TRUE),
	(1, 2, '2023-02-01', TRUE),
	(2, 3, '2023-03-01', TRUE),
	(2, 4, '2023-04-01', FALSE),
	(2, 1, '2023-05-01', FALSE);

SELECT
	*
FROM
	APPOINTMENTS;

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
VALUES
	(
		1,
		1,
		1,
		1,
		NOW() + INTERVAL '1 day',
		NOW() + INTERVAL '1 day' + INTERVAL '30 minutes',
		'Checkup'
	),
	(
		2,
		1,
		2,
		2,
		NOW(),
		NOW() + INTERVAL '30 minutes',
		'Emergency'
	),
	(
		3,
		1,
		3,
		3,
		NOW() - INTERVAL '7 days',
		NOW() - INTERVAL '7 days' + INTERVAL '1 hour',
		'Surgery'
	),
	(
		4,
		1,
		4,
		3,
		NOW() - INTERVAL '1 day',
		NOW() - INTERVAL '1 day' + INTERVAL '30 minutes',
		'Vaccine'
	);

INSERT INTO
	MEDICAL_RECORDS (
		APPOINTMENT_ID,
		STAFF_ID,
		DIAGNOSIS,
		TREATMENT,
		NOTES
	)
VALUES
	(3, 1, 'Recovered', 'Post-op care', 'Stable'),
	(4, 1, 'Vaccinated', 'Rabies applied', 'OK');

INSERT INTO
	FORM_CONTACT_INFO (NAME, EMAIL, PHONE)
VALUES
	('Laura Diaz', 'laura@gmail.com', '3008881111'),
	('Andres Ruiz', 'andres@gmail.com', '3007772222');

INSERT INTO
	FORM_MESSAGES (
		FORM_MESSAGE_STATUS_ID,
		FORM_CONTACT_INFO_ID,
		CONTENT
	)
VALUES
	(1, 1, 'Do you offer emergency services?'),
	(2, 2, 'Price for vaccination?');


TRUNCATE TABLE
    medical_record_files,
    medical_records,
    appointments,
    notifications_staff,
    owners_pets,
    pets,
    staff,
    owners,
    form_messages,
    form_contact_info,
    services,
    categories,
    breeds,
    species,
    auth_users,
    roles,
    personal_data,
    document_type,
    appointment_status,
    form_message_status,
    profile_images
RESTART IDENTITY CASCADE;

