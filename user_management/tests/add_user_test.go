package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"strings"
	"testing"

	"user_management/handlers"
)

func TestAddUserHandler(t *testing.T) {
	// Create a temporary users.yaml file for testing
	tempFile, err := os.CreateTemp("", "users.yaml")
	if err != nil {
		t.Fatalf("Failed to create temporary file: %v", err)
	}
	defer tempFile.Close()

	// Write initial data to the temporary file
	initialData := `
users:
  existinguser:
    disabled: false
    displayname: Existing User
    password: existingpassword
    email: existinguser@example.com
    groups:
      - group1
`
	err = os.WriteFile(tempFile.Name(), []byte(initialData), 0644)
	if err != nil {
		t.Fatalf("Failed to write initial data to temporary file: %v", err)
	}

	// Create a test request with the required parameters
	formData := strings.NewReader("username=newuser&password=newpassword&displayname=New+User&email=newuser@example.com&groups=group2")
	req := httptest.NewRequest(http.MethodPost, "/add-user", formData)
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	// Create a response recorder to capture the response
	res := httptest.NewRecorder()

	// Call the addUserHandler function with the test request and response recorder
	handlers.AddUserHandler(res, req)

	// Check the response status code
	if res.Code != http.StatusOK {
		t.Errorf("Expected status code %d, but got %d", http.StatusOK, res.Code)
	}

	// Read the updated users.yaml file
	usersData, err := os.ReadFile(tempFile.Name())
	if err != nil {
		t.Fatalf("Failed to read users.yaml file: %v", err)
	}

	// Assert that the new user is added to the users.yaml file
	expectedData := `
users:
  existinguser:
    disabled: false
    displayname: Existing User
    password: existingpassword
    email: existinguser@example.com
    groups:
    - group1
  newuser:
    disabled: false
    displayname: New User
    password: newpassword
    email: newuser@example.com
    groups:
    - group2
`
	if string(usersData) != expectedData {
		t.Errorf("Expected users.yaml data:\n%s\n\nBut got:\n%s", expectedData, string(usersData))
	}
}
