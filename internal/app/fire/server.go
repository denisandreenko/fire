package fire

import (
	"io"
	"net/http"

	"github.com/denisandreenko/fire/internal/app/repository"
	"github.com/gorilla/mux"
	"github.com/sirupsen/logrus"
)

// Server ...
type Server struct {
	config     *Config
	logger     *logrus.Logger
	router     *mux.Router
	repository *repository.Repository
}

func New(config *Config) *Server {
	return &Server{
		config: config,
		logger: logrus.New(),
		router: mux.NewRouter(),
	}
}

// Start ...
func (s *Server) Start() error {
	if err := s.configureLogger(); err != nil {
		return err
	}

	s.configureRouter()

	if err := s.configureRepository(); err != nil {
		return err
	}

	s.logger.Info("starting server")

	return http.ListenAndServe(s.config.Service.BindAddr, s.router)
}

func (s *Server) configureLogger() error {
	level, err := logrus.ParseLevel(s.config.Logging.Level)
	if err != nil {
		return err
	}

	s.logger.SetLevel(level)

	return nil
}

func (s *Server) configureRouter() {
	s.router.HandleFunc("/ishealthy", s.handleIsHealthy())
}

func (s *Server) configureRepository() error {
	repo := repository.New(s.config.Repository)
	if err := repo.Open(); err != nil {
		return err
	}

	s.repository = repo

	return nil
}

func (s *Server) handleIsHealthy() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "healthy")
	}
}
