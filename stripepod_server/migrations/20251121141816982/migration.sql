BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "payments" (
    "id" bigserial PRIMARY KEY,
    "stripeId" text NOT NULL,
    "amount" bigint NOT NULL,
    "currency" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR stripepod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('stripepod', '20251121141816982', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251121141816982', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();


COMMIT;
