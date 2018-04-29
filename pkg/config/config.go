package config

import (
	"github.com/kelseyhightower/envconfig"
	"github.com/subosito/gotenv"
)

// Init gather configs from environment variables
func Init(fileName string, config interface{}) error {
	_ = gotenv.OverLoad(fileName)
	return envconfig.Process("", config)
}

// Postgres config
type Postgres struct {
	PGHost     string `envconfig:"PG_HOST" default:"localhost"`
	PGPort     string `envconfig:"PG_PORT" default:"5432"`
	PGUser     string `envconfig:"PG_USER" default:"root"`
	PGPassword string `envconfig:"PG_PASSWORD" default:"root"`
	PGDatabase string `envconfig:"PG_DATABASE" default:"we_leap"`
	PGSSLMode  string `envconfig:"PG_SSL_MODE" default:"disable"`
	PGLog      bool   `envconfig:"PG_LOG" default:"false"`
}

// Gin config
type Gin struct {
	Host string `envconfig:"HOST"`
	Port string `envconfig:"PORT" default:"3000"`
}
