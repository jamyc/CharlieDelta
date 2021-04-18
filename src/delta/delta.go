package main

import (
	"fmt"
	"net/http"
	"os"
)

func handle(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint Hit: DELTA")

	hostname, _ := os.Hostname()
	fmt.Fprintf(w, fmt.Sprintf("I'm %s!", hostname))
}

func handleRequests() {
	server := &http.Server{
		Addr:    ":8080",
		Handler: http.HandlerFunc(handle),
	}

	// Disable keep-alives to show k8s service round robin
	server.SetKeepAlivesEnabled(false)
	server.ListenAndServe()
}

func main() {
	handleRequests()
}
