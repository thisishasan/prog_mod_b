-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS medicine_data;

-- Select the database
USE medicine_data;

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS medicines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    active_ingredient LONGTEXT,
    group_description LONGTEXT,
    medicine_name_and_packaging LONGTEXT,
    marketing_authorization_holder LONGTEXT,
    aic_code BIGINT,
    equivalence_group_code VARCHAR(20),
    atc VARCHAR(50),
    leaflet_url LONGTEXT,
    pdf_url LONGTEXT,
    therapeutic_indications LONGTEXT,
    posology_and_method_of_administration LONGTEXT,
    contraindications LONGTEXT,
    special_warnings_and_precautions_for_use LONGTEXT,
    interactions_with_other_medicinal_products LONGTEXT,
    fertility_pregnancy_and_lactation LONGTEXT,
    effects_on_ability_to_drive_and_use_machines LONGTEXT,
    undesirable_effects_side_effects LONGTEXT,
    overdose LONGTEXT,
    incompatibilities LONGTEXT
);

-- SHOW VARIABLES LIKE 'secure_file_priv';
-- sudo cp /home/hasapmuh/Documents/programming_course_project/prog_mod_b/updated_data.csv /var/lib/mysql-files/

LOAD DATA INFILE '/var/lib/mysql-files/updated_data.csv'
INTO TABLE medicines
CHARACTER SET utf8
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  active_ingredient,
  group_description,
  medicine_name_and_packaging,
  marketing_authorization_holder,
  aic_code,
  equivalence_group_code,
  atc,
  leaflet_url,
  pdf_url,
  therapeutic_indications,
  posology_and_method_of_administration,
  contraindications,
  special_warnings_and_precautions_for_use,
  interactions_with_other_medicinal_products,
  fertility_pregnancy_and_lactation,
  effects_on_ability_to_drive_and_use_machines,
  undesirable_effects_side_effects,
  overdose,
  incompatibilities
);

CREATE TABLE IF NOT EXISTS active_ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    active_ingredient VARCHAR(50) UNIQUE
);

INSERT INTO active_ingredients (active_ingredient)
SELECT distinct medicines.active_ingredient FROM medicines
ON DUPLICATE KEY UPDATE
active_ingredient = VALUES(active_ingredient);

CREATE TABLE IF NOT EXISTS atc_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atc_code VARCHAR(20) UNIQUE
);

INSERT INTO atc_codes (atc_code)
SELECT distinct medicines.atc FROM medicines
ON DUPLICATE KEY UPDATE
atc_code = VALUES(atc_code);

CREATE TABLE IF NOT EXISTS equivalence_group_codes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    equivalence_group_code VARCHAR(5) UNIQUE
);

INSERT INTO equivalence_group_codes (equivalence_group_code)
SELECT distinct medicines.equivalence_group_code FROM medicines
ON DUPLICATE KEY UPDATE
equivalence_group_code = VALUES(equivalence_group_code);

CREATE TABLE IF NOT EXISTS marketing_authorization_holders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marketing_authorization_holder VARCHAR(50) UNIQUE
);

INSERT INTO marketing_authorization_holders (marketing_authorization_holder)
SELECT distinct medicines.marketing_authorization_holder FROM medicines
ON DUPLICATE KEY UPDATE
marketing_authorization_holder = VALUES(marketing_authorization_holder);

ALTER TABLE medicines ADD COLUMN active_ingredient_id INT AFTER active_ingredient;
ALTER TABLE medicines ADD COLUMN atc_code_id INT AFTER atc;
ALTER TABLE medicines ADD COLUMN equivalence_group_code_id INT AFTER equivalence_group_code;
ALTER TABLE medicines ADD COLUMN marketing_authorization_holder_id INT AFTER marketing_authorization_holder;

SET SQL_SAFE_UPDATES = 0;

UPDATE medicines m
JOIN active_ingredients ai ON m.active_ingredient = ai.active_ingredient 
SET m.active_ingredient_id = ai.id;

UPDATE medicines m
JOIN atc_codes ai ON m.atc = ai.atc_code 
SET m.atc_code_id = ai.id;

UPDATE medicines m
JOIN equivalence_group_codes ai ON m.equivalence_group_code = ai.equivalence_group_code 
SET m.equivalence_group_code_id = ai.id;

UPDATE medicines m
JOIN marketing_authorization_holders ai ON m.marketing_authorization_holder = ai.marketing_authorization_holder 
SET m.marketing_authorization_holder_id = ai.id;

ALTER TABLE medicines
DROP COLUMN active_ingredient,
DROP COLUMN atc,
DROP COLUMN equivalence_group_code,
DROP COLUMN marketing_authorization_holder;

DESC medicines;

ALTER TABLE medicines
ADD CONSTRAINT fk_active_ingredient FOREIGN KEY (active_ingredient_id) REFERENCES active_ingredients(id),
ADD CONSTRAINT fk_atc_code FOREIGN KEY (atc_code_id) REFERENCES atc_codes(id),
ADD CONSTRAINT fk_equivalence_group_code FOREIGN KEY (equivalence_group_code_id) REFERENCES equivalence_group_codes(id),
ADD CONSTRAINT fk_marketing_authorization_holder FOREIGN KEY (marketing_authorization_holder_id) REFERENCES marketing_authorization_holders(id);
