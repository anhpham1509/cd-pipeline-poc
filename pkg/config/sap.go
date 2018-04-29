package config

// Sap config
type Sap struct {
	Gin
	Postgres
}

// SapConfig global config
var SapConfig Sap
