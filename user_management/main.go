package main

import (
	"log"
	"net/http"

	"user_management/handlers"
)

func main() {
	// Set up the routes
	http.HandleFunc("/add-user", handlers.AddUserHandler)
	http.Handle("/", http.FileServer(http.Dir("static")))

	// Start the HTTP server
	log.Fatal(http.ListenAndServe(":3000", nil))
}
