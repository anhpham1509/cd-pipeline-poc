package server

import (
	"log"
	"net/http"
	"time"
)

const (
	// ReadTimeout for  requests
	ReadTimeout = time.Second * 15
	// WriteTimeout for requests
	WriteTimeout = time.Second * 15
	// MaxHeaderBytes limit for requests
	MaxHeaderBytes = 1 << 20
)

// Start a http server
func Start(handler http.Handler, port, host string) {
	s := &http.Server{
		Addr:           host + ":" + port,
		Handler:        handler,
		ReadTimeout:    ReadTimeout,
		WriteTimeout:   WriteTimeout,
		MaxHeaderBytes: MaxHeaderBytes,
	}

	err := s.ListenAndServe()
	if err != http.ErrServerClosed && err != nil {
		log.Fatalln("Server failed to start", err)
	}
}
