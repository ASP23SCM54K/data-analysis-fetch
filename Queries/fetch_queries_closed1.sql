#Closed-Ended Question 1:
# "What are the top 5 brands by receipts scanned among users 21 and over?"

SELECT 
    p.brand, COUNT(t.receipt_id) AS receipt_count
FROM
    transactions t
        JOIN
    users u ON t.user_id = u.id
        JOIN
    products p ON t.barcode = p.barcode
WHERE
    u.age >= 21
GROUP BY p.brand
ORDER BY receipt_count DESC
LIMIT 5;

#Closed-Ended Question 2:
#"What are the top 5 brands by sales among users that have had their account for at least six months?"
SELECT 
    p.brand, 
    SUM(t.final_sale) AS total_sales
FROM transactions t
JOIN users u ON t.user_id = u.id
JOIN products p ON t.barcode = p.barcode
WHERE u.created_date <= DATE('2025-01-19', '-6 months')
GROUP BY p.brand
ORDER BY total_sales DESC
LIMIT 5;
# Closed-Ended Question 3:
# "What is the percentage of sales in the Health & Wellness category by generation?"

SELECT 
    CASE 
        WHEN u.age <= 26 THEN 'Young Adults'
        WHEN u.age <= 42 THEN 'Early Career Professionals'
        WHEN u.age <= 58 THEN 'Mid-Life Adults'
        WHEN u.age <= 78 THEN 'Senior Adults'
        ELSE 'Unknown'
    END AS generation_group,
    ROUND(SUM(t.final_sale) * 100.0 / 
        (SELECT SUM(final_sale) 
         FROM transactions t 
         JOIN products p ON t.barcode = p.barcode 
         WHERE p.category_1 = 'Health & Wellness'), 2) AS percentage_of_sales
FROM transactions t
JOIN users u ON t.user_id = u.id
JOIN products p ON t.barcode = p.barcode
WHERE p.category_1 = 'Health & Wellness'
GROUP BY generation_group
ORDER BY percentage_of_sales DESC;
