/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id serial PRIMARY KEY,
    name varchar(100) NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts int NOT NULL,
    neutered bool NOT NULL,
    weight_kg decimal NOT NULL
);

ALTER TABLE animals ADD COLUMN species varchar;

CREATE TABLE owners (
  id serial PRIMARY KEY,
  full_name varchar,
  age int
);

CREATE TABLE species (
  id serial PRIMARY KEY,
  name varchar
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id int REFERENCES species(id);
ALTER TABLE animals ADD owner_id int REFERENCES owners(id);

CREATE TABLE vets(
    id SERIAL PRIMARY KEY,
    name varchar,
    age int,
    date_of_graduation date
);

CREATE TABLE specializations (
  vet_id int REFERENCES vets(id),
  species_id int REFERENCES species(id)
);

CREATE TABLE visits (
  animal_id int REFERENCES animals(id),
  date_of_visit date,
  vet_id int REFERENCES vets(id)
);
