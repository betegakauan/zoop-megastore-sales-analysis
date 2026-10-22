PRAGMA foreign_keys = ON;   -- remove this line if your tool rejects it

-- 1. Create the final tables

CREATE TABLE customers (
    customer_id        INTEGER PRIMARY KEY,
    customer_name      TEXT NOT NULL,
    email              TEXT NOT NULL,
    state              TEXT NOT NULL,
    subscription_plan  TEXT NOT NULL CHECK (subscription_plan IN ('Yes', 'No'))
);

CREATE TABLE sales (
    sale_id      INTEGER PRIMARY KEY,
    sale_date    TEXT    NOT NULL,
    customer_id  INTEGER NOT NULL,
    product_id   INTEGER NOT NULL,
    product      TEXT    NOT NULL,
    category     TEXT    NOT NULL,
    sale_value   REAL    NOT NULL CHECK (sale_value > 0),
    quantity     INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE INDEX idx_sales_customer ON sales (customer_id);
CREATE INDEX idx_sales_product  ON sales (product_id);

INSERT INTO customers (customer_id, customer_name, email, state, subscription_plan)
SELECT DISTINCT
    CAST(id_cliente AS INTEGER),
    TRIM(nome_cliente),
    TRIM(email),
    TRIM(estado),
    CASE WHEN TRIM(plano_assinatura) LIKE 'S%' THEN 'Yes' ELSE 'No' END
FROM clientes;

INSERT INTO sales (sale_id, sale_date, customer_id, product_id, product, category, sale_value, quantity)
SELECT DISTINCT
    CAST(id_venda AS INTEGER),
    TRIM(data_venda),
    CAST(id_cliente AS INTEGER),
    CAST(id_produto AS INTEGER),
    TRIM(produto),
    CASE TRIM(categoria)
        WHEN 'Periféricos'   THEN 'Peripherals'
        WHEN 'Livros'        THEN 'Books'
        WHEN 'Eletrônicos'   THEN 'Electronics'
        WHEN 'Decoração'     THEN 'Home Decor'
        WHEN 'Colecionáveis' THEN 'Collectibles'
        WHEN 'Componentes'   THEN 'Components'
        WHEN 'Áudio'         THEN 'Audio'
        WHEN 'Móveis'        THEN 'Furniture'
        ELSE TRIM(categoria)
    END,
    CAST(valor_venda AS REAL),
    CAST(quantidade AS INTEGER)
FROM vendas
WHERE NULLIF(TRIM(valor_venda), '') IS NOT NULL
  AND NULLIF(TRIM(quantidade), '')  IS NOT NULL
  AND NULLIF(TRIM(data_venda), '')  IS NOT NULL;

-- Quick checks: expected 50 customers and 120 sales
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'sales', COUNT(*) FROM sales;