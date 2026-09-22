CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    parent_id BIGINT,

    CONSTRAINT fk_categories_parent
        FOREIGN KEY (parent_id)
        REFERENCES categories(id)
);