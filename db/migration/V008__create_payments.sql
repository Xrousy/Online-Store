CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    transaction_id VARCHAR(255) UNIQUE,
    status VARCHAR(30) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    paid_at TIMESTAMPTZ,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id),

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0)
);