-- ============================================================
-- V011__insert_test_data.sql
-- Тестовые данные для интернет-магазина
-- ============================================================

-- ============================================================
-- 1. ROLES
-- ============================================================

INSERT INTO roles (code_name)
VALUES
    ('CUSTOMER'),
    ('CONTENT_MANAGER'),
    ('ORDER_OPERATOR'),
    ('ADMIN');


-- ============================================================
-- 2. USERS
-- ============================================================

INSERT INTO users (
    role_id,
    email,
    password_hash,
    full_name,
    phone
)
VALUES
    (
        (SELECT id FROM roles WHERE code_name = 'CUSTOMER'),
        'ivan.petrov@example.com',
        '$2b$12$test_hash_ivan',
        'Иван Петров',
        '+79990000001'
    ),
    (
        (SELECT id FROM roles WHERE code_name = 'CUSTOMER'),
        'anna.sidorova@example.com',
        '$2b$12$test_hash_anna',
        'Анна Сидорова',
        '+79990000002'
    ),
    (
        (SELECT id FROM roles WHERE code_name = 'CONTENT_MANAGER'),
        'content.manager@example.com',
        '$2b$12$test_hash_content',
        'Мария Смирнова',
        '+79990000003'
    ),
    (
        (SELECT id FROM roles WHERE code_name = 'ORDER_OPERATOR'),
        'order.operator@example.com',
        '$2b$12$test_hash_operator',
        'Алексей Иванов',
        '+79990000004'
    ),
    (
        (SELECT id FROM roles WHERE code_name = 'ADMIN'),
        'admin@example.com',
        '$2b$12$test_hash_admin',
        'Дмитрий Кузнецов',
        '+79990000005'
    );


-- ============================================================
-- 3. CATEGORIES
-- ============================================================

INSERT INTO categories (name, parent_id)
VALUES
    ('Электроника', NULL),
    ('Смартфоны', (SELECT id FROM categories WHERE name = 'Электроника')),
    ('Ноутбуки', (SELECT id FROM categories WHERE name = 'Электроника')),
    ('Аксессуары', (SELECT id FROM categories WHERE name = 'Электроника'));


-- ============================================================
-- 4. PRODUCTS
-- ============================================================

INSERT INTO products (
    category_id,
    sku,
    title,
    description,
    price,
    stock_quantity,
    is_deleted
)
VALUES
    (
        (SELECT id FROM categories WHERE name = 'Смартфоны'),
        'SM-GALAXY-A55',
        'Samsung Galaxy A55',
        'Смартфон с экраном 6.6 дюйма и 128 ГБ памяти',
        39990.00,
        15,
        FALSE
    ),
    (
        (SELECT id FROM categories WHERE name = 'Смартфоны'),
        'IPHONE-15-128',
        'Apple iPhone 15',
        'Смартфон Apple iPhone 15 с памятью 128 ГБ',
        79990.00,
        10,
        FALSE
    ),
    (
        (SELECT id FROM categories WHERE name = 'Ноутбуки'),
        'ASUS-VIVOBOOK-15',
        'ASUS VivoBook 15',
        'Ноутбук с экраном 15.6 дюйма',
        64990.00,
        7,
        FALSE
    ),
    (
        (SELECT id FROM categories WHERE name = 'Аксессуары'),
        'LOG-MX-MASTER-3S',
        'Logitech MX Master 3S',
        'Беспроводная компьютерная мышь',
        8990.00,
        20,
        FALSE
    ),
    (
        (SELECT id FROM categories WHERE name = 'Аксессуары'),
        'USB-C-CABLE-2M',
        'USB-C кабель 2 м',
        'Кабель USB Type-C длиной 2 метра',
        1290.00,
        50,
        FALSE
    );


-- ============================================================
-- 5. PROMOCODES
-- ============================================================

INSERT INTO promocodes (
    code,
    discount_percent,
    valid_until
)
VALUES
    (
        'WELCOME10',
        10.00,
        '2027-12-31 23:59:59+03'
    ),
    (
        'SALE15',
        15.00,
        '2027-06-30 23:59:59+03'
    );


-- ============================================================
-- 6. ORDERS
-- ============================================================

-- Заказ 1:
-- Иван Петров
-- Использован промокод WELCOME10
-- Статус: Оплачен

INSERT INTO orders (
    user_id,
    promocode_id,
    created_at,
    status,
    total_amount,
    discount_amount
)
VALUES
    (
        (SELECT id
         FROM users
         WHERE email = 'ivan.petrov@example.com'),

        (SELECT id
         FROM promocodes
         WHERE code = 'WELCOME10'),

        '2026-09-20 10:15:00+03',

        'Оплачен',

        44082.00,

        4898.00
    );


-- Заказ 2:
-- Анна Сидорова
-- Без промокода
-- Статус: Передан в доставку

INSERT INTO orders (
    user_id,
    promocode_id,
    created_at,
    status,
    total_amount,
    discount_amount
)
VALUES
    (
        (SELECT id
         FROM users
         WHERE email = 'anna.sidorova@example.com'),

        NULL,

        '2026-09-21 14:30:00+03',

        'Передан в доставку',

        64990.00,

        0.00
    );


-- Заказ 3:
-- Иван Петров
-- Без промокода
-- Статус: Новый

INSERT INTO orders (
    user_id,
    promocode_id,
    created_at,
    status,
    total_amount,
    discount_amount
)
VALUES
    (
        (SELECT id
         FROM users
         WHERE email = 'ivan.petrov@example.com'),

        NULL,

        '2026-09-22 09:00:00+03',

        'Новый',

        10280.00,

        0.00
    );


-- ============================================================
-- 7. ORDER_ITEMS
-- ============================================================

-- Позиции заказа 1:
-- Samsung Galaxy A55: 1 × 39990
-- USB-C кабель: 2 × 1290
--
-- Сумма до скидки:
-- 39990 + (2 × 1290) = 42570
--
-- В текущем тестовом наборе total_amount заказа 1
-- задан как отдельный снимок итоговой суммы.
-- Поэтому позиции демонстрируют состав заказа,
-- а total_amount — сохраненное итоговое значение заказа.

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE user_id = (
                SELECT id
                FROM users
                WHERE email = 'ivan.petrov@example.com'
            )
            AND created_at = '2026-09-20 10:15:00+03'
        ),

        (
            SELECT id
            FROM products
            WHERE sku = 'SM-GALAXY-A55'
        ),

        1,
        39990.00
    ),
    (
        (
            SELECT id
            FROM orders
            WHERE user_id = (
                SELECT id
                FROM users
                WHERE email = 'ivan.petrov@example.com'
            )
            AND created_at = '2026-09-20 10:15:00+03'
        ),

        (
            SELECT id
            FROM products
            WHERE sku = 'USB-C-CABLE-2M'
        ),

        2,
        1290.00
    );


-- Позиции заказа 2:
-- ASUS VivoBook 15: 1 × 64990

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE user_id = (
                SELECT id
                FROM users
                WHERE email = 'anna.sidorova@example.com'
            )
            AND created_at = '2026-09-21 14:30:00+03'
        ),

        (
            SELECT id
            FROM products
            WHERE sku = 'ASUS-VIVOBOOK-15'
        ),

        1,
        64990.00
    );


-- Позиции заказа 3:
-- Logitech MX Master 3S: 1 × 8990
-- USB-C кабель: 1 × 1290
--
-- Сумма: 10280

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    price_at_purchase
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE user_id = (
                SELECT id
                FROM users
                WHERE email = 'ivan.petrov@example.com'
            )
            AND created_at = '2026-09-22 09:00:00+03'
        ),

        (
            SELECT id
            FROM products
            WHERE sku = 'LOG-MX-MASTER-3S'
        ),

        1,
        8990.00
    ),
    (
        (
            SELECT id
            FROM orders
            WHERE user_id = (
                SELECT id
                FROM users
                WHERE email = 'ivan.petrov@example.com'
            )
            AND created_at = '2026-09-22 09:00:00+03'
        ),

        (
            SELECT id
            FROM products
            WHERE sku = 'USB-C-CABLE-2M'
        ),

        1,
        1290.00
    );


-- ============================================================
-- 8. PAYMENTS
-- ============================================================

-- Оплата заказа 1

INSERT INTO payments (
    order_id,
    transaction_id,
    status,
    amount,
    paid_at
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE created_at = '2026-09-20 10:15:00+03'
        ),

        'TXN-20260920-0001',

        'Успешно',

        44082.00,

        '2026-09-20 10:17:32+03'
    );


-- Оплата заказа 2

INSERT INTO payments (
    order_id,
    transaction_id,
    status,
    amount,
    paid_at
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE created_at = '2026-09-21 14:30:00+03'
        ),

        'TXN-20260921-0002',

        'Успешно',

        64990.00,

        '2026-09-21 14:32:10+03'
    );


-- ============================================================
-- 9. DELIVERIES
-- ============================================================

-- Доставка заказа 1

INSERT INTO deliveries (
    order_id,
    tracking_number,
    status,
    address,
    cost
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE created_at = '2026-09-20 10:15:00+03'
        ),

        'TRACK-100001',

        'Готовится к отправке',

        'г. Новосибирск, ул. Ленина, д. 10, кв. 25',

        0.00
    );


-- Доставка заказа 2

INSERT INTO deliveries (
    order_id,
    tracking_number,
    status,
    address,
    cost
)
VALUES
    (
        (
            SELECT id
            FROM orders
            WHERE created_at = '2026-09-21 14:30:00+03'
        ),

        'TRACK-100002',

        'Передан перевозчику',

        'г. Новосибирск, ул. Кирова, д. 15, кв. 42',

        0.00
    );