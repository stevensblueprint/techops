package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"gopkg.in/yaml.v2"
)

type Users struct {
	Users map[string]User `yaml:"users"`
}

type User struct {
	Disabled    bool     `yaml:"disabled"`
	Displayname string   `yaml:"displayname"`
	Password    string   `yaml:"password"`
	Email       string   `yaml:"email"`
	Groups      []string `yaml:"groups"`
}

func main() {
	http.HandleFunc("/add-user", addUserHandler)
	http.Handle("/", http.FileServer(http.Dir("static")))
	log.Fatal(http.ListenAndServe(":3000", nil))
}

func addUserHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	username := r.FormValue("username")
	password := r.FormValue("password")
	displayname := r.FormValue("displayname")
	email := r.FormValue("email")
	groups := strings.Split(r.FormValue("groups"), ",")

	// Read the existing users.yaml file
	usersFile, err := os.Open("users.yaml")
	if err != nil {
		http.Error(w, "Failed to read users.yaml file", http.StatusInternalServerError)
		return
	}
	defer usersFile.Close()

	usersData, err := io.ReadAll(usersFile)
	if err != nil {
		http.Error(w, "Failed to read users.yaml file", http.StatusInternalServerError)
		return
	}

	var users Users
	err = yaml.Unmarshal(usersData, &users)
	if err != nil {
		http.Error(w, "Failed to parse users.yaml file", http.StatusInternalServerError)
		return
	}

	// Check if the username already exists
	if _, exists := users.Users[username]; exists {
		http.Error(w, "Username already exists", http.StatusBadRequest)
		return
	}

	// Create a new user object
	newUser := User{
		Disabled:    false,
		Displayname: displayname,
		Password:    password,
		Email:       email,
		Groups:      groups,
	}

	// Add the new user to the users object
	users.Users[username] = newUser

	// Write the updated users object back to the users.yaml file
	usersFile, err = os.Create("users.yaml")
	if err != nil {
		http.Error(w, "Failed to write users.yaml file", http.StatusInternalServerError)
		return
	}
	defer usersFile.Close()

	usersData, err = yaml.Marshal(&users)
	if err != nil {
		http.Error(w, "Failed to marshal users data", http.StatusInternalServerError)
		return
	}

	_, err = io.WriteString(usersFile, string(usersData))
	if err != nil {
		http.Error(w, "Failed to write users.yaml file", http.StatusInternalServerError)
		return
	}

	fmt.Fprint(w, "User added successfully")
}
