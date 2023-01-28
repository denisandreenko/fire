package repository

// Config ...
type Config struct {
	Host     string `yaml:"host"`
	Port     int    `yaml:"port"`
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	Driver   string `yaml:"driver"`
	Database string `yaml:"database"`
	Sslmode  string `yaml:"sslmode"`
}
