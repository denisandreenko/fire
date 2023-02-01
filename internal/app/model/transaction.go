package model

// Transaction ...
type Transaction struct {
	ID     int
	Date   string
	Type   string
	Amount float64
	LoanID string
}
