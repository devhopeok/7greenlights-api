(
  SELECT greenlighteable_id AS user_id, user_id AS follower_user_id, friendship_status
  FROM greenlights
  WHERE friendship_status=2 AND greenlighteable_type='User'
)
UNION ALL
(
  SELECT user_id, greenlighteable_id AS follower_user_id, friendship_status
  FROM greenlights
  WHERE friendship_status=1 AND greenlighteable_type='User'
)
