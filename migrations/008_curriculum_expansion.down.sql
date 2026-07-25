-- Revert the curriculum expansion: drop the 31 new labs (cascades to their
-- phases/topology), restore original sort_order for the 14 originals, drop book_ref.
DELETE FROM labs WHERE id BETWEEN 15 AND 45;

UPDATE labs SET sort_order = 1  WHERE id = 1;
UPDATE labs SET sort_order = 2  WHERE id = 2;
UPDATE labs SET sort_order = 3  WHERE id = 3;
UPDATE labs SET sort_order = 4  WHERE id = 4;
UPDATE labs SET sort_order = 5  WHERE id = 5;
UPDATE labs SET sort_order = 6  WHERE id = 6;
UPDATE labs SET sort_order = 7  WHERE id = 7;
UPDATE labs SET sort_order = 8  WHERE id = 8;
UPDATE labs SET sort_order = 9  WHERE id = 9;
UPDATE labs SET sort_order = 10 WHERE id = 10;
UPDATE labs SET sort_order = 11 WHERE id = 11;
UPDATE labs SET sort_order = 12 WHERE id = 12;
UPDATE labs SET sort_order = 13 WHERE id = 13;
UPDATE labs SET sort_order = 14 WHERE id = 14;

ALTER TABLE labs DROP COLUMN IF EXISTS book_ref;
