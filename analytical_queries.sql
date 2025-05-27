SELECT 
    ai.active_ingredient, COUNT(m.id) AS medicine_count
FROM
    medicines m
        JOIN
    active_ingredients ai ON m.active_ingredient_id = ai.id
GROUP BY ai.active_ingredient
ORDER BY medicine_count DESC;

SELECT 
    mah.marketing_authorization_holder AS holder_name,
    COUNT(m.id) AS total_medicines
FROM
    medicines m
        JOIN
    marketing_authorization_holders mah ON m.marketing_authorization_holder_id = mah.id
GROUP BY mah.marketing_authorization_holder
ORDER BY total_medicines DESC;

SELECT 
    m.medicine_name_and_packaging,
    ai.active_ingredient,
    ac.atc_code
FROM
    medicines m
        JOIN
    active_ingredients ai ON m.active_ingredient_id = ai.id
        JOIN
    atc_codes ac ON m.atc_code_id = ac.id
WHERE
    ac.atc_code = 'N04BC07';

SELECT 
    CASE
        WHEN incompatibilities = 'Not available' THEN 'Missing'
        ELSE 'Provided'
    END AS incompatibility_status,
    COUNT(*) AS count
FROM
    medicines
GROUP BY incompatibility_status;

SELECT 
    CONCAT(SUBSTRING(therapeutic_indications,
                1,
                100),
            '...') AS therapeutic_indications,
    COUNT(*) AS count
FROM
    medicines
GROUP BY therapeutic_indications
ORDER BY count DESC
LIMIT 10;

SELECT 
    COUNT(*) AS count, 'nausea' AS keyword
FROM
    medicines
WHERE
    undesirable_effects_side_effects LIKE '%nausea%' 
UNION ALL SELECT 
    COUNT(*), 'headache'
FROM
    medicines
WHERE
    undesirable_effects_side_effects LIKE '%headache%' 
UNION ALL SELECT 
    COUNT(*), 'rash'
FROM
    medicines
WHERE
    undesirable_effects_side_effects LIKE '%rash%';

SELECT 
    id,
    CHAR_LENGTH(therapeutic_indications) AS length,
    SUBSTRING(therapeutic_indications,
        1,
        200) AS preview
FROM
    medicines
ORDER BY length DESC
LIMIT 10;