package fire

import (
	"fmt"
	"time"

	"database/sql"
	"net/http"

	"github.com/denisandreenko/fire/internal/app/store/sqlstore"
	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func Start(config *Config) error {
	db, err := newDB(config)
	if err != nil {
		return err
	}

	defer db.Close()
	store := sqlstore.New(db)
	s := newServer(store)

	return http.ListenAndServe(config.Service.BindAddr, s)
}

func newDB(config *Config) (*sql.DB, error) {
	cfgDB := config.Databases

	var db *gorm.DB
	var err error

	switch cfgDB.ActiveDriver {
	case "mysql":
		cfg := cfgDB.Mysql
		dsn := fmt.Sprintf("%v:%v@tcp(%v:%v)/%v?charset=utf8&parseTime=True&loc=Local", cfg.User, cfg.Password, cfg.Host, cfg.Port, cfg.Database)
		db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	case "postgres":
		cfg := cfgDB.Postgres
		dsn := fmt.Sprintf("host=%v user=%v password=%v dbname=%v port=%v sslmode=%v", cfg.Host, cfg.User, cfg.Password, cfg.Database, cfg.Port, cfg.Sslmode)
		db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	}
	if err != nil {
		return nil, err
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// Set up connection pool
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)

	if err = sqlDB.Ping(); err != nil {
		return nil, err
	}

	return sqlDB, nil
}
