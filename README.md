# Game Monetization Analysis | SQL

## Project Overview

This project analyzes player behavior and in-game purchasing activity in the game "Dark Forest".

The goal of the analysis is to understand how player characteristics and character attributes influence purchasing behavior, evaluate payment activity, and identify opportunities to improve monetization strategies.

## Business Objectives

The analysis aims to answer the following questions:

- What percentage of players make in-game purchases?
- How does character race influence payment behavior?
- What are the most popular in-game items?
- Are there differences in purchase activity and spending patterns between player segments?
- What monetization opportunities can be identified based on player behavior?

## Dataset

The analysis uses game data containing information about:

- Players and their payment status
- Character races
- In-game purchase events
- Purchased items

## Tools

- PostgreSQL
- SQL

## Analysis Performed

### 1. Exploratory Data Analysis

Performed analysis of:

- Overall share of paying users
- Paying user distribution by character race
- Purchase volume and revenue metrics
- Purchase amount distribution
- Anomalous zero-value transactions
- Most popular epic items

### 2. Player Segmentation Analysis

Analyzed purchasing behavior across character races:

- Number of purchases
- Average purchase value
- Total spending per player
- Share of paying users

## SQL Techniques Used

- CTEs (Common Table Expressions)
- JOINs
- GROUP BY aggregations
- Window functions
- CASE statements
- Statistical functions
- Percentile calculations
- Data segmentation

## Key Insights

- 17.7% of registered players made in-game purchases.
- Human players generated the highest number of purchases among all character races.
- Northman players demonstrated the highest average purchase value.
- The most popular epic items were Book of Legends and Bag of Holding.
- Player segments showed different purchasing patterns and monetization potential.

## Business Recommendations

- Develop targeted promotional campaigns for different player segments.
- Test pricing strategies for specific player groups to evaluate demand sensitivity.
- Focus marketing efforts on high-value player segments to increase revenue.
- Use player behavior analysis to optimize item offers and monetization mechanics.

## Project Files

- SQL queries: [game_monetization_analysis.sql](sql/game_monetization_analysis.sql)
- Analysis report: [game_monetization_analysis_report.pdf](documentation/game_monetization_analysis_report.pdf)

## Author

Valeria Polishchuk
