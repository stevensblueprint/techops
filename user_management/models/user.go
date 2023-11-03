package models

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
