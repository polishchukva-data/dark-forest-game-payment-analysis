/*
Project: Game Monetization Analysis

Description:
The project analyzes player behavior and in-game purchasing activity.
The goal is to identify factors influencing payment behavior,
analyze player segments, and provide monetization insights.

Author: Valeria Polishchuk
Date: May 2026

Tools:
PostgreSQL, SQL
*/

-- Part 1. Exploratory Data Analysis
-- Task 1. Analysis of Paying User Share

-- 1.1. Overall Paying User Rate
SELECT COUNT(id) AS total_users,
	SUM(payer) AS total_payer_users,
	ROUND(SUM(payer)::numeric/COUNT(id)*100, 4) AS share_of_paying_percent
FROM fantasy.users;
-- 1.2. Analysis of paying user share across character races:
SELECT race,
total_users_race,	
total_payer_users_race,	
ROUND(total_payer_users_race::numeric/total_users_race*100, 4) AS share_of_paying_race_percent
FROM (
SELECT DISTINCT r.race,
	COUNT(r.race) OVER(PARTITION BY u.race_id) AS total_users_race,
	SUM(u.payer) OVER(PARTITION BY u.race_id) AS total_payer_users_race
FROM fantasy.users AS u
LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id
)
ORDER BY total_payer_users_race DESC;
-- Task 2. Analysis of In-game Purchases
-- 2.1. Descriptive statistics for purchase amounts:
SELECT COUNT(amount) AS count_amount,
	SUM (amount) AS total_amount,
	MIN(amount) AS min_amount,
	MAX(amount) AS max_amount,
	ROUND(AVG(amount)::numeric,2) AS avg_amount,
	(SELECT PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY amount)FROM fantasy.events) AS median_amount,
	(SELECT ROUND(STDDEV(amount::numeric),2) FROM fantasy.events) AS stand_dev_amount
FROM fantasy.events;
-- 2.2. Detection and analysis of anomalous zero-value purchases:
WITH total_zero AS (SELECT 
(SELECT COUNT(amount) FROM fantasy.events WHERE amount = 0) AS count_amount_zero,
COUNT(amount) AS count_amount
FROM fantasy.events )
SELECT 	*,
	ROUND(count_amount_zero::numeric/count_amount*100,4) AS share_of_zero_percent
FROM total_zero;
-- 2.3. Identification of the most popular epic items:
WITH item_purchases AS 
(SELECT game_items, 
		COUNT(amount) AS count_purchases,
		COUNT(DISTINCT e.id) AS purch_users
	FROM fantasy.events AS e
	LEFT JOIN fantasy.items AS i ON e.item_code = i.item_code
	WHERE amount > 0
	GROUP BY game_items),
count_id_events AS (
	SELECT id
	FROM fantasy.events
	WHERE amount > 0
	GROUP BY id),
all_payer_stats AS (
	SELECT COUNT(*) AS all_payer
	FROM count_id_events)
SELECT ip.game_items,
	count_purchases,
	ROUND((count_purchases / SUM(count_purchases) OVER())*100,4) AS share_of_sale_item_percent,
	ROUND((ip.purch_users::numeric / ap.all_payer )*100,4) AS share_of_sale_users_percent
FROM item_purchases AS ip 
CROSS JOIN all_payer_stats AS ap
ORDER BY count_purchases DESC;


-- Part 2. Ad Hoc Analysis
-- Task: Analyze the relationship between player activity and character race:
WITH 
total_users_race AS (
	SELECT DISTINCT r.race,
		COUNT(r.race) OVER(PARTITION BY u.race_id) AS total_users_race
	FROM fantasy.users AS u
	LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id),
total_race_purchase AS (
	SELECT race, 
		COUNT (id) AS users_purchase_race,
		ROUND(SUM(payer::numeric)/cOUNT(id)*100,2) AS share_of_paying_users_race  
		FROM 
	(SELECT DISTINCT e.id, r.race,
		u.payer
	FROM fantasy.events AS e
	LEFT JOIN fantasy.users AS u ON e.id = u.id
	LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id)
	GROUP BY race),
user_purchase_statistics AS (
	SELECT r.race,
		e.id,
		COUNT(transaction_id)  AS count_of_purchase_users,
		AVG(amount::numeric) AS avg_purchases_users,
		SUM(amount::numeric) AS sum_purchases_users
	FROM fantasy.events AS e
	LEFT JOIN fantasy.users AS u ON e.id = u.id
	LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id
	WHERE amount > 0
	GROUP BY r. race, e.id
	),
statistics_total AS (
	SELECT race,
		ROUND(AVG(count_of_purchase_users),0) AS avg_count_purchases_race,
		ROUND(AVG(sum_purchases_users),2) AS avg_total_purchase_race
	FROM user_purchase_statistics
	GROUP BY race)
SELECT tur.race,
	total_users_race,
	users_purchase_race,
	ROUND(users_purchase_race::numeric/total_users_race*100,2) AS share_of_paying_users_race_percent,
	share_of_paying_users_race,
	avg_count_purchases_race,
	ROUND(avg_total_purchase_race/avg_count_purchases_race,2) AS avg_each_purchase_race,
	avg_total_purchase_race
FROM total_users_race AS tur
LEFT JOIN total_race_purchase AS trp ON tur.race=trp.race
LEFT JOIN statistics_total AS st ON trp.race=st.race
ORDER BY total_users_race DESC;
