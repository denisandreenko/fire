package main

import (
	"fmt"
	"log"
	"os"

	"gopkg.in/yaml.v3"

	"github.com/denisandreenko/fire/internal/app/fire"
)

func main() {
	config := &fire.Config{}

	appRoot := os.Getenv("APP_ROOT")
	fireEnv := os.Getenv("FIRE_ENV")
	configPath := fmt.Sprintf("%s/configs/%s.yaml", appRoot, fireEnv)

	configFile, err := os.ReadFile(configPath)
	if err != nil {
		log.Fatal(err)
	}

	err = yaml.Unmarshal(configFile, &config)
	if err != nil {
		log.Fatal(err)
	}

	if err := fire.Start(config); err != nil {
		log.Fatal(err)
	}
}
