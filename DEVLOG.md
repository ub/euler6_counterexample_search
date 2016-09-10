   rake "db:new_migration[CreateHypotheses, value:string{40} terms_count:integer factor:string{40} parent:references ]"
   rake "db:new_migration[CreateRefutations, hypothesis:references reason:integer parameter:bigint ]"
   
   
   
   
   sqlite> .schema 
   CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
   CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
   CREATE TABLE "hypotheses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "value" varchar(40), "terms_count" integer, "factor" varchar(40), "parent_id" integer);
   CREATE INDEX "index_hypotheses_on_parent_id" ON "hypotheses" ("parent_id");
   CREATE TABLE "refutations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "hypothesis_id" integer, "reason" integer, "parameter" bigint);
   CREATE INDEX "index_refutations_on_hypothesis_id" ON "refutations" ("hypothesis_id");
   