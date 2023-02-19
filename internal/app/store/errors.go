package store

import "errors"

var (
	// ErrRecordNotFound ...
	ErrRecordNotFound = errors.New("record not found")
	// ErrIncorrectEmailOrPassword ...
	ErrIncorrectEmailOrPassword = errors.New("incorrect email or password")
	// ErrNotAuthenticated ...
	ErrNotAuthenticated = errors.New("not authenticated")
)
