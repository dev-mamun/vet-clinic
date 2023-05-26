/*Queries that provide answers to the questions from all projects.*/


SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth > '2015-12-31' and date_of_birth < '2020-01-01';
SELECT * FROM animals WHERE neutered = true and escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' or name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals
SELECT COUNT(*) FROM animals;
ROLLBACK;
SELECT COUNT(*) FROM animals;
COMMIT;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;


SELECT COUNT(*) FROM animals;
SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) as escape_attempts FROM animals GROUP BY neutered ORDER BY MAX(escape_attempts) DESC;
SELECT neutered, MAX(weight_kg) as max_weight , MIN(weight_kg) as min_weight FROM animals GROUP BY neutered;
SELECT species, MAX(weight_kg) as max_weight , MIN(weight_kg) as min_weight FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) as avg_escape_attempts FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) >= '1990' AND  EXTRACT(YEAR FROM date_of_birth) < '2000' GROUP BY species;
SELECT neutered, AVG(escape_attempts) as avg_escape_attempts FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) >= '1990' AND  EXTRACT(YEAR FROM date_of_birth) < '2000' GROUP BY neutered;

SELECT name FROM animals a JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Melody Pond';
SELECT a.name FROM animals a JOIN species s ON a.species_id = s.id WHERE s.name = 'Pokemon';
SELECT o.full_name, a.name  FROM animals a RIGHT JOIN owners o ON a.owner_id = o.id;
SELECT s.name, COUNT(a.name) as no_of_animals FROM animals a   JOIN species s ON a.species_id = s.id GROUP BY(s.name);
SELECT a.name FROM animals a  JOIN owners o ON a.owner_id = o.id  JOIN species s ON a.species_id = s.id WHERE s.name ='Digimon'AND o.full_name = 'Jennifer Orwell';
SELECT a.name FROM animals a   JOIN owners o ON a.owner_id = o.id WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;
SELECT o.full_name, COUNT(a.name) as total_animals FROM animals a  JOIN owners o ON a.owner_id = o.id GROUP BY(o.full_name) ORDER BY(total_animals) DESC;

SELECT a.name,v.date_of_visit FROM animals a
  JOIN visits v ON a.id = v.animal_id
  JOIN vets ve ON v.vet_id = ve.id WHERE ve.name ='William Tatcher' ORDER BY(v.date_of_visit) DESC
  LIMIT 1;

SELECT COUNT(a.name) as animal_visits FROM animals a
  JOIN visits v ON a.id = v.animal_id
  JOIN vets ve ON v.vet_id = ve.id WHERE ve.name ='Stephanie Mendez' GROUP BY(ve.name);

SELECT ve.name, s.name FROM vets ve
 	LEFT JOIN specializations sp ON ve.id = sp.vet_id
	LEFT JOIN species s ON s.id= sp.species_id;

SELECT a.name, v.date_of_visit FROM animals a
  JOIN visits v ON a.id = v.animal_id
  JOIN vets ve ON v.vet_id = ve.id
  WHERE ve.name ='Stephanie Mendez' AND v.date_of_visit >='2020-04-01' AND v.date_of_visit <='2020-08-30';

SELECT a.name, COUNT(*) AS visit_count FROM animals a
  JOIN visits v ON a.id = v.animal_id
  GROUP BY a.id
  ORDER BY visit_count DESC
  LIMIT 1;

SELECT a.name, v.date_of_visit FROM animals a
  JOIN visits v ON a.id = v.animal_id
  JOIN vets ve ON v.vet_id = ve.id
  WHERE ve.name ='Maisy Smith' ORDER BY(date_of_visit)
  LIMIT 1;

  SELECT a.id as animal_id, a.name as animal_name, v.date_of_visit, ve.id as vet_id, ve.name as vet_name FROM animals a
  JOIN visits v ON a.id = v.animal_id
  JOIN vets ve ON v.vet_id = ve.id
  ORDER BY(date_of_visit) DESC
  LIMIT 1;

SELECT COUNT(*) FROM visits v
  JOIN vets vE ON v.vet_id = ve.id
  JOIN animals a ON v.animal_id = a.id
  LEFT JOIN specializations s ON ve.id = s.vet_id AND a.species_id = s.species_id
  WHERE s.species_id IS NULL;

SELECT s.name, COUNT(*) as total_visits FROM vets ve
  JOIN visits v ON ve.id = v.vet_id
  JOIN animals a ON a.id = v.animal_id
  JOIN species s ON a.species_id = s.id WHERE ve.name ='Maisy Smith' GROUP BY(s.id)
  ORDER BY(total_visits) DESC
  LIMIT 1;

  --use of explain analyze
EXPLAIN  SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN  SELECT * FROM visits where vet_id = 2;
EXPLAIN  SELECT * FROM owners where email = 'owner_18327@mail.com';

--Find a way to decrease the execution time of the first query
CREATE INDEX idx_animal_id ON visits (animal_id);
--Configure the query cache size in your MySQL configuration file:
query_cache_size = 128M
--Enable the query cache by setting the following parameter to 1:
query_cache_type = 1
--Add a duplicate animal_id column to the visits table:
ALTER TABLE visits ADD duplicate_animal_id INT;
--Update the duplicate_animal_id column with the corresponding values from the animal_id column:
UPDATE visits SET duplicate_animal_id = animal_id;
--Index the new column for faster retrieval:
CREATE INDEX idx_duplicate_animal_id ON visits (duplicate_animal_id);
--Create a partitioned table for the visits table:
CREATE TABLE visits_partitioned (
    animal_id INT,
    -- Other columns
) PARTITION BY LIST (animal_id);
--Create individual partitions for each animal_id value:
CREATE TABLE visits_p1 PARTITION OF visits_partitioned FOR VALUES IN (1);
CREATE TABLE visits_p2 PARTITION OF visits_partitioned FOR VALUES IN (2);
--Create a materialized view that computes the result of the query:
CREATE MATERIALIZED VIEW visits_count_mv AS SELECT COUNT(*) FROM visits WHERE animal_id = 4;
--Refresh the materialized view periodically to update the result:
REFRESH MATERIALIZED VIEW visits_count_mv;


