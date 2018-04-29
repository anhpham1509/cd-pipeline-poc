package model

import (
	"fmt"

	"github.com/anhpham1509/cd-pipeline-poc/pkg/config"
	"github.com/jinzhu/gorm"

	_ "github.com/jinzhu/gorm/dialects/postgres" // PG dialects
)

// OpenPG opens a new Postgres connection
func OpenPG(conf config.Postgres) (*gorm.DB, error) {
	dbAddress := fmt.Sprintf("host=%s sslmode=%s port=%s user=%s dbname=%s password=%s",
		conf.PGHost, conf.PGSSLMode, conf.PGPort, conf.PGUser, conf.PGDatabase, conf.PGPassword)

	db, err := gorm.Open("postgres", dbAddress)
	if err != nil {
		return nil, err
	}

	db.LogMode(conf.PGLog)

	return db, nil
}

// Close Postgres connection
func Close(db *gorm.DB) error {
	err := db.Close()
	if err != nil {
		return err
	}

	return nil
}
