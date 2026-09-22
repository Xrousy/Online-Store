CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    price_at_purchase NUMERIC(12,2) NOT NULL,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(id),

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_price
        CHECK (price_at_purchase >= 0)
);