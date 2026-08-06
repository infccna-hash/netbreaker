-- Migration 062 DOWN: Drop verify_replace function

DROP FUNCTION IF EXISTS verify_replace(text, text, text);
