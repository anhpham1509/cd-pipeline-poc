package main

import (
	"log"
	"net/http"

	"github.com/anhpham1509/cd-pipeline-poc/pkg/config"
	"github.com/anhpham1509/cd-pipeline-poc/pkg/model"
	"github.com/anhpham1509/cd-pipeline-poc/pkg/route"
	"github.com/anhpham1509/cd-pipeline-poc/pkg/server"
	"github.com/gin-gonic/gin"
)

func main() {
	err := config.Init(".env", &config.APIConfig)
	if err != nil {
		         log.Fatalln("Couldn't set config from env variables:", err)
	}

	db, err := model.OpenPG(config.APIConfig.Postgres)
	if err != nil {
		log.Fatalln("Couldn't create Postgres connection:", err)
	}
	defer model.Close(db)

	app := gin.New()
	app.Use(gin.Logger())
	app.Use(gin.Recovery())

	api := app.Group("/api")

	user := api.Group("/user")
	user.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, "Welcome")
	})

	app.NoRoute(route.NotFound)

	server.Start(app, config.APIConfig.Port, config.APIConfig.Host)
}
