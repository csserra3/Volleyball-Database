-- INSERT

-- DELETE

-- UPDATE

-- DIVISION

-- PROJECT

-- JOIN

-- NESTED AGGREGATION WITH GB

-- SELECTION

-- AGGREGATION WITH GB
-- Eg. "name of tallest player in ea position?"
SELLECT position, MAX(height)
FROM Players
WHERE
GROUP BY position

-- AGGREGATION WITH HAVING