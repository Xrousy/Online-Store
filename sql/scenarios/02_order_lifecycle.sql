-- ============================================================
-- 02_order_lifecycle.sql
-- Жизненный цикл заказа
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- Этап 1. Создание нового заказа
-- ------------------------------------------------------------

INSERT INTO orders (
    user_id,
    promocode_id,
    created_at,
    status,
    total_amount,
    discount_amount
)
VALUES (
    (
        SELECT id
        FROM users
        WHERE email = 'ivan.petrov@example.com'
    ),

    NULL,

    NOW(),

    'Создан',

    8990.00,

    0.00
);


-- ------------------------------------------------------------
-- Сохраняем ID созданного заказа
-- ------------------------------------------------------------

CREATE TEMP TABLE tmp_lifecycle_order AS
SELECT id
FROM orders
WHERE user_id = (
    SELECT id
    FROM users
    WHERE email = 'ivan.petrov@example.com'
)
ORDER BY id DESC
LIMIT 1;


-- ------------------------------------------------------------
-- Этап 2. Добавление товара в заказ
-- ------------------------------------------------------------

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
SELECT
    o.id,
    p.id,
    1,
    p.price
FROM tmp_lifecycle_order o
CROSS JOIN products p
WHERE p.sku = 'LOG-MX-MASTER-3S'
  AND p.stock_quantity >= 1
  AND p.is_deleted = FALSE;


-- ------------------------------------------------------------
-- Этап 3. Уменьшение доступного остатка
-- ------------------------------------------------------------

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE sku = 'LOG-MX-MASTER-3S'
  AND stock_quantity >= 1
  AND is_deleted = FALSE;


-- ------------------------------------------------------------
-- Этап 4. Успешная онлайн-оплата
-- ------------------------------------------------------------

INSERT INTO payments (
    order_id,
    transaction_id,
    status,
    amount,
    paid_at
)
SELECT
    id,
    'TXN-LIFECYCLE-' || id,
    'Успешно',
    8990.00,
    NOW()
FROM tmp_lifecycle_order;


-- ------------------------------------------------------------
-- После успешной оплаты заказ получает статус "Оплачен"
-- ------------------------------------------------------------

UPDATE orders
SET status = 'Оплачен'
WHERE id IN (
    SELECT id
    FROM tmp_lifecycle_order
);


-- ------------------------------------------------------------
-- Этап 5. Передача заказа в доставку
-- ------------------------------------------------------------

INSERT INTO deliveries (
    order_id,
    tracking_number,
    status,
    address,
    cost
)
SELECT
    id,
    'TEST-TRACK-' || id,
    'Передан перевозчику',
    'г. Новосибирск, ул. Ленина, д. 10, кв. 25',
    0.00
FROM tmp_lifecycle_order;


UPDATE orders
SET status = 'Передан в доставку'
WHERE id IN (
    SELECT id
    FROM tmp_lifecycle_order
);


-- ------------------------------------------------------------
-- Этап 6. Проверка полного жизненного цикла заказа
-- ------------------------------------------------------------

SELECT
    o.id AS order_id,
    u.full_name AS customer,
    o.status AS order_status,
    o.total_amount,
    p.status AS payment_status,
    d.status AS delivery_status,
    d.tracking_number
FROM orders o
JOIN users u
    ON u.id = o.user_id
LEFT JOIN payments p
    ON p.order_id = o.id
LEFT JOIN deliveries d
    ON d.order_id = o.id
WHERE o.id IN (
    SELECT id
    FROM tmp_lifecycle_order
);


DROP TABLE tmp_lifecycle_order;

COMMIT;