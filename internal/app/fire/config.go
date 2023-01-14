package fire

// Config ...
type Config struct {
	Service struct {
		Name     string `yaml:"name"`
		BindAddr string `yaml:"bind_addr"`
	} `yaml:"service"`
	Database struct {
		Postgres struct {
			Host     string `yaml:"host"`
			Port     int    `yaml:"port"`
			Driver   string `yaml:"driver"`
			Database string `yaml:"database"`
		} `yaml:"postgres"`
	} `yaml:"database"`
	Logging struct {
		Level  string `yaml:"level"`
		Stdout bool   `yaml:"stdout"`
	} `yaml:"logging"`
}