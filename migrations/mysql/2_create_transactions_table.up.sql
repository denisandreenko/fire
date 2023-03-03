CREATE TABLE transactions (
      id BIGINT UNSIGNED AUTO_INCREMENT NOT NULL,
      user_id BIGINT UNSIGNED NOT NULL,
      platform_tx_id BIGINT NOT NULL UNIQUE,
      type VARCHAR(255) NOT NULL,
      amount FLOAT NOT NULL,
      currency ENUM('EUR', 'USD') NOT NULL,
      PRIMARY KEY (id),
      FOREIGN KEY (user_id)
          REFERENCES users(id)
          ON DELETE CASCADE
);