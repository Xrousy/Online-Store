-- ============================================================
-- 03_user_lifecycle.sql
-- Жизненный цикл пользователя
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- Этап 1. Регистрация нового покупателя
-- ------------------------------------------------------------

INSERT INTO users (
    role_id,
    email,
    password_hash,
    full_name,
    phone
)
VALUES (
    (
        SELECT id
        FROM roles
        WHERE code_name = 'CUSTOMER'
    ),

    'test.customer@example.com',

    '$2b$12$test_lifecycle_hash',

    'Тестовый Покупатель',

    '+79991112233'
);


-- ------------------------------------------------------------
-- Этап 2. Изменение профиля покупателя
-- ------------------------------------------------------------

UPDATE users
SET
    full_name = 'Тестовый Покупатель Иванов',
    phone = '+79994445566'
WHERE email = 'test.customer@example.com';


-- ------------------------------------------------------------
-- Этап 3. Проверка профиля
-- ------------------------------------------------------------

SELECT
    u.id,
    u.email,
    u.full_name,
    u.phone,
    r.code_name AS role
FROM users u
JOIN roles r
    ON r.id = u.role_id
WHERE u.email = 'test.customer@example.com';


-- ------------------------------------------------------------
-- Этап 4. Изменение роли администратором
-- ------------------------------------------------------------

-- Для демонстрации изменения роли
-- назначаем пользователю роль CONTENT_MANAGER.

UPDATE users
SET role_id = (
    SELECT id
    FROM roles
    WHERE code_name = 'CONTENT_MANAGER'
)
WHERE email = 'test.customer@example.com';


-- ------------------------------------------------------------
-- Этап 5. Проверка новой роли
-- ------------------------------------------------------------

SELECT
    u.id,
    u.email,
    u.full_name,
    r.code_name AS role
FROM users u
JOIN roles r
    ON r.id = u.role_id
WHERE u.email = 'test.customer@example.com';


-- ------------------------------------------------------------
-- Этап 6. Завершение жизненного цикла тестового пользователя
-- ------------------------------------------------------------

DELETE FROM users
WHERE email = 'test.customer@example.com';

COMMIT;