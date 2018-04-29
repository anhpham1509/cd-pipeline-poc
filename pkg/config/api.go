package config

// API config
type API struct {
	Gin
	Postgres
}

// APIConfig global config
var APIConfig API
