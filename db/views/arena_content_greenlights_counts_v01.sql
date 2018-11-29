SELECT p.arena_id, SUM(m.greenlights_count) AS sum
FROM (posts p JOIN media_contents m ON ((p.media_content_id = m.id)))
GROUP BY p.arena_id;
