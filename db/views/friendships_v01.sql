(
  SELECT greenlighteable_id AS user_id, g.user_id AS friend_id
  FROM greenlights g
  WHERE friendship_status=3 AND greenlighteable_type='User'
)
UNION ALL
(
  SELECT user_id, g.greenlighteable_id AS friend_id
  FROM greenlights g
  WHERE friendship_status=3 AND greenlighteable_type='User'
)
