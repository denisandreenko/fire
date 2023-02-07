package fire

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestAPIServer_HandleHello(t *testing.T) {
	testConfig := &Config{}
	testConfig.Service.BindAddr = ":8080"

	s := New(testConfig)
	rec := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/ishealthy", nil)
	s.handleIsHealthy().ServeHTTP(rec, req)
	assert.Equal(t, rec.Body.String(), "healthy")
}
