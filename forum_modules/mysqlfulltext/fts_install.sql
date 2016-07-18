ALTER TABLE forum_mysqlftsindex CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

delimiter |

CREATE TRIGGER fts_on_insert AFTER INSERT ON forum_node
  FOR EACH ROW
  BEGIN
    INSERT INTO forum_mysqlftsindex (node_id, title, body, tagnames) VALUES (NEW.id, UPPER(NEW.title), UPPER(NEW.body), UPPER(NEW.tagnames));
  END;
|

delimiter |

CREATE TRIGGER fts_on_update AFTER UPDATE ON forum_node
  FOR EACH ROW
  BEGIN
    UPDATE forum_mysqlftsindex SET title = UPPER(NEW.title), body = UPPER(NEW.body), tagnames = UPPER(NEW.tagnames) WHERE node_id = NEW.id;
  END;

|

INSERT INTO forum_mysqlftsindex (node_id, title, body, tagnames) SELECT id, UPPER(title), UPPER(body), UPPER(tagnames) FROM forum_node;
