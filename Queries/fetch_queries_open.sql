#Open-Ended Question 1:
# "Who are Fetch’s power users?"

WITH spending_threshold AS (
    SELECT 
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_spend) AS threshold
    FROM users_spend
)
SELECT 
    id AS user_id, 
    state, 
    language, 
    total_spend, 
    total_quantity,
    created_date
FROM users_spend
WHERE total_spend >= (SELECT threshold FROM spending_threshold)
ORDER BY total_spend DESC;

# 2. Which is the Leading Brand in the Dips & Salsa Category?

SELECT 
    p.brand,
    SUM(t.final_sale) AS total_sales,
    SUM(t.final_quantity) AS total_quantity
FROM
    transactions t
        JOIN
    products p ON t.barcode = p.barcode
WHERE
    p.category_2 = 'Dips & Salsa'
GROUP BY p.brand
ORDER BY total_sales DESC
LIMIT 1;

# 3. At What Percent Has Fetch Grown Year Over Year?

WITH yearly_sales AS (
    SELECT 
        strftime('%Y', purchase_date) AS year, 
        SUM(final_sale) AS total_sales
    FROM transactions
    GROUP BY year
)
SELECT 
    year AS current_year, 
    total_sales AS current_sales, 
    LAG(total_sales) OVER (ORDER BY year) AS previous_sales,
    ROUND(((total_sales - LAG(total_sales) OVER (ORDER BY year)) / 
            LAG(total_sales) OVER (ORDER BY year)) * 100, 2) AS growth_percentage
FROM yearly_sales
ORDER BY current_year DESC;
