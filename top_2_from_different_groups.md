```sql
select * from (
  SELECT sessions.id, sessions.session_id, 
    platform_name, sessions.created_at ,
    gender,
    rank() over ( partition by platform_name order by sessions.created_at desc) 
    FROM "sessions" 
    INNER JOIN "step_values" 
    ON "step_values"."session_id" = "sessions"."id" 
    WHERE "sessions"."gender" = 'female' AND 
          "step_values"."variable_id" = 33 AND 
          "step_values"."variable_value_id" IN (
              SELECT "variable_values"."id" FROM "variable_values" 
                WHERE "variable_values"."variable_id" = 33 
                AND "variable_values"."raw_value" IN ('2', 'main_dbs') 
                ORDER BY "variable_values"."mapping_value_en" ASC
            ) 
      ORDER BY "sessions"."created_at" DESC
) tmp where rank <=2;
```
![image](https://user-images.githubusercontent.com/5484758/145536010-8e287e8d-b871-4c38-b1d3-51f2d312ea76.png)
