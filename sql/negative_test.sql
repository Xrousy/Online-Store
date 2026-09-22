-- Негативные примеры проверки ограничений целостности
-- Каждый блок должен завершаться ошибкой PostgreSQL.

-- =========================================================
-- 1. UNIQUE: повторение кода роли
-- =========================================================

INSERT INTO roles (code_name)
VALUES ('CUSTOMER');


-- =========================================================
-- 2. UNIQUE: повторение email пользователя
-- =========================================================

INSERT INTO users (
    role_id,
    email,
    password_hash,
    full_name,
    phone
)
VALUES (
    (SELECT id FROM roles WHERE code_name = 'CUSTOMER'),
    'ivan.petrov@example.com',
    'test_hash',
    'Тестовый пользователь',
    '+79990000000'
);


-- =========================================================
-- 3. UNIQUE: повторение SKU товара
-- =========================================================

INSERT INTO products (
    category_id,
    sku,
    title,
    description,
    price,
    stock_quantity,
    is_deleted
)
VALUES (
    (SELECT id FROM categories WHERE name = 'Электроника' LIMIT 1),
    'IPHONE-15-001',
    'Тестовый товар',
    'Проверка ограничения UNIQUE для SKU',
    1000.00,
    10,
    FALSE
);


-- =========================================================
-- 4. CHECK: отрицательная цена товара
-- =========================================================

INSERT INTO products (
    category_id,
    sku,
    title,
    description,
    price,
    stock_quantity,
    is_deleted
)
VALUES (
    (SELECT id FROM categories WHERE name = 'Электроника' LIMIT 1),
    'TEST-NEGATIVE-PRICE-001',
    'Товар с отрицательной ценой',
    'Негативный тест',
    -100.00,
    10,
    FALSE
);


-- =========================================================
-- 5. CHECK: отрицательный остаток товара
-- =========================================================

INSERT INTO products (
    category_id,
    sku,
    title,
    description,
    price,
    stock_quantity,
    is_deleted
)
VALUES (
    (SELECT id FROM categories WHERE name = 'Электроника' LIMIT 1),
    'TEST-NEGATIVE-STOCK-001',
    'Товар с отрицательным остатком',
    'Негативный тест',
    1000.00,
    -5,
    FALSE
);


-- =========================================================
-- 6. CHECK: количество товара в заказе должно быть > 0
-- =========================================================

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
VALUES (
    (SELECT id FROM orders ORDER BY id LIMIT 1),
    (SELECT id FROM products WHERE is_deleted = FALSE ORDER BY id LIMIT 1),
    0,
    1000.00
);


-- =========================================================
-- 7. FOREIGN KEY: ссылка на несуществующего пользователя
-- =========================================================

INSERT INTO orders (
    user_id,
    promocode_id,
    created_at,
    status,
    total_amount,
    discount_amount
)
VALUES (
    999999,
    NULL,
    CURRENT_TIMESTAMP,
    'Новый',
    1000.00,
    0.00
);