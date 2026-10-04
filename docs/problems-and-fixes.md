Same text twice is not a duplicate; a duplicate is the same update_id.

DO NOTHING isn't an error, so the workflow kept going and would have replied twice; fix: an IF node on the returned id

Ingestion returned nothing; the cause was empty source files, found by printing file sizes. Lesson: when data looks missing, check the input before the code.