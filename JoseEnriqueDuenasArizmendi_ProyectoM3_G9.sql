-- ARCHIVO ej_joins--

-- 1.Provide a table that provides the region for each sales_rep along with their associated accounts. --
-- This time only for the Midwest region. Your final table should include three columns: the region name,--
-- the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name --- 
SELECT * FROM "public"."accounts"

SELECT * FROM "public"."orders"

SELECT * FROM "public"."sales_reps"

SELECT * FROM "public"."region"

SELECT Accounts."id"
,Accounts."name"            
,Accounts."sales_rep_id"
FROM   "public"."accounts"  AS Accounts

SELECT sales_reps."id"
,sales_reps."name"      
,sales_reps."region_id"
FROM  "public"."sales_reps" AS sales_reps

SELECT regions."id"
,regions."name"         
FROM  "public"."region" AS regions

-- Hacemos la revision del Left Join a utilizar para entender que datos aparecen --
SELECT DISTINCT *  
FROM "public"."sales_reps" AS sales_reps
LEFT JOIN "public"."region" AS regions
    ON  sales_reps."region_id" = regions."id"
-- Revisamos un RIGHT JOIN -- 
SELECT DISTINCT *  
FROM "public"."sales_reps" AS sales_reps
RIGHT JOIN "public"."accounts"  AS Accounts
    ON  Accounts."sales_rep_id" = sales_reps."id"


-- Representantes de ventas de region Midwest con sus cuentas asociadas --
SELECT DISTINCT Accounts."name" As Accounts_name 
,sales_reps."name" As sales_rep_name 
,regions."name" As nombre_region  
FROM "public"."sales_reps" AS sales_reps
LEFT JOIN "public"."region" AS regions
    ON  sales_reps."region_id" = regions."id"
LEFT JOIN "public"."accounts"  AS Accounts
    ON  Accounts."sales_rep_id" = sales_reps."id"
    WHERE regions."id" = 2
GROUP BY 
Accounts."name" 
,regions."name"
,sales_reps."name"
ORDER BY Accounts."name" ASC


-- 2.Provide a table that provides the region for each sales_rep along with their associated accounts.--
--This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.--
--Your final table should include three columns: the region name, the sales rep name, and the account name.--
--Sort the accounts alphabetically (A-Z) according to account name.--

SELECT DISTINCT Accounts."name" As Accounts_name 
,sales_reps."name" As sales_rep_name 
,regions."name" As nombre_region  
FROM "public"."sales_reps" AS sales_reps
LEFT JOIN "public"."region" AS regions
    ON  sales_reps."region_id" = regions."id"
    AND sales_reps."name" LIKE 'S%'
LEFT JOIN "public"."accounts"  AS Accounts
    ON  Accounts."sales_rep_id" = sales_reps."id"
    WHERE regions."id" = 2
GROUP BY 
Accounts."name" 
,regions."name"
,sales_reps."name"
ORDER BY Accounts."name" ASC

--3. Provide a table that provides the region for each sales_rep along with their associated accounts.--
--This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.--
--Your final table should include three columns: the region name, the sales rep name, and the account name.--
--Sort the accounts alphabetically (A-Z) according to account name.--

SELECT DISTINCT Accounts."name" As Accounts_name 
,sales_reps."name" As sales_rep_name 
,regions."name" As nombre_region  
FROM "public"."sales_reps" AS sales_reps
LEFT JOIN "public"."region" AS regions
    ON  sales_reps."region_id" = regions."id"
    AND sales_reps."name" LIKE'%______K%'
LEFT JOIN "public"."accounts"  AS Accounts
    ON  Accounts."sales_rep_id" = sales_reps."id"
    WHERE regions."id" = 2
GROUP BY 
Accounts."name" 
,regions."name"
,sales_reps."name"
ORDER BY Accounts."name" ASC


-- ARCHIVO ej_agg--  


SELECT * FROM "public"."accounts"

SELECT * FROM "public"."orders"

SELECT * FROM "public"."sales_reps"

SELECT * FROM "public"."region"

SELECT Accounts."id"
,Accounts."name"            
,Accounts."sales_rep_id"
FROM   "public"."accounts"  AS Accounts

SELECT sales_reps."id"
,sales_reps."name"      
,sales_reps."region_id"
FROM  "public"."sales_reps" AS sales_reps

SELECT regions."id"
,regions."name"         
FROM  "public"."region" AS regions

SELECT orders."account_id"
,orders."standard_qty"
,orders."gloss_qty"
,orders."poster_qty"
,orders."total"
,orders."occurred_at"
,orders."gloss_amt_usd"
FROM "public"."orders" AS orders 


-- 1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns --
-- one for the account name and one for the average quantity purchased for each of the paper types for each account.--

SELECT DISTINCT Accounts."name" AS Accounts_name
,AVG(orders."standard_qty") AS prom_standard_qty
,AVG(orders."gloss_qty") AS prom_gloss_qty
,AVG(orders."poster_qty") AS prom_poster_qty
,AVG(orders."total") AS prom_total_qty
FROM "public"."orders" As orders
RIGHT JOIN "public"."accounts" As accounts 
    ON  orders."account_id" = accounts."id"
GROUP BY Accounts."name"
ORDER BY prom_total_qty DESC

-- Detectamos que existe una cuenta "Goldman Sachs Group" que tiene datos Null, ya sabemos que esa cuenta hay que 
-- investigarla más adelante para conocer "¿Por qué no tiene datos?"--
--Asi que realizamos un LEFT Join para excluir en el Join esa cuenta que no se relaciona con ninguna orden--- 

SELECT DISTINCT Accounts."name" AS Accounts_name
,AVG(orders."standard_qty") AS prom_standard_qty
,AVG(orders."gloss_qty") AS prom_gloss_qty
,AVG(orders."poster_qty") AS prom_poster_qty
,AVG(orders."total") AS prom_total_qty
FROM "public"."orders" As orders
LEFT JOIN "public"."accounts" As accounts 
    ON  orders."account_id" = accounts."id"
GROUP BY Accounts."name"
ORDER BY prom_total_qty DESC



-- 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?-- 
SELECT DISTINCT Accounts."name" AS Accounts_name
,date_part('month',orders."occurred_at") AS "Month"
,SUM(orders."gloss_amt_usd") AS gloss_amt_usd
FROM "public"."orders" As orders
LEFT JOIN "public"."accounts" As accounts 
    ON  orders."account_id" = accounts."id"
GROUP BY  date_part('month',orders."occurred_at")
,Accounts."name"
,orders."occurred_at"
HAVING Accounts."name" LIKE '%Walmart%'
ORDER BY "Month" ASC

-- Enero 239 + 4831 = 5070.73
--Febrero 217.21 + 4456.55= 4673.76
--Marzo 4711.21
--Abril 4875.99
--Mayo 9257.64 -- MAYO Resulto ser el mes con mayor compra de "Gloss" por parte de Walmart--
--Junio 344.54
--Julio 4254.32
--Agosto 4531.45
--Septiembre 4673.76
--Octubre 1235.85
--Noviembre 9250.15
--Diciembre 5774.79 --