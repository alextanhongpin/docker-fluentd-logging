package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("hello world %s\n", time.Now().String())
		fmt.Fprintf(w, "hello world")
	})
	log.Println("listening to port *:8080. press ctrl + c to cancel")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
