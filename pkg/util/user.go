package util

import "github.com/anhpham1509/cd-pipeline-poc/pkg/model"

// IsAdminUser check if given user is admin or not
func IsAdminUser(user *model.User, isDevEnv bool) bool {
	if isDevEnv {
		return true
	}
	return user.IsAdmin
}
