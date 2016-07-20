ALTER TABLE osqa.forum_mysqlftsindex CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

delimiter |

CREATE TRIGGER osqa.fts_on_insert AFTER INSERT ON osqa.forum_node
  FOR EACH ROW
  BEGIN
    INSERT INTO osqa.forum_mysqlftsindex 
    SET node_id=NEW.id, 
        title=UPPER(NEW.title), 
        body=UPPER(NEW.body), 
        tagnames=UPPER(NEW.tagnames); 
  END;
|

delimiter |

CREATE TRIGGER osqa.fts_on_update AFTER UPDATE ON forum_node
  FOR EACH ROW
  BEGIN
    UPDATE osqa.forum_mysqlftsindex 
    SET title = UPPER(NEW.title), 
    body = UPPER(NEW.body), 
    tagnames = UPPER(NEW.tagnames) 
    WHERE node_id = NEW.id;
  END;

|

INSERT INTO osqa.forum_mysqlftsindex (node_id, title, body, tagnames) 
SELECT id, UPPER(title), UPPER(body), UPPER(tagnames) FROM osqa.forum_node;