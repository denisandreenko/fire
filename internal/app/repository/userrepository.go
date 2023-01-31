package repository

import (
	"github.com/denisandreenko/fire/internal/app/model"
)

// UserRepository ...
type UserRepository struct {
	repository *Repository
}

// Create ...
func (r *UserRepository) Create(u *model.User) (*model.User, error) {
	// TODO: add query db abstraction
	if err := r.repository.db.QueryRow(
		"INSERT INTO users (email, encrypted_password) VALUES ($1, $2) RETURNING idcreate table users(email int,	encrypted_password int,	id int);",
		u.Email,
		u.EncryptedPassword,
	).Scan(&u.ID); err != nil {
		return nil, err
	}

	return u, nil
}

// FindByEmail ...
func (r *UserRepository) FindByEmail(email string) (*model.User, error) {
	u := &model.User{}
	// TODO: add query db abstraction
	if err := r.repository.db.QueryRow(
		"SELECT id, email, encrypted_password FROM users WHERE email = $1",
		email,
	).Scan(
		&u.ID,
		&u.Email,
		&u.EncryptedPassword,
	); err != nil {
		return nil, err
	}

	return u, nil
}
