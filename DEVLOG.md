   ```rake "db:new_migration[CreateHypotheses, value:string{40} terms_count:integer factor:string{40} parent:references ]"```
   ```rake "db:new_migration[CreateRefutations, hypothesis:references reason:integer parameter:bigint ]"```
   
   
   
   
       sqlite> .schema 
       CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
       CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
       CREATE TABLE "hypotheses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "value" varchar(40), "terms_count" integer, "factor" varchar(40), "parent_id" integer);
       CREATE INDEX "index_hypotheses_on_parent_id" ON "hypotheses" ("parent_id");
       CREATE TABLE "refutations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "hypothesis_id" integer, "reason" integer, "parameter" bigint);
       CREATE INDEX "index_refutations_on_hypothesis_id" ON "refutations" ("hypothesis_id");
   
## Тайминг
   Запись 117649 *2/7 в таблицу sqlite без транзакций длилась десятки минут, с транзакцией -- 21 секнду
   
## Терминология
   
   * tactics 
   * backward (top-down) chaining
   * subgoals
   
   Мы можем рассматривать каждую гипотезу как цель (goal). Количество  слагаемых в гипотезе назовем рангом
   Каждую цель ранга N мы можем с помощью тактики/стратегии свести(reduce) к множеству альтернативных (дизъюнктивных) 
   подцелей ранга N-1
   Цель истинна тогда и только тогда, если хотя бы одна из ее подцелей истинна
   
   Исключая (опровергая) подцели мы 
   
   reducing
   
## Тайминг   
   Process5: 10 секунд вычисления, 50 секунд запись
   Поскольку идея заключается в  документированности и отслеживаемости логики -- мы записываем в БД все результаты, а фильтруем потом
   Можно отфильтровать и заранее -- сократить количество. Тогда  время записи сократится
   
   Можно посмотреть, как тайминги будут работать для  Postgres
   
## refutation 
   Появляется первая причина отвержения гипотезы -- не удается сформулировать ни одной _подцели_

 Hypothesis.for_terms(5).left_outer_joins(:subgoals).where( "subgoals_hypotheses.id" => nil).to_sql
 ```
 SELECT "hypotheses".* FROM "hypotheses" LEFT OUTER JOIN "hypotheses" "subgoals_hypotheses" ON "subgoals_hypotheses"."parent_id" = "hypotheses"."id" WHERE "hypotheses"."terms_count" = 5 AND "subgoals_hypotheses"."id" IS NULL
 ```
   
   
   
   