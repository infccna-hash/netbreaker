-- Migration 062 v3: Fix Lab 1 DTP callout
-- Strategy: replace a unique 12-char marker in the callout
-- Old: "uBridge tunnel" → New: "IOU image limitation"

-- Up
SELECT verify_replace(
    'lab_phases',
    'content',
    'uBridge tunnel between Docker and IOU does not forward correctly',
    'IOU images do not implement DTP — frames are never processed by the switch',
    'lab_id = 1 AND phase = ''attack'''
);

-- Also update the callout title
SELECT verify_replace(
    'lab_phases',
    'content',
    'IOU + uBridge Note',
    'IOU Platform Note',
    'lab_id = 1 AND phase = ''attack'''
);

-- And the SNAP detail (remove misleading tech detail)
SELECT verify_replace(
    'lab_phases',
    'content',
    'DTP frames from yersinia use SNAP encapsulation (0x2004) which the',
    'DTP frames from yersinia use SNAP encapsulation (0x2004) —',
    'lab_id = 1 AND phase = ''attack'''
);
