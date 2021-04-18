package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

func home(w http.ResponseWriter, r *http.Request) {
	resp, err := http.Get("http://delta-service")
	if err != nil {
		log.Fatal(fmt.Sprintf("Fatal error connecting to delta-service. Error: %s", err.Error()))
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	resultMessage := fmt.Sprintf("I'm Charlie, who are you? %s", string(body))

	fmt.Fprintf(w, resultMessage)
	fmt.Println("Endpoint Hit: CHARLIE")
}

func handleRequests() {
	http.HandleFunc("/", home)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	handleRequests()
}
