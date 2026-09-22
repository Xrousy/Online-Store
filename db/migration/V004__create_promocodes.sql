CREATE TABLE promocodes (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_percent NUMERIC(5,2) NOT NULL,
    valid_until TIMESTAMPTZ NOT NULL,

    CONSTRAINT chk_promocodes_discount
        CHECK (discount_percent > 0
               AND discount_percent <= 50)
);