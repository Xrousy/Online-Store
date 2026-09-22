CREATE TABLE deliveries (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    tracking_number VARCHAR(255),
    status VARCHAR(30) NOT NULL,
    address TEXT NOT NULL,
    cost NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_deliveries_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id),

    CONSTRAINT chk_deliveries_cost
        CHECK (cost >= 0)
);