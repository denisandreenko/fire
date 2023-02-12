CREATE TYPE currency AS ENUM ('EUR', 'USD');

CREATE TABLE migrations.transactions (
      id BIGSERIAL NOT NULL,
      user_id BIGSERIAL NOT NULL,
      platform_tx_id BIGINT NOT NULL UNIQUE,
      type VARCHAR NOT NULL,
      amount FLOAT4 NOT NULL,
      currency currency NOT NULL,
      PRIMARY KEY (id),
      FOREIGN KEY (user_id)
          REFERENCES migrations.users(id)
          ON DELETE CASCADE
);