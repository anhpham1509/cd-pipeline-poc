package config

// Cms config
type Cms struct {
	Gin
	Postgres
}

// CmsConfig global config
var CmsConfig Cms
