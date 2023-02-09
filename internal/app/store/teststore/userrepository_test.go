package teststore

import (
	"testing"

	"github.com/denisandreenko/fire/internal/app/model"
	"github.com/denisandreenko/fire/internal/app/store"
	"github.com/stretchr/testify/assert"
)

func TestCreate(t *testing.T) {
	s := New()
	u := &model.User{
		Email:    "test@mail.com",
		Password: "password",
	}
	assert.NoError(t, s.User().Create(u))
	assert.NotNil(t, u)
}

func TestFindByEmail(t *testing.T) {
	s := New()
	email := "user@example.org"
	_, err := s.User().FindByEmail(email)
	assert.EqualError(t, err, store.ErrRecordNotFound.Error())

	u := &model.User{
		Email:    email,
		Password: "password",
	}
	s.User().Create(u)
	u, err = s.User().FindByEmail(email)
	assert.NoError(t, err)
	assert.NotNil(t, u)
}
