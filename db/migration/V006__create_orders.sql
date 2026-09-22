CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    promocode_id BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    status VARCHAR(30) NOT NULL,
    total_amount NUMERIC(12,2) NOT NULL,
    discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_orders_promocode
        FOREIGN KEY (promocode_id)
        REFERENCES promocodes(id),

    CONSTRAINT chk_orders_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_orders_discount
        CHECK (discount_amount >= 0)
);