+ Checklist
=============
# Test development & staging
- pg_dump production data
- comment revoke rdsadmin ?
- scp .sql to staging server
- docker exec -it 0a22d268536a bash
  - psql -U postgres
  - create new database ...;
- (source) docker exec -i 0a22d268536a psql -U postgres -d chatfuel_prod1 < chatfuel_production-08-feb.sql
- switch database.yml/docker-compose.yml
  - switch docker images/ database
- rails db:migrate:status
- rails db:migrate
- reset postgres nextval()
  -\d+ table_name;
  -SELECT nextval('sessions_id_seq'::regclass);
  -SELECT setval('sessions_id_seq'::regclass, (SELECT MAX(id) FROM sessions)+1);
- remove template audio/image ( after dump )
- update bot endpoint/manifest.xml
- ivr port 30003:80

comment: Session#update_last_interaction_time

# production
  - create new production database
  - source production data (Amazon rds) ?
  - switch to new database


++ SESSION II ++
* Prepare for Migration
--------------------------------------------------
1. change api request in chatbot & ivr
2. session id for ivr is phone number but for old data keep using callid,
  avoid inconsistent count
3. backing up latest data
4. create new database
5. change database to new database
6. run migration

Note: when testing, must test like production workflow,
otherwise, it will inconsistent due to the logic of creating a new session
require to have at lease, 
  gender, and location.

In some case, database requires to reset nextval().
In staging, after migrate database, we have to clear template assets, otherwise,
It will raise an error because assets are missing.

  + Test in Chatbot
    - create dictionary variable
    - mark as completed, repeated step (clone?)
    - tracking
      - invalid
      - completed
      - incomplete
    - feedback

  + Test in IVR
    - create dictionary variable
    - feedback
    - tracking


* Prepare for rollback
--------------------------------------------------
  . difficult to update endpoints
    - need to update manually, everywhere in chatbot, ivr design step.
  . change to old database (old schema)

9pm:
  update manifest/show.xml
  update external service
  update & save step in call flow design
  test ivr

chatfuel
  issue in gender steps
  set map preview default lang
  
