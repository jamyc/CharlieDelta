package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func handle(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Endpoint Hit: CHARLIE")

	resp, err := http.Get("http://delta-service")
	if err != nil {
		log.Fatal(fmt.Sprintf("Fatal error connecting to delta-service. Error: %s", err.Error()))
	}

	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)

	hostname, _ := os.Hostname()
	resultMessage := fmt.Sprintf("I'm %s! Who are you? %s", hostname, string(body))
	fmt.Fprintf(w, resultMessage)
}

func handleRequests() {
	http.HandleFunc("/", handle)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	handleRequests()
}
