CREATE TABLE migrations.users (
    id BIGSERIAL NOT NULL primary key,
    email VARCHAR NOT NULL UNIQUE,
    encrypted_password VARCHAR NOT NULL,
    PRIMARY KEY (id)
);