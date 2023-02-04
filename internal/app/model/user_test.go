package model

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

var testUser = &User{
	Email:    "user@example.org",
	Password: "password",
}

func TestValidate(t *testing.T) {
	testCases := []struct {
		name    string
		u       func() *User
		isValid bool
	}{
		{
			name: "valid",
			u: func() *User {
				return testUser
			},
			isValid: true,
		},
		{
			name: "with encrypted password",
			u: func() *User {
				u := testUser
				u.EncryptedPassword = "encryptedpassword"
				return u
			},
			isValid: true,
		},
		{
			name: "empty email",
			u: func() *User {
				u := testUser
				u.Email = ""
				return u
			},
			isValid: false,
		},
		{
			name: "invalid email",
			u: func() *User {
				u := testUser
				u.Email = "invalid"
				return u
			},
			isValid: false,
		},
		{
			name: "empty password",
			u: func() *User {
				u := testUser
				u.Password = ""
				return u
			},
			isValid: false,
		},
		{
			name: "short password",
			u: func() *User {
				u := testUser
				u.Password = "1"
				return u
			},
			isValid: false,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			if tc.isValid {
				assert.NoError(t, tc.u().Validate())
			} else {
				assert.Error(t, tc.u().Validate())
			}
		})
	}
}

func TestBeforeCreate(t *testing.T) {
	assert.NoError(t, testUser.BeforeCreate())
	assert.NotEmpty(t, testUser.EncryptedPassword)
}
