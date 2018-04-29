package util

import (
	"testing"

	"github.com/anhpham1509/cd-pipeline-poc/pkg/model"
	"github.com/stretchr/testify/assert"
)

func TestIsAdminUser(t *testing.T) {
	assert := assert.New(t)

	user := model.User{
		FirstName: "Hello",
		LastName:  "World",
		IsAdmin:   false,
	}

	isAdmin := IsAdminUser(&user, true)
	assert.True(isAdmin)
}
